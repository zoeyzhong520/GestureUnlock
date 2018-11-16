//
//  GestureView.m
//  GestureUnlock
//
//  Created by zhifu360 on 2018/11/16.
//  Copyright © 2018 ZZJ. All rights reserved.
//

#import "GestureView.h"
#import "PointView.h"

@interface GestureView ()

///可变数组，用于存放初始化的点击按钮
@property (nonatomic, strong) NSMutableArray *pointViews;
///记录手势滑动的起始点
@property (nonatomic, assign) CGPoint startPoint;
///记录手势滑动的结束点
@property (nonatomic, assign) CGPoint endPoint;
///存储选中的按钮ID
@property (nonatomic, strong) NSMutableArray *selectedViews;
///手势滑动经过的点的连线
@property (nonatomic, strong) CAShapeLayer *lineLayer;
///手势滑动的path
@property (nonatomic, strong) UIBezierPath *linePath;
///用于存储选中的按钮
@property (nonatomic, strong) NSMutableArray *selectedViewCenter;
///判断滑动是否结束
@property (nonatomic, assign) BOOL touchEnd;

@end

@implementation GestureView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

///UI
- (void)initUI {
    
    self.touchEnd = NO;
    
    //初始化开始点位和结束点位
    self.startPoint = CGPointZero;
    self.endPoint = CGPointZero;
    
    //布局手势按钮
    for (int i = 0; i < 9; i ++) {
        PointView *pointView = [[PointView alloc] initWithFrame:CGRectMake((i%3)*(self.bounds.size.width/2-31)+1, (i/3)*(self.bounds.size.height/2-31)+1, 60, 60) withID:[NSString stringWithFormat:@"gestures %d",i+1]];
        [self addSubview:pointView];
        [self.pointViews addObject:pointView];
    }
}

#pragma mark - Touch事件
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (self.touchEnd) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    //判断手势滑动是否在手势按钮范围
    for (PointView *pointView in self.pointViews) {
        //滑动到手势按钮范围，记录状态
        if (CGRectContainsPoint(pointView.frame, point)) {
            //如果开始按钮为zero，记录开始按钮，否则不需要记录开始按钮
            if (CGPointEqualToPoint(self.startPoint, CGPointZero)) {
                self.startPoint = pointView.center;
            }
            
            //判断该手势按钮的中心点是否记录，未记录则记录
            if (![self.selectedViewCenter containsObject:[NSValue valueWithCGPoint:pointView.center]]) {
                [self.selectedViewCenter addObject:[NSValue valueWithCGPoint:pointView.center]];
            }
            
            //判断该手势按钮是否已经选中，未选中就选中
            if (![self.selectedViews containsObject:pointView.ID]) {
                [self.selectedViews addObject:pointView.ID];
                pointView.isSelected = YES;
            }
        }
    }
    
    //如果开始点位不为zero则记录结束点位，否则跳过不记录
    if (!CGPointEqualToPoint(self.startPoint, CGPointZero)) {
        self.endPoint = point;
        //画线
        [self drawLines];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    //结束手势滑动的时候，将结束按钮设置为最后一个手势按钮的中心点，并画线
    self.endPoint = [self.selectedViewCenter.lastObject CGPointValue];
    //如果endPoint还是为zero说明未滑动到有效位置，不做处理
    if (CGPointEqualToPoint(self.endPoint, CGPointZero)) {
        return;
    }
    
    //画线
    [self drawLines];
    
    //改变手势滑动结束的状态，为yes则无法在滑动手势划线
    self.touchEnd = YES;
    //设置手势时，返回设置的手势密码，否则继续下面的操作进行手势解锁
    if (_gestureBlock && _settingGesture) {
        //手势密码不得小于4个点
        if (self.selectedViews.count < 4) {
            
            [self restoreDefaultState];
            
            if (_settingFailureBlock) {
                _settingFailureBlock();
            }
            return;
        }
        
        _gestureBlock(self.selectedViews);
        return;
    }
    
    //手势解锁
    NSArray *selectedID = [[NSUserDefaults standardUserDefaults] objectForKey:GestureUnlockKey] ?: [NSArray array];
    //解锁成功
    if ([self.selectedViews isEqualToArray:selectedID]) {
        //解锁成功，遍历pointview，设置为成功状态
        for (PointView *pointView in self.pointViews) {
            pointView.isSuccess = YES;
        }
        
        self.lineLayer.strokeColor = GestureUnlockSuccessColor.CGColor;
        if (_unlockBlock) {
            self.unlockBlock(YES);
        }
    } else {
        //解锁失败
        //解锁失败，遍历pointView，设置为失败状态
        for (PointView *pointView in self.pointViews) {
            pointView.isError = YES;
        }
        
        self.lineLayer.strokeColor = GestureUnlockErrorColor.CGColor;
        if (_unlockBlock) {
            self.unlockBlock(NO);
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(NSEC_PER_SEC * 1.5)), dispatch_get_main_queue(), ^{
            [self restoreDefaultState];
        });
    }
}

///画线
- (void)drawLines {
    
    //结束手势滑动，不画线
    if (self.touchEnd) {
        return;
    }
    
    //移除path的点和lineLayer
    [self.lineLayer removeFromSuperlayer];
    [self.linePath removeAllPoints];
    
    //画线
    [self.linePath moveToPoint:self.startPoint];
    for (NSValue *pointValue in self.selectedViewCenter) {
        [self.linePath addLineToPoint:[pointValue CGPointValue]];
    }
    [self.linePath addLineToPoint:self.endPoint];
    
    self.lineLayer.path = self.linePath.CGPath;
    self.lineLayer.lineWidth = 4;
    self.lineLayer.strokeColor = GestureUnlockMainColor.CGColor;
    self.lineLayer.fillColor = [UIColor clearColor].CGColor;
    
    [self.layer addSublayer:self.lineLayer];
    
    self.layer.masksToBounds = YES;
}

///还原为默认状态
- (void)restoreDefaultState {
    
    self.touchEnd = NO;
    
    for (PointView *pointView in self.pointViews) {
        pointView.isSelected = NO;
        pointView.isError = NO;
    }
    
    [self.lineLayer removeFromSuperlayer];
    
    [self.selectedViews removeAllObjects];
    
    [self.selectedViewCenter removeAllObjects];
    
    self.startPoint = CGPointZero;
    
    self.endPoint = CGPointZero;
}

#pragma mark - lazy
- (NSMutableArray *)pointViews {
    if (!_pointViews) {
        _pointViews = [NSMutableArray arrayWithCapacity:0];
    }
    return _pointViews;
}

- (NSMutableArray *)selectedViews {
    if (!_selectedViews) {
        _selectedViews = [NSMutableArray arrayWithCapacity:0];
    }
    return _selectedViews;
}

- (CAShapeLayer *)lineLayer {
    if (!_lineLayer) {
        _lineLayer = [CAShapeLayer layer];
    }
    return _lineLayer;
}

- (UIBezierPath *)linePath {
    if (!_linePath) {
        _linePath = [UIBezierPath bezierPath];
    }
    return _linePath;
}

- (NSMutableArray *)selectedViewCenter {
    if (!_selectedViewCenter) {
        _selectedViewCenter = [NSMutableArray arrayWithCapacity:0];
    }
    return _selectedViewCenter;
}

@end

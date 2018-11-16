//
//  PointView.m
//  GestureUnlock
//
//  Created by zhifu360 on 2018/11/16.
//  Copyright © 2018 ZZJ. All rights reserved.
//

#import "PointView.h"

#define SELF_WIDTH self.bounds.size.width
#define SELF_HEIGHT self.bounds.size.height

@interface PointView ()

///外层手势按钮
@property (nonatomic, strong) CAShapeLayer *contentLayer;
///手势按钮边框
@property (nonatomic, strong) CAShapeLayer *borderLayer;
///选中时，中间样式
@property (nonatomic, strong) CAShapeLayer *centerLayer;
///ID
@property (nonatomic, copy, readwrite) NSString *ID;

@end

@implementation PointView

- (instancetype)initWithFrame:(CGRect)frame withID:(NSString *)ID
{
    self = [super initWithFrame:frame];
    if (self) {
        self.ID = ID;
        [self addLayers];
    }
    return self;
}

///UI
- (void)addLayers {
    
    [self.layer addSublayer:self.contentLayer];
    
    [self.layer addSublayer:self.borderLayer];
    
    [self.layer addSublayer:self.centerLayer];
    
    self.centerLayer.hidden = YES;
}

#pragma mark - setter
- (void)setIsSuccess:(BOOL)isSuccess {
    
    _isSuccess = isSuccess;
    if (_isSuccess) {
        self.centerLayer.fillColor = GestureUnlockSeccessColor.CGColor;
    } else {
        self.centerLayer.fillColor = GestureUnlockMainColor.CGColor;
    }
}

- (void)setIsSelected:(BOOL)isSelected {
    
    _isSelected = isSelected;
    if (_isSelected) {
        self.centerLayer.hidden = NO;
        self.borderLayer.strokeColor = GestureUnlockMainColor.CGColor;
    } else {
        self.centerLayer.hidden = YES;
        self.borderLayer.strokeColor = BorderStrokeNormalColor.CGColor;
    }
}

- (void)setIsError:(BOOL)isError {
    
    _isError = isError;
    if (_isError) {
        self.centerLayer.fillColor = GestureUnlockErrorColor.CGColor;
    } else {
        self.centerLayer.fillColor = GestureUnlockMainColor.CGColor;
    }
}

#pragma mark - lazy
- (CAShapeLayer *)contentLayer {
    if (!_contentLayer) {
        _contentLayer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(2, 2, SELF_WIDTH - 4, SELF_HEIGHT - 4) cornerRadius:(SELF_WIDTH - 4)/2];
        _contentLayer.path = path.CGPath;
        _contentLayer.fillColor = ContentFillColor.CGColor;
        _contentLayer.strokeColor = ContentStrokeColor.CGColor;
        _contentLayer.strokeStart = 0;
        _contentLayer.strokeEnd = 1;
        _contentLayer.lineWidth = 2;
        _contentLayer.cornerRadius = SELF_WIDTH/2;
    }
    return _contentLayer;
}

- (CAShapeLayer *)borderLayer {
    if (!_borderLayer) {
        _borderLayer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(SELF_WIDTH/2, SELF_HEIGHT/2) radius:SELF_WIDTH/2 startAngle:0 endAngle:2*M_PI clockwise:NO];
        _borderLayer.strokeColor = BorderStrokeNormalColor.CGColor;
        _borderLayer.fillColor = [UIColor clearColor].CGColor;
        _borderLayer.strokeStart = 0;
        _borderLayer.strokeEnd = 1;
        _borderLayer.lineWidth = 2;
        _borderLayer.path = path.CGPath;
    }
    return _borderLayer;
}

- (CAShapeLayer *)centerLayer {
    if (!_centerLayer) {
        _centerLayer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(SELF_WIDTH/2 - (SELF_WIDTH - 4)/4, SELF_HEIGHT/2 - (SELF_HEIGHT - 4)/4, (SELF_WIDTH - 4)/2, (SELF_WIDTH - 4)/2) cornerRadius:(SELF_WIDTH - 4)/4];
        _centerLayer.path = path.CGPath;
        _centerLayer.lineWidth = 3;
        _centerLayer.strokeColor = [UIColor colorWithWhite:0 alpha:0.7].CGColor;
        _centerLayer.fillColor = GestureUnlockMainColor.CGColor;
    }
    return _centerLayer;
}

@end

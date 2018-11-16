//
//  GestureViewController.m
//  GestureUnlock
//
//  Created by zhifu360 on 2018/11/16.
//  Copyright © 2018 ZZJ. All rights reserved.
//

#import "GestureViewController.h"
#import "GestureView.h"
#import "GestureTool.h"
#import "GestureConst.h"

@interface GestureViewController ()

///手势密码view
@property (nonatomic, strong) GestureView *gestureView;
///提示文本
@property (nonatomic, strong) UILabel *hintLabel;
///设置密码时确定按钮
@property (nonatomic, strong) UIButton *confirmBtn;
///设置密码时取消按钮
@property (nonatomic, strong) UIButton *cancelBtn;
///设置的密码
@property (nonatomic, strong) NSArray *selectedIDs;

@end

@implementation GestureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    
    [self handleGestureViewBlock];
}

///UI
- (void)createUI {
    
    //UI
    self.view.backgroundColor = [UIColor colorWithRed:60/255.0f green:62/255.0f blue:65/255.0f alpha:1.0f];
    
    [self.view addSubview:self.gestureView];
    
    [self.view addSubview:self.hintLabel];
    
    [self initButtons];
}

///初始化按钮
- (void)initButtons {
    
    NSArray *btnNames = @[@"取消",@"确定"];
    CGFloat btnWidth = self.view.bounds.size.width/2;
    CGFloat btnHeight = 80.0f;
    for (int i = 0; i < btnNames.count; i ++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*btnWidth, self.view.bounds.size.height - btnHeight, btnWidth, btnHeight)];
        [btn setTitle:btnNames[i] forState:UIControlStateNormal];
        [btn setTitleColor:GestureUnlockMainColor forState:UIControlStateNormal];
        btn.tag = i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        
        if (i == 0) {
            self.cancelBtn = btn;
        } else {
            self.confirmBtn = btn;
        }
    }
    
    self.cancelBtn.hidden = !self.settingGesture;
    self.confirmBtn.hidden = !self.settingGesture;
}

//点击事件
- (void)btnClick:(UIButton *)button {
    
    NSLog(@"%@",button.titleLabel.text);
    
    if (button.tag == 1) {
        //确定
        if (self.selectedIDs.count > 3) {
            //保存手势密码至本地
            [GestureTool setGesturePassword:self.selectedIDs];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } else {
            [GestureTool alertWithAction:@"手势密码不得为空" vc:self action:^{
                
            }];
        }
    } else {
        //取消
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

///处理gestureView的block
- (void)handleGestureViewBlock {
    
    __weak typeof(self) weakSelf = self;
    
    //设置手势，记录设置的密码，待确定后保存至本地
    self.gestureView.gestureBlock = ^(NSArray * _Nonnull selectedIDs) {
        NSLog(@"设置的手势密码===%@",selectedIDs);
        weakSelf.hintLabel.hidden = YES;
        weakSelf.selectedIDs = [NSArray arrayWithArray:selectedIDs];
    };
    
    //判断解锁状态
    self.gestureView.unlockBlock = ^(BOOL isSuccess) {
        
        weakSelf.hintLabel.hidden = NO;
        weakSelf.hintLabel.text = isSuccess ? @"解锁成功" : @"解锁失败";
        weakSelf.hintLabel.textColor = isSuccess ? GestureUnlockSuccessColor : GestureUnlockErrorColor;
        
        //闭包
        if (weakSelf.gestureResult) {
            weakSelf.gestureResult(isSuccess);
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(NSEC_PER_SEC * 1.5)), dispatch_get_main_queue(), ^{
            if (isSuccess) {
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            } else {
                weakSelf.hintLabel.hidden = YES;
            }
        });
        
    };
    
    //设置失败
    self.gestureView.settingFailureBlock = ^{
        weakSelf.hintLabel.hidden = NO;
        weakSelf.hintLabel.text = @"手势密码不得少于4个点";
        weakSelf.hintLabel.textColor = GestureUnlockErrorColor;
    };
}

#pragma mark - lazy
- (GestureView *)gestureView {
    if (!_gestureView) {
        _gestureView = [[GestureView alloc] initWithFrame:CGRectMake(40, self.view.bounds.size.height / 2.0 - (self.view.bounds.size.width - 80.0) / 2.0, self.view.bounds.size.width - 80.0, self.view.bounds.size.width - 80.0)];
        _gestureView.settingGesture = self.settingGesture;
    }
    return _gestureView;
}

- (NSArray *)selectedIDs {
    if (!_selectedIDs) {
        _selectedIDs = [NSArray array];
    }
    return _selectedIDs;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton new];
    }
    return _cancelBtn;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [UIButton new];
    }
    return _confirmBtn;
}

- (UILabel *)hintLabel {
    if (!_hintLabel) {
        _hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height+10, self.view.bounds.size.width, 16)];
        _hintLabel.font = [UIFont systemFontOfSize:16];
        _hintLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _hintLabel;
}

@end

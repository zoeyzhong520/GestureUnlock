//
//  HomeViewController.m
//  GestureUnlock
//
//  Created by zhifu360 on 2018/11/16.
//  Copyright © 2018 ZZJ. All rights reserved.
//

#import "HomeViewController.h"
#import "Gesture.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"Home";
    
    //重置手势密码
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"重置手势" style:UIBarButtonItemStylePlain target:self action:@selector(resetGesture)];
    
    NSLog(@"GestureUnlockPassword===%@",[GestureTool gesturePassword]);
    
    if ([GestureTool gesturePassword].count == 0) {
        [self presentVCWithClassName:@"GestureViewController" withParamDic:@{@"settingGesture":@(YES)}];
    } else {
        [self presentVCWithClassName:@"GestureViewController" withParamDic:@{@"settingGesture":@(NO)}];
    }
}

//点击事件
- (void)resetGesture {
    
    [GestureTool deleteGesturePassword];
    
    [self presentVCWithClassName:@"GestureViewController" withParamDic:@{@"settingGesture":@(YES)}];
}

- (void)presentVCWithClassName:(NSString *)className withParamDic:(NSDictionary *)paramDic {
    
    if (!className && !className.length) {
        return;
    }
    
    Class vcFromName = NSClassFromString(className);
    UIViewController *vc = [[vcFromName alloc] init];
    if (paramDic && paramDic.count > 0) {
        [paramDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            // 在属性赋值时，做容错处理，防止因为后台数据导致的异常
            if ([vc respondsToSelector:NSSelectorFromString(key)]) {
                [vc setValue:obj forKey:key];
            }
            
        }];
    }
    
    [self presentViewController:vc animated:YES completion:nil];
}

@end

//
//  HomeViewController.m
//  GestureUnlock
//
//  Created by zhifu360 on 2018/11/16.
//  Copyright © 2018 ZZJ. All rights reserved.
//

#import "HomeViewController.h"

//GestureUnlockKey
static NSString * GestureUnlockKey = @"GestureUnlock";

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"Home";
    
    NSLog(@"GestureUnlockKey===%@",[[NSUserDefaults standardUserDefaults] objectForKey:GestureUnlockKey]);
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:GestureUnlockKey]) {
        [self presentVCWithClassName:@"GestureViewController" withParamDic:@{@"settingGesture":@(YES)}];
    } else {
        [self presentVCWithClassName:@"GestureViewController" withParamDic:@{@"settingGesture":@(NO)}];
    }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

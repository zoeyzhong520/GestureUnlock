//
//  GestureTool.m
//  GestureUnlock
//
//  Created by 仲召俊 on 2018/11/16.
//  Copyright © 2018 ZZJ. All rights reserved.
//

#import "GestureTool.h"

//GestureUnlockKey
static NSString * GestureUnlockKey = @"GestureUnlock";

#define GestureUserDefaults [NSUserDefaults standardUserDefaults]

@implementation GestureTool

+ (void)setGesturePassword:(NSArray *)selectedIDs {
    
    [GestureUserDefaults setObject:selectedIDs forKey:GestureUnlockKey];
    [GestureUserDefaults synchronize];
}

+ (void)deleteGesturePassword {
    
    [GestureTool setGesturePassword:[NSArray array]];
}

+ (NSArray *)gesturePassword {
    
    return [GestureUserDefaults objectForKey:GestureUnlockKey] ?: [NSArray array];
}

+ (void)alertWithAction:(NSString *)message vc:(UIViewController *)vc action:(dispatch_block_t)actionBlock {
    
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alertControl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        actionBlock();
    }]];
    
    [vc presentViewController:alertControl animated:YES completion:nil];
}

@end

//
//  GestureTool.h
//  GestureUnlock
//
//  Created by 仲召俊 on 2018/11/16.
//  Copyright © 2018 ZZJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GestureTool : NSObject

///保存设置的手势密码
+ (void)setGesturePassword:(NSArray *)selectedIDs;

///删除设置的手势密码
+ (void)deleteGesturePassword;

///获取设置的手势密码
+ (NSArray *)gesturePassword;

///设置弹框
+ (void)alertWithAction:(NSString *)message vc:(UIViewController *)vc action:(dispatch_block_t)actionBlock;

@end

NS_ASSUME_NONNULL_END

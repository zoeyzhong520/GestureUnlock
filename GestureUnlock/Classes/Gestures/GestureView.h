//
//  GestureView.h
//  GestureUnlock
//
//  Created by zhifu360 on 2018/11/16.
//  Copyright © 2018 ZZJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 圆点按钮的初始化和布局

@interface GestureView : UIView

/**
 设置密码时，返回设置的手势密码
 */
@property (nonatomic, copy) void(^gestureBlock)(NSArray *selectedIDs);

/**
 返回解锁成功还是失败状态
 */
@property (nonatomic, copy) void(^unlockBlock)(BOOL isSuccess);

/**
 判断手势密码时候设置成功（手势密码不得少于四个点）
 */
@property (nonatomic, copy) dispatch_block_t settingFailureBlock;

/**
 判断是设置手势还是手势解锁
 */
@property (nonatomic, assign) BOOL settingGesture;

@end

NS_ASSUME_NONNULL_END

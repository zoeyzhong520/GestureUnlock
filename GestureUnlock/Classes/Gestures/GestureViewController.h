//
//  GestureViewController.h
//  GestureUnlock
//
//  Created by zhifu360 on 2018/11/16.
//  Copyright © 2018 ZZJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 展示UI

@interface GestureViewController : UIViewController

/**
 判断是设置手势还是手势解锁
 */
@property (nonatomic, assign) BOOL settingGesture;

///手势解锁结果
@property (nonatomic, copy) void(^gestureResult)(BOOL isSuccess);

@end

NS_ASSUME_NONNULL_END

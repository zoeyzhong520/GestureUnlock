//
//  PointView.h
//  GestureUnlock
//
//  Created by zhifu360 on 2018/11/16.
//  Copyright © 2018 ZZJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GestureConst.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - 圆点手势按钮

@interface PointView : UIView

- (instancetype)initWithFrame:(CGRect)frame withID:(NSString *)ID;

///ID
@property (nonatomic, copy, readonly) NSString *ID;
///选中
@property (nonatomic, assign) BOOL isSelected;
///解锁失败
@property (nonatomic, assign) BOOL isError;
///解锁成功
@property (nonatomic, assign) BOOL isSuccess;

@end

NS_ASSUME_NONNULL_END

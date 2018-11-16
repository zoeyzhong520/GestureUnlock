//
//  PointView.h
//  GestureUnlock
//
//  Created by zhifu360 on 2018/11/16.
//  Copyright © 2018 ZZJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define GestureRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define GestureRGB(r,g,b) GestureRGBA(r,g,b,1.0f)
#define ContentFillColor GestureRGB(46,47,50)
#define ContentStrokeColor GestureRGB(26,27,29)
#define BorderStrokeNormalColor GestureRGB(105,108,111)
#define GestureUnlockSeccessColor GestureRGB(43,210,110)
#define GestureUnlockErrorColor GestureRGB(222,64,60)
#define GestureUnlockMainColor GestureRGB(30,180,244)

//GestureUnlockKey
#define GestureUnlockKey @"GestureUnlock"

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

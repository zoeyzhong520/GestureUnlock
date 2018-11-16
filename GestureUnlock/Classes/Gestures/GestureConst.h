//
//  GestureConst.h
//  GestureUnlock
//
//  Created by 仲召俊 on 2018/11/16.
//  Copyright © 2018 ZZJ. All rights reserved.
//

#ifndef GestureConst_h
#define GestureConst_h

//宏定义
#define GestureRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define GestureRGB(r,g,b) GestureRGBA(r,g,b,1.0f)
#define ContentFillColor GestureRGB(46,47,50)
#define ContentStrokeColor GestureRGB(26,27,29)
#define BorderStrokeNormalColor GestureRGB(105,108,111)
#define GestureUnlockSuccessColor GestureRGB(43,210,110)
#define GestureUnlockErrorColor GestureRGB(222,64,60)
#define GestureUnlockMainColor GestureRGB(30,180,244)

//GestureUnlockKey
#define GestureUnlockKey @"GestureUnlock"

#endif /* GestureConst_h */

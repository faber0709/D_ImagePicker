//
//  D_Macros.h
//  ImagePicker
//
//  Created by 丁鹏飞 on 2018/10/30.
//  Copyright © 2018 丁鹏飞. All rights reserved.
//

#ifndef D_Macros_h
#define D_Macros_h


#define TOWeak(weakName) __weak typeof(self) weakName = self

#define D_SCREEN_WIDTH                    CGRectGetWidth([UIScreen mainScreen].bounds)
#define D_SCREEN_HEIGHT                   CGRectGetHeight([UIScreen mainScreen].bounds)

#endif /* D_Macros_h */

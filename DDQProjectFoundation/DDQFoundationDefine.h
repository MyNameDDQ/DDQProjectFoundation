//
//  DDQFoundationDefine.h
//
//  Copyright © 2017年 DDQ. All rights reserved.

/**
 
 摘要：这是工程的宏集合
 
 */
#ifndef DDQFoundationDefine_h
#define DDQFoundationDefine_h

//工程宏
#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
#define kDeviceHeight [UIScreen mainScreen].bounds.size.height
#define kSetImage(name) [UIImage imageNamed:name]
#define kFindNib(class) [UINib nibWithNibName:NSStringFromClass(class) bundle:[NSBundle mainBundle]]

#endif /* DDQFoundationDefine_h */

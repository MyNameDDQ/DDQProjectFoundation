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
#define kSetColor(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#ifdef DEBUG
    #define DDQLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
    #define DDQLog(...)
#endif

#define DDQSystemVersion [UIDevice currentDevice].systemVersion.floatValue
#define DDQ_iOS_VersionLater(version) DDQSystemVersion >= version ? YES:NO

#define DDQWeakObject(objc)  __weak typeof(objc) weakObjc = objc

#endif /* DDQFoundationDefine_h */

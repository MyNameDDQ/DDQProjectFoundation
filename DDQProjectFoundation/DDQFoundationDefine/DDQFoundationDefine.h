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

#define DDQStrongObject(objc)  __strong typeof(objc) strongObjc = objc

#define DDQ_DEPRECATED(_available, _deprecated, ...)  NS_DEPRECATED_IOS(_available, _deprecated, __VA_ARGS__)

#define DDQ_DEPRECATED_V(_available, _deprecated, __VA_ARGS__) NS_DEPRECATED_IOS(_available, _deprecated, __VA_ARGS__)

#define DDQ_REQUIRES_SUPER __attribute__((objc_requires_super))

#define DDQ_SOURCE_PATH(bundleName, extension) [NSBundle bundleWithPath: \
[[NSBundle mainBundle] pathForResource:bundleName ofType:extension]]

#define DDQ_SOURCE_FILE(bundleName, bExtension, fileName, fExtension) [UIImage imageWithContentsOfFile: \
[DDQ_SOURCE_PATH(bundleName, bExtension) pathForResource:fileName ofType:fExtension]]

#define DDQ_DEFAULT_SOURCE_PATH DDQ_SOURCE_PATH(@"DDQFoundationSource", @"bundle")

#define DDQ_DEFAULT_SOURCE_IMAGE(imageName, extension) [UIImage imageWithContentsOfFile: \
[DDQ_DEFAULT_SOURCE_PATH pathForResource:imageName ofType:extension]]

#define DDQ_DEFAULT_SOURCE_FILEPATH(fileName, extension) [DDQ_DEFAULT_SOURCE_PATH \
pathForResource:fileName ofType:extension]

#if __has_attribute(objc_designated_initializer)
#define DDQ_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
#endif

#endif /* DDQFoundationDefine_h */

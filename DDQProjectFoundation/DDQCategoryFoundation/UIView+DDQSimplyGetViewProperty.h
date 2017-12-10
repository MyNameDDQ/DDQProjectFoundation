//
//  UIView+DDQSimplyGetViewProperty.h
//
//  Copyright © 2017年 DDQ. All rights reserved.

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DDQFoundationRateDeviceVersion) {
    
    DDQFoundationRateDevice_unknown,    //不是iPhone设备(不支持2G,3GS)
    DDQFoundationRateDevice_iPhone4,    //4屏幕比例大小(包含：4s)
    DDQFoundationRateDevice_iPhone5,    //5屏幕比例大小(包含：5,5c,5s,SE)
    DDQFoundationRateDevice_iPhone6,    //6屏幕比例大小(包含：6,7,8)
    DDQFoundationRateDevice_iPhone6P,   //6p屏幕比例大小(包含：6p,7p,8p)
    DDQFoundationRateDevice_iPhoneX,    //iPhoneX 5.8英寸屏
};

struct DDQRateSet {
    
    CGFloat widthRate;
    CGFloat heightRate;
};
typedef struct DDQRateSet DDQRateSet;

@interface UIView (DDQSimplyGetViewProperty)

@property (nonatomic, assign, readonly) CGFloat x;//x起点
@property (nonatomic, assign, readonly) CGFloat y;//y起点
@property (nonatomic, assign, readonly) CGFloat width;//宽度
@property (nonatomic, assign, readonly) CGFloat height;//高度

/**
 获取当前屏幕的宽高比
 
 @param version 以什么设备为比例基础
 @return 宽高比
 */
+ (DDQRateSet)view_getCurrentDeviceRateWithVersion:(DDQFoundationRateDeviceVersion)version;

/**
 获取当前设备的型号
 */
+ (DDQFoundationRateDeviceVersion)view_getDeviceVersion;

@end

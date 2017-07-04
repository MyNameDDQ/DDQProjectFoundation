//
//  UIView+DDQSimplyGetViewProperty.h
//
//  Copyright © 2017年 DDQ. All rights reserved.

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DDQFoundationRateDeviceVersion) {
    
    DDQFoundationRateDevice_iPhone4s,
    DDQFoundationRateDevice_iPhone5,
    DDQFoundationRateDevice_iPhone6,
    DDQFoundationRateDevice_iPhone6P,
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
- (DDQRateSet)view_getCurrentDeviceRateWithVersion:(DDQFoundationRateDeviceVersion)version;

@end

//
//  UIView+DDQSimplyGetViewProperty.m
//
//  Copyright © 2017年 DDQ. All rights reserved.

#import "UIView+DDQSimplyGetViewProperty.h"

@implementation UIView (DDQSimplyGetViewProperty)

- (CGFloat)x {

    return self.frame.origin.x;
}

- (CGFloat)y {

    return self.frame.origin.y;
}

- (CGFloat)width {

    return self.frame.size.width;
}

- (CGFloat)height {

    return self.frame.size.height;
}

- (DDQRateSet)view_getCurrentDeviceRateWithVersion:(DDQFoundationRateDeviceVersion)version {

    CGFloat wRate = 0.0;
    CGFloat hRate = 0.0;
    if (version == DDQFoundationRateDevice_iPhone5) {
        
        wRate = [UIScreen mainScreen].bounds.size.width / 320.0;
        hRate = [UIScreen mainScreen].bounds.size.height / 568.0;
    } else if (version == DDQFoundationRateDevice_iPhone6) {
        
        wRate = [UIScreen mainScreen].bounds.size.width / 375.0;
        hRate = [UIScreen mainScreen].bounds.size.height / 667.0;
    } else if (version == DDQFoundationRateDevice_iPhone6P) {
        
        wRate = [UIScreen mainScreen].bounds.size.width / 414.0;
        hRate = [UIScreen mainScreen].bounds.size.height / 736.0;
    } else {
        
        wRate = [UIScreen mainScreen].bounds.size.width / 320.0;
        hRate = [UIScreen mainScreen].bounds.size.height / 480.0;
    }
    DDQRateSet rateSet = {wRate, hRate};
    return rateSet;
}

@end

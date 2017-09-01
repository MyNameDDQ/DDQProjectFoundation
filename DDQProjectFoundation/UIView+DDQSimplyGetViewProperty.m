//
//  UIView+DDQSimplyGetViewProperty.m
//
//  Copyright © 2017年 DDQ. All rights reserved.

#import "UIView+DDQSimplyGetViewProperty.h"

#import <sys/utsname.h>

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

+ (DDQFoundationRateDeviceVersion)view_getDeviceVersion {

    struct utsname deviceInfo;
    uname(&deviceInfo);
    
    NSString *machine = [[NSString alloc] initWithUTF8String:deviceInfo.machine];
    NSArray *iPhone4Series = @[@"iPhone3,1", @"iPhone3,2", @"iPhone3,3", @"iPhone4,1"];
    if ([iPhone4Series containsObject:machine]) return DDQFoundationRateDevice_iPhone4;
    
    NSArray *iPhone5Series = @[@"iPhone5,1", @"iPhone5,2", @"iPhone5,3", @"iPhone5,4", @"iPhone8,4"];//@"iPhone8,4"表示SE
    if ([iPhone5Series containsObject:machine]) return DDQFoundationRateDevice_iPhone5;
    
    NSArray *iPhone6Series = @[@"iPhone7,2", @"iPhone8,1", @"iPhone9,1"];//6,6s,7
    if ([iPhone6Series containsObject:machine]) return DDQFoundationRateDevice_iPhone6;
    
    NSArray *iPhone6PSeries = @[@"iPhone8,2", @"iPhone9,2"];//6p,7p
    if ([iPhone6PSeries containsObject:machine]) return DDQFoundationRateDevice_iPhone6P;
    
    return DDQFoundationRateDevice_unknown;
}

+ (DDQRateSet)view_getCurrentDeviceRateWithVersion:(DDQFoundationRateDeviceVersion)version {

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

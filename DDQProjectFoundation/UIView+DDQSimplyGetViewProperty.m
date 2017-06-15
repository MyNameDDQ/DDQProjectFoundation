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
@end

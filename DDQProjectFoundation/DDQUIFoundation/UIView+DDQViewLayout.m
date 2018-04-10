//
//  UIView+DDQViewLayout.m
//
//  Copyright © 2018年 我叫咚咚枪. All rights reserved.


#import "UIView+DDQViewLayout.h"

@implementation UIView (DDQViewLayout)

- (DDQLayoutAttribute *)layout_leading {
    
    DDQLayoutAttribute *attribute = [[DDQLayoutAttribute alloc] initAttributeWithView:self];
    return attribute.leading(CGRectGetMinX(self.frame));

}

- (DDQLayoutAttribute *)layout_trailing {
    
    DDQLayoutAttribute *attribute = [[DDQLayoutAttribute alloc] initAttributeWithView:self];
    return attribute.trailing(CGRectGetMaxX(self.frame));
    
}

- (DDQLayoutAttribute *)layout_top {
    
    DDQLayoutAttribute *attribute = [[DDQLayoutAttribute alloc] initAttributeWithView:self];
    return attribute.top(CGRectGetMinY(self.frame));
    
}

- (DDQLayoutAttribute *)layout_bottom {
    
    DDQLayoutAttribute *attribute = [[DDQLayoutAttribute alloc] initAttributeWithView:self];
    return attribute.bottom(CGRectGetMaxY(self.frame));
    
}

- (DDQLayoutAttribute *)layout_centerX {
    
    DDQLayoutAttribute *attribute = [[DDQLayoutAttribute alloc] initAttributeWithView:self];
    return attribute.centerX(CGRectGetMidX(self.frame));
    
}

- (DDQLayoutAttribute *)layout_centerY {
    
    DDQLayoutAttribute *attribute = [[DDQLayoutAttribute alloc] initAttributeWithView:self];
    return attribute.centerY(CGRectGetMidY(self.frame));
    
}

- (DDQLayoutAttribute *)layout_center {
    
    DDQLayoutAttribute *attribute = [[DDQLayoutAttribute alloc] initAttributeWithView:self];
    return attribute.center(self.center);
    
}

@end

//
//  UIView+DDQViewLayout.m
//
//  Copyright © 2018年 我叫咚咚枪. All rights reserved.


#import "UIView+DDQViewLayout.h"

@implementation UIView (DDQViewLayout)

- (DDQLayoutAttribute *)leading {

    return [[DDQLayoutAttribute alloc] initAttributeWithView:self style:DDQLayoutAttributeStyleLeading];

}

- (DDQLayoutAttribute *)trailing {
    
    return [[DDQLayoutAttribute alloc] initAttributeWithView:self style:DDQLayoutAttributeStyleTrailing];

}

- (DDQLayoutAttribute *)top {
    
    return [[DDQLayoutAttribute alloc] initAttributeWithView:self style:DDQLayoutAttributeStyleTop];

}

- (DDQLayoutAttribute *)bottom {
    
    return [[DDQLayoutAttribute alloc] initAttributeWithView:self style:DDQLayoutAttributeStyleBottom];
    
}

- (DDQLayoutAttribute *)centerX {
    
    return [[DDQLayoutAttribute alloc] initAttributeWithView:self style:DDQLayoutAttributeStyleCenterX];

}

- (DDQLayoutAttribute *)centerY {
    
    return [[DDQLayoutAttribute alloc] initAttributeWithView:self style:DDQLayoutAttributeStyleCenterY];

}

- (DDQLayoutAttribute *)centerPoint {
    
    return [[DDQLayoutAttribute alloc] initAttributeWithView:self style:DDQLayoutAttributeStyleCenter];

}

@end

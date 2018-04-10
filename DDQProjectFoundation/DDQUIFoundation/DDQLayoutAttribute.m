//
//  DDQLayoutAttribute.m
//
//  Copyright © 2018年 我叫咚咚枪. All rights reserved.


#import "DDQLayoutAttribute.h"

@interface DDQLayoutAttribute ()


@end

@implementation DDQLayoutAttribute

@synthesize leadingConstraint = _leadingConstraint;
@synthesize trailingConstraint = _trailingConstraint;
@synthesize topConstraint = _topConstraint;
@synthesize bottomConstraint = _bottomConstraint;
@synthesize centerXConstraint = _centerXConstraint;
@synthesize centerYConstraint = _centerYConstraint;
@synthesize centerPoint = _centerPoint;
@synthesize layoutView = _layoutView;

- (instancetype)initAttributeWithView:(__kindof UIView *)view {
    
    self = [super init];
    
    _layoutView = view;
    
    return self;
    
}

- (instancetype)init {

    return [self initAttributeWithView:nil];

}

- (DDQLayoutAttributeLeading)leading {
    
    return ^DDQLayoutAttribute *(CGFloat constraint) {
        
        _leadingConstraint = constraint;
        return self;
        
    };
}

- (DDQLayoutAttributeTrailing)trailing {
    
    return ^DDQLayoutAttribute *(CGFloat constraint) {
        
        _trailingConstraint = constraint;
        return self;
        
    };
}

- (DDQLayoutAttributeTop)top {
    
    return ^DDQLayoutAttribute *(CGFloat constraint) {
        
        _topConstraint = constraint;
        return self;
        
    };
}

- (DDQLayoutAttributeBottom)bottom {
    
    return ^DDQLayoutAttribute *(CGFloat constraint) {
        
        _bottomConstraint = constraint;
        return self;
        
    };
}

- (DDQLayoutAttributeCenterX)centerX {
    
    return ^DDQLayoutAttribute *(CGFloat constraint) {
        
        _centerXConstraint = constraint;
        return self;
        
    };
}

- (DDQLayoutAttributeCenterY)centerY {
    
    return ^DDQLayoutAttribute *(CGFloat constraint) {
        
        _centerYConstraint = constraint;
        return self;
        
    };
}

- (DDQLayoutAttributeCenter)center {
    
    return ^DDQLayoutAttribute *(CGPoint point) {
        
        _centerPoint = point;
        return self;
        
    };
}

- (UIView *)layoutView {
    
    return _layoutView;
    
}

- (CGFloat)leadingConstraint {
    
    return _leadingConstraint;
    
}

- (CGFloat)trailingConstraint {
    
    return _trailingConstraint;
    
}

- (CGFloat)topConstraint {
    
    return _topConstraint;
    
}

- (CGFloat)bottomConstraint {
    
    return _bottomConstraint;
    
}

- (CGFloat)centerXConstraint {
    
    return _centerXConstraint;
    
}

- (CGFloat)centerYConstraint {
    
    return _centerYConstraint;
    
}

- (CGPoint)centerPoint {
    
    return _centerPoint;
    
}

@end

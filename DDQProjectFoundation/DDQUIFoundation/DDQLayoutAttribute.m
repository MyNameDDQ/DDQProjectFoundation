//
//  DDQLayoutAttribute.m
//
//  Copyright © 2018年 我叫咚咚枪. All rights reserved.


#import "DDQLayoutAttribute.h"

@interface DDQLayoutAttribute ()

@property (nonatomic, assign) DDQLayoutAttributeStyle style;

@end

@implementation DDQLayoutAttribute

@synthesize layoutView = _layoutView;

- (instancetype)initAttributeWithView:(__kindof UIView *)view style:(DDQLayoutAttributeStyle)style {
    
    self = [super init];
    
    _layoutView = view;
    self.style = style;
    
    return self;
    
}

- (instancetype)init {

    return [self initAttributeWithView:nil style:DDQLayoutAttributeStyleUnknow];
    
}

- (DDQLayoutAttributeStyle)layoutStyle {
    
    return self.style;
    
}

@end

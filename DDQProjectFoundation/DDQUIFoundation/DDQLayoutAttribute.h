//
//  DDQLayoutAttribute.h
//
//  Copyright © 2018年 我叫咚咚枪. All rights reserved.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DDQLayoutAttribute;

typedef NS_ENUM(NSUInteger, DDQLayoutAttributeStyle) {
    
    DDQLayoutAttributeStyleUnknow,
    DDQLayoutAttributeStyleLeading,
    DDQLayoutAttributeStyleTrailing,
    DDQLayoutAttributeStyleTop,
    DDQLayoutAttributeStyleBottom,
    DDQLayoutAttributeStyleCenterX,
    DDQLayoutAttributeStyleCenterY,
    DDQLayoutAttributeStyleCenter,
    
};

/**
 Layout Attribute
 */
@interface DDQLayoutAttribute : NSObject

- (instancetype)initAttributeWithView:(nullable __kindof UIView *)view style:(DDQLayoutAttributeStyle)style NS_DESIGNATED_INITIALIZER;

@property (nonatomic, readonly) UIView *layoutView;

@property (nonatomic, readonly) DDQLayoutAttributeStyle layoutStyle;

@end

NS_ASSUME_NONNULL_END

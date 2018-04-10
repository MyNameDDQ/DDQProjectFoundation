//
//  DDQLayoutAttribute.h
//
//  Copyright © 2018年 我叫咚咚枪. All rights reserved.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DDQLayoutAttribute;
typedef DDQLayoutAttribute *_Nonnull (^DDQLayoutAttributeLeading)(CGFloat constraint);
typedef DDQLayoutAttribute *_Nonnull (^DDQLayoutAttributeTrailing)(CGFloat constraint);
typedef DDQLayoutAttribute *_Nonnull (^DDQLayoutAttributeTop)(CGFloat constraint);
typedef DDQLayoutAttribute *_Nonnull (^DDQLayoutAttributeBottom)(CGFloat constraint);
typedef DDQLayoutAttribute *_Nonnull (^DDQLayoutAttributeCenterX)(CGFloat constraint);
typedef DDQLayoutAttribute *_Nonnull (^DDQLayoutAttributeCenterY)(CGFloat constraint);
typedef DDQLayoutAttribute *_Nonnull (^DDQLayoutAttributeCenter)(CGPoint point);

/**
 Layout Attribute
 */
@interface DDQLayoutAttribute : NSObject

- (instancetype)initAttributeWithView:(nullable __kindof UIView *)view NS_DESIGNATED_INITIALIZER;

@property (nonatomic, readonly) UIView *layoutView;

@property (nonatomic, readonly) DDQLayoutAttributeLeading leading;
@property (nonatomic, readonly) DDQLayoutAttributeTrailing trailing;
@property (nonatomic, readonly) DDQLayoutAttributeTop top;
@property (nonatomic, readonly) DDQLayoutAttributeBottom bottom;
@property (nonatomic, readonly) DDQLayoutAttributeCenterX centerX;
@property (nonatomic, readonly) DDQLayoutAttributeCenterY centerY;
@property (nonatomic, readonly) DDQLayoutAttributeCenter center;

@property (nonatomic, readonly) CGFloat leadingConstraint;
@property (nonatomic, readonly) CGFloat trailingConstraint;
@property (nonatomic, readonly) CGFloat topConstraint;
@property (nonatomic, readonly) CGFloat bottomConstraint;
@property (nonatomic, readonly) CGFloat centerXConstraint;
@property (nonatomic, readonly) CGFloat centerYConstraint;
@property (nonatomic, readonly) CGPoint centerPoint;


@end

NS_ASSUME_NONNULL_END

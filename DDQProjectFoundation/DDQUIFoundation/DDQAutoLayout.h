//
//  DDQAutoLayout.h
//
//  Copyright © 2018年 我叫咚咚枪. All rights reserved.


#import "UIView+DDQControlInitialize.h"
#import "UIView+DDQViewLayout.h"

NS_ASSUME_NONNULL_BEGIN

@class DDQAutoLayout;
@class DDQLayoutAttribute;

typedef DDQAutoLayout *_Nonnull(^DDQAutoLayoutLeading)(DDQLayoutAttribute *_Nullable attribute, CGFloat constraint);
typedef DDQAutoLayout *_Nonnull(^DDQAutoLayoutTop)(DDQLayoutAttribute *_Nullable attribute, CGFloat constraint);
typedef DDQAutoLayout *_Nonnull(^DDQAutoLayoutBottom)(DDQLayoutAttribute *_Nullable attribute, CGFloat constraint);
typedef DDQAutoLayout *_Nonnull(^DDQAutoLayoutTrailing)(DDQLayoutAttribute *_Nullable attribute, CGFloat constraint);
typedef DDQAutoLayout *_Nonnull(^DDQAutoLayoutCenter)(DDQLayoutAttribute *_Nullable attribute);
typedef DDQAutoLayout *_Nonnull(^DDQAutoLayoutCenterX)(DDQLayoutAttribute *_Nullable attribute, CGFloat constraint);
typedef DDQAutoLayout *_Nonnull(^DDQAutoLayoutCenterY)(DDQLayoutAttribute *_Nullable attribute, CGFloat constraint);

typedef void(^DDQAutoLayoutInsets)(__kindof UIView *view, UIEdgeInsets insets);
typedef void(^DDQAutoLayoutWidth)(CGFloat width);
typedef void(^DDQAutoLayoutHeight)(CGFloat height);
typedef void(^DDQAutoLayoutSize)(CGSize size);
typedef void(^DDQAutoLayoutEstimateSize)(CGSize size);

typedef void(^DDQAutoLayoutFitViewSize)(void);
typedef void(^DDQAutoLayoutFitViewScaleSize)(CGFloat scale);

UIKIT_EXTERN DDQAutoLayout *autoLayout(__kindof UIView *_Nullable view);

/**
 自定义布局
 */
@interface DDQAutoLayout : NSObject

- (instancetype)initLayoutWithView:(nullable __kindof UIView *)view DDQ_DESIGNATED_INITIALIZER;

@property (nonatomic, readonly) DDQAutoLayoutLeading ddq_leading;
@property (nonatomic, readonly) DDQAutoLayoutTrailing ddq_trailing;
@property (nonatomic, readonly) DDQAutoLayoutTop ddq_top;
@property (nonatomic, readonly) DDQAutoLayoutBottom ddq_bottom;
@property (nonatomic, readonly) DDQAutoLayoutCenterX ddq_centerX;
@property (nonatomic, readonly) DDQAutoLayoutCenterY ddq_centerY;
@property (nonatomic, readonly) DDQAutoLayoutCenter ddq_center;

@property (nonatomic, readonly) DDQAutoLayoutInsets ddq_insets;
@property (nonatomic, readonly) DDQAutoLayoutWidth ddq_width;
@property (nonatomic, readonly) DDQAutoLayoutHeight ddq_height;
@property (nonatomic, readonly) DDQAutoLayoutSize ddq_size;
@property (nonatomic, readonly) DDQAutoLayoutEstimateSize ddq_estimateSize;
@property (nonatomic, readonly) DDQAutoLayoutFitViewSize ddq_fitSize;
@property (nonatomic, readonly) DDQAutoLayoutFitViewScaleSize ddq_fitScaleSize;

@end

typedef NS_ENUM(NSUInteger, DDQLayoutDirection) {
    
    DDQLayoutDirectionLTR,          //从左到右
    DDQLayoutDirectionRTL,          //从右到左
    DDQLayoutDirectionTTB,          //从上到下
    DDQLayoutDirectionBTT,          //从下到上
    DDQLayoutDirectionCenter,
    DDQLayoutDirectionCenterX,
    DDQLayoutDirectionCenterY,
    
};

@interface UIView (DDQViewLayoutDirection)

@property (nonatomic, assign) DDQLayoutDirection horDirection;
@property (nonatomic, assign) DDQLayoutDirection verDirection;

@end

NS_ASSUME_NONNULL_END


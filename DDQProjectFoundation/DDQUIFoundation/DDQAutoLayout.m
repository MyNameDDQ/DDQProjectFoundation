//
//  DDQAutoLayout.m
//
//  Copyright © 2018年 我叫咚咚枪. All rights reserved.

#import "DDQAutoLayout.h"

#import <objc/runtime.h>

typedef NS_ENUM(NSUInteger, DDQLayoutOriginType) {
    
    DDQLayoutOriginTypeTop,
    DDQLayoutOriginTypeBottom,
    DDQLayoutOriginTypeLeading,
    DDQLayoutOriginTypeTrailing,
    DDQLayoutOriginTypeCenterX,
    DDQLayoutOriginTypeCenterY,
    DDQLayoutOriginTypeCenter,
    
};

@interface DDQAutoLayout ()

@property (nonatomic, strong) UIView *targetView;
@property (nonatomic, assign) DDQLayoutOriginType layoutOriginType;

@end

@implementation DDQAutoLayout

DDQAutoLayout *autoLayout(__kindof UIView *_Nullable view) {
    
    return [[DDQAutoLayout alloc] initLayoutWithView:view];
    
}

- (instancetype)initLayoutWithView:(__kindof UIView *)view {
    
    self = [super init];
    
    self.targetView = view;
    
    return self;
    
}

- (instancetype)init {
    
    return [self initLayoutWithView:nil];
    
}

#pragma mark - View Origin Config
- (DDQAutoLayoutLeading)ddq_leading {
    
    return ^DDQAutoLayout *(DDQLayoutAttribute *attribute, CGFloat constraint) {
        
        [self layout_handleViewOriginWithType:DDQLayoutOriginTypeLeading attribute:attribute constraint:constraint];
        return self;
        
    };
}

- (DDQAutoLayoutTrailing)ddq_trailing {
    
    return ^DDQAutoLayout *(DDQLayoutAttribute *attribute, CGFloat constraint) {
        
        [self layout_handleViewOriginWithType:DDQLayoutOriginTypeTrailing attribute:attribute constraint:constraint];

        return self;
        
    };
}

- (DDQAutoLayoutTop)ddq_top {
    
    return ^DDQAutoLayout *(DDQLayoutAttribute *attribute, CGFloat constraint) {
        
        [self layout_handleViewOriginWithType:DDQLayoutOriginTypeTop attribute:attribute constraint:constraint];
        return self;
        
    };
}

- (DDQAutoLayoutBottom)ddq_bottom {
    
    return ^DDQAutoLayout *(DDQLayoutAttribute *attribute, CGFloat constraint) {
        
        [self layout_handleViewOriginWithType:DDQLayoutOriginTypeBottom attribute:attribute constraint:constraint];
        return self;
        
    };
}

- (DDQAutoLayoutCenterX)ddq_centerX {
    
    return ^DDQAutoLayout *(DDQLayoutAttribute *attribute, CGFloat constraint) {
        
        [self layout_handleViewOriginWithType:DDQLayoutOriginTypeCenterX attribute:attribute constraint:constraint];
        return self;
        
    };
}

- (DDQAutoLayoutCenterY)ddq_centerY {
    
    return ^DDQAutoLayout *(DDQLayoutAttribute *attribute, CGFloat constraint) {
        
        [self layout_handleViewOriginWithType:DDQLayoutOriginTypeCenterY attribute:attribute constraint:constraint];
        return self;
        
    };
}

- (DDQAutoLayoutCenter)ddq_center {
    
    return ^DDQAutoLayout *(DDQLayoutAttribute *attribute) {
        
        [self layout_handleViewOriginWithType:DDQLayoutOriginTypeTop attribute:attribute constraint:0.0];
        return self;
        
    };
}

#pragma mark - View Size Config
- (DDQAutoLayoutInsets)ddq_insets {
    
    return ^void (__kindof UIView *view, UIEdgeInsets insets) {
        
        CGFloat x = insets.left;
        CGFloat y = insets.top;
        CGFloat w = view.width - insets.left - insets.right;
        CGFloat h = view.height - insets.top - insets.bottom;
        if (![view isEqual:self.targetView.superview]) {
            
            x += view.x;
            y += view.y;
        }
        self.targetView.frame = CGRectMake(x, y, w, h);
        
    };
}

- (DDQAutoLayoutWidth)ddq_width {
    
    return ^void (CGFloat width) {
        
        CGRect targetFrame = self.targetView.frame;
        targetFrame.size.width = width;
        [self layout_handleViewFrameWithNewSize:targetFrame.size];

    };
}

- (DDQAutoLayoutHeight)ddq_height {
    
    return ^void (CGFloat height) {
      
        CGRect targetFrame = self.targetView.frame;
        targetFrame.size.height = height;
        [self layout_handleViewFrameWithNewSize:targetFrame.size];

    };
}

- (DDQAutoLayoutSize)ddq_size {
    
    return ^void (CGSize size) {
        
        [self layout_handleViewFrameWithNewSize:size];
        
    };
}

- (DDQAutoLayoutEstimateSize)ddq_estimateSize {
    
    return ^void (CGSize size) {
        
        CGSize boundSize = [self.targetView sizeThatFits:size];
        
        if (boundSize.height > size.height) {
            
            boundSize.height = size.height;
            
        }
        [self layout_handleViewFrameWithNewSize:boundSize];
            
    };
}

- (DDQAutoLayoutFitViewSize)ddq_fitSize {
    
    return ^void () {
        
        [self.targetView sizeToFit];
        [self layout_handleViewFrameWithNewSize:self.targetView.frame.size];
        
    };
}

- (DDQAutoLayoutFitViewScaleSize)ddq_fitScaleSize {
    
    return ^void (CGFloat scale) {
        
        [self.targetView sizeToFit];
        [self layout_handleViewFrameWithNewSize:CGSizeMake(self.targetView.width * scale, self.targetView.height * scale)];
        
    };
}

#pragma mark - Custom Api
/**
 集中处理view的origin

 @param type 处理的类型
 @param attribute 布局的属性
 @param constraint 布局的间距
 */
- (void)layout_handleViewOriginWithType:(DDQLayoutOriginType)type attribute:(DDQLayoutAttribute *)attribute constraint:(CGFloat)constraint {
    
    CGRect targetFrame = self.targetView.frame;
    CGPoint targetOrigin = targetFrame.origin;
    switch (type) {
            
        case DDQLayoutOriginTypeTop:{
            
            targetOrigin = [self layout_handleViewOriginWithAttribute:attribute];
            targetOrigin.y += constraint;
            self.targetView.verDirection = DDQLayoutDirectionTTB;
            
        }break;
            
        case DDQLayoutOriginTypeLeading:{
            
            targetOrigin = [self layout_handleViewOriginWithAttribute:attribute];
            targetOrigin.x += constraint;
            self.targetView.horDirection = DDQLayoutDirectionLTR;

        } break;

        case DDQLayoutOriginTypeTrailing:{
            
            targetOrigin = [self layout_handleViewOriginWithAttribute:attribute];
            targetOrigin.x -= constraint;
            self.targetView.horDirection = DDQLayoutDirectionRTL;

        } break;
            
        case DDQLayoutOriginTypeBottom:{
            
            targetOrigin = [self layout_handleViewOriginWithAttribute:attribute];
            targetOrigin.y -= constraint;
            self.targetView.verDirection = DDQLayoutDirectionBTT;

        } break;
            
        case DDQLayoutOriginTypeCenter:{
            
            targetOrigin = [self layout_handleViewOriginWithAttribute:attribute];
            self.targetView.verDirection = DDQLayoutDirectionCenter;
            self.targetView.horDirection = DDQLayoutDirectionCenter;
            
        } break;
            
        case DDQLayoutOriginTypeCenterX:{
            
            targetOrigin = [self layout_handleViewOriginWithAttribute:attribute];
            targetOrigin.x += constraint;
            self.targetView.horDirection = DDQLayoutDirectionCenterX;

        } break;
            
        case DDQLayoutOriginTypeCenterY:{
            
            targetOrigin = [self layout_handleViewOriginWithAttribute:attribute];
            targetOrigin.y += constraint;
            self.targetView.verDirection = DDQLayoutDirectionCenterY;

        } break;

        default:
            break;
            
    }
    targetFrame.origin = targetOrigin;
    self.targetView.frame = targetFrame;
    
}

/**
 根据不同的布局属性样式重新确定起始坐标

 @param attribute 自定义布局属性
 @return 新的起始坐标
 */
- (CGPoint)layout_handleViewOriginWithAttribute:(DDQLayoutAttribute *)attribute {
    
    CGPoint newPoint = self.targetView.frame.origin;
    DDQLayoutAttributeStyle style = attribute.layoutStyle;
    if (style == DDQLayoutAttributeStyleLeading) {
        
        newPoint.x = (attribute.layoutView == self.targetView.superview) ? 0.0 : attribute.layoutView.x;
        
    } else if (style == DDQLayoutAttributeStyleTrailing) {
        
        newPoint.x = (attribute.layoutView == self.targetView.superview) ? attribute.layoutView.width : attribute.layoutView.frameMaxX;
        
    } else if (style == DDQLayoutAttributeStyleCenterX) {
        
        newPoint.x = (attribute.layoutView == self.targetView.superview) ? attribute.layoutView.boundsMidX : attribute.layoutView.frameMidX;
        
    } else if (style == DDQLayoutAttributeStyleTop) {
        
        newPoint.y = (attribute.layoutView == self.targetView.superview) ? 0.0 : attribute.layoutView.y;
        
    } else if (style == DDQLayoutAttributeStyleBottom) {
        
        newPoint.y = (attribute.layoutView == self.targetView.superview) ? attribute.layoutView.height : attribute.layoutView.frameMaxY;
        
    } else if (style == DDQLayoutAttributeStyleCenterY) {
        
        newPoint.y = (attribute.layoutView == self.targetView.superview) ? attribute.layoutView.boundsMidY : attribute.layoutView.frameMidY;
        
    } else if (style == DDQLayoutAttributeStyleCenter) {
        
        newPoint = (attribute.layoutView == self.targetView.superview) ? CGPointMake(attribute.layoutView.boundsMidX, attribute.layoutView.boundsMidY) : attribute.layoutView.center;
        
    }
    return newPoint;
    
}

/**
 处理view的frame

 @param size 新赋值的size
 */
- (void)layout_handleViewFrameWithNewSize:(CGSize)size {
    
    CGRect targetFrame = self.targetView.frame;
    targetFrame.size = size;
    targetFrame.origin = [self layout_handleViewOriginWithSize:size];
    
    self.targetView.frame = targetFrame;

}

/**
 修改应为size变化而导致的origin变化

 @param size 新的大小
 @return 新的其实坐标
 */
- (CGPoint)layout_handleViewOriginWithSize:(CGSize)size {
    
    CGRect targetFrame = self.targetView.frame;
    CGPoint targetOrigin = targetFrame.origin;
    switch (self.targetView.horDirection) {
            
        case DDQLayoutDirectionRTL:
            
            targetOrigin.x -= size.width;
            
            break;

        case DDQLayoutDirectionCenterX:
            
            targetOrigin.x -= size.width * 0.5;
            
            break;
            
        case DDQLayoutDirectionCenter:
            
            targetOrigin.x -= size.width * 0.5;
            
            break;

            
        default:
            break;
            
    }
    
    switch (self.targetView.verDirection) {
        
        case DDQLayoutDirectionBTT:
            
            targetOrigin.y -= size.height;
            
            break;
            
        case DDQLayoutDirectionCenterY:
            
            targetOrigin.y -= size.height * 0.5;
            
            break;

        case DDQLayoutDirectionCenter:
            
            targetOrigin.y -= size.height * 0.5;

            break;

            
        default:
            break;
    }
    return targetOrigin;
    
}

@end

@implementation UIView (DDQViewLayoutDirection)

static const char *HorDirection = "Horizontal";
static const char *VerDirection = "Vertical";

- (void)setHorDirection:(DDQLayoutDirection)horDirection {
    
    objc_setAssociatedObject(self, HorDirection, @(horDirection), OBJC_ASSOCIATION_RETAIN);
    
}

- (DDQLayoutDirection)horDirection {
    
    return [objc_getAssociatedObject(self, HorDirection) integerValue];
    
}

- (void)setVerDirection:(DDQLayoutDirection)verDirection {
    
    objc_setAssociatedObject(self, VerDirection, @(verDirection), OBJC_ASSOCIATION_RETAIN);
    
}

- (DDQLayoutDirection)verDirection {
    
    return [objc_getAssociatedObject(self, VerDirection) integerValue];
    
}


@end

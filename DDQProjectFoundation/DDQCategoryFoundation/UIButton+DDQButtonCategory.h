//
//  UIButton+DDQButtonCategory.h
//
//  Copyright © 2017年 DDQ. All rights reserved.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NSString *DDQButtonBeginSourceKey;
/**
 和UIButton有关的Category
 */
@interface UIButton (DDQButtonCategory)

/**
 Button倒计时
 
 @param interval 倒计时间隔
 @param total 计时的总时间
 @param completion 计时完成情况
 */
- (void)button_countDownWithInterval:(NSTimeInterval)interval totalTime:(float)total comletion:(void(^)(BOOL finished, NSDictionary *_Nullable beginSource))completion;

@end

UIKIT_EXTERN DDQButtonBeginSourceKey const DDQButtonBeginTitle;
UIKIT_EXTERN DDQButtonBeginSourceKey const DDQButtonBeginTextColor;
UIKIT_EXTERN DDQButtonBeginSourceKey const DDQButtonBeginAttributeTitle;
UIKIT_EXTERN DDQButtonBeginSourceKey const DDQButtonBeginBackgroundColor;

NS_ASSUME_NONNULL_END

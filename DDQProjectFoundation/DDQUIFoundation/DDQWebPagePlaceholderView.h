//
//  DDQWebPagePlaceholderView.h
//
//  Copyright © 2017年 DDQ. All rights reserved.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol DDQWebPagePlaceholderDelegate;

/**
 当网页加载出错时的展位视图
 */
@interface DDQWebPagePlaceholderView : UIView

+ (instancetype)placeholderWithTitle:(nullable NSString *)title subTitle:(nullable NSString *)subTitle;

@property (nonatomic, strong) UILabel *placeholder_titleLabel;
@property (nonatomic, strong) UILabel *placeholder_subTitleLabel;
@property (nonatomic, strong) UIButton *placeholder_alertButton;

@property (nonatomic, weak, nullable) id <DDQWebPagePlaceholderDelegate> delegate;

@end

@protocol DDQWebPagePlaceholderDelegate <NSObject>

@optional

/**
 点击了提示的按钮
 */
- (void)placeholder_didSelectAlertWithView:(DDQWebPagePlaceholderView *)placeholderView;

@end

NS_ASSUME_NONNULL_END


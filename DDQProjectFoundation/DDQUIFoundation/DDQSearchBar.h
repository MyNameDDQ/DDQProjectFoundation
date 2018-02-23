//
//  DDQSearchBar.h
//  DDQProjectEdit
//
//  Copyright © 2017年 DDQ. All rights reserved.

#import "UIView+DDQControlInitialize.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, DDQBarUnlessEditingStyle) {
    
    DDQBarUnlessEditingStyleAlignmentCenter,     //显示内容居中.default value
    DDQBarUnlessEditingStyleAlignmentLeft,       //显示内容居左
};
@protocol DDQSearchBarDelegate;
/**
 自定义搜索框
 */
@interface DDQSearchBar : UITextField <NSCopying, UITextFieldDelegate>

/**
 根据内容显示样式进行初始化
 */
+ (instancetype)searchBarWithStyle:(DDQBarUnlessEditingStyle)style;

/**
 未选中状态下占位字符和图片的显示
 当有文字输入时，默认居左
 */
@property (nonatomic, readonly) DDQBarUnlessEditingStyle bar_unlessStyle;

@property (nonatomic, assign) CGFloat bar_leftMargin;//leftView的左边距

/** 各内容之间的间距 */
@property (nonatomic, assign) CGFloat bar_contentSpace;//default 3.0

/** 是否允许自动对边框且圆角 */
@property (nonatomic, assign) BOOL bar_allowCorner;//default YES

/**
 占位字符串
 我默认显示属性字符串
 */
@property (nonatomic, copy) NSString *bar_placeholderText;//default attributePlaceholder

/** 属性字符串的属性 */
@property (nonatomic, copy) NSDictionary<NSAttributedStringKey, id> *bar_attributes;

@property (nonatomic, weak, nullable) id <DDQSearchBarDelegate> searchDelegate;

@end

@protocol DDQSearchBarDelegate <NSObject>

@optional
- (void)searchBar_beginEditing;
- (void)searchBar_endEditing;
- (void)searchBar_text:(nullable NSString *)text relpaceText:(nullable NSString *)rText range:(NSRange)range ;

@end

NS_ASSUME_NONNULL_END

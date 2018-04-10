//
//  DDQAlertItem.h
//
//  Copyright © 2017年 DDQ. All rights reserved.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DDQAlertItemStyle) {
    DDQAlertItemStyleDefault,       //一个默认的类型,一个label
    DDQAlertItemStyleCustom,        //一个自定义的类型
};
@protocol DDQAlertItemDelegate;

/**
 AlertController的Item
 */
@interface DDQAlertItem : UIView

/**
 初始化方法
 
 @param style 视图的类型
 */
+ (instancetype)alertItemWithStyle:(DDQAlertItemStyle)style;

@property (nonatomic, copy, nullable) NSString *item_title;//default @""
@property (nonatomic, strong, nullable) NSAttributedString *item_attrTitle;//default nil
@property (nonatomic, strong, nullable) UIFont *item_font;//default system font size 17.0
@property (nonatomic, weak, nullable) id <DDQAlertItemDelegate> delegate;

@end

@protocol DDQAlertItemDelegate <NSObject>

@optional

/**
 Item被点击
 */
- (void)alert_itemSelectedWithItem:(DDQAlertItem *)item;

@end

NS_ASSUME_NONNULL_END


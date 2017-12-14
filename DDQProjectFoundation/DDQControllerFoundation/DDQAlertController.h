//
//  DDQAlertController.h
//
//  Copyright © 2017年 DDQ. All rights reserved.

#import "DDQFoundationController.h"

NS_ASSUME_NONNULL_BEGIN

@class DDQAlertItem;

typedef NS_ENUM(NSUInteger, DDQAlertControllerStyle) {
    DDQAlertControllerStyleAlert,                    //类似于系统的Alert
    DDQAlertControllerStyleAlertExceptHeader,        //Alert样式除去顶部的提示信息
    DDQAlertControllerStyleSheet,                    //类似于系统的Sheet
    DDQAlertControllerStyleSheetExceptHeader,        //Sheet样式除去顶部的提示信息
};
typedef __kindof DDQAlertItem *_Nullable(^_Nullable DDQAlertItemSetup)(void);
typedef void(^_Nullable DDQAlertItemHandler)(DDQAlertItem *item);
@protocol DDQAlertControllerDelegate;
/**
 提示控制器
 */
@interface DDQAlertController : DDQFoundationController

/**
 初始化方法
 
 @param title 标题
 @param message 消息
 @param style 提示的样式
 */
+ (instancetype)alertControllerWithTitle:(nullable NSString *)title message:(nullable NSString *)message alertStyle:(DDQAlertControllerStyle)style;

@property (nonatomic, strong) UILabel *alert_titleLabel;
@property (nonatomic, strong) UILabel *alert_messageLabel;

@property (nonatomic, strong, readonly) UIView *alert_contentView;//白底的ContentView
@property (nonatomic, strong, readonly) UIView *alert_headerView;//headerView显示标题和消息

/**
 注意只会在：DDQAlertControllerStyleSheet或者DDQAlertControllerStyleSheetExceptHeader才不为nil
 */
@property (nonatomic, strong, readonly) UIView *alert_footContentView;

/**
 Controller上Item的集合
 */
@property (nonatomic, copy, readonly) NSArray<DDQAlertItem *> *alert_items;

/**
 代理方法
 */
@property (nonatomic, weak, nullable) id <DDQAlertControllerDelegate> delegate;

/**
 添加一个Item
 
 @param setup 设置AlertItem
 @param handler Item的点击事件
 */
- (void)alert_addAlertItem:(DDQAlertItemSetup)setup handler:(DDQAlertItemHandler)handler;

/**
 更新当前的提示类型
 */
- (void)alert_updateControllerStyle:(DDQAlertControllerStyle)style;

@end

@protocol DDQAlertControllerDelegate <NSObject>

@optional
/**
 点击的Item的索引
 */
- (void)alert_didSelectItem:(DDQAlertItem *)item;

@end

NS_ASSUME_NONNULL_END


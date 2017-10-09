//
//  DDQAlertController.h
//
//  Created by 我叫咚咚枪 on 2017/10/7.
//

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

@property (nonatomic, copy, nullable) NSString *alert_title;//default @""
@property (nonatomic, copy, nullable) NSString *alert_message;//default @""

@property (nonatomic, strong, nullable) NSAttributedString *alert_attrTitle;//default nil
@property (nonatomic, strong, nullable) NSAttributedString *alert_attrMessage;//default nil

@property (nonatomic, strong, readonly) UIView *alert_contentView;//白底的ContentView
@property (nonatomic, strong, readonly) UIView *alert_headerView;//headerView显示标题和消息

/**
 添加一个Item
 
 @param setup 设置AlertItem
 @param handler Item的点击事件
 */
- (void)alert_addAlertItem:(DDQAlertItemSetup)setup handler:(DDQAlertItemHandler)handler;

@end

NS_ASSUME_NONNULL_END


//
//  DDQNavigationController.h
//
//  Copyright © 2017年 DDQ. All rights reserved.


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NSString *DDQExcptionName;

/**
 自定义导航控制器
 */
@interface DDQNavigationController : UINavigationController

/**
 初始化根视图控制器
 
 @param controllerClass 根控制器类型
 @param nib 是否由Nib进行初始化
 @return 导航控制器
 */
- (instancetype)initWithRootViewControllerClass:(Class)controllerClass FromNib:(BOOL)nib;

/**
 根视图控制器
 */
@property (nonatomic, readonly, strong) __kindof UIViewController *nav_rootViewController;

/**
 当前StatusBar样式
 */
@property (nonatomic, readonly, assign) UIStatusBarStyle nav_barStyle;

/**
 更改StatusBar的样式
 
 @param barStyle 样式类型
 */
- (void)nav_updateNavgationStatusBarStyle:(UIStatusBarStyle)barStyle;

@end

UIKIT_EXTERN DDQExcptionName const DDQInvalidArgumentException;    //错误参数类型

NS_ASSUME_NONNULL_END


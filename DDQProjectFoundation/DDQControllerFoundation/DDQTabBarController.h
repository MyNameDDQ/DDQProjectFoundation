//
//  DDQTabBarController.h
//  DDQProjectEdit
//
//  Copyright © 2017年 DDQ. All rights reserved.

#import <UIKit/UIKit.h>

#import "DDQTabBar.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSString *DDQTabBarItemSourceKey;

/**
 自定义标签控制器
 */
@interface DDQTabBarController : UITabBarController <DDQTabBarDelegate>

/**
 初始化方法

 @param use 是否使用系统的tabBar
 */
- (instancetype)initTabBarControllerUseSystemBar:(BOOL)use;

/**
 Custom TabBar
 当初始化中use为NO时为空
 */
@property (nonatomic, strong) DDQTabBar *tab_tabBar;

/**
 支持旋转的方向
 */
@property (nonatomic, assign) UIInterfaceOrientationMask tab_orientationMask;

/**
 是否支持转屏
 */
@property (nonatomic, assign) BOOL tab_rotate;

/**
 被管理的所有控制器
 */
@property (nonatomic, copy) NSArray<__kindof UIViewController *> *tab_managerControllers;

/**
 设置被管理的控制器
 
 @param controllerClass 控制器的类型
 @param fromXib 是否由Xib初始化
 */
- (void)tab_managerViewControllerClass:(Class)controllerClass fromXib:(BOOL)fromXib itemSource:(nullable NSDictionary<DDQTabBarItemSourceKey, id> *)source;

/**
 添加一个导航控制器。default DDQNavigationController

 @param rootClass 根视图控制器的类
 @param fromXib 是否由xib初始化
 */
- (void)tab_managerNavigationControllerRootClass:(Class)rootClass rootFromXib:(BOOL)fromXib itemSource:(nullable NSDictionary<DDQTabBarItemSourceKey, id> *)source;

/**
 布局Bar上的Item
 PS:当设置好Controller以后一定要掉此方法显示Item
 */
- (void)tab_tabBarLayoutItems;

@end

UIKIT_EXTERN DDQTabBarItemSourceKey const DDQTabBarItemSourceNormalImage;       //未选中状态下的图片
UIKIT_EXTERN DDQTabBarItemSourceKey const DDQTabBarItemSourceSelectedImage;     //已选中状态下的图片
UIKIT_EXTERN DDQTabBarItemSourceKey const DDQTabBarItemSourceItemTitle;         //显示的文字
UIKIT_EXTERN DDQTabBarItemSourceKey const DDQTabBarItemSourceNormalColor;       //未选中状态下的文字颜色
UIKIT_EXTERN DDQTabBarItemSourceKey const DDQTabBarItemSourceSelectedColor;     //已选中状态下的文字颜色

NS_ASSUME_NONNULL_END

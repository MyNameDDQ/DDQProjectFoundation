//
//  DDQTabBarController.m
//  DDQProjectEdit
//
//  Copyright © 2017年 DDQ. All rights reserved.

#import "DDQTabBarController.h"

#import "DDQBarItem.h"
#import "DDQTabBar.h"

#import "DDQNavigationController.h"

@interface DDQTabBarController ()<DDQTabBarDelegate>

@property (nonatomic, assign) BOOL useSystemTabBar;
@property (nonatomic, strong) NSMutableArray<__kindof UIViewController *> *bar_currentControllers;
@property (nonatomic, strong) NSMutableDictionary *bar_itemDataSource;

@end

@implementation DDQTabBarController

@synthesize tab_managerControllers = _tab_managerControllers;

DDQTabBarItemSourceKey const DDQTabBarItemSourceNormalImage = @"item.normalImage";
DDQTabBarItemSourceKey const DDQTabBarItemSourceSelectedImage = @"item.selectedImage";
DDQTabBarItemSourceKey const DDQTabBarItemSourceItemTitle = @"item.itemTitle";
DDQTabBarItemSourceKey const DDQTabBarItemSourceNormalColor = @"item.normalColor";
DDQTabBarItemSourceKey const DDQTabBarItemSourceSelectedColor = @"item.selectedColor";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.bar_currentControllers = [NSMutableArray array];
    self.bar_itemDataSource = [NSMutableDictionary dictionary];
    
    //TabBar Config(判断是否显示自定义TabBar)
    if (!self.useSystemTabBar) [self tab_layoutCustomBar];
}

- (BOOL)shouldAutorotate {
    
    return self.tab_rotate;
    
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return self.tab_orientationMask;
    
}

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    
    self.tab_tabBar.frame = self.tabBar.bounds;
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    [self.tabBar bringSubviewToFront:self.tab_tabBar];
}

#pragma mark - Rewrite Super
- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    
    [super setSelectedIndex:selectedIndex];
    
    self.tab_tabBar.bar_currentIndex = selectedIndex;
    
}

#pragma mark - Custom Method
- (instancetype)initTabBarControllerUseSystemBar:(BOOL)use {
    
    self = [super init];
    if (!self) return nil;
    
    self.useSystemTabBar = use;
    return self;
}

/**
 设置自定义的tabBar
 */
- (void)tab_layoutCustomBar {
    
    self.tab_tabBar = [DDQTabBar tabBarWithFrame:CGRectZero];
    [self.tabBar addSubview:self.tab_tabBar];
    self.tabBar.shadowImage = [[UIImage alloc] init];
    self.tabBar.backgroundImage = [[UIImage alloc] init];
    
    self.tab_tabBar.backgroundColor = [UIColor whiteColor];
    self.tab_tabBar.delegate = self;
}

- (void)tab_tabBarLayoutItems {
    
    (self.useSystemTabBar) ? [self tab_layoutItemWithSystemBar] : [self tab_layoutItemWithCustomBar];
}

/**
 布局系统Item
 */
- (void)tab_layoutItemWithSystemBar {
    
    NSArray<UITabBarItem *> *barItems = self.tabBar.items;
    
    for (UITabBarItem *item in barItems) {
        
        NSDictionary *sourceDic = [self tab_getItemDataSourceWithControllerIndex:[barItems indexOfObject:item]];
        
        item.selectedImage = sourceDic[DDQTabBarItemSourceSelectedImage];
        item.image = sourceDic[DDQTabBarItemSourceNormalImage];
        [item setTitle:sourceDic[DDQTabBarItemSourceItemTitle]];
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:sourceDic[DDQTabBarItemSourceNormalColor]} forState:UIControlStateNormal];
    }
}

/**
 布局自定义Item
 */
- (void)tab_layoutItemWithCustomBar {
    
    NSMutableArray<DDQBarItem *> *tempArray = [NSMutableArray array];
    for (UIViewController *controller in self.bar_currentControllers) {
        
        NSDictionary *dataSource = [self tab_getItemDataSourceWithControllerIndex:[self.bar_currentControllers indexOfObject:controller]];
        
        DDQBarItem *item = [[DDQBarItem alloc] initWithNormalImage:dataSource[DDQTabBarItemSourceNormalImage] selectedImage:dataSource[DDQTabBarItemSourceSelectedImage] normalTitle:dataSource[DDQTabBarItemSourceItemTitle]];
        [item setItemNormalTitleColor:dataSource[DDQTabBarItemSourceNormalColor] selectedColor:dataSource[DDQTabBarItemSourceSelectedColor]];
        [tempArray addObject:item];
    }
    
    self.tab_tabBar.bar_items = tempArray.copy;

}

/**
 获得Item对应的数据源
 */
- (NSDictionary *)tab_getItemDataSourceWithControllerIndex:(NSUInteger)index {
    
    UIViewController *controller = self.bar_currentControllers[index];
    NSDictionary *sourceDic = [self.bar_itemDataSource valueForKey:@(controller.hash).stringValue];
    return sourceDic;
}

#pragma mark - Affect ViewControllers
- (void)tab_managerViewControllerClass:(Class)controllerClass fromXib:(BOOL)fromXib itemSource:(nullable NSDictionary<DDQTabBarItemSourceKey,id> *)source {
    
    [self tab_checkManagerControllerClass:controllerClass];
    
    UIViewController *controller = (fromXib) ? [[controllerClass alloc] initWithNibName:NSStringFromClass(controllerClass) bundle:nil] : [[controllerClass alloc] init];
    [self.bar_currentControllers addObject:controller];

    self.viewControllers = self.bar_currentControllers;
    if (!source) return;//数据源不为空
    [self.bar_itemDataSource setObject:source forKey:@(controller.hash).stringValue];
}

- (void)tab_managerNavigationControllerRootClass:(Class)rootClass rootFromXib:(BOOL)fromXib itemSource:(nullable NSDictionary<DDQTabBarItemSourceKey,id> *)source {
    
    DDQNavigationController *navigationController = [[DDQNavigationController alloc] initWithRootViewControllerClass:rootClass FromNib:fromXib];
    [self.bar_currentControllers addObject:navigationController];
    
    self.viewControllers = self.bar_currentControllers;
    if (!source) return;//数据源不为空
    [self.bar_itemDataSource setObject:source.copy forKey:@(navigationController.hash).stringValue];
}

- (void)setTab_managerControllers:(NSArray<__kindof UIViewController *> *)tab_managerControllers {
    
    _tab_managerControllers = tab_managerControllers;
    self.viewControllers = tab_managerControllers;
}

- (NSArray<UIViewController *> *)tab_managerControllers {
    
    _tab_managerControllers = self.bar_currentControllers.copy;
    return _tab_managerControllers;
}

/**
 处理添加控制器的处理
 */
- (void)tab_checkManagerControllerClass:(Class)class {
    
    if (![class isSubclassOfClass:[UIViewController class]]) {
        [NSException raise:NSInvalidArgumentException format:@"Class不是UIViewController的子类哦"];
    }
}

#pragma mark - CustomBar Delegate
- (void)tabBar_didSelectWithItemIndex:(NSUInteger)index {

    self.selectedIndex = index;

}
@end

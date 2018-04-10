//
//  DDQTabBar.h
//
//  Copyright © 2017年 DDQ. All rights reserved.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class DDQBarItem;
@protocol DDQTabBarDelegate;

/**
 Custom TabBar
 */
@interface DDQTabBar : UIView <NSCopying>

/**
 初始化方法

 @param frame 视图大小
 */
+ (instancetype)tabBarWithFrame:(CGRect)frame;

/**
 背景图片
 */
@property (nonatomic, strong) UIImageView *bar_backgroundImageView;

/**
 当前索引
 */
@property (nonatomic, assign) NSInteger bar_currentIndex;//default 0

/**
 上一次点击的索引
 */
@property (nonatomic, assign, readonly) NSInteger bar_lastIndex;//default 0

/**
 设置的Item
 */
@property (nonatomic, copy) NSArray<DDQBarItem *> *bar_items;

/**
 代理
 */
@property (nonatomic, weak, nullable) id <DDQTabBarDelegate> delegate;

@end

@protocol DDQTabBarDelegate <NSObject>

@optional
/**
 用户点击Item的索引
 */
- (void)tabBar_didSelectWithItemIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END

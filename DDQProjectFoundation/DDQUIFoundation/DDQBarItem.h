//
//  DDQBarItem.h
//  DDQProjectEdit
//
//  Copyright © 2017年 DDQ. All rights reserved.

#import <UIKit/UIKit.h>

#import "DDQFoundationDefine.h"

NS_ASSUME_NONNULL_BEGIN
@protocol DDQBarItemDelegate;

/**
 适用于作为bar上的上下结构的item
 */
@interface DDQBarItem : UIView <NSCopying>

/**
 初始化一个本类的对象

 @param nImage 未选中状态下的图片
 @param sImage 已选中状态下的图片
 @param title item的文字
 */
- (instancetype)initWithNormalImage:(nullable UIImage *)nImage selectedImage:(nullable UIImage *)sImage normalTitle:(nullable NSString *)title DDQ_DESIGNATED_INITIALIZER;

/**
 设置选中和未选中时的文字颜色
 PS:
 1、如果normalColor为空则为默认颜色[UIColor blackColor]
 2、如果selectedColor为空则和normalColor相同。
 
 @param nColor 未选中状态下的文字颜色
 @param sColor 已选中状态下的文字颜色
 */
- (void)setItemNormalTitleColor:(nullable UIColor *)nColor selectedColor:(nullable UIColor *)sColor;

/**
 设置选中和未选中时的图片

 @param nImage 未选中状态下的图片
 @param sImage 已选中状态下的图片
 */
- (void)setItemNormalImage:(nullable UIImage *)nImage selectedImage:(nullable UIImage *)sImage;

/**
 设置代理
 */
@property (nonatomic, weak, nullable) id <DDQBarItemDelegate> delegate;

/**
 显示文字的label
 */
@property (nonatomic, strong) UILabel *item_titleLabel;

/**
 显示图片的imageView
 */
@property (nonatomic, strong) UIImageView *item_imageView;

/**
 item是否被选中
 */
@property (nonatomic, assign, setter=setItemSelected:) BOOL item_selected;//default NO
- (void)setItemSelected:(BOOL)selected;

/**
 item上文字和图片的间距
 */
@property (nonatomic, assign) CGFloat item_controlSpace;//default 4.0

/**
 设置图片距离中心的偏移量
 */
@property (nonatomic, assign) CGFloat item_imageOffsetY;//default 0.0

@end

@protocol DDQBarItemDelegate <NSObject>

@optional
/**
 被点击的按钮
 */
- (void)item_didSelectedWithItem:(DDQBarItem *)item;

@end

NS_ASSUME_NONNULL_END


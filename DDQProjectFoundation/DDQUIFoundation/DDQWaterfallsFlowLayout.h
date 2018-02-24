//
//  DDQWaterfallsFlowLayout.h
//
//  Copyright © 2017年 DDQ. All rights reserved.

#import "UIView+DDQControlInitialize.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DDQCollectionViewFlowLayoutDelegate;
/**
 瀑布流布局
 */
@interface DDQWaterfallsFlowLayout : UICollectionViewFlowLayout

/** 代理方法 */
@property (nonatomic, weak, nullable) id <DDQCollectionViewFlowLayoutDelegate> delegate;

@end

@protocol DDQCollectionViewFlowLayoutDelegate <NSObject>

@required
- (CGFloat)flowLayout:(DDQWaterfallsFlowLayout *)layout heightForItemWithIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)width;

@optional
- (UIEdgeInsets)flowLayoutItemMargin;//default UIEdgeInsetsZero
- (DDQViewVHSpace)flowLayoutItemSpace;//default DDQViewVHSpaceZero
- (NSInteger)flowLayoutItemColumnCount;//default 2

@end

NS_ASSUME_NONNULL_END


//
//  DDQBaseCell.h
//
//  Copyright © 2018年 DDQ. All rights reserved.

#import "UIView+DDQControlInitialize.h"

#import "DDQBaseCellModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, DDQTableViewCellSeparatorStyle) {
    
    DDQTableViewCellSeparatorStyleNone,     //不显示分割线
    DDQTableViewCellSeparatorStyleTop,      //显示上边的分割线
    DDQTableViewCellSeparatorStyleBottom,   //显示下边的分割线
    DDQTableViewCellSeparatorStyleTopAndBottom,
};

struct DDQSeparatorMargin {
    
    CGFloat leftMargin;
    CGFloat rightMargin;
};
typedef struct DDQSeparatorMargin DDQSeparatorMargin;
UIKIT_EXTERN const DDQSeparatorMargin DDQSeparatorMarginZero;

UIKIT_EXTERN DDQSeparatorMargin DDQSeparatorMarginMaker(CGFloat l, CGFloat r);

/**
 工程Cell基类
 */
@interface DDQBaseCell : UITableViewCell

/**
 显示cell的样式
 */
@property (nonatomic, assign) DDQTableViewCellSeparatorStyle cell_separatorStyle;//defalut DDQTableViewCellSeparatorStyleNone

@property (nonatomic, strong) UIColor *cell_separatorColor;//default r:153.0, g:153.0, b:153.0

@property (nonatomic, assign) DDQSeparatorMargin cell_separatorMargin;//default DDQSeparatorMarginZero

@property (nonatomic, assign) CGFloat cell_separatorHeight;//default 0.5

@property (nonatomic, assign, readonly) DDQSeparatorMargin cell_defaultMargin;//default 15.0 * 当前屏幕宽度和iPhone6宽度的比例

/** 是否已经布局过 */
@property (nonatomic, readonly) BOOL cell_layoutSubviews;

/** 对于重新布局方法稍作封装 */
- (void)cell_setNeedsLayout;

/**
 重新计算子视图的大小
 在此方法中可以计算cell高度
 这个方法交由子类实现，父类负责在CellFrame发生改变的时候重新调用次方法
 */
- (void)cell_updateContentSubviewsFrame;

/** 布局cell */
- (void)cell_contentViewSubviewsConfig DDQ_REQUIRES_SUPER;

/**
 是否执行过布局Cell的方法:cell_contentViewSubviewsConfig
 */
@property (nonatomic, readonly) BOOL cell_subviewsConfig;

/**
 是否使用预计算视图大小
 即view_boundRect,但不推荐使用因为是类目里的属性不方便debug
 */
+ (BOOL)cell_useBoundRectLayout;//default YES

/**
 是否在layoutSubview方法中更新subview的frame
 理由同DDQBaseView
 */
+ (BOOL)cell_needUpdateSubviewFrameWhenLayoutSubviews;//default NO

/**
 当前Cell上显示数据的Model
 PS:当cell_updateDataWithModel被调用后有值
 */
@property (nonatomic, strong, nullable, setter=cell_updateDataWithModel:) __kindof DDQBaseCellModel *cell_model;

/**
 更新Cell的数据
 你需要将子视图的赋值内容放在Super之前
 */
- (void)cell_updateDataWithModel:(nullable __kindof DDQBaseCellModel *)model DDQ_REQUIRES_SUPER;

/**
 获得Cell的高度
 */
+ (CGFloat)cell_getCellHeightWithModel:(nullable __kindof DDQBaseCellModel *)model;

/**
 标准屏幕比例，默认iPhone6
 */
@property (nonatomic, assign) DDQRateSet cell_rateSet;

/**
 当前屏宽和iPhone6的比
 */
@property (nonatomic, readonly) CGFloat cell_widthRate;

/**
 默认的左边距
 */
@property (nonatomic, readonly) CGFloat cell_defaultLeftMargin;

@end

NS_ASSUME_NONNULL_END


//
//  DDQBaseView.h
//
//  Copyright © 2018年 DDQ. All rights reserved.

#import "UIView+DDQControlInitialize.h"

NS_ASSUME_NONNULL_BEGIN

/**
 工程View基类
 */
@interface DDQBaseView : UIView

/**
 初始化方法
 
 @param frame 视图大小
 */
- (instancetype)initViewWithFrame:(CGRect)frame DDQ_DESIGNATED_INITIALIZER;

/** 是否已经布局过 */
@property (nonatomic, readonly) BOOL view_layoutSubviews;

/** 对于布局方法稍作封装 */
- (void)view_setNeedsLayout;

/**
 重新计算子视图的大小
 这个方法交由子类实现，父类负责在CellFrame发生改变的时候重新调用次方法
 */
- (void)view_updateContentSubviewsFrame;

/**
 标准屏幕比例，默认iPhone6
 */
@property (nonatomic, assign) DDQRateSet view_rateSet;
@property (nonatomic, assign) CGFloat view_widthRate;

/** 配置tableView */
- (void)view_tableViewConfig DDQ_REQUIRES_SUPER;

/** 布局子视图 */
- (void)view_subviewsConfig;

/**
 是否执行过布局的方法:view_subviewsConfig
 */
@property (nonatomic, readonly) BOOL view_isConfig;

/**
 是否使用预计算视图大小
 即view_boundRect,但不推荐使用因为是类目里的属性不方便debug
 */
+ (BOOL)view_useBoundRectLayout;//default YES

/**
 基础TableView
 没有调取view_tableViewConfig时为空
 */
@property (nonatomic, strong) DDQFoundationTableView *view_subTableView;

/**
 layout
 没有调取view_tableViewConfig时为空
 */
@property (nonatomic, strong, readonly) DDQFoundationTableViewLayout *view_subTableViewLayout;

/**
 TableView的样式。default UITableViewStyleGrouped
 */
- (UITableViewStyle)view_tableViewStyle;

/**
 默认的TableView的布局
 */
- (DDQFoundationTableViewLayout *)view_tableViewLayout;

@end

NS_ASSUME_NONNULL_END


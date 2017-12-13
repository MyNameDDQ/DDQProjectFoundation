//
//  DDQFoundationTableView.h
//
//  Copyright © 2017年 DDQ. All rights reserved.


#import <UIKit/UIKit.h>

@class DDQFoundationTableViewLayout;
NS_ASSUME_NONNULL_BEGIN

typedef NSInteger(^DDQTableViewSectionConfig)(void);
typedef NSInteger(^DDQTableViewRowConfig)(NSInteger section);
typedef void(^DDQTableViewDidSelectConfig)(NSIndexPath *indexPath);
typedef CGFloat(^DDQTableViewHeaderHeightConfig)(NSInteger section);
typedef CGFloat(^DDQTableViewFooterHeightConfig)(NSInteger section);
typedef CGFloat(^DDQTableViewCellHeightConfig)(NSIndexPath *indexPath);
typedef __kindof UIView *_Nullable(^DDQTableViewHeaderViewConfig)(NSInteger section);
typedef __kindof UIView *_Nullable(^DDQTableViewFooterViewConfig)(NSInteger section);
typedef __kindof UITableViewCell *_Nonnull(^DDQTableViewCellConfig)(NSIndexPath *indexPath, UITableView *tableView);

/**
 基础TableView
 这个类简化了TableView的创建和点击事件两类最常用的代理方法。
 */
@interface DDQFoundationTableView : UITableView<UITableViewDelegate, UITableViewDataSource>

/**
 TableView的布局设置
 */
@property (nonatomic, strong, setter=tableView_configLayout:) DDQFoundationTableViewLayout *tableView_layout;
- (void)tableView_configLayout:(DDQFoundationTableViewLayout *)layout;

/**
 自定义分区数
 */
- (void)tableView_setSectionConfig:(DDQTableViewSectionConfig)config;

/**
 自定义行数
 */
- (void)tableView_setRowConfig:(DDQTableViewRowConfig)config;

/**
 自定义cell
 */
- (void)tableView_setCellConfig:(DDQTableViewCellConfig)config;

/**
 自定义cell高度
 */
- (void)tableView_setCellHeightConfig:(DDQTableViewCellHeightConfig)config;

/**
 自定义Header高度
 */
- (void)tableView_setHeaderHeightConfig:(DDQTableViewHeaderHeightConfig)config;

/**
 自定义Footer高度
 */
- (void)tableView_setFooterHeightConfig:(DDQTableViewFooterHeightConfig)config;

/**
 自定义Header视图
 */
- (void)tableView_setHeaderViewConfig:(DDQTableViewHeaderViewConfig)config;

/**
 自定义Footer视图
 */
- (void)tableView_setFooterViewConfig:(DDQTableViewFooterViewConfig)config;

/**
 cell的点击事件
 */
- (void)tableView_setDidSelectConfig:(DDQTableViewDidSelectConfig)config;

@end

NS_ASSUME_NONNULL_END

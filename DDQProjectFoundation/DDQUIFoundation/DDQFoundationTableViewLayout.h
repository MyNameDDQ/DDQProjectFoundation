//
//  DDQFoundationTableViewLayout.h
//
//  Copyright © 2017年 DDQ. All rights reserved.

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 TableView基础配置
 */
@interface DDQFoundationTableViewLayout : NSObject

/**
 初始化本类
 
 @param table TableView及其子类
 @return 本类实例
 */
+ (instancetype)layoutWithTableView:(nullable __kindof UITableView *)table;

/**
 目标TableView
 */
@property (nonatomic, readonly) UITableView *layout_tableView;

/**
 分区数，default 0
 */
@property (nonatomic, assign) NSInteger layout_sectionCount;

/**
 行数，default 0
 */
@property (nonatomic, assign) NSInteger layout_rowCount;

/**
 Cell的类，default UITableViewCell
 */
@property (nonatomic) Class layout_cellClass;

/**
 Cell的重用标识，default DDQTableViewLayoutDefaultCellIdentifier
 */
@property (nonatomic, copy) NSString *layout_cellIdentifier;

/**
 Cell的信息,PS:Identifier为键名，class为键值。在处理多种Cell时用这个属性
 */
@property (nonatomic, copy) NSDictionary<NSString *, Class> *layout_cellDataSource NS_DEPRECATED_IOS(2_0, 2_2, "Not recommanded use the property");
/**
 Cell的重用数据源。PS:新的数据源以class的string形式为键名，重用字符串为键值。
 */
@property (nonatomic, copy) NSDictionary<NSString *, NSString *> *layout_reuseDataSource NS_AVAILABLE(2_0, 2_0);

/**
 是否从xib中读取, default NO
 */
@property (nonatomic, assign) BOOL layout_loadFromNib;

/**
 Cell的高度，default 0
 */
@property (nonatomic, assign) CGFloat layout_rowHeight;

/**
 Cell的Header高度, UITableViewStylePlain default 0,UITableViewStyleGroup default 0.0000001
 */
@property (nonatomic, assign) CGFloat layout_headerHeight;

/**
 Cell的Footer高度, UITableViewStylePlain default 0,UITableViewStyleGroup default 0.0000001
 */
@property (nonatomic, assign) CGFloat layout_footerHeight;

/**
 HeaderView
 */
@property (nonatomic, strong) __kindof UIView *layout_headerView;

/**
 FooterView
 */
@property (nonatomic, strong) __kindof UIView *layout_footerView;

@end

FOUNDATION_EXTERN NSString *const DDQLayoutDefaultCellIdentifier;  //默认的重用标识符

NS_ASSUME_NONNULL_END

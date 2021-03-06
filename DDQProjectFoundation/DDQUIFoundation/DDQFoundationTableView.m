//
//  DDQFoundationTableView.m
//
//  Copyright © 2017年 DDQ. All rights reserved.


#import "DDQFoundationTableView.h"

#import "DDQFoundationTableViewLayout.h"

@interface DDQFoundationTableView ()

@property (nonatomic, copy) DDQTableViewRowConfig rowConfig;
@property (nonatomic, copy) DDQTableViewCellConfig cellConfig;
@property (nonatomic, copy) DDQTableViewSectionConfig sectionConfig;
@property (nonatomic, copy) DDQTableViewDidSelectConfig selectConfig;
@property (nonatomic, copy) DDQTableViewCellHeightConfig cellHeightConfig;
@property (nonatomic, copy) DDQTableViewHeaderViewConfig headerViewConfig;
@property (nonatomic, copy) DDQTableViewFooterViewConfig footerViewConfig;
@property (nonatomic, copy) DDQTableViewHeaderHeightConfig headerHeightConfig;
@property (nonatomic, copy) DDQTableViewFooterHeightConfig footerHeightConfig;
@property (nonatomic, copy) DDQTableViewCellCanEditingConfig canConfig;
@property (nonatomic, copy) DDQTableViewCellCommitEditingConfig commitConfig;
@end

@implementation DDQFoundationTableView

@synthesize tableView_layout = _tableView_layout;

- (void)dealloc {
    
    if (self.delegate) self.delegate = nil;
    if (self.dataSource) self.dataSource = nil;
}

- (void)tableView_configLayout:(DDQFoundationTableViewLayout *)layout {
    
    _tableView_layout = layout;
    [self tableView_initialize];
}

/**
 调用代理方法
 */
- (void)tableView_initialize {
    
    if (self.tableView_layout.layout_reuseDataSource) {
        
        NSDictionary *dataDic = self.tableView_layout.layout_reuseDataSource;
        for (NSString *classKey in dataDic.allKeys) {
            
            NSString *identifier = dataDic[classKey];
            !(self.tableView_layout.layout_loadFromNib) ? [self registerClass:NSClassFromString(classKey) forCellReuseIdentifier:identifier] : [self registerNib:[UINib nibWithNibName:classKey bundle:nil] forCellReuseIdentifier:identifier];
        }
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    } else if (self.tableView_layout.layout_cellDataSource) {
        
        NSDictionary *dataDic = self.tableView_layout.layout_cellDataSource;
        for (NSString *identifier in dataDic.allKeys) {
            
            self.tableView_layout.layout_loadFromNib?[self registerNib:[UINib nibWithNibName:NSStringFromClass(dataDic[identifier]) bundle:nil] forCellReuseIdentifier:identifier]:[self registerClass:dataDic[identifier] forCellReuseIdentifier:identifier];
        }
    } else {
#pragma clang diagnostic pop
        self.tableView_layout.layout_loadFromNib?[self registerNib:[UINib nibWithNibName:NSStringFromClass(self.tableView_layout.layout_cellClass) bundle:nil] forCellReuseIdentifier:self.tableView_layout.layout_cellIdentifier]:[self registerClass:self.tableView_layout.layout_cellClass forCellReuseIdentifier:self.tableView_layout.layout_cellIdentifier];
    }
    
    if (!self.delegate) self.delegate = self;
    if (!self.dataSource) self.dataSource = self;
}

- (void)tableView_dealloc {
    
    _tableView_layout = nil;
    
}

- (void)tableView_setSectionConfig:(DDQTableViewSectionConfig)config {
    
    if (config) self.sectionConfig = config;
}

- (void)tableView_setRowConfig:(DDQTableViewRowConfig)config {
    
    if (config) self.rowConfig = config;
}

- (void)tableView_setCellConfig:(DDQTableViewCellConfig)config {
    
    if (config) self.cellConfig = config;
}

- (void)tableView_setHeaderHeightConfig:(DDQTableViewHeaderHeightConfig)config {
    
    if (config) self.headerHeightConfig = config;
}

- (void)tableView_setFooterHeightConfig:(DDQTableViewFooterHeightConfig)config {
    
    if (config) self.footerHeightConfig = config;
}

- (void)tableView_setCellHeightConfig:(DDQTableViewCellHeightConfig)config {
    
    if (config) self.cellHeightConfig = config;
}

- (void)tableView_setHeaderViewConfig:(DDQTableViewHeaderViewConfig)config {
    
    if (config) self.headerViewConfig = config;
}

- (void)tableView_setFooterViewConfig:(DDQTableViewFooterViewConfig)config {
    
    if (config) self.footerViewConfig = config;
}

- (void)tableView_setDidSelectConfig:(DDQTableViewDidSelectConfig)config {
    
    if (config) self.selectConfig = config;
}

- (void)tableView_setCellCanEditingConfig:(DDQTableViewCellCanEditingConfig)config {
    
    if (config) self.canConfig = config;
}

- (void)tableView_setCellCommitEditingConfig:(DDQTableViewCellCommitEditingConfig)config {
    
    if (config) self.commitConfig = config;
}

#pragma mark - TableView Delegate && DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.rowConfig) {
        return self.rowConfig(section);
    }
    return self.tableView_layout.layout_rowCount;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.sectionConfig) {
        return self.sectionConfig();
    }
    
    return self.tableView_layout.layout_sectionCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.cellConfig) {
        return self.cellConfig(indexPath, self);
    }
    return [tableView dequeueReusableCellWithIdentifier:self.tableView_layout.layout_cellIdentifier forIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.cellHeightConfig) {
        return self.cellHeightConfig(indexPath);
    }
    return self.tableView_layout.layout_rowHeight;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (self.headerHeightConfig) {
        return self.headerHeightConfig(section);
    }
    return self.tableView_layout.layout_headerHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (self.footerHeightConfig) {
        return self.footerHeightConfig(section);
    }
    return self.tableView_layout.layout_footerHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (self.headerViewConfig) {
        return self.headerViewConfig(section, self);
    }
    return self.tableView_layout.layout_headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (self.footerViewConfig) {
        return self.footerViewConfig(section, self);
    }
    return self.tableView_layout.layout_footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.selectConfig) self.selectConfig(indexPath);
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.canConfig) return self.canConfig(indexPath);
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.commitConfig) self.commitConfig(indexPath, self, editingStyle);
}

@end

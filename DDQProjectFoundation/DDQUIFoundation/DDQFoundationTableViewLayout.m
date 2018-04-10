//
//  DDQFoundationTableViewLayout.m
//
//  Copyright © 2017年 DDQ. All rights reserved.


#import "DDQFoundationTableViewLayout.h"

@interface DDQFoundationTableViewLayout () {
    
    UITableView *_targetTableView;
}

@end

@implementation DDQFoundationTableViewLayout

NSString *const DDQLayoutDefaultCellIdentifier = @"com.ddq.default.cellIdentifier";

- (id)copyWithZone:(NSZone *)zone {
    
    return [DDQFoundationTableViewLayout layoutWithTableView:_targetTableView];
}

- (void)dealloc {
    
    _targetTableView = nil;
    
}

+ (instancetype)layoutWithTableView:(__kindof UITableView *)table {
    
    return [[self alloc] initWithTableView:table];
}

- (instancetype)initWithTableView:(UITableView *)table {
    
    self = [super init];
    if (!self) return nil;
    
    _targetTableView = table;
    return self;
}

- (UITableView *)layout_tableView {
    
    return _targetTableView;
}

- (CGFloat)layout_footerHeight {
    
    if (_targetTableView.style == UITableViewStyleGrouped) {
        return _layout_footerHeight == 0.0 ? 0.0000001:_layout_footerHeight;
    }
    return _layout_footerHeight;
}

- (CGFloat)layout_headerHeight {
    
    if (_targetTableView.style == UITableViewStyleGrouped) {
        return _layout_headerHeight == 0.0 ? 0.0000001:_layout_headerHeight;
    }
    return _layout_headerHeight;
}

- (NSString *)layout_cellIdentifier {
    
    if (!_layout_cellIdentifier) {
        _layout_cellIdentifier = DDQLayoutDefaultCellIdentifier;
        return _layout_cellIdentifier;
    }
    return _layout_cellIdentifier;
}

- (Class)layout_cellClass {
    
    if (!_layout_cellClass) {
        _layout_cellClass = [UITableViewCell class];
        return _layout_cellClass;
    }
    return _layout_cellClass;
}

@end

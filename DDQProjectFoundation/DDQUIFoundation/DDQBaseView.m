//
//  DDQBaseView.m
//  AFNetworking
//
//  Copyright © 2018年 DDQ. All rights reserved.

#import "DDQBaseView.h"

@interface DDQBaseView () {
    
    BOOL _is_layoutSubviews;
    BOOL _is_config;
}

@end

@implementation DDQBaseView

- (instancetype)initViewWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    self.view_autoLayout = YES;
    _is_layoutSubviews = NO;
    self.backgroundColor = [UIColor clearColor];
    [self view_subviewsConfig];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    return [self initViewWithFrame:frame];
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    return [self initViewWithFrame:CGRectZero];
    
}

+ (BOOL)requiresConstraintBasedLayout {
    
    return YES;
}

- (void)setFrame:(CGRect)frame {
    
    [super setFrame:frame];
    
    [self view_updateContentSubviewsFrame];
    [self view_setNeedsLayout];
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    _is_layoutSubviews = YES;

    if ([self.class view_useBoundRectLayout]) {
        
        //给计算过大小的视图布局
        for (UIView *subView in self.subviews) {
            
            if (!CGRectEqualToRect(subView.view_boundRect, CGRectZero)) subView.frame = subView.view_boundRect;
            
            for (UIView *sSubView in subView.subviews) {
                
                if (!CGRectEqualToRect(sSubView.view_boundRect, CGRectZero)) sSubView.frame = sSubView.view_boundRect;
                
            }
        }
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [super touchesEnded:touches withEvent:event];
    [self endEditing:YES];
    
}

- (DDQRateSet)view_rateSet {
    
    return [UIView view_getCurrentDeviceRateWithVersion:DDQFoundationRateDevice_iPhone6];
    
}

- (CGFloat)view_widthRate {
    
    return self.view_rateSet.widthRate;
    
}

- (void)view_tableViewConfig {
    
    self.view_subTableView = [DDQFoundationTableView tableViewWithStyle:[self view_tableViewStyle]];
    [self addSubview:self.view_subTableView];
    self.view_subTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view_subTableView.backgroundColor = [UIColor clearColor];
    [self.view_subTableView tableView_configLayout:[self view_tableViewLayout]];
    
}

- (UITableViewStyle)view_tableViewStyle { return UITableViewStyleGrouped; }

- (DDQFoundationTableViewLayout *)view_subTableViewLayout { return self.view_subTableView.tableView_layout; }

- (DDQFoundationTableViewLayout *)view_tableViewLayout {
    
    DDQFoundationTableViewLayout *layout = [DDQFoundationTableViewLayout layoutWithTableView:self.view_subTableView];
    layout.layout_sectionCount = 1;
    return layout;
    
}

- (BOOL)view_layoutSubviews {
    
    return _is_layoutSubviews;
    
}

- (void)view_setNeedsLayout {
    
    //是否调用过layoutSubviews方法
    if (_is_layoutSubviews) {//如果未调用则不需要重新布局
        
        [self setNeedsLayout];
        
    }
}

- (void)view_updateContentSubviewsFrame {}//SubClass implementation

- (void)view_subviewsConfig {
    
    _is_config = YES;
    
}

- (BOOL)view_isConfig {
    
    return _is_config;
    
}

+ (BOOL)view_useBoundRectLayout {
    
    return YES;
    
}

@end

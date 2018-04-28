//
//  DDQBaseCell.m
//
//  Copyright © 2018年 DDQ. All rights reserved.

#import "DDQBaseCell.h"

@interface DDQBaseCell () {
    
    BOOL _is_layoutSubviews;
    BOOL _subviewsConfig;
    CGRect _originFrame;
}

@property (nonatomic, strong) UIView *topSeparatorView;
@property (nonatomic, strong) UIView *bottomSeparatorView;

@end

@implementation DDQBaseCell

const DDQSeparatorMargin DDQSeparatorMarginZero = {0, 0};
@synthesize cell_model = _cell_model;

DDQSeparatorMargin DDQSeparatorMarginMaker(CGFloat l, CGFloat r) {
    
    DDQSeparatorMargin margin = {l, r};
    return margin;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.cell_separatorStyle = DDQTableViewCellSeparatorStyleNone;
    self.cell_separatorMargin = DDQSeparatorMarginZero;
    self.cell_separatorHeight = 0.5;
    [self cell_contentViewSubviewsConfig];

    //不能给ContentView add self为observer
//    [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    return self;
}

- (void)setFrame:(CGRect)frame {
    
    [super setFrame:frame];

    if (self.cell_subviewsConfig && !CGRectEqualToRect(_originFrame, self.frame)) {
    
        //self的frame（主要是宽度，默认为320.0）发生变化以后需要重新计算子视图的大小
        //不把布局写在layoutSubview里是因为在下执行方法中实现布局后更容易算取Cell高度。
        [self cell_updateContentSubviewsFrame];

    }
    _originFrame = frame;
    
}

+ (BOOL)requiresConstraintBasedLayout {
    
    return YES;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    _is_layoutSubviews = YES;

    if ([self.class cell_useBoundRectLayout]) {
        
        //给计算过大小的视图布局
        for (UIView *subView in self.contentView.subviews) {
            
            if (!CGRectEqualToRect(subView.view_boundRect, CGRectZero)) subView.frame = subView.view_boundRect;
            
            for (UIView *sSubView in subView.subviews) {
                
                if (!CGRectEqualToRect(sSubView.view_boundRect, CGRectZero)) sSubView.frame = sSubView.view_boundRect;
                
            }
        }
    }
    
    if ([self.class cell_needUpdateSubviewFrameWhenLayoutSubviews]) {
        
        [self cell_updateContentSubviewsFrame];

    }
    
    if (self.cell_separatorStyle == DDQTableViewCellSeparatorStyleNone) return;
    
    CGFloat separatorX = self.cell_separatorMargin.leftMargin;
    CGFloat separatorW = self.contentView.width - self.cell_separatorMargin.leftMargin - self.cell_separatorMargin.rightMargin;
    if (self.cell_separatorStyle == DDQTableViewCellSeparatorStyleTop) {
        
        self.topSeparatorView.frame = CGRectMake(separatorX, 0.0, separatorW, self.cell_separatorHeight);
        
    } else if (self.cell_separatorStyle == DDQTableViewCellSeparatorStyleBottom) {
        
        self.bottomSeparatorView.frame = CGRectMake(separatorX, self.contentView.height - self.cell_separatorHeight, separatorW, self.cell_separatorHeight);
        
    } else {
        
        self.topSeparatorView.frame = CGRectMake(separatorX, 0.0, separatorW, self.cell_separatorHeight);
        self.bottomSeparatorView.frame = CGRectMake(separatorX, self.contentView.height - self.cell_separatorHeight, separatorW, self.cell_separatorHeight);
        
    }
}

#pragma mark - Custom IMP
- (void)setCell_separatorStyle:(DDQTableViewCellSeparatorStyle)cell_separatorStyle {
    
    _cell_separatorStyle = cell_separatorStyle;
    
    if (!_subviewsConfig) return;
    
    [self.contentView view_removeSubviews:@[self.topSeparatorView, self.bottomSeparatorView]];
    if (cell_separatorStyle == DDQTableViewCellSeparatorStyleNone) return;
    
    if (cell_separatorStyle == DDQTableViewCellSeparatorStyleTopAndBottom) {
        
        [self.contentView view_configSubviews:@[self.topSeparatorView, self.bottomSeparatorView]];
        
    } else if (cell_separatorStyle == DDQTableViewCellSeparatorStyleTop) {
        
        [self.contentView view_configSubviews:@[self.topSeparatorView]];
        
    } else {
        
        [self.contentView view_configSubviews:@[self.bottomSeparatorView]];
        
    }
    [self cell_setNeedsLayout];
    
}

- (void)setCell_separatorColor:(UIColor *)cell_separatorColor {
    
    _cell_separatorColor = cell_separatorColor;
    self.topSeparatorView.backgroundColor = self.bottomSeparatorView.backgroundColor = _cell_separatorColor;
    
}

- (void)setCell_separatorMargin:(DDQSeparatorMargin)cell_separatorMargin {
    
    _cell_separatorMargin = cell_separatorMargin;
    [self cell_setNeedsLayout];
    
}

- (void)setCell_separatorHeight:(CGFloat)cell_separatorHeight {
    
    _cell_separatorHeight = cell_separatorHeight;
    [self cell_setNeedsLayout];
    
}

- (DDQSeparatorMargin)cell_defaultMargin {
    
    DDQSeparatorMargin margin = {15.0 * self.cell_rateSet.widthRate, 0};
    return margin;
    
}

- (void)cell_updateDataWithModel:(__kindof DDQBaseCellModel *)model {
    
    _cell_model = model;
    
    //当子视图内容被赋值以后需要再次重新计算
    [self cell_updateContentSubviewsFrame];
//    [self cell_setNeedsLayout];
    
}

+ (CGFloat)cell_getCellHeightWithModel:(__kindof DDQBaseCellModel *)model {
    
    return (model.model_recordHeight > 1.0) ? model.model_recordHeight : 1.0;
    
}

- (DDQRateSet)cell_rateSet {
    
    return [UIView view_getCurrentDeviceRateWithVersion:DDQFoundationRateDevice_iPhone6];
    
}

- (BOOL)cell_layoutSubviews {
    
    return _is_layoutSubviews;
    
}

- (void)cell_setNeedsLayout {
    
    //是否调用过layoutSubviews方法
    if (_is_layoutSubviews) {//如果未调用则不需要重新布局
        
        [self setNeedsLayout];
        
    }
}

- (void)cell_contentViewSubviewsConfig {
    
    self.topSeparatorView = [UIView viewChangeBackgroundColor:kSetColor(153.0, 153.0, 153.0, 1.0)];
    self.bottomSeparatorView = [UIView viewChangeBackgroundColor:kSetColor(153.0, 153.0, 153.0, 1.0)];
    _subviewsConfig = YES;
    
}

- (void)cell_updateContentSubviewsFrame {}//SubClass implementation

- (CGFloat)cell_widthRate {
    
    return self.cell_rateSet.widthRate;
}

- (CGFloat)cell_defaultLeftMargin {
    
    return 15.0 * self.cell_widthRate;
}

+ (BOOL)cell_useBoundRectLayout {
    
    return YES;
    
}

+ (BOOL)cell_needUpdateSubviewFrameWhenLayoutSubviews {
    
    return NO;
    
}

- (BOOL)cell_subviewsConfig {
    
    return _subviewsConfig;
    
}

@end

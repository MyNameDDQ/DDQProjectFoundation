//
//  DDQAlertItem.m
//
//  Copyright © 2017年 DDQ. All rights reserved.


#import "DDQAlertItem.h"

@interface DDQAlertItem ()

@property (nonatomic, strong) UILabel *item_titleLabel;
@property (nonatomic, strong) UIView *item_lineView;
@property (nonatomic, assign) DDQAlertItemStyle item_style;

@end

@implementation DDQAlertItem

+ (instancetype)alertItemWithStyle:(DDQAlertItemStyle)style {
    
    return [[self alloc] initItemWithStyle:style];
}



- (instancetype)initItemWithStyle:(DDQAlertItemStyle)style {
    
    self = [super initWithFrame:CGRectZero];
    if (!self) return nil;
    
    self.item_title = @"";
    self.item_attrTitle = nil;
    self.item_style = style;
    self.item_font = [UIFont systemFontOfSize:17.0];
    [self item_layoutSubviews];
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(alert_itemSelectedWithItem:)]) {
        [self.delegate alert_itemSelectedWithItem:self];
    }
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.item_lineView.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.frame), 1.0);
    if (self.item_style == DDQAlertItemStyleDefault) {
        self.item_titleLabel.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    }
}

- (void)item_layoutSubviews {
    
    if (self.item_style == DDQAlertItemStyleDefault) {
        
        self.item_titleLabel = [[UILabel alloc] init];
        [self addSubview:self.item_titleLabel];
        self.item_titleLabel.textAlignment = NSTextAlignmentCenter;
        self.item_titleLabel.textColor = [UIColor blackColor];
        self.item_titleLabel.font = self.item_font;
    }
    self.item_lineView = [[UIView alloc] init];
    [self addSubview:self.item_lineView];
    CGFloat rate = 235.0 / 255.0;
    self.item_lineView.backgroundColor = [UIColor colorWithRed:rate green:rate blue:rate alpha:1.0];
}

- (void)setItem_title:(NSString *)item_title {
    
    _item_title = item_title;
    
    self.item_titleLabel.text = item_title;
}

- (void)setItem_attrTitle:(NSAttributedString *)item_attrTitle {
    
    _item_attrTitle = item_attrTitle;
    
    if (item_attrTitle) {
        
        self.item_titleLabel.text = @"";
        self.item_titleLabel.attributedText =  item_attrTitle;
    }
}

@end

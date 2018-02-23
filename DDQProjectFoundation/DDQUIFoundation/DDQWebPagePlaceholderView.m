//
//  DDQWebPagePlaceholderView.m
//
//  Copyright © 2017年 DDQ. All rights reserved.

#import "DDQWebPagePlaceholderView.h"

@implementation DDQWebPagePlaceholderView

+ (instancetype)placeholderWithTitle:(NSString *)title subTitle:(NSString *)subTitle {
    
    return [[DDQWebPagePlaceholderView alloc] initWithTitle:title subTitle:subTitle];
}

- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle {
    
    self = [super initWithFrame:CGRectZero];
    if (!self) return nil;
    
    self.backgroundColor = [UIColor whiteColor];
    [self placeholder_layoutSubviewsWithTitle:title subTitle:subTitle];
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];

    CGFloat viewCenterX = CGRectGetMidX(self.bounds);
    CGFloat viewCenterY = CGRectGetMidY(self.bounds);
    
    CGSize boundSize = CGSizeMake(CGRectGetWidth(self.frame), 100000.0);
    CGSize titleSize = [self.placeholder_titleLabel.text boundingRectWithSize:boundSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.placeholder_titleLabel.font.pointSize + 1.0]} context:nil].size;
    self.placeholder_titleLabel.frame = CGRectMake(viewCenterX - titleSize.width * 0.5, viewCenterY - titleSize.height + 2.0, titleSize.width, titleSize.height);
    
    CGSize subTitleSize = [self.placeholder_subTitleLabel.text boundingRectWithSize:boundSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.placeholder_subTitleLabel.font.pointSize + 1.0]} context:nil].size;
    self.placeholder_subTitleLabel.frame = CGRectMake(viewCenterX - subTitleSize.width * 0.5, viewCenterY + 2.0, subTitleSize.width, subTitleSize.height);
    
    CGFloat buttonW = 80.0;
    CGFloat buttonH = 35.0;
    self.placeholder_alertButton.frame = CGRectMake(viewCenterX - buttonW * 0.5, CGRectGetMaxY(self.placeholder_subTitleLabel.frame) + 15.0, buttonW, buttonH);
}

- (void)dealloc {
    
    [self.placeholder_subTitleLabel removeObserver:self forKeyPath:@"text"];
    [self.placeholder_titleLabel removeObserver:self forKeyPath:@"text"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    [self setNeedsLayout];
}

/**
 布局子视图
 
 @param title 提示的标题
 @param subTitle 提示的副标题
 */
- (void)placeholder_layoutSubviewsWithTitle:(NSString *)title subTitle:(NSString *)subTitle {
    
    UIColor *textColor = [UIColor colorWithRed:170.0 / 255.0 green:170.0 / 255.0 blue:170.0 / 255.0 alpha:1.0];
    
    self.placeholder_titleLabel = [[UILabel alloc] init];
    [self addSubview:self.placeholder_titleLabel];
    self.placeholder_titleLabel.textColor = textColor;
    self.placeholder_titleLabel.text = title;
    
    self.placeholder_subTitleLabel = [[UILabel alloc] init];
    [self addSubview:self.placeholder_subTitleLabel];
    self.placeholder_subTitleLabel.textColor = textColor;
    self.placeholder_subTitleLabel.text = subTitle;
    
    self.placeholder_alertButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.placeholder_alertButton];
    [self.placeholder_alertButton setTitle:@"点击重试" forState:UIControlStateNormal];
    self.placeholder_alertButton.backgroundColor = [UIColor blackColor];
    self.placeholder_alertButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [self.placeholder_alertButton addTarget:self action:@selector(placeholder_buttonSelectSel:) forControlEvents:UIControlEventTouchUpInside];
    
    //KVO
    [self.placeholder_titleLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    [self.placeholder_subTitleLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
}

/**
 按钮的点击事件
 */
- (void)placeholder_buttonSelectSel:(UIButton *)button {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(placeholder_didSelectAlertWithView:)]) {
        [self.delegate placeholder_didSelectAlertWithView:self];
    }
}

@end

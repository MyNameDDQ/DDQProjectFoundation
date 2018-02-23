//
//  DDQQRScanPreviewView.m
//
//  Copyright © 2017年 DDQ. All rights reserved.

#import "DDQQRScanPreviewView.h"

@interface DDQQRScanPreviewView ()

@property (nonatomic, strong) UIView *preview_topView;
@property (nonatomic, strong) UIView *preview_leftView;
@property (nonatomic, strong) UIView *preview_rightView;
@property (nonatomic, strong) UIView *preview_bottomView;

@property (nonatomic, strong) UIImageView *preview_lineImageView;
@property (nonatomic, strong) UIImageView *preview_scanImageView;

@end

@implementation DDQQRScanPreviewView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    [self preview_subViewInit];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (!self) return nil;
    
    [self preview_subViewInit];
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGFloat topBottomViewW = CGRectGetWidth(self.frame);
    CGFloat leftRightViewH = CGRectGetHeight(self.preview_scanRect);
    
    self.preview_topView.frame = CGRectMake(0.0, 0.0, topBottomViewW, CGRectGetMinY(self.preview_scanRect));
    self.preview_leftView.frame = CGRectMake(0.0, CGRectGetMaxY(self.preview_topView.frame), CGRectGetMinX(self.preview_scanRect), leftRightViewH);
    self.preview_rightView.frame = CGRectMake(CGRectGetMaxX(self.preview_scanRect), self.preview_leftView.frame.origin.y, CGRectGetWidth(self.frame) - CGRectGetMaxX(self.preview_scanRect), leftRightViewH);
    self.preview_bottomView.frame = CGRectMake(0.0, CGRectGetMaxY(self.preview_scanRect), topBottomViewW, CGRectGetHeight(self.frame) - CGRectGetMaxY(self.preview_scanRect));
    
    self.preview_lineImageView.frame = CGRectMake(2.0, 0.0, CGRectGetWidth(self.preview_scanImageView.frame) - 4.0, 1.5);
    self.preview_tipLabel.frame = CGRectMake(CGRectGetMinX(self.preview_scanRect), CGRectGetMaxY(self.preview_scanRect) + 4.0, CGRectGetWidth(self.preview_scanRect), 20.0);
}

- (void)dealloc {
    
    [self preview_stopScanAnimation];
}

+ (instancetype)previewViewWithFrame:(CGRect)frame {
    
    return [[self alloc] initWithFrame:frame];
}

/**
 初始化视图
 */
- (void)preview_subViewInit {
    
    self.preview_topView = [[UIView alloc] init];
    [self addSubview:self.preview_topView];
    
    self.preview_leftView = [[UIView alloc] init];
    [self addSubview:self.preview_leftView];
    
    self.preview_rightView = [[UIView alloc] init];
    [self addSubview:self.preview_rightView];
    
    self.preview_bottomView = [[UIView alloc] init];
    [self addSubview:self.preview_bottomView];
    
    self.preview_scanImageView = [[UIImageView alloc] init];
    [self addSubview:self.preview_scanImageView];
    self.preview_scanImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.preview_lineImageView = [[UIImageView alloc] init];
    [self.preview_scanImageView addSubview:self.preview_lineImageView];
    self.preview_lineImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.preview_tipLabel = [[UILabel alloc] init];
    [self addSubview:self.preview_tipLabel];
    self.preview_tipLabel.font = [UIFont systemFontOfSize:12.0];
    self.preview_tipLabel.textColor = [UIColor whiteColor];
    self.preview_tipLabel.textAlignment = NSTextAlignmentCenter;
    
    self.backgroundColor = [UIColor clearColor];
}

- (void)setPreview_sacnImage:(UIImage *)preview_sacnImage {
    
    _preview_sacnImage = preview_sacnImage;
    _preview_scanImageView.image = preview_sacnImage;
}

- (void)setPreview_lineImage:(UIImage *)preview_lineImage {
    
    _preview_lineImage = preview_lineImage;
    _preview_lineImageView.image = preview_lineImage;
}

- (void)setPreview_scanRect:(CGRect)preview_scanRect {
    
    _preview_scanRect = preview_scanRect;
    self.preview_scanImageView.frame = preview_scanRect;
    [self setNeedsLayout];
}

- (void)setPreview_dimColor:(UIColor *)preview_dimColor {
    
    _preview_dimColor = preview_dimColor;
    
    self.preview_topView.backgroundColor = preview_dimColor;
    self.preview_leftView.backgroundColor = preview_dimColor;
    self.preview_rightView.backgroundColor = preview_dimColor;
    self.preview_bottomView.backgroundColor = preview_dimColor;
}

static NSString *const PreviewAnimationKey = @"preview.lineAnimation";
- (void)preview_startScanAnimation {
    
    self.preview_lineImageView.hidden = NO;
    CABasicAnimation *lineAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    lineAnimation.fromValue = @(0.0);
    lineAnimation.repeatCount = INTMAX_MAX;
    lineAnimation.fillMode = kCAFillModeRemoved;
    lineAnimation.duration = self.preview_animationDuration;
    lineAnimation.toValue = @(CGRectGetHeight(self.preview_scanImageView.frame));
    [self.preview_lineImageView.layer addAnimation:lineAnimation forKey:PreviewAnimationKey];
}

- (void)preview_stopScanAnimation {
    
    self.preview_lineImageView.hidden = YES;
    [self.preview_lineImageView.layer removeAnimationForKey:PreviewAnimationKey];
}

@end


//
//  DDQBarItem.m
//  DDQProjectEdit
//
//  Copyright © 2017年 DDQ. All rights reserved.


#import "DDQBarItem.h"

@interface DDQBarItem ()

@property (nonatomic, copy) NSString *item_title;
@property (nonatomic, strong) UIImage *item_normalImage;
@property (nonatomic, strong) UIImage *item_selectedImage;
@property (nonatomic, strong) UIColor *item_normalTitleColor;
@property (nonatomic, strong) UIColor *item_selectedTitleColor;

@end

@implementation DDQBarItem

- (id)copyWithZone:(NSZone *)zone {
    
    return [[DDQBarItem allocWithZone:zone] init];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    return [self initWithNormalImage:nil selectedImage:nil normalTitle:nil];
    
}

- (instancetype)init {
    
    return [self initWithNormalImage:nil selectedImage:nil normalTitle:nil];
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    return [self initWithNormalImage:nil selectedImage:nil normalTitle:nil];
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [super touchesEnded:touches withEvent:event];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(item_didSelectedWithItem:)]) {
        
        [self.delegate item_didSelectedWithItem:self];
    }
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    CGSize imageSize = self.item_imageView.image.size;
    CGFloat superCenterX = CGRectGetMidX(self.bounds);
    CGFloat superCenterY = CGRectGetMidY(self.bounds);
    self.item_imageView.frame = CGRectMake(superCenterX - imageSize.width * 0.5, superCenterY - imageSize.height * 0.75 - self.item_imageOffsetY, imageSize.width, imageSize.height);
    
    CGSize boundSize = CGSizeMake(CGRectGetWidth(self.bounds), 10000.0);
    CGSize titleSize = [self.item_titleLabel.text boundingRectWithSize:boundSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:self.item_titleLabel.font.pointSize + 1.0]} context:nil].size;
    self.item_titleLabel.frame = CGRectMake(superCenterX - titleSize.width * 0.5, CGRectGetMaxY(self.item_imageView.frame) + self.item_controlSpace, titleSize.width, titleSize.height);
}

- (void)dealloc {
    
    [self.item_imageView removeObserver:self forKeyPath:@"image"];
    [self.item_titleLabel removeObserver:self forKeyPath:@"text"];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    [self setNeedsLayout];
}

#pragma mark - Custom Method IMP
- (instancetype)initWithNormalImage:(UIImage *)nImage selectedImage:(UIImage *)sImage normalTitle:(NSString *)title {
    
    self = [super initWithFrame:CGRectZero];
    if (!self) return nil;
    
    self.item_title = (title) ? : @"";
    self.item_normalImage = nImage;
    self.item_selectedImage = sImage;
    self.item_controlSpace = 4.0;
    self.item_selected = NO;
    self.item_imageOffsetY = 0.0;
    [self item_handleInitialze];
    return self;
}

/**
 处理初始化的准备工作
 */
- (void)item_handleInitialze {
    
    [self item_layoutSubviews];

    //你可以去看看UIAppearance协议
    [self.item_titleLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    [self.item_imageView addObserver:self forKeyPath:@"image" options:NSKeyValueObservingOptionNew context:nil];
}

/**
 布局子视图
 */
- (void)item_layoutSubviews {
    
    self.item_imageView = [[UIImageView alloc] init];
    [self addSubview:self.item_imageView];
    self.item_imageView.image = self.item_normalImage;
    self.item_imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.item_titleLabel = [[UILabel alloc] init];
    [self addSubview:self.item_titleLabel];
    self.item_titleLabel.font = [UIFont systemFontOfSize:13.0];
    self.item_titleLabel.textAlignment = NSTextAlignmentCenter;
    self.item_titleLabel.text = self.item_title;
    self.item_titleLabel.textColor = [UIColor blackColor];
}

- (void)setItemNormalTitleColor:(UIColor *)nColor selectedColor:(UIColor *)sColor {
    
    self.item_titleLabel.textColor = (nColor) ? nColor : self.item_titleLabel.textColor;
    self.item_normalTitleColor = (nColor) ? : self.item_titleLabel.textColor;
    self.item_selectedTitleColor = (sColor) ? : self.item_normalTitleColor;
}

- (void)setItemNormalImage:(UIImage *)nImage selectedImage:(UIImage *)sImage {
    
    self.item_normalImage = nImage;
    self.item_selectedImage = sImage;
    if (!self.item_imageView.image) self.item_imageView.image = nImage;
}

/**
 设置选中状态
 */
- (void)setItemSelected:(BOOL)selected {
    
    _item_selected = selected;
    
    self.item_imageView.image = (selected) ?  (self.item_selectedImage) ? self.item_selectedImage : self.item_normalImage : self.item_normalImage;
    self.item_titleLabel.textColor = (selected) ? (self.item_selectedTitleColor) ? self.item_selectedTitleColor : self.item_normalTitleColor : self.item_normalTitleColor;
    
}

@end

//
//  DDQAlertController.m
//
//  Copyright © 2017年 DDQ. All rights reserved.

#import "DDQAlertController.h"

#import "DDQAlertItem.h"
#import "UIView+DDQSimplyGetViewProperty.h"

@interface DDQAlertController ()<DDQAlertItemDelegate> {
    
    BOOL _alert_registerKVO;
}

@property (nonatomic, strong, readwrite) UIView *alert_contentView;
@property (nonatomic, strong, readwrite) UIView *alert_headerView;
@property (nonatomic, strong, readwrite) UIView *alert_footContentView;
@property (nonatomic, strong) UIView *alert_verLineView;
@property (nonatomic, assign) DDQAlertControllerStyle alert_style;
@property (nonatomic, strong) NSMutableArray<DDQAlertItem *> *alert_itemContainer;
@property (nonatomic, strong) NSMutableDictionary<NSString *, DDQAlertItemHandler> *alert_handlerContainer;
@property (nonatomic, strong) DDQAlertItemHandler alert_handler;
@property (nonatomic, copy) NSString *alert_title;
@property (nonatomic, copy) NSString *alert_message;

@property (nonatomic, strong) NSAttributedString *alert_attrTitle;
@property (nonatomic, strong) NSAttributedString *alert_attrMessage;
@property (nonatomic, strong) UIFont *alert_titleFont;
@property (nonatomic, strong) UIFont *alert_messageFont;
@property (nonatomic, assign) DDQRateSet alert_rateSet;
@end

@implementation DDQAlertController

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message alertStyle:(DDQAlertControllerStyle)style {
    
    return [[self alloc] initWithTitle:title message:message style:style];
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message style:(DDQAlertControllerStyle)style {
    
    self = [super init];
    if (!self) return nil;
    
    self.alert_title = (!title) ? @"":title;
    self.alert_message = (!message) ? @"":message;
    self.alert_style = style;
    self.alert_rateSet = [UIView view_getCurrentDeviceRateWithVersion:DDQFoundationRateDevice_iPhone5];
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    [self alert_handleDifferentStyleLabelFont];
    [self alert_layoutSubviews];
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.alert_itemContainer = [NSMutableArray array];
    self.alert_handlerContainer = [NSMutableDictionary dictionary];
}

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    
    if (self.alert_style == DDQAlertControllerStyleAlertExceptHeader || self.alert_style == DDQAlertControllerStyleAlert) {
        
        [self alert_layoutAlertStyleFrameWithRate:self.alert_rateSet];
    } else {
        
        [self alert_layoutSheetStyleFrameWithRate:self.alert_rateSet];
    }
}

- (void)dealloc {
    
    self.alert_handlerContainer = nil;
    self.alert_itemContainer = nil;
    
    if (!_alert_registerKVO) return;
    
    [self.alert_titleLabel removeObserver:self forKeyPath:@"text"];
    [self.alert_titleLabel removeObserver:self forKeyPath:@"attributedText"];
    
    [self.alert_messageLabel removeObserver:self forKeyPath:@"text"];
    [self.alert_messageLabel removeObserver:self forKeyPath:@"attributedText"];
}

/**
 处理样式为Alert时的情况
 */
- (void)alert_layoutAlertStyleFrameWithRate:(DDQRateSet)rateSet {
    
    CGFloat contentX = 25.0;
    contentX = contentX * rateSet.widthRate;
    CGFloat contentW = self.view.width - contentX * 2.0;
    
    CGFloat labelX = 16.0 * rateSet.widthRate;
    CGFloat boundW = contentW - labelX * 2.0;
    CGSize boundSize = CGSizeMake(boundW, 200.0);
    
    CGRect headerFrame = CGRectZero;
    //当前的样式判断
    if (self.alert_style == DDQAlertControllerStyleAlert) {
        
        CGSize titleSize = [self.alert_attrTitle boundingRectWithSize:boundSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        CGSize messageSize = [self.alert_attrMessage boundingRectWithSize:boundSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        
        CGFloat labelY = 20.0 * rateSet.heightRate;
        self.alert_titleLabel.frame = CGRectMake(labelX, labelY, contentW - labelX * 2.0, titleSize.height);
        self.alert_messageLabel.frame = CGRectMake(labelX, CGRectGetMaxY(self.alert_titleLabel.frame) + 4.0, self.alert_titleLabel.width, messageSize.height);
        
        self.alert_headerView.frame = CGRectMake(0.0, 0.0, contentW, labelY * 2.0 + titleSize.height + messageSize.height + 4.0);
        headerFrame = self.alert_headerView.frame;
    }
    
    CGFloat itemX = 0.0;
    CGFloat itemY = CGRectGetMaxY(headerFrame);
    CGFloat itemH = 44.0 * rateSet.heightRate;
    if (self.alert_itemContainer.count == 2) {
        
        self.alert_verLineView.frame = CGRectMake(contentW * 0.5 - 0.5, itemY, 1.0, itemH);
        self.alert_verLineView.hidden = NO;
        for (NSInteger index = 0; index < self.alert_itemContainer.count; index++) {
            
            DDQAlertItem *item = self.alert_itemContainer[index];
            item.frame = CGRectMake(itemX, itemY, contentW * 0.5, itemH);
            itemX = CGRectGetMaxX(item.frame);
        }
    } else {
        
        for (NSInteger index = 0; index < self.alert_itemContainer.count; index++) {
            
            DDQAlertItem *item = self.alert_itemContainer[index];
            item.frame = CGRectMake(0.0, itemY, contentW, itemH);
            itemY = CGRectGetMaxY(item.frame);
        }
    }
    
    CGFloat itemTotalH = (self.alert_itemContainer.count > 2) ? itemH * self.alert_itemContainer.count : itemH;
    CGFloat contentH = (self.alert_style == DDQAlertControllerStyleAlertExceptHeader) ? itemTotalH : itemTotalH + self.alert_headerView.height;
    CGFloat contentY = self.view.height * 0.5 - contentH * 0.5;
    self.alert_contentView.frame = CGRectMake(contentX, contentY, contentW, contentH);
}

/**
 处理样式为Sheet时的情况
 */
- (void)alert_layoutSheetStyleFrameWithRate:(DDQRateSet)rateSet {
    
    CGFloat contentX = 8.0 * rateSet.widthRate;
    CGFloat contentW = self.view.width - contentX * 2.0;
    
    CGFloat labelX = 16.0 * rateSet.widthRate;
    CGFloat boundW = contentW - labelX * 2.0;
    CGSize boundSize = CGSizeMake(boundW, 200.0);
    
    CGRect headerFrame = CGRectZero;
    //当前的样式判断
    if (self.alert_style == DDQAlertControllerStyleSheet) {
        
        CGSize titleSize = [self.alert_attrTitle boundingRectWithSize:boundSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        CGSize messageSize = [self.alert_attrMessage boundingRectWithSize:boundSize options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        
        CGFloat labelY = 20.0 * rateSet.heightRate;
        self.alert_titleLabel.frame = CGRectMake(labelX, labelY, contentW - labelX * 2.0, titleSize.height);
        self.alert_messageLabel.frame = CGRectMake(labelX, CGRectGetMaxY(self.alert_titleLabel.frame) + 4.0, self.alert_titleLabel.width, messageSize.height);
        
        self.alert_headerView.frame = CGRectMake(0.0, 0.0, contentW, labelY * 2.0 + titleSize.height + messageSize.height + 4.0);
        headerFrame = self.alert_headerView.frame;
    }
    
    CGFloat itemX = 0.0;
    CGFloat itemY = CGRectGetMaxY(headerFrame);
    CGFloat itemH = 44.0 * rateSet.heightRate;
    CGFloat itemTotalH = 0.0;
    if (self.alert_itemContainer.count > 1) {
        
        for (NSUInteger index = 0; index < self.alert_itemContainer.count - 1; index++) {
            
            DDQAlertItem *item = self.alert_itemContainer[index];
            item.frame = CGRectMake(itemX, itemY, contentW, itemH);
            itemY = CGRectGetMaxY(item.frame);
        }
        itemTotalH = itemH * (self.alert_itemContainer.count - 1);
    } else if (self.alert_itemContainer.count == 1) {
        
        DDQAlertItem *item = [self.alert_itemContainer firstObject];
        item.frame = CGRectMake(itemX, itemY, contentW, itemH);
        itemTotalH = itemH;
    }
    CGFloat contentH = itemTotalH + self.alert_headerView.height;
    
    CGRect footerFrame = CGRectZero;
    CGFloat bottomSpace = 12.0 * rateSet.heightRate;
    if (self.alert_itemContainer.count > 1) {
        
        self.alert_footContentView.frame = CGRectMake(contentX, CGRectGetHeight(self.view.frame) - bottomSpace - itemH, CGRectGetWidth(self.view.frame) - contentX * 2.0, itemH);
        self.alert_footContentView.layer.cornerRadius = 5.0;
        footerFrame = self.alert_footContentView.frame;
        
        DDQAlertItem *item = [self.alert_itemContainer lastObject];
        [item removeFromSuperview];
        [self.alert_footContentView addSubview:item];
        item.frame = self.alert_footContentView.bounds;
        
        bottomSpace = bottomSpace * 2.0;
    }
    
    CGFloat contentY = CGRectGetHeight(self.view.frame) - CGRectGetHeight(footerFrame) - bottomSpace - contentH;
    self.alert_contentView.frame = CGRectMake(contentX, contentY, contentW, contentH);
}

/**
 布局子视图
 */
- (void)alert_layoutSubviews {
    
    self.alert_contentView = [[UIView alloc] init];
    [self.view addSubview:self.alert_contentView];
    self.alert_contentView.backgroundColor = [UIColor whiteColor];
    self.alert_contentView.layer.cornerRadius = 5.0;
    self.alert_contentView.layer.masksToBounds = YES;
    
    self.alert_headerView = [[UIView alloc] init];
    [self.alert_contentView addSubview:self.alert_headerView];
    self.alert_headerView.backgroundColor = [UIColor clearColor];
    
    [self alert_handleDifferentStyleHeaderSubviews];
}

/**
 处理不同情况下header的显示
 */
- (void)alert_handleDifferentStyleHeaderSubviews {
    
    if (self.alert_style == DDQAlertControllerStyleSheet || self.alert_style == DDQAlertControllerStyleSheetExceptHeader) {
        
        self.alert_footContentView = [[UIView alloc] init];
        [self.view addSubview:self.alert_footContentView];
        self.alert_footContentView.backgroundColor = [UIColor whiteColor];
        self.alert_footContentView.layer.masksToBounds = YES;
    }
    
    //除开头部的话就不需要两个label了
    if (self.alert_style == DDQAlertControllerStyleSheetExceptHeader || self.alert_style == DDQAlertControllerStyleAlertExceptHeader) return;
    
    self.alert_verLineView = [[UIView alloc] init];
    [self.alert_contentView addSubview:self.alert_verLineView];
    self.alert_verLineView.hidden = YES;
    self.alert_verLineView.backgroundColor = kSetColor(235.0, 235.0, 235.0, 1.0);
    
    self.alert_titleLabel = [[UILabel alloc] init];
    [self.alert_headerView addSubview:self.alert_titleLabel];
    self.alert_titleLabel.textColor = [UIColor blackColor];
    self.alert_titleLabel.textAlignment = NSTextAlignmentCenter;
    self.alert_titleLabel.text = self.alert_title;
    self.alert_titleLabel.font = self.alert_titleFont;
    self.alert_titleLabel.numberOfLines = 0;
    
    self.alert_messageLabel = [[UILabel alloc] init];
    [self.alert_headerView addSubview:self.alert_messageLabel];
    self.alert_messageLabel.textColor = [UIColor blackColor];
    self.alert_messageLabel.textAlignment = NSTextAlignmentCenter;
    self.alert_messageLabel.text = self.alert_message;
    self.alert_messageLabel.font = self.alert_messageFont;
    self.alert_messageLabel.numberOfLines = 0;
    
    //不用重复注册
    if (_alert_registerKVO) return;
    
    [self.alert_messageLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    [self.alert_messageLabel addObserver:self forKeyPath:@"attributedText" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.alert_titleLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    [self.alert_titleLabel addObserver:self forKeyPath:@"attributedText" options:NSKeyValueObservingOptionNew context:nil];
    
    _alert_registerKVO = YES;
}

/**
 处理不同情况下字体的大小
 */
- (void)alert_handleDifferentStyleLabelFont {
    
    //也只有在有头视图的情况下才设置字体大小
    if (self.alert_style == DDQAlertControllerStyleAlert || self.alert_style == DDQAlertControllerStyleSheet) {
        
        self.alert_titleFont = (self.alert_style == DDQAlertControllerStyleAlert) ? [UIFont systemFontOfSize:18.0]:[UIFont systemFontOfSize:17.0];
        self.alert_attrTitle = [[NSAttributedString alloc] initWithString:self.alert_title attributes:@{NSFontAttributeName:self.alert_titleFont}];
        
        self.alert_messageFont = (self.alert_style == DDQAlertControllerStyleAlert) ? [UIFont systemFontOfSize:13.0] : [UIFont systemFontOfSize:12.0];
        self.alert_attrMessage = [[NSAttributedString alloc] initWithString:self.alert_message attributes:@{NSFontAttributeName:self.alert_messageFont}];
    }
    
}

- (void)alert_addAlertItem:(DDQAlertItemSetup)setup handler:(DDQAlertItemHandler)handler {
    
    if (setup && setup()) {
        
        DDQAlertItem *alertItem = setup();
        alertItem.delegate = self;
        [self.alert_contentView addSubview:alertItem];
        [self.alert_itemContainer addObject:alertItem];
        
        if (handler) [self.alert_handlerContainer setObject:handler forKey:@(alertItem.hash).stringValue];
    }
}

- (void)alert_updateControllerStyle:(DDQAlertControllerStyle)style {
    
    self.alert_style = style;
    [self alert_handleDifferentStyleLabelFont];
    [self alert_handleDifferentStyleHeaderSubviews];
}

- (NSArray<DDQAlertItem *> *)alert_items {
    
    return self.alert_itemContainer;
}

#pragma mark - Item Delegate
- (void)alert_itemSelectedWithItem:(DDQAlertItem *)item {
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    DDQAlertItemHandler handler = [self.alert_handlerContainer valueForKey:@(item.hash).stringValue];
    if (handler) handler(item);
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(alert_didSelectItem:)]) {
        [self.delegate alert_didSelectItem:item];
    }
}

#pragma mark - Label KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    //响应KVO的属性判断
    if ([keyPath isEqualToString:@"attributedText"]) {
        
        //响应KVO的对象判断
        if (object == self.alert_messageLabel) {
            
            //这么写是为了在计算frame时时统一的、方便的。
            self.alert_attrMessage = self.alert_messageLabel.attributedText;
            
            //当前的样式判断
            //PS:当前为except的样式不会注册KVO
            if (self.alert_style == DDQAlertControllerStyleAlert) {
                
                [self alert_layoutAlertStyleFrameWithRate:self.alert_rateSet];
            } else {
                
                [self alert_layoutSheetStyleFrameWithRate:self.alert_rateSet];
            }
        } else {
            
            self.alert_attrTitle = self.alert_titleLabel.attributedText;
            
            if (self.alert_style == DDQAlertControllerStyleAlert) {
                
                [self alert_layoutAlertStyleFrameWithRate:self.alert_rateSet];
            } else {
                
                [self alert_layoutSheetStyleFrameWithRate:self.alert_rateSet];
            }
        }
    } else {
        
        if (object == self.alert_messageLabel) {
            
            self.alert_attrMessage = [[NSAttributedString alloc] initWithString:self.alert_messageLabel.text attributes:@{NSFontAttributeName:self.alert_messageLabel.font}];
            
            if (self.alert_style == DDQAlertControllerStyleAlert) {
                
                [self alert_layoutAlertStyleFrameWithRate:self.alert_rateSet];
            } else {
                
                [self alert_layoutSheetStyleFrameWithRate:self.alert_rateSet];
            }
        } else {
            
            self.alert_attrTitle = [[NSAttributedString alloc] initWithString:self.alert_titleLabel.text attributes:@{NSFontAttributeName:self.alert_titleLabel.font}];
            
            if (self.alert_style == DDQAlertControllerStyleAlert) {
                
                [self alert_layoutAlertStyleFrameWithRate:self.alert_rateSet];
            } else {
                
                [self alert_layoutSheetStyleFrameWithRate:self.alert_rateSet];
            }
        }
    }
}

@end


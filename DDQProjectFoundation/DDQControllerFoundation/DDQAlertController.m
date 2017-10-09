//
//  DDQAlertController.m
//
//  Created by 我叫咚咚枪 on 2017/10/7.
//

#import "DDQAlertController.h"

#import "DDQAlertItem.h"
#import "UIView+DDQSimplyGetViewProperty.h"

@interface DDQAlertController ()<DDQAlertItemDelegate>

@property (nonatomic, strong, readwrite) UIView *alert_contentView;
@property (nonatomic, strong, readwrite) UIView *alert_headerView;
@property (nonatomic, strong) UIView *alert_verLineView;
@property (nonatomic, strong) UILabel *alert_titleLabel;
@property (nonatomic, strong) UILabel *alert_messageLabel;
@property (nonatomic, assign) DDQAlertControllerStyle alert_style;
@property (nonatomic, strong) NSMutableArray<DDQAlertItem *> *alert_itemContainer;
@property (nonatomic, strong) DDQAlertItemHandler alert_handler;

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
    self.alert_attrTitle = nil;
    self.alert_attrMessage = nil;
    self.alert_style = style;
    self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self alert_layoutSubviews];
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.alert_itemContainer = [NSMutableArray array];
}

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    
    DDQRateSet rateSet = [UIView view_getCurrentDeviceRateWithVersion:DDQFoundationRateDevice_iPhone5];
    
    CGFloat contentX = (self.alert_style == DDQAlertControllerStyleAlert || self.alert_style == DDQAlertControllerStyleAlertExceptHeader) ? 25.0:8.0;
    contentX = contentX * rateSet.widthRate;
    CGFloat contentW = self.view.width - contentX * 2.0;
    
    CGFloat headerH = (self.alert_style == DDQAlertControllerStyleAlert || self.alert_style == DDQAlertControllerStyleSheet) ? 78:0.0;
    headerH = headerH * rateSet.heightRate;
    
    CGFloat itemH = 44.0 * rateSet.heightRate;
    CGFloat contentH = itemH + headerH;
    if (self.alert_itemContainer.count > 2) {
        contentH = itemH * self.alert_itemContainer.count + headerH;
    } else if (self.alert_itemContainer.count == 2) {
        self.alert_verLineView.hidden = NO;
    }
    
    CGFloat contentY = (self.alert_style == DDQAlertControllerStyleAlert || self.alert_style == DDQAlertControllerStyleAlertExceptHeader) ? CGRectGetMidY(self.view.frame) - contentH * 0.5:CGRectGetHeight(self.view.frame) - contentX - contentH;
    
    if (self.alert_style == DDQAlertControllerStyleSheetExceptHeader || self.alert_style == DDQAlertControllerStyleSheet) {
        contentH = headerH + ((self.alert_itemContainer.count > 1)?self.alert_itemContainer.count - 1:1) * itemH;
        contentY = contentY - contentX;
    }
    
    self.alert_contentView.frame = CGRectMake(contentX, contentY, contentW, contentH);
    self.alert_headerView.frame = CGRectMake(0.0, 0.0, contentW, headerH);
    self.alert_titleLabel.frame = CGRectMake(0.0, 0.0, contentW, headerH * 0.5);
    self.alert_messageLabel.frame = CGRectMake(0.0, CGRectGetMaxY(self.alert_titleLabel.frame), contentW, headerH * 0.5);
    
    CGFloat itemX = 0.0;
    CGFloat itemY = CGRectGetMaxY(self.alert_headerView.frame);
    if (self.alert_itemContainer.count == 2 && (self.alert_style == DDQAlertControllerStyleAlertExceptHeader || self.alert_style == DDQAlertControllerStyleAlert)) {
        
        self.alert_verLineView.frame = CGRectMake(contentW * 0.5 - 0.5, CGRectGetMaxY(self.alert_headerView.frame), 1.0, itemH);
        for (NSInteger index = 0; index < self.alert_itemContainer.count; index++) {
            
            DDQAlertItem *item = self.alert_itemContainer[index];
            item.frame = CGRectMake(itemX, itemY, contentW * 0.5, itemH);
            itemX = CGRectGetMaxX(item.frame);
        }
    } else {
        
        for (NSInteger index = 0; index < self.alert_itemContainer.count; index++) {
            
            DDQAlertItem *item = self.alert_itemContainer[index];
            if ((self.alert_style == DDQAlertControllerStyleSheetExceptHeader || self.alert_style == DDQAlertControllerStyleSheet) && item == self.alert_itemContainer.lastObject) {
                
                [item removeFromSuperview];
                [self.view addSubview:item];
                
                item.frame = CGRectMake(contentX + contentX * 0.5, self.alert_contentView.y + self.alert_contentView.height + contentX, contentW - contentX + contentX * 0.5, itemH - contentX);
                
                item.layer.cornerRadius = 5.0;
                item.layer.masksToBounds = YES;
            } else {
                
                item.frame = CGRectMake(0.0, itemY, contentW, itemH);
                itemY = CGRectGetMaxY(item.frame);
            }
        }
    }
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
    
    self.alert_verLineView = [[UIView alloc] init];
    [self.alert_contentView addSubview:self.alert_verLineView];
    self.alert_verLineView.hidden = YES;
    self.alert_verLineView.backgroundColor = kSetColor(235.0, 235.0, 235.0, 1.0);
    
    self.alert_titleLabel = [[UILabel alloc] init];
    [self.alert_headerView addSubview:self.alert_titleLabel];
    self.alert_titleLabel.textColor = [UIColor blackColor];
    self.alert_titleLabel.textAlignment = NSTextAlignmentCenter;
    self.alert_titleLabel.text = self.alert_title;
    
    self.alert_messageLabel = [[UILabel alloc] init];
    [self.alert_headerView addSubview:self.alert_messageLabel];
    self.alert_messageLabel.textColor = [UIColor blackColor];
    self.alert_messageLabel.font = [UIFont systemFontOfSize:12.0];
    self.alert_messageLabel.textAlignment = NSTextAlignmentCenter;
    self.alert_messageLabel.text = self.alert_message;
}

- (void)alert_addAlertItem:(DDQAlertItemSetup)setup handler:(DDQAlertItemHandler)handler {
    
    if (setup && setup()) {
        
        DDQAlertItem *alertItem = setup();
        alertItem.delegate = self;
        [self.alert_contentView addSubview:alertItem];
        [self.alert_itemContainer addObject:alertItem];
    }
    if (handler) self.alert_handler = handler;
}

#pragma mark - Item Delegate
- (void)alert_itemSelectedWithItem:(DDQAlertItem *)item {
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    if (self.alert_handler) self.alert_handler(item);
}

@end


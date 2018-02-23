//
//  DDQTabBar.m
//
//  Copyright © 2017年 DDQ. All rights reserved.

#import "DDQTabBar.h"

#import "DDQBarItem.h"

@interface DDQTabBar ()<DDQBarItemDelegate>

@property (nonatomic, strong) DDQBarItem *tempItem;
@end

@implementation DDQTabBar

@synthesize bar_currentIndex = _bar_currentIndex;

- (id)copyWithZone:(NSZone *)zone {

    return [[DDQTabBar allocWithZone:zone] init];
}

+ (instancetype)tabBarWithFrame:(CGRect)frame {

    return [[self alloc] initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (!self) return nil;

    self.bar_backgroundImageView = [[UIImageView alloc] init];
    [self addSubview:self.bar_backgroundImageView];
    self.bar_backgroundImageView.userInteractionEnabled = YES;
    self.bar_backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    return self;
}

- (void)setBar_currentIndex:(NSUInteger)bar_currentIndex {

    _bar_currentIndex = bar_currentIndex;
    
    if (_bar_currentIndex > self.bar_items.count) {
        NSException *ex = [NSException exceptionWithName:@"索引设置错误" reason:@"索引超过了Item的数量" userInfo:nil];
        [ex raise];
    }
    
    DDQBarItem *item = self.bar_items[_bar_currentIndex];
    if (self.tempItem == item) return;
    
    self.tempItem.item_selected = NO;
    item.item_selected = YES;
    self.tempItem = item;
}

- (NSUInteger)barCurrentIndex {

    return self.tempItem.tag;
}

- (void)setBar_items:(NSArray<DDQBarItem *> *)bar_items {

    _bar_items = bar_items;
    
    for (NSUInteger index = 0; index < _bar_items.count; index++) {
        
        DDQBarItem *item = _bar_items[index];
        item.delegate = self;
        item.tag = index;
        if (index == 0) {
            item.item_selected = YES;
            self.tempItem = item;
        }
        [self addSubview:item];
    }
    
    [self setNeedsLayout];
}

- (void)layoutSubviews {

    [super layoutSubviews];
    
    self.bar_backgroundImageView.frame = self.bounds;
    
    CGFloat itemW = CGRectGetWidth(self.frame) / self.bar_items.count;
    CGFloat itemH = CGRectGetHeight(self.frame);
    for (NSUInteger index = 0; index < self.bar_items.count; index++) {
        
        DDQBarItem *item = [self.bar_items objectAtIndex:index];
        item.frame = CGRectMake(itemW * index, 0.0, itemW, itemH);
    }
}

#pragma mark - CustomItem Delegate
- (void)item_didSelectedWithItem:(DDQBarItem *)item {

    if (self.tempItem == item) return;
    
    self.tempItem.item_selected = NO;
    item.item_selected = YES;
    self.tempItem = item;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBar_didSelectWithItemIndex:)]) {
        [self.delegate tabBar_didSelectWithItemIndex:item.tag];
    }
}

@end


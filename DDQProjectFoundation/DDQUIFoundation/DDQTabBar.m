//
//  DDQTabBar.m
//
//  Copyright © 2017年 DDQ. All rights reserved.

#import "DDQTabBar.h"

#import "DDQBarItem.h"

@interface DDQTabBar ()<DDQBarItemDelegate> {
    
    NSInteger lastIndex;
}

@property (nonatomic, strong) DDQBarItem *tempItem;


@end

@implementation DDQTabBar

- (id)copyWithZone:(NSZone *)zone {

    DDQTabBar *bar = [[DDQTabBar allocWithZone:zone] init];
    bar.bar_items = self.bar_items;
    bar.bar_currentIndex = self.bar_currentIndex;
    bar.delegate = self.delegate;
    bar.bar_backgroundImageView = self.bar_backgroundImageView;
    return bar;
    
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
    
    [self addObserver:self forKeyPath:@"tempItem" options:NSKeyValueObservingOptionOld context:nil];
    return self;
    
}

- (void)dealloc {
    
    [self removeObserver:self forKeyPath:@"tempItem"];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"tempItem"] && ![change[NSKeyValueChangeOldKey] isEqual:[NSNull null]]) {
        
        DDQBarItem *lastItem = [change valueForKey:NSKeyValueChangeOldKey];
        lastIndex = lastItem.tag;
        
    }
}

- (void)setBar_currentIndex:(NSInteger)bar_currentIndex {

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

- (NSInteger)bar_lastIndex {
    
    return lastIndex;
    
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
            self.bar_currentIndex = index;
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


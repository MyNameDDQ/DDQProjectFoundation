//
//  DDQWaterfallsFlowLayout.m
//
//  Copyright © 2017年 DDQ. All rights reserved.

#import "DDQWaterfallsFlowLayout.h"

@interface DDQWaterfallsFlowLayout ()

@property (nonatomic, assign) UIEdgeInsets layout_margin;
@property (nonatomic, assign) DDQViewVHSpace layout_space;
@property (nonatomic, assign) NSInteger layout_columnCount;

@property (nonatomic, assign) CGFloat layout_maxColumnHeight;
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *layout_attributes;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *layout_recordHeights;

@end

@implementation DDQWaterfallsFlowLayout

static NSInteger const DefaultColumnCount = 2;

#pragma mark - Custom Property
- (UIEdgeInsets)layout_margin {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(flowLayoutItemMargin)]) {
        
        _layout_margin = [self.delegate flowLayoutItemMargin];
        
    } else {
        
        _layout_margin = UIEdgeInsetsZero;
        
    }
    return _layout_margin;
    
}

- (DDQViewVHSpace)layout_space {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(flowLayoutItemSpace)]) {
        
        _layout_space = [self.delegate flowLayoutItemSpace];
        
    } else {
        
        _layout_space = DDQViewVHSpaceZero;
        
    }
    return _layout_space;
    
}

- (NSInteger)layout_columnCount {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(flowLayoutItemColumnCount)]) {
        
        _layout_columnCount = [self.delegate flowLayoutItemColumnCount];
        
    } else {
        
        _layout_columnCount = DefaultColumnCount;
        
    }
    return _layout_columnCount;
    
}


#pragma mark - Super Method
- (void)prepareLayout {
    
    [super prepareLayout];

    self.layout_maxColumnHeight = 0;
    if (self.layout_maxColumnHeight < self.layout_margin.top) {
        
        self.layout_maxColumnHeight = self.layout_margin.top;
        
    }
    
    self.layout_recordHeights = [NSMutableArray arrayWithCapacity:self.layout_columnCount];
    for (NSInteger index = 0; index < self.layout_columnCount; index++) {
        
        [self.layout_recordHeights addObject:@(self.layout_margin.top)];
        
    }
    
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    self.layout_attributes = [NSMutableArray arrayWithCapacity:itemCount];
    for (NSInteger row = 0; row < itemCount; row++) {
        
        NSIndexPath *itemPath = [NSIndexPath indexPathForItem:row inSection:0];
        UICollectionViewLayoutAttributes *layoutAttrs = [self layoutAttributesForItemAtIndexPath:itemPath];
        [self.layout_attributes addObject:layoutAttrs];
        
    }
    
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //W
    CGFloat attrW = (CGRectGetWidth(self.collectionView.frame) - self.layout_margin.left - self.layout_margin.right - self.layout_space.horSpace) / self.layout_columnCount;
    
    //H
    CGFloat attrH = [self.delegate flowLayout:self heightForItemWithIndexPath:indexPath itemWidth:attrW];
    
    //X
    __block NSInteger minColumn = 0;
    __block CGFloat minHeight = 0.0;
    [self.layout_recordHeights enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.floatValue < self.layout_maxColumnHeight) {
            
            minColumn = idx;
            minHeight = obj.floatValue;
            *stop = YES;
            
        }
        
    }];
    CGFloat attrX = self.layout_margin.left + minColumn * attrW + self.layout_space.horSpace * minColumn;
    
    //Y
    CGFloat attrY = minHeight;
    if (attrY != self.layout_margin.top) {
        
        attrY += self.layout_space.verSpace;
        
    }
    
    layoutAttributes.frame = CGRectMake(attrX, attrY, attrW, attrH);
    
    self.layout_recordHeights[minColumn] = @(CGRectGetMaxY(layoutAttributes.frame));
    if (CGRectGetMaxY(layoutAttributes.frame) > self.layout_maxColumnHeight) {
        
        self.layout_maxColumnHeight = CGRectGetMaxY(layoutAttributes.frame);
        
    }
    
    return layoutAttributes;
    
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    return self.layout_attributes.copy;
    
}

- (CGSize)collectionViewContentSize {
    
    return CGSizeMake(CGRectGetWidth(self.collectionView.frame), self.layout_maxColumnHeight);
    
}

@end


//
//  DDQSearchBar.m
//
//  Copyright © 2017年 DDQ. All rights reserved.

#import "DDQSearchBar.h"

#import "DDQFoundationDefine.h"

typedef NS_ENUM(NSUInteger, DDQSearchBarContentType) {
    DDQSearchBarContentTypeTextAndEditing,      //编辑与文字显示
    DDQSearchBarContentTypeLeftView,            //左边图片的显示
    DDQSearchBarContentTypePlaceholder,         //占位字符的显示
};

@interface DDQSearchBar () {
    
    DDQBarUnlessEditingStyle _editingStyle;
}


@end

@implementation DDQSearchBar

- (id)copyWithZone:(NSZone *)zone {
    return [[DDQSearchBar allocWithZone:zone] initBarWithStyle:DDQBarUnlessEditingStyleAlignmentCenter];
}

+ (instancetype)searchBarWithStyle:(DDQBarUnlessEditingStyle)style {
    
    return [[self alloc] initBarWithStyle:style];
}

- (instancetype)initBarWithStyle:(DDQBarUnlessEditingStyle)style {
    
    self = [super initWithFrame:CGRectZero];
    if (!self) return nil;
    
    UIFont *systemFont = [UIFont systemFontOfSize:13.0];
    _editingStyle = style;
    self.bar_allowCorner = YES;
    self.bar_contentSpace = 3.0;
    self.bar_attributes = @{NSFontAttributeName:systemFont, NSForegroundColorAttributeName:kSetColor(153.0, 153.0, 153.0, 1.0)};
    
    self.delegate = self;
    self.font = systemFont;
    self.returnKeyType = UIReturnKeySearch;
    self.backgroundColor = [UIColor whiteColor];
    
    self.borderStyle =  UITextBorderStyleNone;
    self.leftViewMode = UITextFieldViewModeAlways;
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    UIImage *image = DDQ_DEFAULT_SOURCE_IMAGE(@"search@2x", @"png");
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    self.leftView = imageView;
    
    [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];
    return self;
}

- (void)dealloc {
    
    [self removeObserver:self forKeyPath:@"frame"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if (change) {
        
        CGRect rect = [change[NSKeyValueChangeNewKey] CGRectValue];
        if (self.bar_allowCorner) {
            self.layer.cornerRadius = CGRectGetHeight(rect) * 0.5;
        }
        self.bar_leftMargin = CGRectGetHeight(rect) * 0.5;
    }
}

- (void)setBar_placeholderText:(NSString *)bar_placeholderText {
    
    _bar_placeholderText = bar_placeholderText;
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_bar_placeholderText attributes:self.bar_attributes];
}

- (DDQBarUnlessEditingStyle)bar_unlessStyle {
    return _editingStyle;
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    return [self bar_handleFieldContentRectWithType:DDQSearchBarContentTypePlaceholder bounds:bounds];
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    return [self bar_handleFieldContentRectWithType:DDQSearchBarContentTypeLeftView bounds:bounds];
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return [self bar_handleFieldContentRectWithType:DDQSearchBarContentTypeTextAndEditing bounds:bounds];
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self bar_handleFieldContentRectWithType:DDQSearchBarContentTypeTextAndEditing bounds:bounds];
}

/**
 处理重写后Field内容的Frame
 
 @param type 处理的类型
 @param bounds 处理的实际大小
 @return 对应内容的显示大小
 */
- (CGRect)bar_handleFieldContentRectWithType:(DDQSearchBarContentType)type bounds:(CGRect)bounds {
    
    CGRect contentRect = CGRectZero;    /* 最后return的frame大小 */
    CGFloat boundCenterY = CGRectGetHeight(self.bounds) * 0.5;     /* bounds中y的中心点 */
    CGRect leftRect = CGRectZero;   /* 左边视图相对bounds的frame */
    CGSize leftViewSize = self.leftView.frame.size;     /* 左边视图的大小 */
    CGRect clearRect = [self clearButtonRectForBounds:bounds];  /* 清除按钮的大小 */
    CGRect editRect = CGRectZero;   /* 编辑范围的大小 */
    CGSize placeholderSize = (self.attributedPlaceholder) ? [self.attributedPlaceholder boundingRectWithSize:CGSizeMake(CGRectGetWidth(bounds) - self.bar_leftMargin * 2.0 - self.bar_contentSpace * 2.0 - leftViewSize.width, CGRectGetHeight(bounds)) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size : CGSizeZero;    /* 占位字符Size */
    CGRect placeholderRect = CGRectZero;    /* 占位字符相对Bounds的frame */
    
    //是否处于编辑状态
    if (self.editing) {//正在编辑
        
        leftRect = CGRectMake(self.bar_contentSpace + self.bar_leftMargin, boundCenterY - leftViewSize.height * 0.5, leftViewSize.width, leftViewSize.height);
        placeholderRect = CGRectMake(CGRectGetMaxX(leftRect) + self.bar_contentSpace, 0.0, placeholderSize.width, CGRectGetHeight(bounds));

    } else {//未编辑
        
        leftRect = CGRectMake(self.bar_contentSpace + self.bar_leftMargin, boundCenterY - leftViewSize.height * 0.5, leftViewSize.width, leftViewSize.height);
        placeholderRect = CGRectMake(CGRectGetMaxX(leftRect) + self.bar_contentSpace, 0.0, placeholderSize.width, CGRectGetHeight(bounds));
        
        //内容显示的样式判断
        if (_editingStyle == DDQBarUnlessEditingStyleAlignmentCenter && self.text.length == 0) {//当需要显示的样式居中且没有输入的文字，则变换布局
            
            placeholderRect = CGRectMake(CGRectGetMidX(bounds) - placeholderSize.width * 0.5, 0.0, placeholderSize.width, CGRectGetHeight(bounds));
            leftRect = CGRectMake(CGRectGetMinX(placeholderRect) - leftViewSize.width - self.bar_contentSpace, CGRectGetMidY(placeholderRect) - leftViewSize.height * 0.5, leftViewSize.width, leftViewSize.height);
        }
    }
    CGFloat rectX = CGRectGetMinX(placeholderRect);
    editRect = CGRectMake(rectX, 0.0, CGRectGetMinX(clearRect) - rectX - self.bar_contentSpace, CGRectGetHeight(bounds));
    
    //field位置重绘
    if (type == DDQSearchBarContentTypeLeftView) {//左视图
        contentRect = leftRect;
    } else if (type == DDQSearchBarContentTypePlaceholder) {//占位字符串
        contentRect = placeholderRect;
    } else {//输入和编辑的内容
        contentRect = editRect;
    }
    return contentRect;
}

#pragma mark - TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (self.searchDelegate && [self.searchDelegate respondsToSelector:@selector(searchBar_beginEditing)]) {
        [self.searchDelegate searchBar_beginEditing];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (self.searchDelegate && [self.searchDelegate respondsToSelector:@selector(searchBar_endEditing)]) {
        [self.searchDelegate searchBar_endEditing];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (self.searchDelegate && [self.searchDelegate respondsToSelector:@selector(searchBar_text:relpaceText:range:)]) {
        [self.searchDelegate searchBar_text:textField.text relpaceText:string range:range];
    }
    return YES;
}

@end

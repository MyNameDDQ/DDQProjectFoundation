//
//  UIView+DDQControlInitialize.m
//
//  Copyright © 2017年 DDQ. All rights reserved.

#import "UIView+DDQControlInitialize.h"

#import <objc/runtime.h>

@implementation UIView (DDQControlInitialize)

const DDQViewVHSpace DDQViewVHSpaceZero = {0, 0};
const DDQViewVHMargin DDQViewVHMarginZero = {0, 0};

DDQViewVHSpace DDQViewVHSpaceMaker(CGFloat v, CGFloat h) {
    
    DDQViewVHSpace space = {v, h};
    return space;
    
}

DDQViewVHMargin DDQViewVHMarginMaker(CGFloat v, CGFloat h) {
    
    DDQViewVHMargin margin = {v, h};
    return margin;
    
}

- (UIColor *)view_borderColor {
    return kSetColor(244.0, 244.0, 244.0, 1.0);
}

- (CGFloat)view_borderWidth {
    return 1.0;
}

- (CGFloat)view_borderRadius {
    return 5.0;
}

- (UIFont *)field_defaultTextFont {
    return [UIFont systemFontOfSize:15.0];
}

- (UIColor *)field_defaultTextColor {
    return [UIColor blackColor];
}

- (UIFont *)label_defaultTextFont {
    return [UIFont systemFontOfSize:15.0];
}

- (UIColor *)label_defaultTextColor {
    return kSetColor(157.0, 157.0, 157.0, 1.0);
}

- (UIFont *)button_defaultTitleFont {
    return [UIFont systemFontOfSize:15.0];
}

- (UIColor *)button_defaultTitleColor {
    return kSetColor(157.0, 157.0, 157.0, 1.0);
}

static const char *AutoLayout = "view.autoLayout";
static const char *Animated = "view.animated";
static const char *DrawLayer = "view.drawLayer";
- (void)setView_autoLayout:(BOOL)view_autoLayout {
    
    objc_setAssociatedObject(self, AutoLayout, @(view_autoLayout), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)view_autoLayout {
    
    return [objc_getAssociatedObject(self, AutoLayout) boolValue];
}

- (void)setView_animated:(BOOL)view_animated {
    
    objc_setAssociatedObject(self, Animated, @(view_animated), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)view_animated {
    
    return [objc_getAssociatedObject(self, Animated) boolValue];
}

- (void)setView_drawLayer:(BOOL)view_drawLayer {
 
    objc_setAssociatedObject(self, DrawLayer, @(view_drawLayer), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)view_drawLayer {
    
    return [objc_getAssociatedObject(self, DrawLayer) boolValue];
}

#pragma mark - Get Property
- (CGFloat)boundsMaxX {
    return CGRectGetMaxX(self.bounds);
}

- (CGFloat)boundsMaxY {
    return CGRectGetMaxY(self.bounds);
}

- (CGFloat)boundsMidX {
    return CGRectGetMidX(self.bounds);
}

- (CGFloat)boundsMidY {
    return CGRectGetMidY(self.bounds);
}

- (CGFloat)frameMaxX {
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)frameMaxY {
    return CGRectGetMaxY(self.frame);
}

- (CGFloat)frameMidX {
    return CGRectGetMidX(self.frame);
}

- (CGFloat)frameMidY {
    return CGRectGetMidY(self.frame);
}

- (CGSize)size {
    return self.frame.size;
}

#pragma mark - Initialize Method
+ (UIView *)view {
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

+ (UIView *)viewChangeBackgroundColor:(UIColor *)color {
    
    UIView *view = [UIView view];
    if (color) view.backgroundColor = color;
    return view;
}

+ (UILabel *)label {
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [label view_handlePointSizeWithDefaultSize:label.label_defaultTextFont.pointSize];
    label.textColor = label.label_defaultTextColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.userInteractionEnabled = YES;
    return label;
}

+ (UIButton *)button {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:button.button_defaultTitleColor forState:UIControlStateNormal];
    button.titleLabel.font = [button view_handlePointSizeWithDefaultSize:button.button_defaultTitleFont.pointSize];
    return button;
}

+ (UIImageView *)imageView {
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.userInteractionEnabled = YES;
    imageView.clipsToBounds = YES;
    return imageView;
}

+ (UITextField *)textField {
    
    UITextField *textField = [[UITextField alloc] init];
    textField.font = textField.field_defaultTextFont;
    textField.textColor = textField.field_defaultTextColor;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    return textField;
}

+ (DDQFoundationTableView *)tableViewWithStyle:(UITableViewStyle)style {
    
    DDQFoundationTableView *tableView = [[DDQFoundationTableView alloc] initWithFrame:CGRectZero style:style];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    if (style == UITableViewStylePlain) {
        tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return tableView;
}

static const char *BoundRect = "Bound.Rect";
- (void)setView_boundRect:(CGRect)view_boundRect {
    objc_setAssociatedObject(self, BoundRect, NSStringFromCGRect(view_boundRect), OBJC_ASSOCIATION_COPY);
}

- (CGRect)view_boundRect {
    
    NSString *rectString = objc_getAssociatedObject(self, BoundRect);
    return (rectString.length == 0) ? CGRectZero : CGRectFromString(rectString);
}

#pragma mark - Custom Method
- (void)view_configSubviews:(NSArray<__kindof UIView *> *)views {
    
    for (UIView *view in views) {
        if (![self.subviews containsObject:view]) {
            [self addSubview:view];
        }
    }
}

- (void)view_removeSubviews:(NSArray<__kindof UIView *> *)views {
    
    for (UIView *view in views) {
        if ([self.subviews containsObject:view]) {
            [view removeFromSuperview];
        }
    }
}

- (void)view_hanlderLayerWithRadius:(CGFloat)rad borderWidth:(CGFloat)width borderColor:(UIColor *)color {
    
    self.layer.cornerRadius = rad;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = width;
    if (color) self.layer.borderColor = color.CGColor;
    self.view_drawLayer = YES;
}

- (UIFont *)view_handlePointSizeWithDefaultSize:(CGFloat)defaultSize {
    
    //对于字体大小也需要适配
    DDQFoundationRateDeviceVersion currentVersion = [UIView view_getDeviceVersion];
    DDQRateSet rateSet = [UIView view_getCurrentDeviceRateWithVersion:DDQFoundationRateDevice_iPhone6];
    CGFloat pointSize = 0.0;
    //当前屏幕类型判断
    if (currentVersion >= DDQFoundationRateDevice_iPhone6) {//iPhone6及以上屏幕大小不变
        pointSize = defaultSize;
    } else {
        pointSize = ceil(defaultSize * rateSet.widthRate);
    }
    return [UIFont systemFontOfSize:pointSize];
}

- (NSString *)view_changeTimes:(NSString *)times format:(NSString *)format {
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:times.floatValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *temp = (format.length == 0) ? @"yyyy-MM-dd HH:mm:ss" : format;
    [formatter setDateFormat:temp];
    return [formatter stringFromDate:date];
}

@end

@implementation UIImageView (DDQImageViewUpdate)

+ (instancetype)imageViewChangeImage:(UIImage *)image {
    
    UIImageView *imageView = [UIImageView imageView];
    if (image) imageView.image = image;
    [imageView sizeToFit];
    return imageView;
}

@end

@implementation UILabel (DDQLabelUpdate)

+ (instancetype)labelChangeText:(NSString *)text font:(UIFont *)font textColor:(UIColor *)color {
    
    UILabel *label = [UILabel label];
    if (font) label.font = [label view_handlePointSizeWithDefaultSize:font.pointSize];
    if (color) label.textColor = color;
    if (text.length > 0) label.text = text;
    return label;
}

- (CGSize)label_boundWithMaxSize:(CGSize)mSize attributes:(NSDictionary<NSAttributedStringKey,id> *)attrs {
    
//    CGSize boundSize = (CGSizeEqualToSize(mSize, CGSizeZero)) ? CGSizeMake(10000.0, 10000.0) : mSize;
//    if (attrs.count > 0) {
//
//        return [self.text boundingRectWithSize:boundSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
//
//    }
//
//    return [self sizeThatFits:boundSize];
    
    NSDictionary *sizeAttrs = nil;
    if (attrs.count > 0) {
        sizeAttrs = attrs;
    } else {
        sizeAttrs = @{NSFontAttributeName:[UIFont systemFontOfSize:self.font.pointSize + 0.5]};
    }

    CGSize boundSize = [self.text boundingRectWithSize:mSize options:NSStringDrawingUsesLineFragmentOrigin attributes:sizeAttrs context:nil].size;
    return CGSizeMake(ceil(boundSize.width), ceil(boundSize.height));
    
}

- (CGSize)label_boundWithMaxSize:(CGSize)mSize options:(NSStringDrawingOptions)options {
    
    NSDictionary *sizeAttrs = @{NSFontAttributeName:[UIFont systemFontOfSize:self.font.pointSize + 0.5]};
    CGSize boundSize = [self.text boundingRectWithSize:mSize options:options attributes:sizeAttrs context:nil].size;
    return CGSizeMake(ceil(boundSize.width), ceil(boundSize.height));
    
}

- (CGSize)label_boundAttributeTextSize {
    
    return [self.attributedText size];
    
}

@end

@implementation UIButton (DDQButtonUpdate)

+ (instancetype)buttonChangeFont:(UIFont *)font titleColor:(UIColor *)color image:(UIImage *)image backgroundImage:(UIImage *)backgroundImage title:(NSString *)title attributeTitle:(NSAttributedString *)attrTitle target:(id)target sel:(SEL)sel {
    
    UIButton *button = [UIButton button];
    if (font) button.titleLabel.font = [button view_handlePointSizeWithDefaultSize:font.pointSize];
    if (color) [button setTitleColor:color forState:UIControlStateNormal];
    if (image) [button setImage:image forState:UIControlStateNormal];
    if (backgroundImage && ![button imageForState:UIControlStateNormal]) [button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    if (title.length > 0) [button setTitle:title forState:UIControlStateNormal];
    if (attrTitle && [button titleForState:UIControlStateNormal].length == 0) [button setAttributedTitle:attrTitle forState:UIControlStateNormal];
    if (target && sel) [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    return button;
}

@end

@implementation UITextField (DDQTextFieldUpdate)

+ (instancetype)fieldChangeFont:(UIFont *)font textColor:(UIColor *)color placeholder:(NSString *)placeholder attributePlaceholder:(NSAttributedString *)attrPlaceholder {
    
    UITextField *filed = [UITextField textField];
    if (font) filed.font = [filed view_handlePointSizeWithDefaultSize:font.pointSize];
    if (color) filed.textColor = color;
    if (placeholder.length > 0) filed.placeholder = placeholder;
    if (attrPlaceholder && filed.placeholder.length == 0) filed.attributedPlaceholder = attrPlaceholder;
    return filed;
}

@end

@implementation DDQFoundationTableView (DDQTableViewUpdate)

+ (instancetype)tableViewChangeStyle:(UITableViewStyle)style {
    
    DDQFoundationTableView *tableView = [DDQFoundationTableView tableViewWithStyle:style];
    return tableView;
    
}

@end

@implementation UIImage (DDQImageHandler)

static const char *IsDefault = "Is.Default";
static const char *Extension = "Extension";
- (void)setIsDefault:(BOOL)isDefault {
    
    objc_setAssociatedObject(self, IsDefault, [NSNumber numberWithBool:isDefault], OBJC_ASSOCIATION_RETAIN);
    
}

- (BOOL)isDefault {
    
    return [objc_getAssociatedObject(self, IsDefault) boolValue];
    
}

- (void)setImage_extension:(NSString *)image_extension {
    
    objc_setAssociatedObject(self, Extension, image_extension, OBJC_ASSOCIATION_COPY);
}

- (NSString *)image_extension {
    
    return objc_getAssociatedObject(self, Extension);
    
}

@end

@implementation UIView (DDQJKYViewApi)

- (UIColor *)defaultBlackColor {
    
    return kSetColor(51.0, 51.0, 51.0, 1.0);
    
}

- (UIColor *)defaultRedColor {
    
    return kSetColor(230.0, 17.0, 40.0, 1.0);
    
}

- (UIColor *)defaultGrayColor {
    
    return kSetColor(153.0, 153.0, 153.0, 1.0);
    
}

- (CGFloat)defaultWidthRate {
    
    DDQRateSet rateSet = [UIView view_getCurrentDeviceRateWithVersion:DDQFoundationRateDevice_iPhone6];
    return rateSet.widthRate;
    
}

- (CGSize)imageViewImageSize {
    
    if ([NSStringFromClass([self class]) isEqualToString:@"UIImageView"] || [self.class isSubclassOfClass:[UIImageView class]]) {
        
        UIImageView *imageView = (UIImageView *)self;
        return imageView.image.size;
    }
    return CGSizeZero;
    
}

@end

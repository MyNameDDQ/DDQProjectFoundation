//
//  UIView+DDQControlInitialize.h
//
//  Copyright © 2017年 DDQ. All rights reserved.

#import "DDQFoundationTableView.h"
#import "DDQFoundationTableViewLayout.h"
#import "UIView+DDQSimplyGetViewProperty.h"

#import "DDQFoundationDefine.h"

NS_ASSUME_NONNULL_BEGIN
//控件相对于父视图边缘的上下距离
struct DDQViewVerHorMargin {
    
    CGFloat verMargin;//垂直边距
    CGFloat horMargin;//水平边距
};
typedef struct DDQViewVerHorMargin DDQViewVHMargin;

//控件与控件间的上下距离
struct DDQViewVerHorSpace {
    
    CGFloat verSpace;//垂直间距
    CGFloat horSpace;//水平间距
};
typedef struct DDQViewVerHorSpace DDQViewVHSpace;

UIKIT_EXTERN const DDQViewVHSpace DDQViewVHSpaceZero;
UIKIT_EXTERN const DDQViewVHMargin DDQViewVHMarginZero;

UIKIT_EXTERN DDQViewVHSpace DDQViewVHSpaceMaker(CGFloat v, CGFloat h);
UIKIT_EXTERN DDQViewVHMargin DDQViewVHMarginMaker(CGFloat v, CGFloat h);

/**
 控件初始化
 */
@interface UIView (DDQControlInitialize)

//初始化
+ (UIView *)view;
+ (UIView *)viewChangeBackgroundColor:(nullable UIColor *)color;
+ (UILabel *)label;
+ (UIButton *)button;
+ (UIImageView *)imageView;
+ (UITextField *)textField;
+ (DDQFoundationTableView *)tableViewWithStyle:(UITableViewStyle)style;

//Get View Property
@property (nonatomic, assign, readonly) CGFloat boundsMaxX;
@property (nonatomic, assign, readonly) CGFloat boundsMaxY;
@property (nonatomic, assign, readonly) CGFloat boundsMidX;
@property (nonatomic, assign, readonly) CGFloat boundsMidY;
@property (nonatomic, assign, readonly) CGFloat frameMaxX;
@property (nonatomic, assign, readonly) CGFloat frameMaxY;
@property (nonatomic, assign, readonly) CGFloat frameMidX;
@property (nonatomic, assign, readonly) CGFloat frameMidY;
@property (nonatomic, assign, readonly) CGSize size;

//Set View SuperView
- (void)view_configSubviews:(NSArray<__kindof UIView *> *)views;
- (void)view_removeSubviews:(NSArray<__kindof UIView *> *)views;

/**
 储存计算过的frame大小
 */
@property (nonatomic, assign) CGRect view_boundRect DDQ_DEPRECATED(2_0, 2_0, "别用这个属性了");//default CGRectZero

/**
 View是否完成过动画
 */
@property (nonatomic, assign) BOOL view_animated;//default NO

/**
 View是不是随controller.view的变化而变化
 */
@property (nonatomic, assign) BOOL view_autoLayout;//default NO

/**
 View有没有切过圆角等操作
 */
@property (nonatomic, assign) BOOL view_drawLayer;

//默认的一些属性
@property (nonatomic, readonly) CGFloat view_borderWidth;     //default 1.0
@property (nonatomic, readonly) CGFloat view_borderRadius;    //default 5.0
@property (nonatomic, readonly) UIColor *view_borderColor;    //default 244.0,244.0,244.0

@property (nonatomic, readonly) UIFont *button_defaultTitleFont;    //default 15.0
@property (nonatomic, readonly) UIColor *button_defaultTitleColor;  //default 157.0,157.0,157.0

@property (nonatomic, readonly) UIFont *label_defaultTextFont;
@property (nonatomic, readonly) UIColor *label_defaultTextColor;

@property (nonatomic, readonly) UIFont *field_defaultTextFont;
@property (nonatomic, readonly) UIColor *field_defaultTextColor;

/**
 处理View的layer

 @param rad 半径
 @param width 宽度
 @param color 颜色
 */
- (void)view_hanlderLayerWithRadius:(CGFloat)rad borderWidth:(CGFloat)width borderColor:(nullable UIColor *)color;

/**
 处理label显示的文字大小
 说明：按照设计图iPhone6的大小为基准。历史遗留请用字体像素除二的值，因为我会在方法里放大两倍。
 
 @param defaultSize 字体原先的大小
 */
- (UIFont *)view_handlePointSizeWithDefaultSize:(CGFloat)defaultSize;

/**
 将时间戳装换成时间格式
 PS:默认yyyy-MM-dd
 */
- (NSString *)view_changeTimes:(NSString *)times format:(nullable NSString *)format;

@end

@interface UIImageView (DDQImageViewUpdate)

+ (instancetype)imageViewChangeImage:(nullable UIImage *)image;

@end

@interface UILabel (DDQLabelUpdate)

+ (instancetype)labelChangeText:(nullable NSString *)text font:(nullable UIFont *)font textColor:(nullable UIColor *)color;

/**
 计算文字的Size
 
 @param mSize 计算的Size。如果传CGSizeZero，计算的size为CGSizeMake(10000.0, 10000.0)。
 @param attrs 计算的属性。如果传nil，则只计算字体属性。
 @return 算出来的size
 */
- (CGSize)label_boundWithMaxSize:(CGSize)mSize attributes:(nullable NSDictionary<NSAttributedStringKey, id> *)attrs;


/**
 计算label的文字

 @param mSize 最大的内容
 @param options 计算时的选项
 */
- (CGSize)label_boundWithMaxSize:(CGSize)mSize options:(NSStringDrawingOptions)options;

/**
 计算label的属性字符串的大小

 @return 算出来的Size
 */
- (CGSize)label_boundAttributeTextSize;

@end

@interface UIButton (DDQButtonUpdate)

+ (instancetype)buttonChangeFont:(nullable UIFont *)font titleColor:(nullable UIColor *)color image:(nullable UIImage *)image backgroundImage:(nullable UIImage *)backgroundImage title:(nullable NSString *)title attributeTitle:(nullable NSAttributedString *)attrTitle target:(nullable id)target sel:(nullable SEL)sel;

@end

@interface UITextField (DDQTextFieldUpdate)

+ (instancetype)fieldChangeFont:(nullable UIFont *)font textColor:(nullable UIColor *)color placeholder:(nullable NSString *)placeholder attributePlaceholder:(nullable NSAttributedString *)attrPlaceholder;

@end

@interface DDQFoundationTableView (DDQTableViewUpdate)

+ (instancetype)tableViewChangeStyle:(UITableViewStyle)style;

@end

@interface UIImage (DDQImageHandler)

/**
 是不是默认的图片
 */
@property (nonatomic, assign) BOOL isDefault;

/** 图片的格式 */
@property (nonatomic, copy) NSString *image_extension;

@end

NS_ASSUME_NONNULL_END

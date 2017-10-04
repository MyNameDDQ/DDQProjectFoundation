//
//  DDQFoundationAlertItem.h
//
//  Created by 我叫咚咚枪 on 2017/10/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, DDQAlertItemStyle) {
    DDQAlertItemStyleDefault,       //一个默认的类型,一个label
    DDQAlertItemStyleCustom,        //一个自定义的类型
};
@protocol DDQFoundationAlertItemDelegate;
/**
 AlertController的Item
 */
@interface DDQFoundationAlertItem : UIView

/**
 初始化方法
 
 @param style 视图的类型
 */
+ (instancetype)alertItemWithStyle:(DDQAlertItemStyle)style;

@property (nonatomic, copy, nullable) NSString *item_title;//default @""
@property (nonatomic, strong, nullable) NSAttributedString *item_attrTitle;//default nil
@property (nonatomic, weak, nullable) id <DDQFoundationAlertItemDelegate> delegate;
@end

@protocol DDQFoundationAlertItemDelegate <NSObject>

@optional

/**
 Item被点击
 */
- (void)alert_itemSelectedWithItem:(DDQFoundationAlertItem *)item;

@end

NS_ASSUME_NONNULL_END

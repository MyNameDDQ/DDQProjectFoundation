//
//  DDQCityPickerController.h
//  DDQProjectEdit
//
//  Copyright © 2017年 DDQ. All rights reserved.

#import "DDQFoundationController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DDQCityPickerControllerDelegate;

/** 城市选择控制器 */
@interface DDQCityPickerController : DDQFoundationController

@property (nonatomic, strong) UIView *picker_toolBar;
@property (nonatomic, strong) UIPickerView *picker_pickerView;
@property (nonatomic, strong) UIButton *picker_sureButton;
@property (nonatomic, strong) UIButton *picker_cancelButton;
@property (nonatomic, strong) UIColor *picker_separatorColor;

/** 是否显示自定义的分割线 */
@property (nonatomic, assign) BOOL showCustomSeparator;//defalut NO

/** 当先显示的文字内容 */
@property (nonatomic, readonly) NSString *picker_content;

/** 代理内容 */
@property (nonatomic, weak, nullable) id <DDQCityPickerControllerDelegate> delegate;

@end

@protocol DDQCityPickerControllerDelegate <NSObject>

@optional

/**
 点击确认按钮
 */
- (void)picker_didSelectSureWithController:(DDQCityPickerController *)controller;

/**
 点击取消按钮
 */
- (void)picker_didSelectCancelWithController:(DDQCityPickerController *)controller;

/**
 点击了PickerView
 */
- (void)picker_didSelectCityPickerWithController:(DDQCityPickerController *)controller;

@end


NS_ASSUME_NONNULL_END


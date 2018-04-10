//
//  DDQQRScanPreviewView.h
//
//  Copyright © 2017年 DDQ. All rights reserved.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 二维码扫描的预览视图
 */
@interface DDQQRScanPreviewView : UIView

/**
 初始化方法
 */
+ (instancetype)previewViewWithFrame:(CGRect)frame;

/**
 扫描框
 */
@property (nonatomic, strong, nullable) UIImage *preview_sacnImage;

/**
 扫描时的线
 */
@property (nonatomic, strong, nullable) UIImage *preview_lineImage;

/**
 扫描框大小
 */
@property (nonatomic, assign) CGRect preview_scanRect;

/**
 蒙版背景色
 */
@property (nonatomic, strong, nonnull) UIColor *preview_dimColor;

/**
 提示文字
 */
@property (nonatomic, strong) UILabel *preview_tipLabel;

/**
 动画完成时间
 */
@property (nonatomic, assign) NSTimeInterval preview_animationDuration;

/**
 开始扫描动画
 */
- (void)preview_startScanAnimation;

/**
 停止扫描动画
 */
- (void)preview_stopScanAnimation;

@end

NS_ASSUME_NONNULL_END


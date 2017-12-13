//
//  DDQQRScanController.h
//
//  Copyright © 2017年 DDQ. All rights reserved.

#import "DDQFoundationController.h"

NS_ASSUME_NONNULL_BEGIN
@class DDQQRScanPreviewView;
@class DDQAlertController;
@protocol DDQQRScanControllerDelegate;
/**
 二维码扫描
 */
@interface DDQQRScanController : DDQFoundationController

/**
 初始化方法
 
 @param previewView 二维码扫描的预览视图。为空则显示默认布局。
 */
- (instancetype)initWithPreviewView:(nullable DDQQRScanPreviewView *)previewView;
@property (nonatomic, strong, readonly) DDQQRScanPreviewView *scan_previewView;

/**
 提不提示权限不足
 */
@property (nonatomic, assign) BOOL scan_showAuthorityAlert;//Default YES

/**
 是否使用默认的扫描区域
 */
@property (nonatomic, assign) BOOL scan_defaultRect;//Default YES

/**
 提示时的控制器
 PS:当scan_showAuthorityAlert为YES时才不为空
 */
@property (nonatomic, strong) DDQAlertController *scan_alertController;

@property (nonatomic, weak, nullable) id <DDQQRScanControllerDelegate> delegate;

/**
 扫描支持的类型
 */
@property (nonatomic, strong) NSArray *scan_supportTypes;//default AVMetadataObjectTypeQRCode

/**
 开始扫描
 */
- (void)scan_startScan;

/**
 停止扫描
 */
- (void)scan_stopScan;

@end

@protocol DDQQRScanControllerDelegate <NSObject>

@optional
/**
 获得扫描的结果
 */
- (void)scan_getScanResult:(nullable NSString *)scanString;

@end

NS_ASSUME_NONNULL_END

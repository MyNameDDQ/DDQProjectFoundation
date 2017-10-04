//
//  DDQQRScanController.h
//
//  Created by 我叫咚咚枪 on 2017/10/4.
//

#import <DDQProjectFoundation/DDQFoundationController.h>

#import "DDQQRScanPreviewView.h"

NS_ASSUME_NONNULL_BEGIN
@protocol DDQQRScanControllerDelegate;
/**
 二维码扫描
 */
@interface DDQQRScanController : DDQFoundationController

/**
 初始化方法
 
 @param previewView 二维码扫描的预览视图
 */
- (instancetype)initWithPreviewView:(DDQQRScanPreviewView *)previewView;

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


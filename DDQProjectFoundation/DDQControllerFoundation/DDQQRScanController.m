//
//  DDQQRScanController.m
//
//  Copyright © 2017年 DDQ. All rights reserved.


#import "DDQQRScanController.h"

#import "DDQQRScanPreviewView.h"
#import "DDQAlertController.h"
#import "DDQAlertItem.h"
#import <AVFoundation/AVFoundation.h>
#import "UIView+DDQSimplyGetViewProperty.h"

@interface DDQQRScanController ()<AVCaptureMetadataOutputObjectsDelegate> {
    
    id _systemActiveObserver;
}

@property (nonatomic, strong) AVCaptureSession *scan_captureSession;
@property (nonatomic, strong, readwrite) DDQQRScanPreviewView *scan_previewView;
@property (nonatomic, strong) dispatch_block_t scan_block;

@end


@implementation DDQQRScanController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //AVCapture
    if ([self scan_checkCameraAuthority]) {//相机权限
        
        [self scan_captureDeviceConfig];
        
        //Notification
        DDQWeakObject(self);
        _systemActiveObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            
            [weakObjc scan_startScan];
        }];
    }
}

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    
    self.scan_previewView.frame = self.view.bounds;
    
    if (!self.scan_defaultRect) return;
    
    CGFloat previewWH = 192.0 * [UIView view_getCurrentDeviceRateWithVersion:DDQFoundationRateDevice_iPhone6].widthRate;
    CGFloat previewX = (self.view.width * 0.5) - previewWH * 0.5;
    CGFloat previewY = (self.view.height * 0.5) - previewWH * 0.5;
    self.scan_previewView.preview_scanRect = CGRectMake(previewX, previewY, previewWH, previewWH);
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:YES];
    if (self.scan_block) dispatch_block_perform(DISPATCH_BLOCK_BARRIER, self.scan_block);
    [self scan_startScan];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:YES];
    [self scan_stopScan];
}

- (void)dealloc {
    
    if (self.scan_block) dispatch_block_cancel(self.scan_block);
    if (_systemActiveObserver) [[NSNotificationCenter defaultCenter] removeObserver:_systemActiveObserver];
}

- (void)scan_startScan {
    
    //重新捕捉
    AVCaptureMetadataOutput *output = self.scan_captureSession.outputs.firstObject;
    AVCaptureConnection *connection = output.connections.firstObject;
    if (!connection.enabled)  connection.enabled = YES;
    
    [self.scan_previewView preview_startScanAnimation];
}

- (void)scan_stopScan {
    
    //停止捕捉
    AVCaptureMetadataOutput *output = self.scan_captureSession.outputs.firstObject;
    AVCaptureConnection *connection = output.connections.firstObject;
    if (connection.enabled)  connection.enabled = NO;
    
    [self.scan_previewView preview_stopScanAnimation];
}

#pragma mark - Init
- (instancetype)initWithPreviewView:(DDQQRScanPreviewView *)previewView {
    
    self = [super init];
    if (!self) return nil;
    
    if (!previewView) {

        self.scan_previewView = [DDQQRScanPreviewView previewViewWithFrame:CGRectZero];
        self.scan_previewView.preview_dimColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.scan_previewView.preview_sacnImage = DDQ_DEFAULT_SOURCE_IMAGE(@"scan_box@2x", @"png");
        self.scan_previewView.preview_lineImage = DDQ_DEFAULT_SOURCE_IMAGE(@"scan_line@2x", @"png");
        self.scan_previewView.preview_animationDuration = 3.2;
        [self.view addSubview:self.scan_previewView];
    }
    self.scan_defaultRect = YES;
    self.scan_showAuthorityAlert = YES;
    self.scan_alertController = [DDQAlertController alertControllerWithTitle:@"提示" message:@"" alertStyle:DDQAlertControllerStyleAlert];
    return self;
}

- (NSArray *)scan_supportTypes {
    
    if (!_scan_supportTypes) {
        _scan_supportTypes = @[AVMetadataObjectTypeQRCode];
    }
    return _scan_supportTypes;
}

#pragma mark - Camera Authority && Caputure Config
- (BOOL)scan_checkCameraAuthority {
    
    NSError *authorityError = [DDQFoundationController foundation_checkUserAuthorityWithType:DDQFoundationAuthorityCamera];
    
    if (authorityError) {
        
        DDQWeakObject(self);
        self.scan_block = dispatch_block_create(DISPATCH_BLOCK_BARRIER, ^{
            
            weakObjc.scan_alertController.alert_messageLabel.text = authorityError.domain;
            [weakObjc.scan_alertController alert_addAlertItem:^__kindof DDQAlertItem * _Nullable{
                
                DDQAlertItem *leftItem = [DDQAlertItem alertItemWithStyle:DDQAlertItemStyleDefault];
                leftItem.item_title = @"取消";
                return leftItem;
            } handler:^(DDQAlertItem * _Nonnull item) {
                
                [weakObjc.navigationController popViewControllerAnimated:YES];
            }];
            
            [weakObjc.scan_alertController alert_addAlertItem:^__kindof DDQAlertItem * _Nullable{
                
                DDQAlertItem *rightItem = [DDQAlertItem alertItemWithStyle:DDQAlertItemStyleDefault];
                rightItem.item_attrTitle = [[NSAttributedString alloc] initWithString:@"确定" attributes:@{NSForegroundColorAttributeName:[UIColor redColor], NSFontAttributeName:rightItem.item_font}];
                return rightItem;
            } handler:^(DDQAlertItem * _Nonnull item) {
                
                [DDQFoundationController foundation_gotoAppSystemSet];
            }];
            [weakObjc presentViewController:weakObjc.scan_alertController animated:YES completion:nil];
        });
        return NO;
    }
    return YES;
}

/**
 AVCapture配置
 */
- (void)scan_captureDeviceConfig {
    
    self.scan_captureSession = [[AVCaptureSession alloc] init];
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *inputError = nil;
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&inputError];
    AVCaptureMetadataOutput *captureOutput = [[AVCaptureMetadataOutput alloc] init];
    [captureOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    if ([self.scan_captureSession canAddInput:captureInput]) {
        [self.scan_captureSession addInput:captureInput];
    }
    
    if ([self.scan_captureSession canAddOutput:captureOutput]) {
        [self.scan_captureSession addOutput:captureOutput];
    }
    
    captureOutput.metadataObjectTypes = self.scan_supportTypes;
    
    AVCaptureVideoPreviewLayer *captureLayer =[AVCaptureVideoPreviewLayer layerWithSession:self.scan_captureSession];
    captureLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    captureLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:captureLayer atIndex:0];
    [self.scan_captureSession startRunning];
}

#pragma mark - Output Delegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    if (metadataObjects.count == 0) return;
    
    //不再捕获数据
    connection.enabled = NO;
    
    AVMetadataMachineReadableCodeObject *codeObject = metadataObjects.firstObject;
    NSString *codeValue = codeObject.stringValue;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(scan_getScanResult:)]) {
        [self.delegate scan_getScanResult:codeValue];
    }
    //可以查看 https://github.com/TUNER88/iOSSystemSoundsLibrary
    //    AudioServicesPlaySystemSound(4095);
}

@end

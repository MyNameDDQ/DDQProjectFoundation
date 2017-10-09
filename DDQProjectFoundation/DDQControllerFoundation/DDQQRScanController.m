//
//  DDQQRScanController.m
//
//  Created by 我叫咚咚枪 on 2017/10/7.
//

#import "DDQQRScanController.h"

#import "DDQQRScanPreviewView.h"
#import <AVFoundation/AVFoundation.h>

@interface DDQQRScanController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    id _systemActiveObserver;
}

@property (nonatomic, strong) AVCaptureSession *scan_captureSession;
@property (nonatomic, strong) DDQQRScanPreviewView *scan_previewView;
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

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    [self scan_startScan];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:YES];
    if (self.scan_block) dispatch_block_perform(DISPATCH_BLOCK_BARRIER, self.scan_block);
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
    
    self.scan_previewView = previewView;
    [self.view addSubview:previewView];
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
            
            UIAlertController *alerC = [UIAlertController alertControllerWithTitle:@"提示" message:authorityError.domain preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [weakObjc.navigationController popViewControllerAnimated:YES];
            }];
            UIAlertAction *acitonTwo = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [DDQFoundationController foundation_gotoAppSystemSet];
            }];
            [alerC addAction:actionOne];
            [alerC addAction:acitonTwo];
            alerC.view.tintColor = [UIColor blackColor];
            [weakObjc presentViewController:alerC animated:YES completion:nil];
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

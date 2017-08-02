//
//  DDQFoundationController.m
//
//  Copyright © 2017年 DDQ. All rights reserved.

#import "DDQFoundationController.h"

#import <MJRefresh/MJRefresh.h>

#import <objc/runtime.h>

#import <Photos/Photos.h>
#import <HealthKit/HealthKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface DDQFoundationController ()<UIGestureRecognizerDelegate> {
    
    AFNetworkReachabilityManager *_reachabilityManager;
}

@property (nonatomic, copy) NSDictionary *httpField;

@end

@implementation DDQFoundationController

DDQFoundationRequestFailureKey const DDQFoundationRequestFailureDesc = @"com.ddq.foundation.errorDesc";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //view的一些设置
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
}

#pragma mark - Base Method
- (UIButton *)setLeftBarButtonItemStyle:(DDQFoundationBarButtonStyle)style Content:(id)content {
    
    UIBarButtonItem *leftItem = nil;
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //内容类型判断
    if (style == DDQFoundationBarButtonText) {
        
        [customButton setTitle:(NSString *)content forState:UIControlStateNormal];
        leftItem = [[UIBarButtonItem alloc] initWithCustomView:customButton];
    } else {
        
        [customButton setBackgroundImage:(UIImage *)content forState:UIControlStateNormal];
        leftItem = [[UIBarButtonItem alloc] initWithCustomView:customButton];
    }
    
    //设置leftItem
    NSMutableArray *itemArray = self.navigationItem.leftBarButtonItems.mutableCopy;
    if (!itemArray) {
        itemArray = [NSMutableArray array];
    }
    [itemArray addObject:leftItem];
    [self.navigationItem setLeftBarButtonItems:itemArray.copy animated:YES];
    
    
    return customButton;
}

- (UIButton *)setRightBarButtonItemStyle:(DDQFoundationBarButtonStyle)style Content:(id)content {
    
    UIBarButtonItem *rightItem = nil;
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //内容类型判断
    if (style == DDQFoundationBarButtonText) {
        
        [customButton setTitle:(NSString *)content forState:UIControlStateNormal];
        rightItem = [[UIBarButtonItem alloc] initWithCustomView:customButton];
    } else {
        
        [customButton setBackgroundImage:(UIImage *)content forState:UIControlStateNormal];
        rightItem = [[UIBarButtonItem alloc] initWithCustomView:customButton];
    }
    
    //设置rightItem
    NSMutableArray *itemArray = self.navigationItem.rightBarButtonItems.mutableCopy;
    if (!itemArray) {
        itemArray = [NSMutableArray array];
    }
    
    if (itemArray.count >= 1) {//已经有了一个item了
        
        //那么设置一个占位的item，分开点距离
        UIView *placeholderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)];
        UIBarButtonItem *placeholderItem = [[UIBarButtonItem alloc] initWithCustomView:placeholderView];
        [itemArray addObject:placeholderItem];
    }
    [itemArray addObject:rightItem];
    [self.navigationItem setRightBarButtonItems:itemArray.copy animated:YES];
    
    return customButton;
}
@end

@implementation DDQFoundationController (DDQFoundationRefreshConfig)

+ (MJRefreshHeader *)foundation_setHeaderWithView:(__kindof UIScrollView *)scrollView Stlye:(DDQFoundationHeaderStyle)style Handle:(void (^)())handle {
    
    Class headerClass;
    switch (style) {
            
        case DDQFoundationHeaderStyleNormal:{
            headerClass = [MJRefreshNormalHeader class];
        }break;
            
        case DDQFoundationHeaderStyleGif:{
            headerClass = [MJRefreshGifHeader class];
        }break;
            
        case DDQFoundationHeaderStyleState:{
            headerClass = [MJRefreshStateHeader class];
        }break;
            
        default:
            break;
    }
    scrollView.mj_header = [headerClass headerWithRefreshingBlock:^{
        
        if (handle) {
            handle();
        }
    }];
    return scrollView.mj_header;
}

+ (MJRefreshFooter *)foundation_setFooterWithView:(__kindof UIScrollView *)scrollView Stlye:(DDQFoundationFooterStyle)style Handle:(void (^)())handle {
    
    Class footerClass;
    switch (style) {
            
        case DDQFoundationFooterStyleAutoGif:{
            footerClass = [MJRefreshAutoGifFooter class];
        }break;
            
        case DDQFoundationFooterStyleAutoState:{
            footerClass = [MJRefreshAutoStateFooter class];
        }break;
            
        case DDQFoundationFooterStyleAutoNormal:{
            footerClass = [MJRefreshAutoNormalFooter class];
        }break;
            
        case DDQFoundationFooterStyleBackGif:{
            footerClass = [MJRefreshBackGifFooter class];
        }break;
            
        case DDQFoundationFooterStyleBackState:{
            footerClass = [MJRefreshBackStateFooter class];
        }break;
            
        case DDQFoundationFooterStyleBackNormal:{
            footerClass = [MJRefreshBackNormalFooter class];
        }break;
            
        default:
            break;
    }
    scrollView.mj_footer = [footerClass footerWithRefreshingBlock:^{
        
        if (handle) {
            handle();
        }
    }];
    return scrollView.mj_footer;
}
@end

@implementation UIScrollView (DDQFoundationRefreshHandle)

- (void)foundation_endRefreshing {
    
    if (self.mj_header.state == MJRefreshStateRefreshing) {
        
        [self.mj_header endRefreshing];
    }
    
    if (self.mj_footer.state == MJRefreshStateRefreshing) {
        
        [self.mj_footer endRefreshing];
    }
}

- (void)foundation_endNoMoreData {
    
    [self.mj_footer endRefreshingWithNoMoreData];
}

- (void)foundation_endRestNoMoreData {
    
    [self.mj_footer resetNoMoreData];
}
@end

@implementation DDQFoundationController (DDQFoundationNetRequest)

static const char *response = "com.ddq.netResponse";
- (void)setFoundation_jsonResponse:(BOOL)foundation_jsonResponse {
    objc_setAssociatedObject(self, response, @(foundation_jsonResponse), OBJC_ASSOCIATION_RETAIN);
}

- (BOOL)foundation_jsonResponse {
    
    NSNumber *number = objc_getAssociatedObject(self, response);
    if (number) {
        return number.boolValue;
    } else {
        return NO;
    }
}

- (void)setFoundation_reachability:(AFNetworkReachabilityManager *)foundation_reachability {
    
    _reachabilityManager = foundation_reachability;
}

- (AFNetworkReachabilityManager *)foundation_reachability {
    
    if (!_reachabilityManager) {
        _reachabilityManager = [AFNetworkReachabilityManager sharedManager];
        [_reachabilityManager startMonitoring];
    }
    return _reachabilityManager;
}

- (void)foundation_setHttpField:(NSDictionary *)field {
    
    self.httpField = field;
}

- (void)foundation_checkUserNetStatus:(void (^)(AFNetworkReachabilityStatus, AFNetworkReachabilityManager * _Nonnull))result {
    
    AFNetworkReachabilityManager *reachbility = [AFNetworkReachabilityManager sharedManager];
    [reachbility startMonitoring];
    
    if (result) {
        result(reachbility.networkReachabilityStatus, reachbility);
        [reachbility stopMonitoring];
    }
}

- (void)foundation_checkUserNetChange:(void (^)(AFNetworkReachabilityStatus, AFNetworkReachabilityManager * _Nonnull))result {
    
    AFNetworkReachabilityManager *reachbility = [AFNetworkReachabilityManager sharedManager];
    [reachbility startMonitoring];
    
    DDQWeakObject(reachbility);
    [reachbility setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (result) {
            result(status, weakObjc);
        }
    }];
}

- (void)foundation_GETRequestWithUrl:(NSString *)url Param:(nullable NSDictionary<NSString *,NSString *> *)param Success:(void (^)(id _Nullable))success Failure:(void (^)(NSDictionary<DDQFoundationRequestFailureKey,NSString *> * _Nonnull))failure {
    
    AFHTTPSessionManager *sessionManager = [self foundation_sessionManagerConfig];
    
    [sessionManager GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success([self foundation_handleResponseObject:responseObject]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure([self foundation_handleRequestError:error]);
    }];
}

- (void)foundation_POSTRequestWithUrl:(NSString *)url Param:(nullable NSDictionary<NSString *,NSString *> *)param Success:(void (^)(id _Nullable))success Failure:(void (^)(NSDictionary<DDQFoundationRequestFailureKey,NSString *> * _Nonnull))failure {
    
    AFHTTPSessionManager *sessionManager = [self foundation_sessionManagerConfig];
    
    [sessionManager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success([self foundation_handleResponseObject:responseObject]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure([self foundation_handleRequestError:error]);
    }];
}

- (void)foundation_UploadRequestWithUrl:(NSString *)url Param:(nullable NSDictionary<NSString *,NSString *> *)param Images:(NSDictionary<NSString *,UIImage *> *)images Success:(void (^)(id _Nullable))success Progress:(void (^)(NSProgress * _Nonnull))progress Failure:(void (^)(NSDictionary<DDQFoundationRequestFailureKey,NSString *> * _Nonnull))failure {
    
    AFHTTPSessionManager *sessionManager = [self foundation_sessionManagerConfig];
    
    [sessionManager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (NSString *key in images.allKeys) {
            if (UIImageJPEGRepresentation(images[key], 1.0)) {
                [formData appendPartWithFormData:UIImageJPEGRepresentation(images[key], 1.0) name:key];
            } else {
                [formData appendPartWithFormData:UIImagePNGRepresentation(images[key]) name:key];
            }
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (![NSThread isMainThread]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                progress(uploadProgress);
            });
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success([self foundation_handleResponseObject:responseObject]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure([self foundation_handleRequestError:error]);
    }];
}

- (void)foundation_UploadBase64StringWithUrl:(NSString *)url Param:(NSDictionary<NSString *,NSString *> *)param Success:(void (^)(id _Nullable))success Progress:(void (^)(double))progress Failure:(void (^)(NSDictionary<DDQFoundationRequestFailureKey,NSString *> * _Nonnull))failure {
    
    AFHTTPSessionManager *sessionManager = [self foundation_sessionManagerConfig];
    [sessionManager POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (![NSThread isMainThread]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                progress(uploadProgress.fractionCompleted);
            });
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success([self foundation_handleResponseObject:responseObject]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure([self foundation_handleRequestError:error]);
    }];
}

/**
 处理请求错误
 
 @param error CocoaRequest Error
 @return 错误描述
 */
- (NSDictionary<DDQFoundationRequestFailureKey, NSString *> *)foundation_handleRequestError:(NSError *)error {
    
    NSMutableDictionary *errorDic = [NSMutableDictionary dictionary];
    
    //判断系统错误码
    switch (error.code) {
            
        case NSURLErrorTimedOut:{
            [errorDic setValue:@"请求超时" forKey:DDQFoundationRequestFailureDesc];
        }break;
            
        case NSURLErrorBadURL | NSURLErrorUnsupportedURL:{
            [errorDic setValue:@"错误的请求地址" forKey:DDQFoundationRequestFailureDesc];
        }break;
            
        case NSURLErrorNotConnectedToInternet:{
            [errorDic setValue:@"当前无网络连接" forKey:DDQFoundationRequestFailureDesc];
        }break;
            
        default:
            break;
    }
    
    //若不是上述几种情况，则把系统描述返回
    if (errorDic.count == 0) {
        [errorDic setValue:error.localizedDescription forKey:DDQFoundationRequestFailureDesc];
    }
    return errorDic.copy;
}

/**
 设置SessionManager
 */
- (AFHTTPSessionManager *)foundation_sessionManagerConfig {
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    
    AFHTTPRequestSerializer *reqSer = nil;
    if (!self.foundation_jsonResponse) {
        reqSer = [AFHTTPRequestSerializer serializer];
    } else {
        reqSer = [AFJSONRequestSerializer serializer];
    }
    reqSer.timeoutInterval = 15.0;
    for (NSString *key in self.httpField.allKeys) {
        
        [reqSer setValue:self.httpField[key] forHTTPHeaderField:key];
    }
    reqSer.networkServiceType = NSURLNetworkServiceTypeDefault;
    
    AFHTTPResponseSerializer *resSer = nil;
    if (!self.foundation_jsonResponse) {
        resSer = [AFHTTPResponseSerializer serializer];
    } else {
        resSer = [AFJSONResponseSerializer serializer];
    }
    resSer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    sessionManager.requestSerializer = reqSer;
    sessionManager.responseSerializer = resSer;
    
    return sessionManager;
}

/**
 返回值类型判断
 */
- (id)foundation_handleResponseObject:(id)object {
    
    if ([object isKindOfClass:[NSData class]]) {
        
        id json = [NSJSONSerialization JSONObjectWithData:object options:NSJSONReadingMutableContainers error:nil];
        return json;
    }
    return object;
}
@end

@implementation DDQFoundationController (DDQFoundationUserInterface)

static const char *HUDKey = "com.ddq.foundation.defaultHUD";

- (void)setFoundation_hud:(MBProgressHUD *)foundation_hud {
    
    objc_setAssociatedObject(self, HUDKey, foundation_hud, OBJC_ASSOCIATION_RETAIN);
}

- (MBProgressHUD *)foundation_hud {
    
    MBProgressHUD *hud = objc_getAssociatedObject(self, HUDKey);
    if (hud) {
        
        [self.view bringSubviewToFront:hud];
        return hud;
    } else {
        
        UIView *hudSuperView = nil;
        if ([self respondsToSelector:@selector(foundation_HUDSuperView)]) {
            hudSuperView = [self performSelector:@selector(foundation_HUDSuperView)];
        } else {
            hudSuperView = self.view;
        }
        
        hud = [MBProgressHUD HUDForView:hudSuperView];
        
        if (hud) {
            
            [hudSuperView bringSubviewToFront:hud];
            return hud;
        }
        hud = [[MBProgressHUD alloc] initWithView:hudSuperView];
        [hudSuperView addSubview:hud];
        hud.label.text = @"请稍候...";
        return hud;
    }
}

- (void)alertHUDWithText:(NSString *)text Delegate:(id<MBProgressHUDDelegate>)delegate {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = text;
    hud.mode = MBProgressHUDModeText;
    hud.delegate = delegate;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:1.0];
}

- (MBProgressHUD *)alertHUDWithMode:(MBProgressHUDMode)mode Text:(nullable NSString *)text Delegate:(id<MBProgressHUDDelegate>)delegate {
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    
    hud.mode = mode;
    hud.label.text = text;
    hud.delegate = delegate;
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}
@end

@implementation DDQFoundationController (DDQFoundationUserAuthority)

+ (NSError *)foundation_checkUserAuthorityWithType:(DDQFoundationAuthorityType)type {
    
    NSError *error = nil;
    if (type == DDQFoundationAuthorityCamera) {
        
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            error = [NSError errorWithDomain:@"该设备没有摄像头" code:DDQFoundationErrorNoCamera userInfo:nil];
            return error;
        }
        
        if (![UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear | UIImagePickerControllerCameraDeviceFront]) {//前后摄像头是否能用
            
            error = [NSError errorWithDomain:@"您的摄像头不可用" code:DDQFoundationErrorNoCamera userInfo:nil];
            return error;
        }
        
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied) {//是否让用
            
            error = [NSError errorWithDomain:@"暂无摄像头权限" code:DDQFoundationErrorCameraNotUse userInfo:nil];
            return error;
        }
        return error;
    } else if (type == DDQFoundationAuthorityHealth) {
        
        if ([HKHealthStore isHealthDataAvailable]) {
            
            error = [NSError errorWithDomain:@"该设备不支持访问健康" code:DDQFoundationErrorNoCamera userInfo:nil];
            return error;
        }
        return error;
    } else if (type == DDQFoundationAuthorityPhotoLibary) {
        
#if (__IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_9_0)
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
            
            error = [NSError errorWithDomain:@"无法访问您的相册" code:DDQFoundationErrorNoCamera userInfo:nil];
            return error;
        }
        
#else
        ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
        
        if (status == ALAuthorizationStatusRestricted || status == ALAuthorizationStatusDenied) {
            
            error = [NSError errorWithDomain:@"无法访问您的相册" code:DDQFoundationErrorNoCamera userInfo:nil];
            return error;
        }
#endif
    }
    //2017-7-12 部分权限判断未实现
    return error;
}

+ (void)foundation_gotoAppSystemSet {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    
}
@end

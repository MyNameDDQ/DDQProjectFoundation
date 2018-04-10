//
//  DDQFoundationController.m
//
//  Copyright © 2017年 DDQ. All rights reserved.

#import "DDQFoundationController.h"

#import <objc/runtime.h>

#import <Photos/Photos.h>
#import <HealthKit/HealthKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "DDQAlertController.h"

@interface DDQFoundationController ()<UIGestureRecognizerDelegate>

@property (nonatomic, copy) NSDictionary *httpField;
@property (nonatomic, assign) BOOL json;
@end

@implementation DDQFoundationController

DDQFoundationRequestFailureKey const DDQFoundationRequestFailureDesc = @"com.ddq.foundation.errorDesc";

#pragma mark - Base Method
- (UIButton *)setLeftBarButtonItemStyle:(DDQFoundationBarButtonStyle)style Content:(id)content {
    
    UIBarButtonItem *leftItem = nil;
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //内容类型判断
    if (style == DDQFoundationBarButtonText) {
        
        NSAssert([content isKindOfClass:[NSString class]], @"内容的类型和按钮Style不符");
        [customButton setTitle:(NSString *)content forState:UIControlStateNormal];
        leftItem = [[UIBarButtonItem alloc] initWithCustomView:customButton];
    } else {
        
        NSAssert([content isKindOfClass:[UIImage class]], @"内容的类型和按钮Style不符");
        [customButton setImage:(UIImage *)content forState:UIControlStateNormal];
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
        
        NSAssert([content isKindOfClass:[NSString class]], @"内容的类型和按钮Style不符");
        [customButton setTitle:(NSString *)content forState:UIControlStateNormal];
        rightItem = [[UIBarButtonItem alloc] initWithCustomView:customButton];
    } else {
        
        NSAssert([content isKindOfClass:[UIImage class]], @"内容的类型和按钮Style不符");
        [customButton setImage:(UIImage *)content forState:UIControlStateNormal];
        rightItem = [[UIBarButtonItem alloc] initWithCustomView:customButton];
    }
    
    [customButton sizeToFit];
    
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

- (void)foundation_setLeftBackItemFrame:(CGRect)frame Style:(DDQFoundationBarButtonStyle)style Content:(id)content Selector:(SEL)sel {

    UIButton *button = [self setLeftBarButtonItemStyle:style Content:content];
    button.frame = frame;
    if (sel) {
        [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    } else {
        [button addTarget:self action:@selector(foundation_leftItemSelectedWithCustomButton:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)foundation_leftItemSelectedWithCustomButton:(UIButton *)button {

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)foundation_setRightItemFrame:(CGRect)frame Style:(DDQFoundationBarButtonStyle)style Content:(id)content Selector:(SEL)sel {

    UIButton *button = [self setRightBarButtonItemStyle:style Content:content];
    button.frame = frame;
    [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
}

- (void)foundation_setRightItemWithStyle:(DDQFoundationBarButtonStyle)style Content:(id)content Selector:(SEL)sel {
    
    UIButton *button = [self setRightBarButtonItemStyle:style Content:content];
    [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
}

- (UIModalPresentationStyle)modalPresentationStyle {
    return UIModalPresentationOverFullScreen;
}
@end

@implementation DDQFoundationController (DDQFoundationRefreshConfig)

+ (MJRefreshHeader *)foundation_setHeaderWithView:(__kindof UIScrollView *)scrollView Stlye:(DDQFoundationHeaderStyle)style Handle:(void (^)(void))handle {
    
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

+ (MJRefreshFooter *)foundation_setFooterWithView:(__kindof UIScrollView *)scrollView Stlye:(DDQFoundationFooterStyle)style Handle:(void (^)(void))handle {
    
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

- (void)setFoundation_jsonResponse:(BOOL)foundation_jsonResponse {

    self.json = foundation_jsonResponse;
}

- (BOOL)foundation_jsonResponse {

    return self.json;
}

- (void)foundation_setHttpField:(NSDictionary *)field {
    
    self.httpField = field;
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

- (void)foundation_GETRequestWithUrl:(NSString *)url Param:(NSDictionary<NSString *,NSString *> *)param Success:(DDQRequestSuccess)success Failure:(DDQRequestFailure)failure {
    
    [self foundation_requestWithMethod:@"GET" url:url param:param success:success failure:failure];
}

- (void)foundation_POSTRequestWithUrl:(NSString *)url Param:(NSDictionary<NSString *,NSString *> *)param Success:(DDQRequestSuccess)success Failure:(DDQRequestSuccess)failure {
    
    [self foundation_requestWithMethod:@"POST" url:url param:param success:success failure:failure];
}

- (void)foundation_requestWithMethod:(NSString *)method url:(NSString *)url param:(nullable NSDictionary<NSString *,NSString *> *)param success:(DDQRequestSuccess)success failure:(DDQRequestFailure)failure {
    
    AFHTTPSessionManager *sessionManager = [self foundation_sessionManagerConfig];

    if ([method isEqualToString:@"POST"]) {
        
        [sessionManager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            success([self foundation_handleResponseObject:responseObject]);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure([self foundation_handleRequestError:error]);
        }];
    } else {
        
        [sessionManager GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            success([self foundation_handleResponseObject:responseObject]);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure([self foundation_handleRequestError:error]);
        }];
    }
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

@implementation DDQFoundationController (DDQFoundationRequestHandle)

#pragma mark - GET Request
- (void)foundation_processNetGETRequestWithUrl:(NSString *)url Param:(NSDictionary *)param WhenHUDHidden:(DDQFoundationRequestHandle)handle {
    
    [self foundation_processNetGETRequestWithUrl:url Param:param WhenHUDHidden:handle AfterAlert:nil];
}

- (void)foundation_processNetGETRequestWithUrl:(NSString *)url Param:(NSDictionary *)param WhenHUDHidden:(DDQFoundationRequestHandle)handle AfterAlert:(DDQFoundationRequestAlertHandle)alert {

    [self foundation_processNetGETRequestWithUrl:url Param:param WaitHud:nil ShowHud:YES WhenHUDHidden:handle AfterAlert:alert];
}

- (void)foundation_processNetGETRequestWithUrl:(NSString *)url Param:(NSDictionary *)param WaitHud:(DDQFoundationRequestHUDHandle)hud ShowHud:(BOOL)show WhenHUDHidden:(DDQFoundationRequestHandle)handle AfterAlert:(DDQFoundationRequestAlertHandle)alert {
    
    [self foundation_processRequestWithMethod:@"GET" url:url param:param waitHud:hud showHud:show whenHUDHidden:handle afterAlert:alert];
}

#pragma mark - POST Request
- (void)foundation_processNetPOSTRequestWithUrl:(NSString *)url Param:(NSDictionary *)param WhenHUDHidden:(DDQFoundationRequestHandle)handle {
    
    [self foundation_processNetPOSTRequestWithUrl:url Param:param WhenHUDHidden:handle AfterAlert:nil];
}

- (void)foundation_processNetPOSTRequestWithUrl:(NSString *)url Param:(NSDictionary *)param WhenHUDHidden:(DDQFoundationRequestHandle)handle AfterAlert:(DDQFoundationRequestAlertHandle)alert {

    [self foundation_processNetPOSTRequestWithUrl:url Param:param WaitHud:nil ShowHud:YES WhenHUDHidden:handle AfterAlert:alert];
}

- (void)foundation_processNetPOSTRequestWithUrl:(NSString *)url Param:(NSDictionary *)param WaitHud:(DDQFoundationRequestHUDHandle)hud ShowHud:(BOOL)show WhenHUDHidden:(DDQFoundationRequestHandle)handle AfterAlert:(DDQFoundationRequestAlertHandle)alert {
    
    [self foundation_processRequestWithMethod:@"POST" url:url param:param waitHud:hud showHud:show whenHUDHidden:handle afterAlert:alert];
}

#pragma mark - Public Method
/**
 集中处理不同请求方式的结果
 */
- (void)foundation_processRequestWithMethod:(NSString *)method url:(NSString *)url param:(NSDictionary *)param waitHud:(DDQFoundationRequestHUDHandle)hud showHud:(BOOL)show whenHUDHidden:(DDQFoundationRequestHandle)handle afterAlert:(DDQFoundationRequestAlertHandle)alert  {
    
    MBProgressHUD *waitHud;
    //是否允许显示等待的HUD
    if (show) {
        
        //是否设置了自定义的HUD
        if (hud) {
            waitHud = hud();
        }
        //自定义的HUD是否为空
        if (!waitHud) {
            waitHud = [MBProgressHUD showHUDAddedTo:[self foundation_getHUDSuperView] animated:YES];
            waitHud.label.text = [self foundation_getHUDText];
            waitHud.mode = [self foundation_getHUDMode];
        }
    }
    
    DDQWeakObject(self);
    [self foundation_requestWithMethod:method url:url param:param success:^(id  _Nullable result) {
        
        int netCode = [result[@"result"] intValue];
        NSString *netMessage = result[@"message"];
        if (handle) {
            
            BOOL isShow = handle(result, netCode);//数据处理完成
            if (isShow) {
                
                [weakObjc foundation_handleRequestedWithHud:waitHud message:netMessage code:netCode hidden:YES alertHandler:alert];
            } else {
                [waitHud hideAnimated:YES afterDelay:[weakObjc foundation_getWaitHUDHiddenTime]];
            }
        }
        
    } failure:^(NSDictionary<DDQFoundationRequestFailureKey,NSString *> * _Nonnull errDic) {
        
        if (handle) {
            
            BOOL isShow = handle(nil, DDQFoundationRequestFailure);//数据处理完成
            if (isShow) {
                
                [weakObjc foundation_handleRequestedWithHud:waitHud message:errDic[DDQFoundationRequestFailureDesc] code:DDQFoundationRequestFailure hidden:YES alertHandler:alert];
            } else {
                [waitHud hideAnimated:YES afterDelay:[weakObjc foundation_getWaitHUDHiddenTime]];
            }
        }
    }];
}

/**
 集中处理hud的显示和显示后的操作
 */
- (void)foundation_handleRequestedWithHud:(MBProgressHUD *)hud message:(NSString *)message code:(int)code hidden:(BOOL)hidden alertHandler:(DDQFoundationRequestAlertHandle)alert {
    
    DDQWeakObject(self);
    if (hud) {
        
        hud.completionBlock = ^{
            
            MBProgressHUD *alertHUD = [MBProgressHUD showHUDAddedTo:[weakObjc foundation_getHUDSuperView] animated:YES];
            alertHUD.label.text = message;
            alertHUD.mode = MBProgressHUDModeText;
            alertHUD.removeFromSuperViewOnHide = YES;
            
            [alertHUD hideAnimated:YES afterDelay:[weakObjc foundation_getAlertHUDHiddenTime]];
            alertHUD.completionBlock = ^{
                
                if (alert) {
                    weakObjc.foundation_hud.completionBlock = nil;
                    alert(code);
                }
            };
        };
        if (hidden) {
            [hud hideAnimated:YES afterDelay:[self foundation_getWaitHUDHiddenTime]];
        }
    } else {
        
        MBProgressHUD *alertHUD = [MBProgressHUD showHUDAddedTo:[weakObjc foundation_getHUDSuperView] animated:YES];
        alertHUD.label.text = message;
        alertHUD.mode = MBProgressHUDModeText;
        alertHUD.removeFromSuperViewOnHide = YES;
        
        [alertHUD hideAnimated:YES afterDelay:[weakObjc foundation_getAlertHUDHiddenTime]];
        alertHUD.completionBlock = ^{
            
            if (alert) {
                weakObjc.foundation_hud.completionBlock = nil;
                alert(DDQFoundationRequestFailure);
            }
        };
    }
}

/** 获取HUD的父视图 */
- (UIView *)foundation_getHUDSuperView {
    
    UIView *superView = nil;
    if ([self respondsToSelector:@selector(foundation_HUDSuperView)]) {
        superView = [self performSelector:@selector(foundation_HUDSuperView)];
    } else {
        superView = self.view;
    }
    return superView;
}

/** 获取AlertHUD隐藏时间 */
- (float)foundation_getAlertHUDHiddenTime {
    
    float time = 1.2;
    if ([self respondsToSelector:@selector(foundation_alertHUDHiddenAfterDelay)]) {
        time = [[self performSelector:@selector(foundation_alertHUDHiddenAfterDelay)] floatValue];
    }
    return time;
}

/** 获取WaitHUD隐藏时间 */
- (float)foundation_getWaitHUDHiddenTime {
 
    float time = 0.2;
    if ([self respondsToSelector:@selector(foundation_waitHUDHiddenAfterDelay)]) {
        time = [[self performSelector:@selector(foundation_waitHUDHiddenAfterDelay)] floatValue];
    }
    return time;
}

/** 获取HUD显示的文字 */
- (NSString *)foundation_getHUDText {
    
    NSString *text = @"请稍候...";
    if ([self respondsToSelector:@selector(foundation_showHUDText)]) {
        text = [self performSelector:@selector(foundation_showHUDText)];
    }
    return text;
}

/** 获取HUD显示的类型 */
- (MBProgressHUDMode)foundation_getHUDMode {
    
    MBProgressHUDMode mode = MBProgressHUDModeIndeterminate;
    if ([self respondsToSelector:@selector(foundation_showHUDMode)]) {
        mode = [[self performSelector:@selector(foundation_showHUDMode)] integerValue];
    }
    return mode;
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
            
            error = [NSError errorWithDomain:@"该设备不支持访问健康" code:DDQFoundationErrorHealthKitNotUse userInfo:nil];
            return error;
        }
        return error;
    } else if (type == DDQFoundationAuthorityPhotoLibary) {
        
#if (__IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_8_0)
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
            
            error = [NSError errorWithDomain:@"无法访问您的相册" code:DDQFoundationErrorPhotoLibaryNotUse userInfo:nil];
            return error;
        }
        
#else
        ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
        
        if (status == ALAuthorizationStatusRestricted || status == ALAuthorizationStatusDenied) {
            
            error = [NSError errorWithDomain:@"无法访问您的相册" code:DDQFoundationErrorPhotoLibaryNotUse userInfo:nil];
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

@implementation DDQFoundationController (DDQFoundationCheckContent)

- (BOOL)foundation_checkPhone:(NSString *)phone {
    
    BOOL isPhone = NO;
    if (phone.length != 11) {
        return isPhone;
    }
    
    NSString *rexStr = @"[1][3578]\\d{9}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", rexStr];
    isPhone = [predicate evaluateWithObject:phone];
    return isPhone;
}

- (BOOL)foundation_checkEmail:(NSString *)mail {
    
    BOOL isEmail = NO;
    
    NSString *rexStr = @"^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", rexStr];
    isEmail = [predicate evaluateWithObject:mail];
    return isEmail;
}

- (BOOL)foundation_checkMessageCode:(NSString *)code {
    
    NSScanner *scanner = [[NSScanner alloc] initWithString:code];
    int value;
    BOOL isInt = [scanner scanInt:&value];
    return isInt && [scanner isAtEnd];
}

- (BOOL)foundation_checkIntWithString:(NSString *)intString {
    
    NSScanner *scanner = [[NSScanner alloc] initWithString:intString];
    int value;
    BOOL isInt = [scanner scanInt:&value];
    return isInt && [scanner isAtEnd];
}

- (BOOL)foundation_checkFloatWithString:(NSString *)floatString {
    
    NSScanner *scanner = [[NSScanner alloc] initWithString:floatString];
    float value;
    BOOL isFloat = [scanner scanFloat:&value];
    return isFloat && [scanner isAtEnd];
}

@end

@implementation DDQFoundationController (DDQFoundationTool)

- (NSString *)foundation_getCurrentDateWithFormat:(NSString *)format date:(NSDate *)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    
    return [formatter stringFromDate:date];
}

- (UIImage *)foundation_compressionImageWithImage:(UIImage *)image Scale:(float)scale {
    
    //图片压缩
    CGSize imageSize = CGSizeMake(image.size.width * 0.5, image.size.height * 0.5);
    UIGraphicsBeginImageContext(imageSize);
    CGRect imageRect = CGRectMake(0.0, 0.0, imageSize.width, imageSize.height);
    [image drawInRect:imageRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end

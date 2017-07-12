//
//  DDQFoundationController.m
//
//  Copyright © 2017年 DDQ. All rights reserved.

#import "DDQFoundationController.h"

#import <AFNetworking/AFNetworking.h>
#import <MJRefresh/MJRefresh.h>

#import <objc/runtime.h>

#import <AVFoundation/AVFoundation.h>
#import <HealthKit/HealthKit.h>

@interface DDQFoundationController ()

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
    
    //设置leftItem
    NSMutableArray *itemArray = self.navigationItem.rightBarButtonItems.mutableCopy;
    if (!itemArray) {
        itemArray = [NSMutableArray array];
    }
    [itemArray addObject:rightItem];
    [self.navigationItem setRightBarButtonItems:itemArray.copy animated:YES];
    
    return customButton;
}
@end

@implementation DDQFoundationController (DDQFoundationRefreshConfig)

- (MJRefreshHeader *)foundation_setHeaderWithView:(__kindof UIScrollView *)scrollView Stlye:(DDQFoundationHeaderStyle)style Handle:(void (^)())handle {
    
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

- (MJRefreshFooter *)foundation_setFooterWithView:(__kindof UIScrollView *)scrollView Stlye:(DDQFoundationFooterStyle)style Handle:(void (^)())handle {
    
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

- (void)foundation_GETRequestWithUrl:(NSString *)url Param:(NSDictionary<NSString *,NSString *> *)param Success:(void (^)(id _Nullable))success Failure:(void (^)(NSDictionary<DDQFoundationRequestFailureKey,NSString *> * _Nonnull))failure {
    
    AFHTTPSessionManager *sessionManager = [self foundation_sessionManagerConfig];
    
    [sessionManager GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success([self foundation_handleResponseObject:responseObject]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure([self foundation_handleRequestError:error]);
    }];
}

- (void)foundation_POSTRequestWithUrl:(NSString *)url Param:(NSDictionary<NSString *,NSString *> *)param Success:(void (^)(id _Nullable))success Failure:(void (^)(NSDictionary<DDQFoundationRequestFailureKey,NSString *> * _Nonnull))failure {
    
    AFHTTPSessionManager *sessionManager = [self foundation_sessionManagerConfig];
    
    [sessionManager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success([self foundation_handleResponseObject:responseObject]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure([self foundation_handleRequestError:error]);
    }];
}

- (void)foundation_UploadRequestWithUrl:(NSString *)url Param:(NSDictionary<NSString *,NSString *> *)param Images:(NSDictionary<NSString *,UIImage *> *)images Success:(void (^)(id _Nullable))success Progress:(void (^)(NSProgress * _Nonnull))progress Failure:(void (^)(NSDictionary<DDQFoundationRequestFailureKey,NSString *> * _Nonnull))failure {
    
    AFHTTPSessionManager *sessionManager = [self foundation_sessionManagerConfig];
    
    [sessionManager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (NSString *key in images.allKeys) {
            [formData appendPartWithFormData:UIImageJPEGRepresentation(images[key], 1.0) name:key];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progress(uploadProgress);
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
    
    AFHTTPRequestSerializer *reqSer = [AFHTTPRequestSerializer serializer];
    reqSer.timeoutInterval = 15.0;
    
    AFHTTPResponseSerializer *resSer = [AFHTTPResponseSerializer serializer];
    resSer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
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
    
        hud = [MBProgressHUD HUDForView:self.view];
        
        if (hud) {
            
            [self.view bringSubviewToFront:hud];
            return hud;
        }
        hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:hud];
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

- (MBProgressHUD *)alertHUDWithMode:(MBProgressHUDMode)mode Text:(NSString *)text Delegate:(id<MBProgressHUDDelegate>)delegate {
    
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
        
        if ([UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera]) {
            
            error = [NSError errorWithDomain:@"该设备没有摄像头" code:DDQFoundationErrorNoCamera userInfo:nil];
            return error;
        }
        
        if ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] != AVAuthorizationStatusAuthorized) {
            
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
    }
    //2017-7-12 部分权限判断未实现
    return error;
}

+ (void)foundation_gotoAppSystemSet {

    NSString *appDisplayName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"prefs:root=Apps&path=%@", appDisplayName]]];
}
@end

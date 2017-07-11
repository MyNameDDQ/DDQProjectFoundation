//
//  DDQFoundationController.m
//
//  Copyright © 2017年 DDQ. All rights reserved.

#import "DDQFoundationController.h"

#import <AFNetworking/AFNetworking.h>
#import <MJRefresh/MJRefresh.h>

@interface DDQFoundationController (){

    NSString *_navBarBackgroundImageName;
}

@end

@implementation DDQFoundationController

RequestFailureKey const RequestFailureDescKey = @"com.ddq.errorDesc";
ControllerNavBarContentKey const ControllerNavBarTitleKey = @"com.ddq.navBarTitle";
ControllerNavBarContentKey const ControllerNavBarAttrsKey = @"com.ddq.navBarAttrs";

static NSString *DDQFoundationArchiverURLPath = nil;
static NSString *DDQFoundationArchiverNavBGImagePath = nil;

+ (void)load {

    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    DDQFoundationArchiverURLPath = [cachePath stringByAppendingPathComponent:@"DDQBaseURL"];
    DDQFoundationArchiverNavBGImagePath = [cachePath stringByAppendingPathComponent:@"DDQNavBGName"];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //view的一些设置
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    //navbar的设置
    self.navigationController.navigationBar.translucent = NO;
    _navBarBackgroundImageName = [NSKeyedUnarchiver unarchiveObjectWithFile:DDQFoundationArchiverNavBGImagePath];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self.navigationController.navigationBar setBackgroundImage:kSetImage(_navBarBackgroundImageName) forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - Base Method
+ (instancetype)foundationController {
    
    return [[self alloc] init];
}

- (void)setFoundationNavAttrs:(NSDictionary<ControllerNavBarContentKey,id> *)foundationNavAttrs {
    
    _foundationNavAttrs = foundationNavAttrs;
    //标题有值
    if (foundationNavAttrs[ControllerNavBarTitleKey]) {
        self.navigationItem.title = foundationNavAttrs[ControllerNavBarTitleKey];
    }
    
    //attr有值
    if (foundationNavAttrs[ControllerNavBarAttrsKey]) {
        [self.navigationController.navigationBar setTitleTextAttributes:foundationNavAttrs[ControllerNavBarAttrsKey]];
    }
}

- (void)foundation_setBaseURL:(NSString *)url {

    [NSKeyedArchiver archiveRootObject:url toFile:DDQFoundationArchiverURLPath];
}

- (NSString *)foundationBaseURL {

    return [NSKeyedUnarchiver unarchiveObjectWithFile:DDQFoundationArchiverURLPath];
}

- (void)foundation_setNavigationBarBackgroundImageName:(NSString *)name {

    [NSKeyedArchiver archiveRootObject:name toFile:DDQFoundationArchiverNavBGImagePath];
}

- (MBProgressHUD *)foundationDefaultHUD {
    
    _foundationDefaultHUD = [MBProgressHUD HUDForView:self.view];
    //非空判断
    if (!_foundationDefaultHUD) {
        
        _foundationDefaultHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_foundationDefaultHUD];
    }
    
    //层级判断
    if (self.view.subviews.lastObject != _foundationDefaultHUD) {//最上层的不是hud，就把他移到最上层
        [self.view bringSubviewToFront:_foundationDefaultHUD];
    }
    return _foundationDefaultHUD;
}

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

#pragma mark - Custom Method
- (void)foundation_GETRequestWithUrl:(NSString *)url Param:(NSDictionary<NSString *,NSString *> *)param Success:(void (^)(id _Nullable))success Failure:(void (^)(NSDictionary<RequestFailureKey,NSString *> * _Nonnull))failure {
    
    AFHTTPSessionManager *sessionManager = [self foundation_sessionManagerConfig];
    
    [sessionManager GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success([self foundation_handleResponseObject:responseObject]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure([self foundation_handleRequestError:error]);
    }];
}

- (void)foundation_POSTRequestWithUrl:(NSString *)url Param:(NSDictionary<NSString *,NSString *> *)param Success:(void (^)(id _Nullable))success Failure:(void (^)(NSDictionary<RequestFailureKey,NSString *> * _Nonnull))failure {
    
    AFHTTPSessionManager *sessionManager = [self foundation_sessionManagerConfig];
    
    [sessionManager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success([self foundation_handleResponseObject:responseObject]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure([self foundation_handleRequestError:error]);
    }];
}

- (void)foundation_UploadRequestWithUrl:(NSString *)url Param:(NSDictionary<NSString *,NSString *> *)param Images:(NSDictionary<NSString *,UIImage *> *)images Success:(void (^)(id _Nullable))success Progress:(void (^)(NSProgress * _Nonnull))progress Failure:(void (^)(NSDictionary<RequestFailureKey,NSString *> * _Nonnull))failure {

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
- (NSDictionary<RequestFailureKey, NSString *> *)foundation_handleRequestError:(NSError *)error {

    NSMutableDictionary *errorDic = [NSMutableDictionary dictionary];
    
    //判断系统错误码
    switch (error.code) {
            
        case NSURLErrorTimedOut:{
            [errorDic setValue:@"请求超时" forKey:RequestFailureDescKey];
        }break;
            
        case NSURLErrorBadURL | NSURLErrorUnsupportedURL:{
            [errorDic setValue:@"错误的请求地址" forKey:RequestFailureDescKey];
        }break;
            
        case NSURLErrorNotConnectedToInternet:{
            [errorDic setValue:@"当前无网络连接" forKey:RequestFailureDescKey];
        }break;
            
        default:
            break;
    }
    
    //若不是上述几种情况，则把系统描述返回
    if (errorDic.count == 0) {
        [errorDic setValue:error.localizedDescription forKey:RequestFailureDescKey];
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

@implementation UIScrollView (DDQFoundationFreshStateHandle)

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

@implementation MBProgressHUD (DDQFoundationHUDShowHandle)

+ (void)alertHUDInView:(UIView *)view Text:(NSString *)text {

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:1.0];
}

+ (void)alertHUDInView:(UIView *)view Text:(NSString *)text Delegate:(id<MBProgressHUDDelegate>)delegate {

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    hud.mode = MBProgressHUDModeText;
    hud.delegate = delegate;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:1.0];
}

+ (instancetype)alertHUDInView:(UIView *)view Mode:(MBProgressHUDMode)mode Text:(NSString *)text Delegate:(id<MBProgressHUDDelegate>)delegate {

    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    
    hud.mode = mode;
    hud.label.text = text;
    hud.delegate = delegate;
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}

@end

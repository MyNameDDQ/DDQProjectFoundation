//
//  DDQFoundationController.m
//
//  Copyright © 2017年 DDQ. All rights reserved.

#import "DDQFoundationController.h"

#import <AFNetworking/AFNetworking.h>
#import <MJRefresh/MJRefresh.h>

@interface DDQFoundationController ()

@end

@implementation DDQFoundationController

RequestFailureKey const RequestFailureDescKey = @"com.ddq.errorDesc";
ControllerNavBarContentKey const ControllerNavBarTitleKey = @"com.ddq.navBarTitle";
ControllerNavBarContentKey const ControllerNavBarAttrsKey = @"com.ddq.navBarAttrs";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //view的一些设置
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    self.view.backgroundColor = [UIColor clearColor];
    
    //navbar的设置
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBackgroundImage:kSetImage(@"nav_barImage") forBarMetrics:UIBarMetricsDefault];
}

- (void)setFoundationNavAttrs:(NSDictionary<ControllerNavBarContentKey,id> *)foundationNavAttrs {
    
    NSAssert([foundationNavAttrs isKindOfClass:[NSDictionary class]], @"设置控制器的Nav需要是个字典");
    self.navigationItem.title = foundationNavAttrs[ControllerNavBarTitleKey];
    [self.navigationController.navigationBar setTitleTextAttributes:foundationNavAttrs[ControllerNavBarAttrsKey]];
}

- (void)setFoundationNavBarImage:(UIImage *)foundationNavBarImage {
    
    [self.navigationController.navigationBar setBackgroundImage:foundationNavBarImage forBarMetrics:UIBarMetricsDefault];
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
- (void)foundation_GETRequestWithUrl:(NSString *)url Param:(NSDictionary<NSString *,id> *)param Success:(void (^)(id))success Failure:(void (^)(NSDictionary<RequestFailureKey,NSString *> *))failure {
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    
    AFHTTPRequestSerializer *reqSer = [AFHTTPRequestSerializer serializer];
    reqSer.timeoutInterval = 15.0;
    
    AFHTTPResponseSerializer *resSer = [AFHTTPResponseSerializer serializer];
    resSer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    sessionManager.requestSerializer = reqSer;
    sessionManager.responseSerializer = resSer;
    
    [sessionManager GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
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
    }];
}

- (void)foundation_POSTRequestWithUrl:(NSString *)url Param:(NSDictionary<NSString *,id> *)param Success:(void (^)(id))success Failure:(void (^)(NSDictionary<RequestFailureKey,NSString *> *))failure {
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    
    AFHTTPRequestSerializer *reqSer = [AFHTTPRequestSerializer serializer];
    reqSer.timeoutInterval = 15.0;
    
    AFHTTPResponseSerializer *resSer = [AFHTTPResponseSerializer serializer];
    resSer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    sessionManager.requestSerializer = reqSer;
    sessionManager.responseSerializer = resSer;
    
    [sessionManager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
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
    }];
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

- (void)EndRefreshing {

    //头视图判断
    if (self.mj_header.state == MJRefreshStateRefreshing) {//头视图如果在刷新就暂停
        
        [self.mj_header endRefreshing];
    }
    
    //脚视图判断
    if (self.mj_footer.state == MJRefreshStateRefreshing) {//脚视图如果在刷新就暂停
        
        [self.mj_footer endRefreshing];
    }
}

- (void)EndNoMoreData {

    [self.mj_footer endRefreshingWithNoMoreData];
}

- (void)EndRestNoMoreData {

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

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = mode;
    hud.label.text = text;
    hud.delegate = delegate;
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}

@end

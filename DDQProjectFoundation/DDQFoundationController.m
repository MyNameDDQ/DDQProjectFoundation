//
//  DDQFoundationController.m
//  TimeSpace
//
//  Created by 123 on 2017/5/25.
//  Copyright © 2017年 WICEP. All rights reserved.
//

#import "DDQFoundationController.h"

#import <AFNetworking/AFNetworking.h>

@interface DDQFoundationController ()

@property (nonatomic, strong) UILabel *controllerTitleLabel;

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
    
    [self.view bringSubviewToFront:_foundationDefaultHUD];
    return _foundationDefaultHUD;
}

- (UIButton *)setLeftBarButtonItemStyle:(DDQFoundationBarButtonStyle)style Content:(id)content {
    
    //类型判断
    if (![content isMemberOfClass:[NSString class]] || ![content isMemberOfClass:[UIImage class]]) return nil;
    
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
    [itemArray addObject:leftItem];
    self.navigationItem.leftBarButtonItems = itemArray.copy;
    
    return customButton;
}

- (UIButton *)setRightBarButtonItemStyle:(DDQFoundationBarButtonStyle)style Content:(id)content {
    
    //类型判断
    if (![content isMemberOfClass:[NSString class]] || ![content isMemberOfClass:[UIImage class]]) return nil;
    
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
    [itemArray addObject:rightItem];
    self.navigationItem.rightBarButtonItems = itemArray.copy;
    
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

@end

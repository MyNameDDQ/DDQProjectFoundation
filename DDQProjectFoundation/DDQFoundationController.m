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

- (void)setControllerNavAttrs:(NSDictionary<ControllerNavBarContentKey,id> *)controllerNavAttrs {

    self.navigationItem.title = controllerNavAttrs[ControllerNavBarTitleKey];
    [self.navigationController.navigationBar setTitleTextAttributes:controllerNavAttrs[ControllerNavBarAttrsKey]];
}

- (MBProgressHUD *)controllerDefaultHUD {

    if (!_controllerDefaultHUD) {
        
        _controllerDefaultHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    return _controllerDefaultHUD;
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

@end

//
//  DDQWebPageController.m
//  DDQProjectEdit
//
//  Copyright © 2017年 DDQ. All rights reserved.

#import "DDQWebPageController.h"

#import "DDQAlertController.h"
#import "DDQAlertItem.h"
#import "DDQWebPagePlaceholderView.h"

@interface DDQWebPageController ()<DDQWebPagePlaceholderDelegate>

@end

@implementation DDQWebPageController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //WebView
    WKWebViewConfiguration *webConfig = [[WKWebViewConfiguration alloc] init];
    self.web_WKWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:webConfig];
    [self.view addSubview:self.web_WKWebView];
    self.web_WKWebView.UIDelegate = self;

    //Progress
    self.web_rateProgress = [[UIProgressView alloc] initWithFrame:CGRectZero];
    self.web_rateProgress.progressViewStyle = UIProgressViewStyleDefault;
    self.web_rateProgress.trackTintColor = kSetColor(235.0, 235.0, 235.0, 1.0);
    [self.view addSubview:self.web_rateProgress];
    [self.web_rateProgress setProgressTintColor:[UIColor blackColor]];
    
    //PlaceholderView
    self.web_placeholderView = [DDQWebPagePlaceholderView placeholderWithTitle:@"当前网络异常!" subTitle:@"加载失败"];
    [self.view addSubview:self.web_placeholderView];
    self.web_placeholderView.hidden = YES;
    self.web_placeholderView.delegate = self;

    //KVO
    [self.web_WKWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];//进度条
    
    //iOS 11.0
    if (@available(iOS 11.0, *)) {
        self.web_WKWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.web_showWebTitle = YES;
    self.web_webAutoLayout = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    
    //PS:我这么写的原因是因为防止bridge的base对页面的强引用，造成页面的不被释放。释放我写在了viewDidDisappear;
    //大致就是 self -> bridge -> bridgeBase -> self
    if (!self.web_jsBridge) {
        
        //重新注册一次JS
        self.web_jsBridge = [WKWebViewJavascriptBridge bridgeForWebView:self.web_WKWebView webViewDelegate:self handler:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:YES];
    
    if (self.navigationController.viewControllers.firstObject != self) {//不是根视图控制器就销毁
        
        //销毁bridge防止循环引用
        self.web_jsBridge = nil;
    }
}

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    
    if (self.web_webAutoLayout) {
        self.web_WKWebView.frame = self.view.bounds;
    }
    
    self.web_rateProgress.frame = CGRectMake(CGRectGetMinX(self.web_WKWebView.frame), CGRectGetMinY(self.web_WKWebView.frame), CGRectGetWidth(self.web_WKWebView.frame), 2.0);
    
    self.web_placeholderView.frame = self.view.bounds;
}

- (void)dealloc {
    
    [self.web_WKWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    if (self.web_jsBridge) self.web_jsBridge = nil;
    if (self.web_WKWebView.UIDelegate) self.web_WKWebView.UIDelegate = nil;
}

#pragma mark - Custom Method
/**
 创建一个bridge
 PS:这里重点说明下，我将pod的WebViewJavascriptBridge指定到了4.1.5版本。因为5.0以后的版本我截获不到js，原因排查中。
 */
- (WKWebViewJavascriptBridge *)web_jsBridge {
    
    if (!_web_jsBridge) {
        
        _web_jsBridge = [WKWebViewJavascriptBridge bridgeForWebView:self.web_WKWebView webViewDelegate:self handler:nil];
    }
    return _web_jsBridge;
}

- (void)setWeb_requestUrl:(NSString *)web_requestUrl {
    
    _web_requestUrl = web_requestUrl;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_web_requestUrl] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:25.0];
    [self.web_WKWebView loadRequest:request];
}

#pragma mark - WKWebView Delegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
    [self.web_rateProgress setHidden:NO];
    if (self.view.subviews.lastObject != self.web_rateProgress) [self.view bringSubviewToFront:self.web_rateProgress];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    if (self.web_showWebTitle && webView.title.length > 0) self.navigationItem.title = webView.title;//显示标题并且标题不为空
    [self.web_rateProgress setHidden:YES];
    self.web_placeholderView.hidden = YES;
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    self.web_placeholderView.hidden = NO;
    [self.view bringSubviewToFront:self.web_placeholderView];
    
    self.web_placeholderView.placeholder_titleLabel.text = @"当前网络异常！";
    self.web_placeholderView.placeholder_subTitleLabel.text = @"加载失败";
}

#pragma mark - WKWebView UIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(nonnull NSString *)message initiatedByFrame:(nonnull WKFrameInfo *)frame completionHandler:(nonnull void (^)(void))completionHandler {

    DDQAlertController *alerController = [DDQAlertController alertControllerWithTitle:@"提示" message:message alertStyle:DDQAlertControllerStyleAlert];
    [alerController alert_addAlertItem:^__kindof DDQAlertItem * _Nullable{
        
        DDQAlertItem *item = [DDQAlertItem alertItemWithStyle:DDQAlertItemStyleDefault];
        item.item_attrTitle = [[NSAttributedString alloc] initWithString:@"确定" attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
        return item;
    } handler:nil];
    [self presentViewController:alerController animated:YES completion:nil];
    
    completionHandler();
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if (change[NSKeyValueChangeNewKey]) {
        
        float progress = [change[NSKeyValueChangeNewKey] floatValue];
        [self.web_rateProgress setProgress:progress animated:YES];
        
        if (progress >= 1.0) {//加载完成
            
            [self.web_rateProgress setHidden:YES];
            [self.web_rateProgress setProgress:0.0];
        }
    }
}

#pragma mark - PlaceholderView Delegate
- (void)placeholder_didSelectAlertWithView:(DDQWebPagePlaceholderView *)placeholderView {
    
    placeholderView.placeholder_titleLabel.text = @"重新加载中...";
    placeholderView.placeholder_subTitleLabel.text = @"请稍候";
    DDQWeakObject(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //webview没有数据，reload后不会重走代理方法
        weakObjc.web_requestUrl = weakObjc.web_requestUrl;
        [weakObjc.web_WKWebView reload];
    });
}

@end

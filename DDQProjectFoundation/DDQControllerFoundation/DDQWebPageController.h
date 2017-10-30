//
//  DDQWebPageController.h
//  DDQProjectEdit
//
//  Copyright © 2017年 DDQ. All rights reserved.

#import <DDQProjectFoundation/DDQFoundationController.h>

#import <WebViewJavascriptBridge/WKWebViewJavascriptBridge.h>

NS_ASSUME_NONNULL_BEGIN
@class DDQWebPagePlaceholderView;

/**
 工程网页控制器
 */
@interface DDQWebPageController : DDQFoundationController <WKNavigationDelegate, WKUIDelegate>

/**
 一个基础的WebView
 */
@property (nonatomic, strong) WKWebView *web_WKWebView;

/**
 请求地址
 */
@property (nonatomic, copy, nullable) NSString *web_requestUrl;

/**
 是否显示Web的标题
 */
@property (nonatomic, assign) BOOL web_showWebTitle;//Default YES

/**
 WebView自适应大小
 */
@property (nonatomic, assign) BOOL web_webAutoLayout;//Default YES

/**
 网页加载进度
 */
@property (nonatomic, strong) UIProgressView *web_rateProgress;

/**
 js交互
 */
@property (nonatomic, strong, nullable) WKWebViewJavascriptBridge *web_jsBridge;

/**
 网页加载失败时的提示View
 */
@property (nonatomic, strong) DDQWebPagePlaceholderView *web_placeholderView;

@end

NS_ASSUME_NONNULL_END


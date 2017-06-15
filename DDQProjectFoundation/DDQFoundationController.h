//
//  DDQFoundationController.h
//
//  Copyright © 2017年 DDQ. All rights reserved.

#import <UIKit/UIKit.h>

#import "DDQFoundationHeader.h"

typedef NSString * ControllerSourceKey;//数据源标识
typedef NSString * ControllerCellIdentifier;//cell的id标识
typedef NSString * RequestFailureKey;//访问错误的描述
typedef NSString * ControllerNavBarContentKey;//控制器bar内容

typedef NS_ENUM(NSUInteger, DDQFoundationBarButtonStyle) {
    
    DDQFoundationBarButtonText = 107038,
    DDQFoundationBarButtonImage,
};

typedef NS_ENUM(NSUInteger, DDQFoundationHeaderStyle) {
    
    DDQFoundationHeaderStyleNormal,
    DDQFoundationHeaderStyleGif,
    DDQFoundationHeaderStyleState,
};

typedef NS_ENUM(NSUInteger, DDQFoundationFooterStyle) {
    
    DDQFoundationFooterStyleAutoNormal,
    DDQFoundationFooterStyleAutoGif,
    DDQFoundationFooterStyleAutoState,
    DDQFoundationFooterStyleBackNormal,
    DDQFoundationFooterStyleBackGif,
    DDQFoundationFooterStyleBackState,
};

@class MJRefreshHeader;
@class MJRefreshFooter;

@interface DDQFoundationController : UIViewController

/**
 NavgationBar的backgroundImage
 */
@property (nonatomic, copy) UIImage *foundationNavBarImage;

/**
 控制器名称
 */
@property (nonatomic, copy) NSDictionary<ControllerNavBarContentKey, id> *foundationNavAttrs;

/**
 控制器默认的hud
 */
@property (nonatomic, strong) MBProgressHUD *foundationDefaultHUD;

/**
 设置一个左按钮(调用一次即创建一个UIBarButtonItem的实例)
 
 @param style 按钮显示样式
 @param content 按钮显示内容(NSString || UIImage)
 @return Custom Button
 */
- (UIButton *)setLeftBarButtonItemStyle:(DDQFoundationBarButtonStyle)style Content:(id)content;

/**
 设置一个右按钮(调用一次即创建一个UIBarButtonItem的实例)
 
 @param style 按钮显示样式
 @param content 按钮显示内容(NSString || UIImage)
 @return Custom Button
 */
- (UIButton *)setRightBarButtonItemStyle:(DDQFoundationBarButtonStyle)style Content:(id)content;

/**
 基础请求：GET
 
 @param url 访问地址
 @param param 参数
 @param success 请求成功
 @param failure 请求失败
 */
- (void)foundation_GETRequestWithUrl:(NSString *)url Param:(NSDictionary<NSString *, id> *)param Success:(void(^)(id result))success Failure:(void(^)(NSDictionary<RequestFailureKey, NSString *> *errDic))failure;

/**
 基础请求:POST
 
 @param url 访问地址
 @param param 请求参数
 @param success 请求成功
 @param failure 请求失败
 */
- (void)foundation_POSTRequestWithUrl:(NSString *)url Param:(NSDictionary<NSString *,id> *)param Success:(void (^)(id))success Failure:(void (^)(NSDictionary<RequestFailureKey,NSString *> *))failure;

/**
 设置Header
 
 @param scrollView 被设置的view
 @param style header的类型
 @param handle 下拉的回调
 @return 如果需要，自己设置这个Header
 */
- (MJRefreshHeader *)foundation_setHeaderWithView:(__kindof UIScrollView *)scrollView Stlye:(DDQFoundationHeaderStyle)style Handle:(void(^)())handle;

/**
 设置Footer

 @param scrollView 被设置的view
 @param style footer的类型
 @param handle 上拉的回调
 @return 如果需要，自己设置这个Footer
 */
- (MJRefreshFooter *)foundation_setFooterWithView:(__kindof UIScrollView *)scrollView Stlye:(DDQFoundationFooterStyle)style Handle:(void(^)())handle;
@end

@interface UIScrollView (DDQFoundationFreshStateHandle)

- (void)EndRefreshing;
- (void)EndNoMoreData;
- (void)EndRestNoMoreData;
@end

@interface MBProgressHUD (DDQFoundationHUDShowHandle)

+ (void)alertHUDInView:(UIView *)view Text:(NSString *)text;
+ (void)alertHUDInView:(UIView *)view Text:(NSString *)text Delegate:(id<MBProgressHUDDelegate>)delegate;
+ (instancetype)alertHUDInView:(UIView *)view Mode:(MBProgressHUDMode)mode Text:(NSString *)text Delegate:(id<MBProgressHUDDelegate>)delegate;

@end

FOUNDATION_EXTERN RequestFailureKey const RequestFailureDescKey;//网络请求错误后的错误描述
FOUNDATION_EXTERN ControllerNavBarContentKey const ControllerNavBarTitleKey;//navgationBar，标题
FOUNDATION_EXTERN ControllerNavBarContentKey const ControllerNavBarAttrsKey;//navgaitonBar，标题富文本

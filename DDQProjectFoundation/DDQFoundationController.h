//
//  DDQFoundationController.h
//
//  Copyright © 2017年 DDQ. All rights reserved.

#import <UIKit/UIKit.h>

#import "DDQFoundationHeader.h"

NS_ASSUME_NONNULL_BEGIN
typedef NSString * ControllerSourceKey;       //数据源标识
typedef NSString * ControllerCellIdentifier;  //cell的id标识
typedef NSString * RequestFailureKey;         //访问错误的描述
typedef NSString * ControllerNavBarContentKey;//控制器bar内容

typedef NS_ENUM(NSUInteger, DDQFoundationBarButtonStyle) {
    
    DDQFoundationBarButtonText = 107038,//显示文字
    DDQFoundationBarButtonImage,        //显示图片
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
 初始化方法

 @return 本类的实例
 */
+ (instancetype)foundationController;

/**
 基础url
 */
@property (nonatomic, readonly) NSString *foundationBaseURL;

/**
 设置基础URL

 @param url 基础的url
 */
- (void)foundation_setBaseURL:(NSString *)url;

/**
 设置barImageName

 @param name imageName
 */
- (void)foundation_setNavigationBarBackgroundImageName:(NSString *)name;

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
- (void)foundation_GETRequestWithUrl:(NSString *)url Param:(NSDictionary<NSString *, NSString *> *)param Success:(void(^)(id _Nullable result))success Failure:(void(^)(NSDictionary<RequestFailureKey, NSString *> *errDic))failure;

/**
 基础请求:POST
 
 @param url 访问地址
 @param param 请求参数
 @param success 请求成功
 @param failure 请求失败
 */
- (void)foundation_POSTRequestWithUrl:(NSString *)url Param:(NSDictionary<NSString *, NSString *> *)param Success:(void (^)(id _Nullable result))success Failure:(void (^)(NSDictionary<RequestFailureKey,NSString *> *errDic))failure;

/**
 基础请求:上传图片

 @param url 访问地址
 @param param 访问参数
 @param images 图片数据(图片名为字典的key)
 @param success 上传成功
 @param progress 上传进度
 @param failure 上传失败
 */
- (void)foundation_UploadRequestWithUrl:(NSString *)url Param:(NSDictionary<NSString *, NSString *> *)param Images:(NSDictionary<NSString *, UIImage *> *)images Success:(void (^)(id _Nullable result))success Progress:(void (^)(NSProgress *progress))progress Failure:(void(^)(NSDictionary<RequestFailureKey, NSString *> *errDic))failure;

/**
 设置Header
 
 @param scrollView 被设置的view
 @param style header的类型
 @param handle 下拉的回调
 @return 如果需要，自己设置这个Header
 */
- (__kindof MJRefreshHeader *)foundation_setHeaderWithView:(__kindof UIScrollView *)scrollView Stlye:(DDQFoundationHeaderStyle)style Handle:(void(^)())handle;

/**
 设置Footer

 @param scrollView 被设置的view
 @param style footer的类型
 @param handle 上拉的回调
 @return 如果需要，自己设置这个Footer
 */
- (__kindof MJRefreshFooter *)foundation_setFooterWithView:(__kindof UIScrollView *)scrollView Stlye:(DDQFoundationFooterStyle)style Handle:(void(^)())handle;
@end

@interface UIScrollView (DDQFoundationFreshStateHandle)

- (void)foundation_endRefreshing;
- (void)foundation_endNoMoreData;
- (void)foundation_endRestNoMoreData;
@end

@interface MBProgressHUD (DDQFoundationHUDShowHandle)

+ (void)alertHUDInView:(UIView *)view Text:(NSString *)text;
+ (void)alertHUDInView:(UIView *)view Text:(NSString *)text Delegate:(nullable id<MBProgressHUDDelegate>)delegate;
+ (instancetype)alertHUDInView:(UIView *)view Mode:(MBProgressHUDMode)mode Text:(NSString *)text Delegate:(nullable id<MBProgressHUDDelegate>)delegate;

@end

UIKIT_EXTERN RequestFailureKey const RequestFailureDescKey;            //网络请求错误后的错误描述
UIKIT_EXTERN ControllerNavBarContentKey const ControllerNavBarTitleKey;//navgationBar，标题
UIKIT_EXTERN ControllerNavBarContentKey const ControllerNavBarAttrsKey;//navgaitonBar，标题富文本
NS_ASSUME_NONNULL_END


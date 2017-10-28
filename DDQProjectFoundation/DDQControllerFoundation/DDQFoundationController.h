//
//  DDQFoundationController.h
//
//  Copyright © 2017年 DDQ. All rights reserved.

#import <UIKit/UIKit.h>

#import "DDQDependencyHeader.h"
#import "DDQFoundationDefine.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSString * DDQFoundationControllerSourceKey;       //数据源标识
typedef NSString * DDQFoundationControllerCellIdentifier;  //cell的id标识
typedef NSString * DDQFoundationRequestFailureKey;         //访问错误的描述

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

typedef NS_ENUM(NSUInteger, DDQFoundationAuthorityType) {
    
    DDQFoundationAuthorityCamera,       //相机
    DDQFoundationAuthorityHealth,       //健康
    DDQFoundationAuthorityMicrophone,   //麦克风
    DDQFoundationAuthorityPhotoLibary,  //相册
};

typedef NS_ENUM(NSUInteger, DDQFoundationAuthorityErrorCode) {
    
    DDQFoundationErrorNoCamera,
    DDQFoundationErrorCameraNotUse,
    DDQFoundationErrorNoMicrophone,
    DDQFoundationErrorMicrophoneNotUse,
    DDQFoundationErrorPhotoLibaryNotUse,
    DDQFoundationErrorHealthKitNotUse,
};

typedef NS_ENUM(NSUInteger, DDQFoundationRequestErrorCode) {
    
    DDQFoundationRequestFailure = 107038,
    DDQFoundationRequestNotConnection,
    DDQFoundationRequestTimeOut,
    DDQFoundationRequestCancel,
};

@class MJRefreshHeader;
@class MJRefreshFooter;

@interface DDQFoundationController : UIViewController
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
 这是设置返回键和点击方法
 
 @param frame 按钮的大小
 @param style 按钮的类型
 @param content 按钮的内容
 @param sel 按钮的点击事件
 */
- (void)foundation_setLeftBackItemFrame:(CGRect)frame Style:(DDQFoundationBarButtonStyle)style Content:(id)content Selector:(_Nullable SEL)sel;

/**
 默认的点击事件
 */
- (void)foundation_leftItemSelectedWithCustomButton:(UIButton *)button;//leftItem default SEL

/**
 创建一个右边按键点击事件
 
 @param frame 按钮的大小
 @param style 按钮的显示类型
 @param content 按钮的显示内容
 @param sel 点击事件
 */
- (void)foundation_setRightItemFrame:(CGRect)frame Style:(DDQFoundationBarButtonStyle)style Content:(id)content Selector:(SEL)sel;

@end

@interface DDQFoundationController (DDQFoundationRefreshConfig)
/**
 设置Header
 
 @param scrollView 被设置的view
 @param style header的类型
 @param handle 下拉的回调
 @return 如果需要，自己设置这个Header
 */
+ (__kindof MJRefreshHeader *)foundation_setHeaderWithView:(__kindof UIScrollView *)scrollView Stlye:(DDQFoundationHeaderStyle)style Handle:(void(^)())handle;

/**
 设置Footer
 
 @param scrollView 被设置的view
 @param style footer的类型
 @param handle 上拉的回调
 @return 如果需要，自己设置这个Footer
 */
+ (__kindof MJRefreshFooter *)foundation_setFooterWithView:(__kindof UIScrollView *)scrollView Stlye:(DDQFoundationFooterStyle)style Handle:(void(^)())handle;
@end

@interface UIScrollView (DDQFoundationRefreshHandle)
/**
 停止刷新
 */
- (void)foundation_endRefreshing;

/**
 提示没有更多数据
 */
- (void)foundation_endNoMoreData;

/**
 重置刷新状态
 */
- (void)foundation_endRestNoMoreData;

@end

@interface DDQFoundationController (DDQFoundationNetRequest)

/**
 jsonResponse
 */
@property (nonatomic, assign) BOOL foundation_jsonResponse;

/**
 设置http请求头
 
 @param field 请求头参数
 */
- (void)foundation_setHttpField:(NSDictionary *)field;

/**
 当前网络状况发生改变
 
 @param result 改变结果
 */
- (void)foundation_checkUserNetChange:(void (^)(AFNetworkReachabilityStatus status, AFNetworkReachabilityManager *manager))result;

/**
 基础请求：GET
 
 @param url 访问地址
 @param param 参数
 @param success 请求成功
 @param failure 请求失败
 */
- (void)foundation_GETRequestWithUrl:(NSString *)url Param:(nullable NSDictionary<NSString *, NSString *> *)param Success:(void(^)(id _Nullable result))success Failure:(void(^)(NSDictionary<DDQFoundationRequestFailureKey, NSString *> *errDic))failure;

/**
 基础请求:POST
 
 @param url 访问地址
 @param param 请求参数
 @param success 请求成功
 @param failure 请求失败
 */
- (void)foundation_POSTRequestWithUrl:(NSString *)url Param:(nullable NSDictionary<NSString *, NSString *> *)param Success:(void (^)(id _Nullable result))success Failure:(void (^)(NSDictionary<DDQFoundationRequestFailureKey,NSString *> *errDic))failure;

/**
 基础请求:上传图片
 
 @param url 访问地址
 @param param 访问参数
 @param images 图片数据(图片名为字典的key)
 @param success 上传成功
 @param progress 上传进度
 @param failure 上传失败
 */
- (void)foundation_UploadRequestWithUrl:(NSString *)url Param:(nullable NSDictionary<NSString *, NSString *> *)param Images:(NSDictionary<NSString *, UIImage *> *)images Success:(void (^)(id _Nullable result))success Progress:(void (^)(NSProgress *progress))progress Failure:(void(^)(NSDictionary<DDQFoundationRequestFailureKey, NSString *> *errDic))failure;

/**
 基础请求:base64上传图片
 
 @param url 访问地址
 @param param 访问参数
 @param success 上传成功
 @param progress 上传进度
 @param failure 上传失败
 */
- (void)foundation_UploadBase64StringWithUrl:(NSString *)url Param:(nullable NSDictionary<NSString *, NSString *> *)param Success:(void(^)(id _Nullable result))success Progress:(void(^)(double progress))progress Failure:(void(^)(NSDictionary<DDQFoundationRequestFailureKey, NSString *> *errDic))failure;
@end


@protocol DDQFoundationHUDHandler <NSObject>
@optional

/**
 指定HUD的父视图
 */
- (UIView *)foundation_HUDSuperView;

@end

@interface DDQFoundationController (DDQFoundationUserInterface)<DDQFoundationHUDHandler>
/**
 控制器默认的hud
 */
@property (nonatomic, strong) MBProgressHUD *foundation_hud;

/**
 短暂的文字提示
 
 @param text 显示的文字
 @param delegate hud代理
 */
- (void)alertHUDWithText:(NSString *)text Delegate:(nullable id<MBProgressHUDDelegate>)delegate;

/**
 获得一个hud
 
 @param mode hud类型
 @param text 显示的文字
 @param delegate hud代理
 @return hud的实例
 */
- (MBProgressHUD *)alertHUDWithMode:(MBProgressHUDMode)mode Text:(nullable NSString *)text Delegate:(nullable id<MBProgressHUDDelegate>)delegate;

@end

typedef BOOL(^_Nullable DDQFoundationRequestHandle)(_Nullable id response, int code);
typedef void(^_Nullable DDQFoundationRequestAlertHandle)(int code);

@interface DDQFoundationController (DDQFoundationRequestHandle)
/**
 处理POST请求及HUD的显示

 @param url 请求的接口地址
 @param param 请求的参数
 @param handle 请求的结果
 @param alert 当HUD隐藏后的回调
 */
- (void)foundation_processNetPOSTRequestWithUrl:(NSString *)url Param:(nullable NSDictionary *)param WhenHUDHidden:(DDQFoundationRequestHandle)handle AfterAlert:(DDQFoundationRequestAlertHandle)alert;

/**
 处理POST请求及HUD的显示

 @param url 请求的接口地址
 @param param 请求的参数
 @param handle 请求的结果
 */
- (void)foundation_processNetPOSTRequestWithUrl:(NSString *)url Param:(nullable NSDictionary *)param WhenHUDHidden:(DDQFoundationRequestHandle)handle;

/**
 处理GET请求及HUD的显示

 @param url 请求的接口地址
 @param param 请求的参数
 @param handle 请求的结果
 @param alert 当HUD隐藏后的回调
 */
- (void)foundation_processNetGETRequestWithUrl:(NSString *)url Param:(nullable NSDictionary *)param WhenHUDHidden:(DDQFoundationRequestHandle)handle AfterAlert:(DDQFoundationRequestAlertHandle)alert;

/**
 处理GET请求及HUD的显示
 
 @param url 请求的接口地址
 @param param 请求的参数
 @param handle 请求的结果
 */
- (void)foundation_processNetGETRequestWithUrl:(NSString *)url Param:(nullable NSDictionary *)param WhenHUDHidden:(DDQFoundationRequestHandle)handle;

@end

@interface DDQFoundationController (DDQFoundationUserAuthority)

/**
 判断设备的对应权限
 
 @param type 判断类型
 @return 错误信息，无错误信息则为空
 */
+ (nullable NSError *)foundation_checkUserAuthorityWithType:(DDQFoundationAuthorityType)type;

/**
 跳转到本app的系统设置页
 */
+ (void)foundation_gotoAppSystemSet;
@end

@interface DDQFoundationController (DDQFoundationCheckContent)

/**
 检查手机号的准确性
 */
- (BOOL)foundation_checkPhone:(NSString *)phone;

/**
 检查验证码的准确性
 */
- (BOOL)foundation_checkMessageCode:(NSString *)code;

/**
 检查邮箱的准确性
 */
- (BOOL)foundation_checkEmail:(NSString *)mail;

@end

@interface DDQFoundationController (DDQFoundationTool)

/**
 获取当前的时间
 
 @param format YMDHSs
 */
- (NSString *)foundation_getCurrentDateWithFormat:(NSString *)format date:(NSDate *)date;

/**
 压缩图片
 
 @param image 图片
 @param scale 比例
 @return 新的图片
 */
- (UIImage *)foundation_compressionImageWithImage:(UIImage *)image Scale:(float)scale;

@end

UIKIT_EXTERN DDQFoundationRequestFailureKey const DDQFoundationRequestFailureDesc; //网络请求错误后的错误描述

NS_ASSUME_NONNULL_END


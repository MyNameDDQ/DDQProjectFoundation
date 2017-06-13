//
//  DDQFoundationController.h
//  TimeSpace
//
//  Created by 123 on 2017/5/25.
//  Copyright © 2017年 WICEP. All rights reserved.
//

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

@end

FOUNDATION_EXTERN RequestFailureKey const RequestFailureDescKey;//网络请求错误后的错误描述
FOUNDATION_EXTERN ControllerNavBarContentKey const ControllerNavBarTitleKey;//navgationBar，标题
FOUNDATION_EXTERN ControllerNavBarContentKey const ControllerNavBarAttrsKey;//navgaitonBar，标题富文本

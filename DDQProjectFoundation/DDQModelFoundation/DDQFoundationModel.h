//
//  DDQFoundationModel.h
//
//  Copyright © 2017年 DDQ. All rights reserved.


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol DDQFoundationModelHandler <NSObject>

@optional
/**
 处理模型类的属性列表,防止接口出现参数缺少或参数为null而导致取值时为空，进而导致的程序崩溃。
 */
- (void)model_handlerPropertyList;

/**
 被忽视的属性名称
 */
- (nullable NSArray *)model_handlerIgnoredProperty;

/**
 被替换的属性名称
 */
- (NSDictionary *)model_handlerReplaceProperty;

@end

/**
 模型基类
 */
@interface DDQFoundationModel : NSObject<DDQFoundationModelHandler>


@end

@interface NSObject (DDQFoundationModelClass)

/**
 这个属性的类所遵循的协议
 
 @return 协议的集合
 */
- (nullable NSSet *)model_propertyAttrFollowProtocalWithClass:(Class)proClass;

@end

NS_ASSUME_NONNULL_END

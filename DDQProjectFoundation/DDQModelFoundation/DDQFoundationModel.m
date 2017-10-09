//
//  DDQFoundationModel.m
//  Pods
//
//  Created by 我叫咚咚枪 on 2017/8/2.
//
//

#import "DDQFoundationModel.h"

#import <objc/runtime.h>
#import <MJExtension/MJExtension.h>

@implementation DDQFoundationModel

- (void)setValue:(id)value forKey:(NSString *)key {
    
    [super setValue:[self base_checkModelValue:value] forKey:key];
}

/**
 判断赋值是否为空
 
 @param value 判断的值
 @return 处理后的结果
 */
- (NSObject *)base_checkModelValue:(id)value {
    
    if (!value) {
        
        if ([value isKindOfClass:[NSObject class]]) {
            return [[[value class] alloc] init];
        } else {
            return [[NSObject alloc] init];
        }
    }
    return value;
}

/**
 读取模型类中的所有属性名称
 
 @return 属性名数组
 */
- (NSDictionary *)base_loadClassPropertyList {
    
    unsigned int listCount = 0;
    
    objc_property_t *propertys = class_copyPropertyList([self class], &listCount);
    
    NSMutableDictionary *propertyDic = [NSMutableDictionary dictionaryWithCapacity:listCount];
    
    NSArray *ignoredArr = nil;
    if ([self respondsToSelector:@selector(model_handlerIgnoredProperty)]) {
        ignoredArr = [self performSelector:@selector(model_handlerIgnoredProperty)];
    }
    
    for (int index = 0; index < listCount; index++) {
        
        objc_property_t property = propertys[index];
        NSString *propertyName = [[NSString alloc] initWithUTF8String:property_getName(property)];
        
        if ([ignoredArr containsObject:propertyName] && ignoredArr) {
            continue;
        }
        
        NSDictionary *propertyAttr = [self base_handlePropertyAttribute:[[NSString alloc] initWithUTF8String:property_getAttributes(property)]];
        [propertyDic setValue:propertyAttr forKey:propertyName];
    }
    free(propertys);
    
    return propertyDic.copy;
}

static NSString *const PropertyClass = @"JFModelClassName";
static NSString *const PropertyAttribute = @"JFModelAttrName";
/**
 获取属性的修饰词，及属性的类型
 
 @param attr 属性的描述
 @return 一个字典
 */
- (NSDictionary *)base_handlePropertyAttribute:(NSString *)attr {
    
    NSArray *attrArr = [attr componentsSeparatedByString:@","];
    NSString *classStr = attrArr.firstObject;
    
    //写的不够优雅 - - ！
    if ([[classStr substringToIndex:2] isEqualToString:@"T@"]) {//OC子类表现形式:T@"XXXXX"
        
        NSArray *classArr = [classStr componentsSeparatedByString:@"\""];
        return @{PropertyClass:classArr[1], PropertyAttribute:attrArr[1]};
    } else {//基础数据类型:TX
        return @{PropertyClass:[classStr substringWithRange:NSMakeRange(1, 1)]};
    }
}

#pragma mark - Custom Delegate
- (void)model_handlerPropertyList {
    
    //已被转化的key
    NSMutableDictionary *valueDic = [self mj_keyValues];
    NSArray *ignoredArr = @[@"description", @"debugDescription", @"hash", @"superclass"];
    for (NSString *ignoredKey in ignoredArr) {
        
        if ([valueDic valueForKey:ignoredKey]) {
            [valueDic removeObjectForKey:ignoredKey];
        }
    }
    NSArray *allKeyArr = [valueDic allKeys];
    
    //全部的key
    NSDictionary *propertyListDic = [self base_loadClassPropertyList];
    
    //未被转化的key
    NSPredicate *resultPre = [NSPredicate predicateWithFormat:@"NOT (SELF in %@)", allKeyArr];
    NSArray *remainedArr = [propertyListDic.allKeys filteredArrayUsingPredicate:resultPre];
    
    //设置默认值
    for (NSString *remainedKey in remainedArr) {
        
        NSDictionary *attrDic = propertyListDic[remainedKey];
        Class propertyClass = NSClassFromString(attrDic[PropertyClass]);
        if ([propertyClass isSubclassOfClass:[NSObject class]]) {//OC子类
            
            NSString *propertyAttr = attrDic[PropertyAttribute];
            if ([propertyAttr isEqualToString:@"C"]) {//copy
                
                NSSet *set = [self model_propertyAttrFollowProtocalWithClass:propertyClass];
                
                if ([set.allObjects containsObject:@"NSCopying"]) {//该类遵循NSCopying协议
                    [self setValue:[[propertyClass alloc] init] forKey:remainedKey];
                } else {//该类不支持NSCopying协议，但属性修饰词却是copy
                    
                    NSString *excTip = [NSString stringWithFormat:@"%@没有遵循NSCopying协议", propertyClass];
                    NSException *exc = [NSException exceptionWithName:NSInvalidArgumentException reason:excTip userInfo:nil];
                    [exc raise];
                }
            } else {//strong,weak
                [self setValue:[[propertyClass alloc] init] forKey:remainedKey];
            }
        } else {//基础数据类型
            
            //可不用实现，基础数据类型，为空时取值时0。而且MJ也做了相关处理
        }
    }
}

@end

@implementation NSObject (DDQJFModelClass)

- (NSSet *)model_propertyAttrFollowProtocalWithClass:(Class)proClass {
    
    unsigned int protocolCount = 0;
    __unsafe_unretained Protocol **protocolList = class_copyProtocolList(proClass, &protocolCount);
    
    NSMutableArray *protocolArr = [NSMutableArray arrayWithCapacity:protocolCount];
    for (int index = 0; index < protocolCount; index++) {
        
        Protocol *protocol = protocolList[index];
        [protocolArr addObject:[[NSString alloc] initWithUTF8String:protocol_getName(protocol)]];
    }
    free(protocolList);
    
    return [NSSet setWithArray:protocolArr.copy];
}

@end

//
//  DDQFoundationModel.m
//
//  Copyright © 2017年 DDQ. All rights reserved.


#import "DDQFoundationModel.h"

#import <objc/runtime.h>
#import <MJExtension/MJExtension.h>

@implementation DDQFoundationModel

+ (instancetype)mj_objectWithKeyValues:(id)keyValues {
    
    id object = [super mj_objectWithKeyValues:keyValues];
    if ([object respondsToSelector:@selector(model_handlerPropertyList)]) {
        [object performSelector:@selector(model_handlerPropertyList)];
    }
    return object;
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
    [valueDic removeObjectsForKeys:ignoredArr];
    NSArray *allKeyArr = [valueDic allKeys];
    
    //全部的key
    NSDictionary *propertyListDic = [self base_loadClassPropertyList];
    for (NSString *key in propertyListDic.allKeys) {//检查所有属性中被转化过的属性
        
        if ([allKeyArr containsObject:key]) {//找到已经被转化过的属性
         
            @try {
                
                id objecValue = [self valueForKey:key];
                NSDictionary *propertyAttr = propertyListDic[key];
                Class attrClass = NSClassFromString([propertyAttr objectForKey:PropertyClass]);
                if ([attrClass isSubclassOfClass:[NSString class]]) {//属性是不是NSString及其子类
                    
                    if (![[objecValue class] isSubclassOfClass:[NSString class]]) {//赋值的属性不是字符串及其子类
                        
                        [self setValue:[objecValue description] forKey:key];
                        
                    }
                }
                
                if ([[objecValue class] isSubclassOfClass:[NSNull class]] && [attrClass isSubclassOfClass:[NSObject class]]) {//赋值的是NSNull，且属性指向NSObject及其子类
                    
                    [self setValue:[[attrClass alloc] init] forKey:key];
                    
                }
            } @catch (NSException *exception) {
                
                NSLog(@"%@", exception);
                
            } @finally {
                
                continue;
                
            }
        }
    }
    
    //属性替换
    NSDictionary *replaceDic = nil;
    if ([self respondsToSelector:@selector(model_handlerReplaceProperty)]) {
        
        replaceDic = [self performSelector:@selector(model_handlerReplaceProperty)];
        //转化字典里所有的value即是被mj真正转化的服务器返回的属性名
        for (NSString *replaceKey in replaceDic.allKeys) {
            
            NSString *assignKey = [replaceDic valueForKey:replaceKey];
            if ([allKeyArr containsObject:assignKey]) {
                
                id object = [valueDic objectForKey:assignKey];
                [valueDic removeObjectForKey:assignKey];
                [valueDic setObject:object forKey:replaceKey];
                
            }
        }
        allKeyArr = valueDic.allKeys;
        
    }

    
    //未被转化的key
    NSPredicate *resultPre = [NSPredicate predicateWithFormat:@"NOT (SELF in %@)", allKeyArr];
    NSArray *remainedArr = [propertyListDic.allKeys filteredArrayUsingPredicate:resultPre];
    
    //设置默认值
    for (NSString *remainedKey in remainedArr) {
        
        NSDictionary *attrDic = propertyListDic[remainedKey];
        Class propertyClass = NSClassFromString(attrDic[PropertyClass]);

        if ([propertyClass isSubclassOfClass:[NSObject class]]) {//OC子类
            
            @try {
                
                [self setValue:[[propertyClass alloc] init] forKey:remainedKey];
                    
            } @catch (NSException *exception) {
                
                NSLog(@"%@", exception);
                
            } @finally {
                
                continue;
                
            }
        } else {//基础数据类型
            
            //可不用实现，基础数据类型，为空时取值时0。而且MJ也做了相关处理
        }
    }
}
@end

@implementation NSObject (DDQModelClass)

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

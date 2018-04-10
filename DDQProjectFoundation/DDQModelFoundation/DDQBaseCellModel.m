//
//  DDQBaseCellModel.m
//
//  Copyright © 2018年 DDQ. All rights reserved.

#import "DDQBaseCellModel.h"

#import <MJExtension/MJExtension.h>

@implementation DDQBaseCellModel
 
- (NSArray *)model_handlerIgnoredProperty {
    
    return @[@"model_recordHeight"];
    
}

+ (NSArray *)mj_ignoredPropertyNames {
    
    return @[@"model_recordHeight"];
    
}

@end

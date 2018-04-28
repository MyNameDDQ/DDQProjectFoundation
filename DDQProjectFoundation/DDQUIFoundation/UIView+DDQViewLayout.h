//
//  UIView+DDQViewLayout.h
//
//  Copyright © 2018年 我叫咚咚枪. All rights reserved.


#import "DDQLayoutAttribute.h"

@interface UIView (DDQViewLayout)

- (DDQLayoutAttribute *)leading;
- (DDQLayoutAttribute *)trailing;
- (DDQLayoutAttribute *)top;
- (DDQLayoutAttribute *)bottom;
- (DDQLayoutAttribute *)centerX;
- (DDQLayoutAttribute *)centerY;
- (DDQLayoutAttribute *)centerPoint;


@end

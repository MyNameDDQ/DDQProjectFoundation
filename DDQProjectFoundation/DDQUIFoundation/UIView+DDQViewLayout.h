//
//  UIView+DDQViewLayout.h
//
//  Copyright © 2018年 我叫咚咚枪. All rights reserved.


#import "DDQLayoutAttribute.h"

@interface UIView (DDQViewLayout)

- (DDQLayoutAttribute *)layout_leading;
- (DDQLayoutAttribute *)layout_trailing;
- (DDQLayoutAttribute *)layout_top;
- (DDQLayoutAttribute *)layout_bottom;
- (DDQLayoutAttribute *)layout_centerX;
- (DDQLayoutAttribute *)layout_centerY;
- (DDQLayoutAttribute *)layout_center;

@end

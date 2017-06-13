//
//  DDQFoundationHeader.h
//  DDQFoundationControllerDemo
//
//  Created by 123 on 2017/6/13.
//  Copyright © 2017年 DDQ. All rights reserved.
//

/**
 
 摘要：这是工程的头文件及宏集合
 
 */
#ifndef DDQFoundationHeader_h
#define DDQFoundationHeader_h

//工程宏
#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
#define kDeviceHeight [UIScreen mainScreen].bounds.size.height
#define kSetImage(name) [UIImage imageNamed:name]
#define kFindNib(class) [UINib nibWithNibName:NSStringFromClass(class) bundle:[NSBundle mainBundle]]

//工程三方文件
#import <Masonry/Masonry.h>
#import <MJRefresh/MJRefresh.h>
#import <MJExtension/MJExtension.h>
#import <MBProgressHUD/MBProgressHUD.h>

//工程文件
#import "UIView+DDQSimplyGetViewProperty.h"


#endif /* DDQFoundationHeader_h */

//
//  UIButton+DDQButtonCategory.m
//  DDQProjectEdit
//
//  Created by 我叫咚咚枪 on 2017/9/11.
//  Copyright © 2017年 我叫咚咚枪. All rights reserved.
//

#import "UIButton+DDQButtonCategory.h"

@implementation UIButton (DDQButtonCategory)

- (void)button_countDownWithInterval:(NSTimeInterval)interval totalTime:(float)total comletion:(nonnull void (^)(BOOL, NSDictionary * _Nullable))completion {

    __block float totalTime = total;
    
    self.enabled = NO;
    [self setTitle:[NSString stringWithFormat:@"(%.0f)", totalTime] forState:UIControlStateNormal];
    
    dispatch_source_t timerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timerSource, DISPATCH_TIME_NOW, interval * NSEC_PER_SEC, 0.0 * NSEC_PER_SEC);
    
    NSDictionary *beginSourceDic = @{DDQButtonBeginTitle:[self titleForState:UIControlStateNormal]?:@"", DDQButtonBeginTextColor:[self titleColorForState:UIControlStateNormal]?:[UIColor clearColor], DDQButtonBeginBackgroundColor:[self backgroundImageForState:UIControlStateNormal]?:[UIColor clearColor]};
    
    dispatch_source_set_event_handler(timerSource, ^{
        
        totalTime --;
        //秒数判断
        if (totalTime <= 0.0) {//总时间计时完毕
            
            dispatch_suspend(timerSource);
            if (completion) {
                completion(YES, beginSourceDic);
            }
        } else {//倒计时未完成
            
            [self setTitle:[NSString stringWithFormat:@"(%.0f)", totalTime] forState:UIControlStateNormal];
            if (completion) {
                completion(NO, nil);
            }
        }
    });
    dispatch_resume(timerSource);
}

@end

//
//  UIButton+DDQButtonCategory.m
//
//  Copyright © 2017年 DDQ. All rights reserved.

#import "UIButton+DDQButtonCategory.h"

@implementation UIButton (DDQButtonCategory)

DDQButtonBeginSourceKey const DDQButtonBeginTitle = @"button.beginTitle";
DDQButtonBeginSourceKey const DDQButtonBeginTextColor = @"button.beginTextColor";
DDQButtonBeginSourceKey const DDQButtonBeginAttributeTitle = @"button.attributeTitle";
DDQButtonBeginSourceKey const DDQButtonBeginBackgroundColor = @"button.beginBackgroundColor";

- (void)button_countDownWithInterval:(NSTimeInterval)interval totalTime:(float)total comletion:(nonnull void (^)(BOOL, NSDictionary * _Nullable))completion {

    __block float totalTime = total;
    
    NSMutableDictionary *beginSourceDic = [NSMutableDictionary dictionaryWithDictionary:@{DDQButtonBeginBackgroundColor:self.backgroundColor?:[UIColor clearColor]}];
    
    UIColor *defaultTitleColor = [UIColor whiteColor];
    //接下来是判断button显示是不是NSString
    if ([self titleForState:UIControlStateNormal].length > 0) {//NSString
        
        [beginSourceDic setValue:[self titleForState:UIControlStateNormal] forKey:DDQButtonBeginTitle];
        [beginSourceDic setValue:[self titleColorForState:UIControlStateNormal]?:[UIColor clearColor] forKey:DDQButtonBeginTextColor];
        defaultTitleColor = [self titleColorForState:UIControlStateNormal];
        
    } else if ([self attributedTitleForState:UIControlStateNormal]) {//NSAttributeString
        
        //记录开始时的文字
        NSAttributedString *titleAttributeString = [self attributedTitleForState:UIControlStateNormal];
        [beginSourceDic setValue:titleAttributeString forKey:DDQButtonBeginAttributeTitle];
        
        //获得字符串属性
        NSRange range = {0, titleAttributeString.length};
        NSDictionary *attrs = [titleAttributeString attributesAtIndex:0 effectiveRange:&range];
        defaultTitleColor = attrs[NSForegroundColorAttributeName];
        //置为空是需要显示下面的提示字样
        [self setAttributedTitle:nil forState:UIControlStateNormal];
    }
    
    self.enabled = NO;
//    [self setTitle:[NSString stringWithFormat:@"(%.0fs)重发", totalTime] forState:UIControlStateNormal];
    [self setTitleColor:defaultTitleColor forState:UIControlStateNormal];
    
    __weak typeof(self) weakSelf = self;
    dispatch_source_t timerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timerSource, DISPATCH_TIME_NOW, interval * NSEC_PER_SEC, 0.0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timerSource, ^{
        
        __strong typeof(self) strongSelf = weakSelf;

        totalTime --;
        //秒数判断
        if (totalTime <= 0.0) {//总时间计时完毕
            
            strongSelf.enabled = YES;
            dispatch_suspend(timerSource);
            if (completion) {
                completion(YES, beginSourceDic);
            }
        } else {//倒计时未完成
        
            [strongSelf setTitle:[NSString stringWithFormat:@"(%.0fs)重发", totalTime] forState:UIControlStateNormal];
            if (completion) {
                completion(NO, nil);
            }
        }
    });
    dispatch_resume(timerSource);
}

@end


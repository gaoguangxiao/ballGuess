//
//  ShareHandle.m
//  WTD
//
//  Created by Wangshuguan-mac on 13-7-4.
//  Copyright (c) 2013年 ling. All rights reserved.
//

#import "ShareHandle.h"
@implementation NSDateFormatter(mydateformmater)
+(id)dateFormatterWithFormat:(NSString *)s{
    NSDateFormatter *f = [[NSDateFormatter alloc]init];
    f.dateFormat = s;
    f.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:8];
    [f setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_Hans_CN"]];
    return f;
}
@end
//加一个 日历的封装
@implementation NSCalendar(mycalendea)
+(NSString *)calenderWithCalender:(NSUInteger )s{
    NSCalendar *c = [NSCalendar currentCalendar];
    NSDateComponents *conponent = [c components:s fromDate:[NSDate date]];
    
    NSInteger year=[conponent year];
    NSInteger month=[conponent month]+s;
    if (month>12) {
        month =month/12;
        year = year+1;
    }
    NSInteger day    = [conponent day];
//    NSInteger hours  = [conponent hour];
//    NSInteger minute = [conponent minute];
//    NSInteger second = [conponent second];
    
    return [self backYear_Month_Day:@{@"year":@(year),@"month":@(month),@"day":@(day)}];
}
+(NSString *)backYear_Month_Day:(NSDictionary *)dic{
    
    NSString *nsDateString= [NSString  stringWithFormat:@"%@年%@月%@日",dic[@"year"],dic[@"month"],dic[@"day"]];
    return nsDateString;
}
+(NSString *)backYear_Month_Day_Hours_Minuter_Second:(NSDictionary *)dic{
    
    NSString *nsDateString= [NSString  stringWithFormat:@"%@年%@月%@日",dic[@"year"],dic[@"month"],dic[@"day"]];
    return nsDateString;
}
@end
//@implementation ShareHandle
//-(void)Init{
//    [super Init];
//    _sharedCity = @"不限";
//    _sharedProvince = @"不限";
//}
//@end

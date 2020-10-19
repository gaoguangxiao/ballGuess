//
//  UIColor+Compare.m
//  MXSFramework
//
//  Created by gaoguangxiao on 2020/4/24.
//  Copyright © 2020 MXS. All rights reserved.
//

#import "UIColor+Compare.h"
#import "CheckValid.h"
#import "YBColorConfigure.h"
@implementation UIColor (Compare)

//指数盘口变化时 字体颜色
+(UIColor *)getColorForCompare:(NSString *)a andB:(NSString *)b{
    if ([CheckValid isPureFloat:a] && [CheckValid isPureFloat:b]) {
        
        float aFloat = [[self eliminateSymbolWithDecimalString:a] floatValue];
        float bFloat = [[self eliminateSymbolWithDecimalString:b] floatValue];
        if (bFloat > aFloat) {
            return RRCHighLightTitleColor;
        }else if (bFloat < aFloat){
            return RRC0F9958Color;
        }else{
            return RRCThemeTextColor;
        }
        
    }else{
        return RRCThemeTextColor;
    }
}

//指数盘口变化时 字体背景颜色
+(UIColor *)getBackColorForCompare:(NSString *)a andB:(NSString *)b{
    if ([CheckValid isPureFloat:a] && [CheckValid isPureFloat:b]) {
        float aFloat = [[self eliminateSymbolWithDecimalString:a] floatValue];
        float bFloat = [[self eliminateSymbolWithDecimalString:b] floatValue];
        if (bFloat> aFloat) {
            return RRCFFEBEEColor;
        }else if (bFloat < aFloat){
            return RRCE8FFF4Color;
        }else{
            return RRCUnitViewColor;
        }
    }else{
        return RRCUnitViewColor;
    }
    
}

//消除符号 获取绝对值
+(NSString *)eliminateSymbolWithDecimalString:(NSString *)decimalString{
    
    NSString *param = decimalString;
    if ([param hasPrefix:@"-"]) {
        param = [param stringByReplacingOccurrencesOfString:@"-" withString:@""];
    } else if ([param hasPrefix:@"+"]) {
        param = [param stringByReplacingOccurrencesOfString:@"+" withString:@""];
    } else {
        
    }
    return param;
}
@end

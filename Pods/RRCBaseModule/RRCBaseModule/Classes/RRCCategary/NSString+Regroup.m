//
//  NSString+Regroup.m
//  MXSFramework
//
//  Created by gaoguangxiao on 2020/4/22.
//  Copyright © 2020 MXS. All rights reserved.
//

#import "NSString+Regroup.h"

@implementation NSString (Regroup)

+(NSString *)regroupPointCount:(NSString *)decimalString{
    
    NSString *param = decimalString;
    NSString *paramSymbol;//符号标志
    if ([param hasSuffix:@".25"] || [param hasSuffix:@".75"]) {
        if ([param hasPrefix:@"-"]) {
            paramSymbol = @"-";
            param = [param stringByReplacingOccurrencesOfString:@"-" withString:@""];
        } else if ([param hasPrefix:@"+"]) {
            paramSymbol = @"+";
            param = [param stringByReplacingOccurrencesOfString:@"+" withString:@""];
        } else {
            paramSymbol = @"";
        }
        float aFloat = [param floatValue];
        
        if ([param isEqualToString:@"0.25"]) {
            param = [NSString stringWithFormat:@"%@0/%@",paramSymbol,@(aFloat + 0.25)];
        } else {
            param = [NSString stringWithFormat:@"%@%@/%@",paramSymbol,@(aFloat - 0.25),@(aFloat + 0.25)];
        }
    }
    
    return param;
}

//截取一定长度拼接...
-(NSString *)regrouSubstringToIndex:(NSInteger)toIndex{
    NSString *tempString = self;
    if (tempString.length == toIndex) {
        return tempString;
    }
    if (tempString.length > toIndex) {
        tempString = [NSString stringWithFormat:@"%@...",[tempString substringToIndex:toIndex - 1]];
    }
    return tempString;
}
@end

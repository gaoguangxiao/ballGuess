//
//  RRCPortSecretTool.m
//  MXSFramework
//
//  Created by 人人彩 on 2020/9/16.
//  Copyright © 2020 MXS. All rights reserved.
//

#import "RRCPortSecretTool.h"
#import <CommonCrypto/CommonDigest.h>
#define RRCSecretSaltKey @"FFE2339642CC0EEB"
@implementation RRCPortSecretTool

+(instancetype)defaultManager{
    static RRCPortSecretTool *portSecret = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        portSecret = [[RRCPortSecretTool alloc] init];
    });
    return portSecret;
}

-(NSString *)portSectetWithParameter:(NSDictionary *)parameters{
    NSArray *sortArray = [self chineseSortWithStringArray:[parameters allKeys]];
    NSString *resultStr = @"";
    for (NSString *keyStr in sortArray) {
        NSString *valueStr = parameters[keyStr];
        if (resultStr.length == 0) {
            resultStr = valueStr;
        }else{
            resultStr = [NSString stringWithFormat:@"%@%@",resultStr,valueStr];
        }
    }
    NSString *md5Str = [self MD5Hash:[NSString stringWithFormat:@"%@%@",resultStr,RRCSecretSaltKey]];
    return [self stringToUpper:md5Str];
}

- (NSArray*) chineseSortWithStringArray: (NSArray*)stringArray {
    if (stringArray == nil) {
        return nil;
    }
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (int i = 0 ; i < [stringArray count] ; i++) {
        if (![[stringArray objectAtIndex:i] isKindOfClass:[NSString class]]) {
            return nil;
        }
        NSDictionary *tempDic = [[NSDictionary alloc] initWithObjectsAndKeys:[stringArray objectAtIndex:i], @"chinese", [self chineseStringTransformPinyin:[stringArray objectAtIndex:i]], @"pinyin", nil];
        [tempArray addObject:tempDic];
    }
    // 排序
    [tempArray sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj1 objectForKey:@"pinyin"] compare:[obj2 objectForKey:@"pinyin"]];
    }];
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    for (NSDictionary *tempDic in tempArray) {
        [resultArray addObject:[tempDic objectForKey:@"chinese"]];
    }
    return resultArray;
}

// 中文字符串转换成拼音
- (NSString*)chineseStringTransformPinyin: (NSString*)chineseString {
    if (chineseString == nil) {
        return nil;
    }
    // 拼音字段
    NSMutableString *tempNamePinyin = [chineseString mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)tempNamePinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)tempNamePinyin, NULL, kCFStringTransformStripDiacritics, NO);
    return tempNamePinyin.uppercaseString;
}

//小写转成大写
-(NSString *)stringToUpper:(NSString *)str{
    for (NSInteger i = 0; i < str.length; i++) {
        if ([str characterAtIndex:i] >= 'a' & [str characterAtIndex:i] <= 'z') {
            char temp = [str characterAtIndex:i] - 32;
            str = [str stringByReplacingCharactersInRange:NSMakeRange(i, 1) withString:[NSString stringWithFormat:@"%c",temp]];
        }
    }
    return str;
}

-(NSString *)MD5Hash:(NSString *)str{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}
@end


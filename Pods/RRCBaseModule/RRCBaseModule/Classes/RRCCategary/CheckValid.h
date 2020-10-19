//
//  CheckValid.h
//  UTDoorStyle
//
//  Created by CYN on 14-9-28.
//  Copyright (c) 2014年 exmart. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CheckValid : NSObject


+ (NSRange)HadTel:(NSString *)string;
+ (NSRange)HadUrl:(NSString *)string;

+ (BOOL)isValidateEmail:(NSString *)email;

+ (BOOL)isValidatePhone:(NSString *)phone;

+ (BOOL)isValidateZuoJiPhone:(NSString *)phone;

+ (BOOL)isTotalNumber:(NSString *)number;

+ (BOOL)isValidatePassword:(NSString *)password;

+ (BOOL)isValidateNetConnection;

+ (BOOL)isValidateIdentityCard: (NSString *)identityCard;

+ (BOOL)isValidateWuWeiPhone:(NSString *)phone;

+ (BOOL)isIncludeEmoji:(NSString *)str;

+ (BOOL)isHZ:(NSString *)string;
+ (BOOL)isSZ:(NSString *)string;
+ (BOOL)isXXZM:(NSString *)string;
+ (BOOL)isDXZM:(NSString *)string;
+(BOOL)isIncludeSpecialCharact: (NSString *)str;

// 字符串判断
+ (BOOL)isBlankString:(NSString *)string;

//数字判断
+ (BOOL)isPureInt:(NSString*)string;
+ (BOOL)isPureFloat:(NSString*)string;

+ (BOOL)isEndWithUrl:(NSString *)string;

// 去除文字首尾的换行符和空格
+ (NSString *)removeSpaceAndNewline:(NSString *)str;

// 判断内容全部为英文
+ (BOOL)containEngish:(NSString *)str;

// 判断内容为文字，数字，字母组合
+ (NSString *)checkContentTypeWithString:(NSString*)password;

@end

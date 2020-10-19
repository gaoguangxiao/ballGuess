//
//  DataTypeTranslate.h
//  UTDoorStyle
//
//  Created by CYN on 14-9-28.
//  Copyright (c) 2014年 exmart. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KDateFormatterTypeYMDHMSFFF @"yyyy-MM-dd HH:mm:ss.fff"
#define KDateFormatterTypeYMDHMS @"yyyy-MM-dd HH:mm:ss"
#define KDateFormatterTypeYMD @"yyyy-MM-dd"
#define KDateFormatterTypeHMS @"HH:mm:ss"
#define KDateFormatterTypeYMDHM @"yyyy-MM-dd HH:mm"
#define KDateFormatterTypeMDHM @"MM-dd HH:mm"


@interface DataTypeTranslate : NSObject
+ (NSString*)sha1:(NSString *)str;
+ (NSString *)stringToString:(NSString *)str;

+ (id)stringToIntNumber:(NSString *)str;

+ (id)stringToFloatNumber:(NSString *)str;

+ (NSString *)numberToString:(NSNumber *)num;

+ (NSString *)arrayToJsonString:(NSArray *)ary;

+ (NSString *)dictionaryToJsonString:(NSDictionary *)dict;

+ (NSString *)dateToString:(NSDate *)date withFormatterType:(NSString *)formatterType;

+ (NSDate *)string2Date:(NSString *)dateStr withFormatterType:(NSString *)formatterType;

+ (NSString *)changeDateToFormatterString:(NSString *)dataTraStr;

+ (NSString *)decodeBase64String:(NSString *)base64Str;

+ (NSString *)encodeBase64String:(NSString *)base64Str;

+ (NSString *)md5:(NSString *)md5Str;
+ (NSString *)NullToEmpty:(NSString *)str;
//字典排序
+ (NSString *)createRank:(NSMutableDictionary*)dict;
+ (NSString*)createCommentRank:(NSMutableDictionary*)dict;//替换不包含remark

+ (NSString *)leftDisplacementOfFive;

//sha256加密方式
+ (NSString *)getSha256String:(NSString *)srcString;


//DES加密、解密方法
+(NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key;
+(NSString *) decryptUseDES:(NSString *)cipherText key:(NSString *)key;

//DES_CBC加密、解密方法
+(NSString *) encryptUseDES_CBC:(NSString *)plainText key:(NSString *)key;
+(NSString *)decryptUseDES_CBC:(NSString *)cipherText key:(NSString *)key;

//base64加密
+(NSString *)encode:(NSData *)data;
@end

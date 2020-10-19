//
//  DataTypeTranslate.m
//  UTDoorStyle
//
//  Created by CYN on 14-9-28.
//  Copyright (c) 2014年 exmart. All rights reserved.
//

#import "DataTypeTranslate.h"
#import "Log.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCrypto.h>
#import <Foundation/Foundation.h>
@implementation DataTypeTranslate

const Byte iv[] = {1,2,3,4,5,6,7,8};
static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

#pragma mark -
#pragma mark - public Method

+ (NSString*)sha1:(NSString *)str
{
    const char *cstr = [str cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:str.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    //extern unsigned char *CC_SHA1(const void *data, CC_LONG len, unsigned char *md)
    CC_SHA1(data.bytes,(CC_LONG)data.length, digest);
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}


+ (NSString *)dateToString:(NSDate *)date withFormatterType:(NSString *)formatterType
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:formatterType];
    return [dateFormatter stringFromDate:date];
}

+ (NSDate *)string2Date:(NSString *)dateStr withFormatterType:(NSString *)formatterType
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:formatterType];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    if (date)
    {
        
    }
    else
    {
        [dateFormatter setDateFormat:KDateFormatterTypeYMDHMS];
        date = [dateFormatter dateFromString:dateStr];
        if (!date)
        {
            [dateFormatter setDateFormat:KDateFormatterTypeYMDHM];
            date = [dateFormatter dateFromString:dateStr];
            
            if (!date)
            {
                [dateFormatter setDateFormat:KDateFormatterTypeYMD];
                date = [dateFormatter dateFromString:dateStr];
            }
        }
    }
    
    return date;
}

+ (NSString *)changeDateToFormatterString:(NSString *)dataTraStr
{
    NSDate *dataTra = [self string2Date:dataTraStr withFormatterType:KDateFormatterTypeYMDHMS];
    NSDate *date = [NSDate date];
    NSTimeInterval timeInterval = [date timeIntervalSinceDate:dataTra];
    int day = (int)(timeInterval/(60*60*24));
    NSString *timeStr = @"";
    if (day>0)
    {
        timeStr = [NSString stringWithFormat:@"%d天前",day];
    }
    else
    {
        int hour = (int)(timeInterval/(60*60));
        if (hour>0)
        {
            timeStr = [NSString stringWithFormat:@"%d小时前",hour];
        }
        else
        {
            int minute = (int)(timeInterval/60);
            if (minute>0)
            {
                timeStr = [NSString stringWithFormat:@"%d分钟前",minute];
            }
            else
            {
                if ((int)timeInterval==0)
                {
                    timeStr = @"1分钟前";
                }
                else
                {
                    timeStr = [NSString stringWithFormat:@"%d秒前",(int)timeInterval];
                }
                
            }
        }
    }
    return timeStr;
}

+ (NSString *)stringToString:(NSString *)str
{
    return [self NullToEmpty:str];
}

+ (id)stringToIntNumber:(NSString *)str
{
    if ([str isEqualToString:@""])
    {
        return @"";
    }
    return [NSNumber numberWithInt:[str intValue]];
}

+ (id)stringToFloatNumber:(NSString *)str
{
    if ([str isEqualToString:@""])
    {
        return @"";
    }
    return [NSNumber numberWithFloat:[str floatValue]];

}

+ (NSString *)numberToString:(NSNumber *)num
{
    if ([self isNumber:num])
    {
        return [NSString stringWithFormat:@"%@",num];
    }
    else
    {
        if ([self isNull:num])
        {
            return @"";
        }
        else
        {
            return (NSString *)num;
        }
    }

}

+ (NSString *)arrayToJsonString:(NSArray *)ary
{
    if (!ary)
    {
        ary = [[NSArray alloc]init];
    }
    NSString *jsonStr = [[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:ary options:kNilOptions error:nil] encoding:NSUTF8StringEncoding];
    return jsonStr;
}

+ (NSString *)dictionaryToJsonString:(NSDictionary *)dict
{
    return [[NSString alloc]initWithData:[NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:nil] encoding:NSUTF8StringEncoding];
}

+ (NSString *)encodeBase64String:(NSString *)base64Str
{
    if (base64Str.length>0)
    {
        NSData *nsdata = [base64Str
                          dataUsingEncoding:NSUTF8StringEncoding];
        
        // Get NSString from NSData object in Base64
        NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
        
        return base64Encoded;
    }
    else
    {
        return base64Str;
    }
    
}

+ (NSString *)decodeBase64String:(NSString *)base64Str
{
    
    if (base64Str&&[base64Str isKindOfClass:[NSString class]]&&base64Str.length>0)
    {
//        if (![self checkStrIsBase64Encoded:base64Str])
//        {
//            return base64Str;
//        }
        NSData *dataFromBase64Str = [[NSData alloc]initWithBase64EncodedString:base64Str options:0];
        NSString *base64Decoded = [[NSString alloc]
                                   initWithData:dataFromBase64Str encoding:NSUTF8StringEncoding];
        
        return base64Decoded;
    }
    else
    {
        return base64Str;
    }
}

+ (BOOL)checkStrIsBase64Encoded:(NSString *)checkStr
{
    log(@"checkStr:%@",checkStr);
    NSString *myNewStr = [self encodeBase64String:checkStr];
    log(@"myNewStr:%@",myNewStr);
    BOOL isBase64 = NO;
    if ([myNewStr isEqualToString:checkStr])
    {
        isBase64 = YES;
    }
    else
    {
        isBase64 = NO;
    }
    return isBase64;
}

#pragma mark -
#pragma mark - private Method


+ (NSString *)NullToEmpty:(NSString *)str
{
    if ([self isNull:str])
    {
        return @"";
    }
    else
    {
        return str;
        
    }
}

+ (BOOL)isNumber:(id)obj
{
    if ([obj isKindOfClass:[NSNumber class]])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)isNull:(id)obj
{
    if ([obj isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    else if(!obj)
    {
        return YES;
    }
    else if ([obj  isEqual: @"(null)"])
    {
        return YES;
    }
    else if ([obj isEqual:@"null"])
    {
        return YES;
    }
    else if ([obj isEqual:@"<null>"])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (NSString *)md5:(NSString *)md5Str
{
    const char *cStr = [md5Str UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, (int)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:32];
    
    for(int i = 0; i < 16; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}


+ (NSString*)createRank:(NSMutableDictionary*)dict
{
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (id categoryId in sortedArray) {
//        if (   ![[dict objectForKey:categoryId] isEqualToString:@""]
//            && ![categoryId isEqualToString:@"sign"]
//            && ![categoryId isEqualToString:@"key"]
//            )
//        if ([[dict objectForKey:categoryId] isKindOfClass:[NSString class]]) {
//            NSString *encodedString = [[dict objectForKey:categoryId] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//
//        }else{
        [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];

//        }
        
//        }
    }
    
    NSString *newContent = [contentString substringToIndex:[contentString length] - 1];
//    NSString *strUrl1 = [newContent stringByReplacingOccurrencesOfString:@" " withString:@""];
//    NSString *strUrl3 = [strUrl1 stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    //转换
    NSString * encodedString = (__bridge_transfer  NSString*) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)newContent, NULL, (__bridge CFStringRef)@"!*'();:@+$,/?%#[]&=", kCFStringEncodingUTF8 );
//    NSString *encodedString = [newContent stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *strUrl1 = [encodedString stringByReplacingOccurrencesOfString:@"%20" withString:@"+"];
    return strUrl1;
}

+ (NSString*)createCommentRank:(NSMutableDictionary*)dict
{
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (id categoryId in sortedArray) {
        //转换
        if ([[dict objectForKey:categoryId] isKindOfClass:[NSString class]]) {
            if ([categoryId isEqualToString:@"remark"] || [categoryId isEqualToString:@"content"] || [categoryId isEqualToString:@"job_name"] || [categoryId isEqualToString:@"interest"] || [categoryId isEqualToString:@"tags"] || [categoryId isEqualToString:@"tag_ids"]) {
                [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
            }else{
                NSString * encodedString = (__bridge_transfer  NSString*) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)[dict objectForKey:categoryId], NULL, (__bridge CFStringRef)@"!*'();:@+$,/?%#[]", kCFStringEncodingUTF8 );
                [contentString appendFormat:@"%@=%@&", categoryId, encodedString];
            }
        }else{
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
        
    }
    NSString *newContent = [contentString substringToIndex:[contentString length] - 1];
    NSString * encodedString = (__bridge_transfer  NSString*) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)newContent, NULL, (__bridge CFStringRef)@"&=", kCFStringEncodingUTF8 );

    return encodedString;
}
//向左位移5
+ (NSString *)leftDisplacementOfFive
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *myDate = [dateFormatter stringFromDate:[NSDate date]];
    
    long long timeStr =[myDate longLongValue];
    
    timeStr = timeStr << 5;
    
    NSString *newTimeStr = [NSString stringWithFormat:@"%lld",timeStr];
    
    return newTimeStr;
}

//sha265加密
+ (NSString *)getSha256String:(NSString *)srcString
{
    const char *cstr = [srcString cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:srcString.length];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH];
    
    int myLenght = [[NSString stringWithFormat:@"%lu",(unsigned long)data.length] intValue]/2;
    
    CC_SHA256(data.bytes, myLenght, digest);
    
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return result;
}

#pragma mark- DES加密算法
+(NSString *) encryptUseDES:(NSString *)plainText key:(NSString *)key
{
    NSString *ciphertext = nil;
    NSData *textData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [textData length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          ccPKCS7Padding|kCCOptionECBMode,
                                          [key UTF8String], kCCKeySizeDES,
                                          iv,
                                          [textData bytes], dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        ciphertext = [self encode:data];
       
    }
    return ciphertext;
}


#pragma mark- DES解密算法
+(NSString *)decryptUseDES:(NSString *)cipherText key:(NSString *)key
{
    NSString *plaintext = nil;
    NSData *cipherdata = [self decode:cipherText];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    // kCCOptionPKCS7Padding|kCCOptionECBMode 最主要在这步
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          [key UTF8String], kCCKeySizeDES,
                                          iv,
                                          [cipherdata bytes], [cipherdata length],
                                          buffer, 1024,
                                          &numBytesDecrypted);
    if(cryptStatus == kCCSuccess) {
        NSData *plaindata = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plaintext = [[NSString alloc]initWithData:plaindata encoding:NSUTF8StringEncoding];
    }
    return plaintext;
}

#pragma mark- DES_CBC加密算法
+(NSString *) encryptUseDES_CBC:(NSString *)plainText key:(NSString *)key
{
    NSString *ciphertext = nil;
    NSData *textData = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [textData length];
    unsigned char buffer[10*dataLength];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    const  void *iv = (const void *)[key UTF8String];
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmDES,
                                          ccPKCS7Padding,
                                          [key UTF8String], kCCKeySizeDES,
                                          iv,
                                          [textData bytes], dataLength,
                                          buffer, 10*dataLength,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        NSString *oriStr = [NSString stringWithFormat:@"%@",data];
        NSCharacterSet *cSet = [NSCharacterSet characterSetWithCharactersInString:@"< >"];
        ciphertext = [[[oriStr componentsSeparatedByCharactersInSet:cSet] componentsJoinedByString:@""] uppercaseString];
    }else{
        ciphertext =@"";
    }
    return ciphertext;
}



#pragma mark- DES_CBC解密算法
+(NSString *)decryptUseDES_CBC:(NSString *)cipherText key:(NSString *)key
{

     const  void *iv = (const void *)[key UTF8String];
    NSData* data = [self parseHexToByteArray:cipherText];
    
    NSUInteger bufferSize=([data length] + kCCKeySizeDES) & ~(kCCKeySizeDES -1);
    
    char buffer[bufferSize];
    
    memset(buffer, 0,sizeof(buffer));
    
    size_t bufferNumBytes;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          
                                          kCCAlgorithmDES,
                                          
                                          kCCOptionPKCS7Padding,
                                          
                                          [key UTF8String],
                                          
                                          kCCKeySizeDES,
                                          
                                          iv,
                                          
                                          [data bytes],
                                          
                                          [data length],
                                          
                                          buffer,
                                          
                                          bufferSize,
                                          
                                          &bufferNumBytes);
    
    NSString* plainText = nil;
    
    if (cryptStatus ==kCCSuccess) {
        
        NSData *plainData =[NSData dataWithBytes:buffer length:(NSUInteger)bufferNumBytes];
        
        plainText = [[NSString alloc] initWithData:plainData encoding:NSUTF8StringEncoding];
    }
    
    return plainText;
}




//base64加密
+(NSString *)encode:(NSData *)data
{
    if (data.length == 0)
        return nil;
    
    char *characters = malloc(data.length * 3 / 2);
    
    if (characters == NULL)
        return nil;
    
    
    int end = [[NSString stringWithFormat:@"%lu",(unsigned long)data.length - 3] intValue];
    
    int index = 0;
    int charCount = 0;
    int n = 0;
    
    while (index <= end) {
        int d = (((int)(((char *)[data bytes])[index]) & 0x0ff) << 16)
        | (((int)(((char *)[data bytes])[index + 1]) & 0x0ff) << 8)
        | ((int)(((char *)[data bytes])[index + 2]) & 0x0ff);
        
        characters[charCount++] = encodingTable[(d >> 18) & 63];
        characters[charCount++] = encodingTable[(d >> 12) & 63];
        characters[charCount++] = encodingTable[(d >> 6) & 63];
        characters[charCount++] = encodingTable[d & 63];
        
        index += 3;
        
        if(n++ >= 14)
        {
            n = 0;
            characters[charCount++] = ' ';
        }
    }
    
    if(index == data.length - 2)
    {
        int d = (((int)(((char *)[data bytes])[index]) & 0x0ff) << 16)
        | (((int)(((char *)[data bytes])[index + 1]) & 255) << 8);
        characters[charCount++] = encodingTable[(d >> 18) & 63];
        characters[charCount++] = encodingTable[(d >> 12) & 63];
        characters[charCount++] = encodingTable[(d >> 6) & 63];
        characters[charCount++] = '=';
    }
    else if(index == data.length - 1)
    {
        int d = ((int)(((char *)[data bytes])[index]) & 0x0ff) << 16;
        characters[charCount++] = encodingTable[(d >> 18) & 63];
        characters[charCount++] = encodingTable[(d >> 12) & 63];
        characters[charCount++] = '=';
        characters[charCount++] = '=';
    }
    NSString * rtnStr = [[NSString alloc] initWithBytesNoCopy:characters length:charCount encoding:NSUTF8StringEncoding freeWhenDone:YES];
    return rtnStr;
    
}
//base64解密
+(NSData *)decode:(NSString *)data
{
    if(data == nil || data.length <= 0) {
        return nil;
    }
    NSMutableData *rtnData = [[NSMutableData alloc]init];
    int slen = [[NSString stringWithFormat:@"%lu",(unsigned long)data.length] intValue];

    int index = 0;
    while (true) {
        while (index < slen && [data characterAtIndex:index] <= ' ') {
            index++;
        }
        if (index >= slen || index  + 3 >= slen) {
            break;
        }
        
        int byte = ([self char2Int:[data characterAtIndex:index]] << 18) + ([self char2Int:[data characterAtIndex:index + 1]] << 12) + ([self char2Int:[data characterAtIndex:index + 2]] << 6) + [self char2Int:[data characterAtIndex:index + 3]];
        Byte temp1 = (byte >> 16) & 255;
        [rtnData appendBytes:&temp1 length:1];
        if([data characterAtIndex:index + 2] == '=') {
            break;
        }
        Byte temp2 = (byte >> 8) & 255;
        [rtnData appendBytes:&temp2 length:1];
        if([data characterAtIndex:index + 3] == '=') {
            break;
        }
        Byte temp3 = byte & 255;
        [rtnData appendBytes:&temp3 length:1];
        index += 4;
        
    }
    return rtnData;
}
+(int)char2Int:(char)c
{
    if (c >= 'A' && c <= 'Z') {
        return c - 65;
    } else if (c >= 'a' && c <= 'z') {
        return c - 97 + 26;
    } else if (c >= '0' && c <= '9') {
        return c - 48 + 26 + 26;
    } else {
        switch(c) {
            case '+':
                return 62;
            case '/':
                return 63;
            case '=':
                return 0;
            default:
                return -1;
        }
    }
}

/*
 将16进制数据转化成NSData 数组
 */
+(NSData*)parseHexToByteArray:(NSString*)hexString
{
    int j=0;
    Byte bytes[hexString.length];
    for(int i=0;i<[hexString length];i++)
    {
        int int_ch;  /// 两位16进制数转化后的10进制数
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        i++;
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char1 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        
        int_ch = int_ch1+int_ch2;
        bytes[j] = int_ch;  ///将转化后的数放入Byte数组里
        j++;
    }
    
    NSData *newData = [[NSData alloc] initWithBytes:bytes length:hexString.length/2];
    
    return newData;
}
@end

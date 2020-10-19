//
//  CheckValid.m
//  UTDoorStyle
//
//  Created by CYN on 14-9-28.
//  Copyright (c) 2014年 exmart. All rights reserved.
//

#import "CheckValid.h"
#import "Reachability.h"
#import <UIKit/UIDevice.h>
@implementation CheckValid
+ (BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)isValidatePhone:(NSString *)phone
{
    NSString *regex = @"^((13[0-9])|(14[0-9])|(15[0-9])|(18[0-9])|(17[0-9])|(16[0-9])|(19[0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:phone];
}

+ (BOOL)isValidateZuoJiPhone:(NSString *)phone
{
    NSString *phoneRegex = @"\\d{3}-\\d{8}|\\d{4}-\\d{7,8}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}

+ (BOOL)isTotalNumber:(NSString *)number
{
    NSString *regex = @"^[0-9-]$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:number];
    
}

//一下可修改
+ (BOOL)isValidateWuWeiPhone:(NSString *)phone
{
    NSString *regex = @"^((95[0-9])|(96[0-9])|(10[0-9])|(11[0-9])|(12[0-9])|(16[0-9])|(179))\\d{2}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:phone];
    
}



+ (BOOL)isValidatePassword:(NSString *)password
{
    NSString *regex = @"^[_0-9a-zA-Z]{6,16}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:password];
}

/*
 + (BOOL)isValidateIdentityCard: (NSString *)identityCard
 {
 BOOL flag;
 if (identityCard.length <= 0) {
 flag = NO;
 return flag;
 }
 NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
 NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
 return [identityCardPredicate evaluateWithObject:identityCard];
 }
 */

+ (BOOL)isValidateNetConnection
{
    if([Reachability reachabilityForLocalWiFi].currentReachabilityStatus==NotReachable&&[[Reachability reachabilityForInternetConnection] currentReachabilityStatus]==NotReachable)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}



+ (BOOL)isValidateIdentityCard: (NSString *)identityCard
{
    return [self chk18PaperId:identityCard];
}


/**
 
 * 功能:获取指定范围的字符串
 
 * 参数:字符串的开始小标
 
 * 参数:字符串的结束下标
 
 */



+ (NSString *)getStringWithRange:(NSString *)str Value1:(NSInteger)value1 Value2:(NSInteger )value2;

{
    
    return [str substringWithRange:NSMakeRange(value1,value2)];
    
}



/**
 
 * 功能:判断是否在地区码内
 
 * 参数:地区码
 
 */

+ (BOOL)areaCode:(NSString *)code

{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:@"北京" forKey:@"11"];
    
    [dic setObject:@"天津" forKey:@"12"];
    
    [dic setObject:@"河北" forKey:@"13"];
    
    [dic setObject:@"山西" forKey:@"14"];
    
    [dic setObject:@"内蒙古" forKey:@"15"];
    
    [dic setObject:@"辽宁" forKey:@"21"];
    
    [dic setObject:@"吉林" forKey:@"22"];
    
    [dic setObject:@"黑龙江" forKey:@"23"];
    
    [dic setObject:@"上海" forKey:@"31"];
    
    [dic setObject:@"江苏" forKey:@"32"];
    
    [dic setObject:@"浙江" forKey:@"33"];
    
    [dic setObject:@"安徽" forKey:@"34"];
    
    [dic setObject:@"福建" forKey:@"35"];
    
    [dic setObject:@"江西" forKey:@"36"];
    
    [dic setObject:@"山东" forKey:@"37"];
    
    [dic setObject:@"河南" forKey:@"41"];
    
    [dic setObject:@"湖北" forKey:@"42"];
    
    [dic setObject:@"湖南" forKey:@"43"];
    
    [dic setObject:@"广东" forKey:@"44"];
    
    [dic setObject:@"广西" forKey:@"45"];
    
    [dic setObject:@"海南" forKey:@"46"];
    
    [dic setObject:@"重庆" forKey:@"50"];
    
    [dic setObject:@"四川" forKey:@"51"];
    
    [dic setObject:@"贵州" forKey:@"52"];
    
    [dic setObject:@"云南" forKey:@"53"];
    
    [dic setObject:@"西藏" forKey:@"54"];
    
    [dic setObject:@"陕西" forKey:@"61"];
    
    [dic setObject:@"甘肃" forKey:@"62"];
    
    [dic setObject:@"青海" forKey:@"63"];
    
    [dic setObject:@"宁夏" forKey:@"64"];
    
    [dic setObject:@"新疆" forKey:@"65"];
    
    [dic setObject:@"台湾" forKey:@"71"];
    
    [dic setObject:@"香港" forKey:@"81"];
    
    [dic setObject:@"澳门" forKey:@"82"];
    
    [dic setObject:@"国外" forKey:@"91"];
    
    if ([dic objectForKey:code] == nil) {
        
        return NO;
        
    }
    
    return YES;
    
}



/**
 
 * 功能:验证身份证是否合法
 
 * 参数:输入的身份证号
 
 */

+ (BOOL) chk18PaperId:(NSString *) sPaperId

{
    
    //判断位数
    
    
    if ([sPaperId length] != 15 && [sPaperId length] != 18)
    {
        return NO;
    }
    
    NSString *carid = sPaperId;
    
    long lSumQT =0;
    
    //加权因子
    
    int R[] ={7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };
    
    //校验码
    
    unsigned char sChecker[11]={'1','0','X', '9', '8', '7', '6', '5', '4', '3', '2'};
    
    
    
    //将15位身份证号转换成18位
    
    NSMutableString *mString = [NSMutableString stringWithString:sPaperId];
    
    if ([sPaperId length] == 15) {
        
        [mString insertString:@"19" atIndex:6];
        
        long p = 0;
        
        const char *pid = [mString UTF8String];
        
        for (int i=0; i<=16; i++)
            
        {
            
            p += (pid[i]-48) * R[i];
            
        }
        
        int o = p%11;
        
        NSString *string_content = [NSString stringWithFormat:@"%c",sChecker[o]];
        
        [mString insertString:string_content atIndex:[mString length]];
        
        carid = mString;
        
    }
    
    //判断地区码
    
    NSString * sProvince = [carid substringToIndex:2];
    
    if (![self areaCode:sProvince])
    {
        
        return NO;
        
    }
    
    //判断年月日是否有效
    
    
    
    //年份
    
    int strYear = [[self getStringWithRange:carid Value1:6 Value2:4] intValue];
    
    //月份
    
    int strMonth = [[self getStringWithRange:carid Value1:10 Value2:2] intValue];
    
    //日
    
    int strDay = [[self getStringWithRange:carid Value1:12 Value2:2] intValue];
    
    
    
    NSTimeZone *localZone = [NSTimeZone localTimeZone];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    [dateFormatter setTimeZone:localZone];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date=[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d 12:01:01",strYear,strMonth,strDay]];
    
    if (date == nil)
    {
        
        return NO;
        
    }
    
    const char *PaperId  = [carid UTF8String];
    
    //检验长度
    
    if( 18 != strlen(PaperId)) return -1;
    
    
    
    //校验数字
    
    for (int i=0; i<18; i++)
        
    {
        
        if ( !isdigit(PaperId[i]) && !(('X' == PaperId[i] || 'x' == PaperId[i]) && 17 == i) )
            
        {
            
            return NO;
            
        }
        
    }
    
    //验证最末的校验码
    
    for (int i=0; i<=16; i++)
        
    {
        
        lSumQT += (PaperId[i]-48) * R[i];
        
    }
    
    if (sChecker[lSumQT%11] != PaperId[17] )
        
    {
        
        return NO;
        
    }
    
    
    //    台湾的：1个英文+9个数字
    if(sPaperId.length == 10){
        
        NSString *regexTaiWan = @"[A-Z][0-9]{9}";
        NSPredicate *predTaiWan = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexTaiWan];
        if(![predTaiWan evaluateWithObject:sPaperId]){
            return NO;
            
        }
    }
    
    //    香港的：一个英文+6个数字+（一个校验码0~9或A）
    if (sPaperId.length == 7) {
        
        NSString *regexXiangGang = @"[A-Z][0-9]{6}\([0-9A])";
        NSPredicate *predXiangGang = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexXiangGang];
        if(![predXiangGang evaluateWithObject:sPaperId]){
            return NO;
            
        }
    }
    
    //    澳门的：第一位1、5、7，后面7个数字，最后带括号的一位校验码【不知道有没有字母】
    if (sPaperId.length == 8) {
        
        NSString *regexAoMen = @"[157][0-9]{6}\([0-9])";
        NSPredicate *predAoMen = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexAoMen];
        if(![predAoMen evaluateWithObject:sPaperId]){
            return NO;
            
        }
    }
    
    
    
    
    return YES;
    
}

+ (BOOL)isIncludeEmoji:(NSString *)str
{
    __block BOOL isEomji = NO;
    [str enumerateSubstringsInRange:NSMakeRange(0, [str length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    isEomji = YES;
                }
            }
        } else {
            // non surrogate
            if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                isEomji = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                isEomji = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                isEomji = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                isEomji = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                isEomji = YES;
            }
            if (!isEomji && substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                if (ls == 0x20e3) {
                    isEomji = YES;
                }
            }
        }
    }];
    return isEomji;
}
#pragma mark - 判断字符串
//返回 网址在字符串中的位置
+ (NSRange)HadTel:(NSString *)string{
    NSRange resultRange = {0,0};
    NSError *error;
    NSString *regulaStr = @"\\d{3}-\\d{8}|\\d{3}-\\d{7}|\\d{4}-\\d{8}|\\d{4}-\\d{7}|1+[358]+\\d{9}|\\d{8}|\\d{7}";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (regex != nil) {
        NSTextCheckingResult *firstMatch = [regex firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
        
        if (firstMatch) {
            resultRange = [firstMatch rangeAtIndex:0];
            return resultRange;
        }
    }
    
    return resultRange;
}

#pragma mark - 判断字符串
//返回 网址在字符串中的位置
+ (NSRange)HadUrl:(NSString *)string{
    NSRange resultRange = {0,0};
    NSError *error;
    NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    if (regex != nil) {
        NSTextCheckingResult *firstMatch = [regex firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
        
        if (firstMatch) {
            resultRange = [firstMatch rangeAtIndex:0];
            return resultRange;
        }
    }
    
    return resultRange;
}

// 是否是整形数字
+ (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
//判断是否为浮点形：
+ (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}
//网址英文域名结尾的结尾
+ (BOOL)isEndWithUrl:(NSString *)string{
    if ([string hasSuffix:@".com"] ||[string hasSuffix:@".cn"]||[string hasSuffix:@".net"]||[string hasSuffix:@".xyz"]||[string hasSuffix:@".co"]||[string hasSuffix:@".cn.com"]||[string hasSuffix:@".org"]||[string hasSuffix:@".hk"]||[string hasSuffix:@".la"]||[string hasSuffix:@".asia"]||[string hasSuffix:@".pw"]||[string hasSuffix:@".biz"]||[string hasSuffix:@".mobi"]||[string hasSuffix:@".net.cn"]||[string hasSuffix:@".org.cn"]||[string hasSuffix:@".gov.cn"]||[string hasSuffix:@".name"]||[string hasSuffix:@".info"]||[string hasSuffix:@".com.hk"]||[string hasSuffix:@".tm"]||[string hasSuffix:@".tv"]||[string hasSuffix:@".tel"]||[string hasSuffix:@".us"]||[string hasSuffix:@".tw"]||[string hasSuffix:@".website"]||[string hasSuffix:@".host"]||[string hasSuffix:@".site"]||[string hasSuffix:@".in"]||[string hasSuffix:@".mn"]||[string hasSuffix:@".eu"]||[string hasSuffix:@".ca"]||[string hasSuffix:@".es"]||[string hasSuffix:@".vip"]||[string hasSuffix:@".store"]||[string hasSuffix:@".htm"]||[string hasSuffix:@".html"]) {
        return YES;
    }else{
        return NO;
    }
    
    
}

//汉字
+ (BOOL)isHZ:(NSString *)string
{
    NSString *regex = @"^[\u4e00-\u9fa5]{0,}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:string];
}

//数字
+ (BOOL)isSZ:(NSString *)string
{
    NSString *regex = @"^[0-9]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:string];
}

//小写字母
+ (BOOL)isXXZM:(NSString *)string
{
    NSString *regex = @"^[a-z]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:string];
}

//大写字母
+ (BOOL)isDXZM:(NSString *)string
{
    NSString *regex = @"^[A-Z]+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:string];
}


//特殊符号
+(BOOL)isIncludeSpecialCharact: (NSString *)str
{
    //***需要过滤的特殊字符：~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€。
    NSRange urgentRange = [str rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€"]];
    if (urgentRange.location == NSNotFound)
    {
        return NO;
    }
    return YES;
}

// 去除文字首尾的换行符和空格
+ (NSString *)removeSpaceAndNewline:(NSString *)str
{
    // 如果字符串中有一个换行符不去除它,大于1个那么就删除其它的
    NSString *temp = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //    NSString *newNewStr =[temp stringByReplacingOccurrencesOfString:@"\n\n" withString:@"\n"];
    NSString *text = [temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\n{2,}" options:NSRegularExpressionCaseInsensitive error:&error];

    NSArray *arr = [regex matchesInString:text options:NSMatchingReportCompletion range:NSMakeRange(0, [text length])];
    arr = [[arr reverseObjectEnumerator] allObjects];
    for (NSTextCheckingResult *str in arr) {
        text = [text stringByReplacingCharactersInRange:[str range] withString:@"\n\n"];
    }
    
    NSRegularExpression *regexWhite = [NSRegularExpression regularExpressionWithPattern:@"\\n\\s{2,}" options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *arrWhite = [regexWhite matchesInString:text options:NSMatchingReportCompletion range:NSMakeRange(0, [text length])];
    arrWhite = [[arrWhite reverseObjectEnumerator] allObjects];
    for (NSTextCheckingResult *str in arrWhite) {
        text = [text stringByReplacingCharactersInRange:[str range] withString:@"\n\n"];
    }
    return text;
    
}


//判断字符串为空和只为空格解决办法
+ (BOOL)isBlankString:(NSString *)string{
    
    if (string == nil) {
        return YES;
    }
    
    if (string == NULL) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

// 判断内容全部为英文
+ (BOOL)containEngish:(NSString *)str
{
    NSRegularExpression *tLetterRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger tLetterMatchCount = [tLetterRegularExpression numberOfMatchesInString:str options:NSMatchingReportProgress range:NSMakeRange(0, str.length)];
    if (tLetterMatchCount == str.length) {
        return YES;
    }
    return NO;
}

// 判断内容为文字，数字，字母组合
+ (NSString *)checkContentTypeWithString:(NSString*)password{
    // 汉字条件
    NSRegularExpression *tTxtRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[\u4e00-\u9fa5]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    //符合汉字条件的有几个字节
    NSUInteger tTxtMatchCount = [tTxtRegularExpression numberOfMatchesInString:password options:NSMatchingReportProgress range:NSMakeRange(0, password.length)];
    
    //数字条件
    NSRegularExpression *tNumRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    //符合数字条件的有几个字节
    NSUInteger tNumMatchCount = [tNumRegularExpression numberOfMatchesInString:password options:NSMatchingReportProgress range:NSMakeRange(0, password.length)];
    
    //英文字条件
    NSRegularExpression *tLetterRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    //符合英文字条件的有几个字节
    NSUInteger tLetterMatchCount = [tLetterRegularExpression numberOfMatchesInString:password options:NSMatchingReportProgress range:NSMakeRange(0, password.length)];
    
    //特殊字符条件
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[\\p{P}~^<>]" options:NSRegularExpressionCaseInsensitive error:nil];
    //符合特殊字符条件的有几个字节
    NSUInteger regexCount = [regex numberOfMatchesInString:password options:NSMatchingReportProgress range:NSMakeRange(0, password.length)];
    
    if(0 == password.length) {
        
        // 无内容
        return @"";
        
    }else if(tLetterMatchCount == password.length) {
        
        //全部符合英文，表示沒有数字
        return @"全部为英文";
        
    }else if(tNumMatchCount == password.length) {
        
        //全部符合数字，表示沒有英文
        return @"全部为数字";
        
    }else if(tTxtMatchCount == password.length){
        
        //全部为汉字
        return @"全部为汉字";
        
    } else if(tNumMatchCount + tLetterMatchCount == password.length) {
        
        //符合英文和符合数字条件的相加等于密码长度
        return @"全部为数字和英文结合";
        
    } else if(tNumMatchCount + tLetterMatchCount + tTxtMatchCount == password.length) {
        
        //内容为文字，数字，字母组合
        return @"内容为文字，数字，字母组合";
    }else if (tLetterMatchCount + tTxtMatchCount + regexCount == password.length){
        return @"内容为文字，字母，字符组合";
    }else if(regexCount == password.length){
        return @"全部为字符";
    }
    return @"规则错误";
}

@end

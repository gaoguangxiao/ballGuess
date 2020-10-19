//
//  UIColor+RRCColor.m
//  MXSFramework
//
//  Created by 晓松 on 2018/11/16.
//  Copyright © 2018年 MXS. All rights reserved.
//

#import "UIColor+RRCColor.h"
#import "RRCColorLib.h"

@implementation UIColor (RRCColor)

//后期再变
+(UIColor *)viewColorDefault:(NSString *)defaultColor{
    return [self textColorDefault:defaultColor];
}

+(UIColor *)textColorDefault:(NSString *)defaultColor{
    NSString *_defaultColor = defaultColor;
    if (!defaultColor) {
        return [UIColor clearColor];
    }
    if ([_defaultColor hasPrefix:@"0x"])
        _defaultColor = [_defaultColor substringFromIndex:2];
    if ([_defaultColor hasPrefix:@"#"])
        _defaultColor = [_defaultColor substringFromIndex:1];
    
    return [self HandleDarkModelColor:_defaultColor];
}

//color 只能是 一串数字
+(UIColor *)HandleDarkModelColor:(NSString *)color{
    NSString *colorKey = [NSString stringWithFormat:@"#%@",color];
    NSString *userColor = [AppearanceLightColorDict valueForKey:colorKey];
    if (userColor == nil) {
        return [UIColor colorWithKey:colorKey];;
    }
       UIColor *tintColor;
       if (@available(iOS 13.0, *)) {
           tintColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
               if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
                   NSString *darkValueColor = [AppearanceDarkColorDict valueForKey:colorKey];
                   return [UIColor colorWithKey:darkValueColor];
               }else{
                   UIColor *lightColor = [UIColor colorWithKey:userColor];
                   return lightColor;
               }
           }];
       } else {// Fallback on earlier versions
           tintColor = [UIColor colorWithKey:userColor];
       }
       return tintColor;
}

+(UIColor *)colorWithKey:(NSString *)key{
    UIColor *tempColor;
    if (!key || [key length] <= 8) {
        tempColor = [self colorValueString:key];
    }else{
        tempColor = [self colorWithHexStringAlpha:key];
    }
    return tempColor;
}

+(UIColor *)colorValueString:(NSString *)color{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}


+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    //R、G、B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+ (UIColor *) colorWithHexStringAlpha: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    // 判断前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 8)
        return [UIColor clearColor];
    // 从六位数值中找到RGB对应的位数并转换
    NSRange range;
    
    range.location = 0;
    range.length = 2;
    NSString *aString = [cString substringWithRange:range];
    //R、G、B
    range.location = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 4;
    NSString *gString = [cString substringWithRange:range];
    range.location = 6;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:((float) [aString floatValue] / 100.0f)];
}

@end

//
//  UIColor+RRCColor.h
//  MXSFramework
//
//  Created by 晓松 on 2018/11/16.
//  Copyright © 2018年 MXS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (RRCColor)

/// 传入之前默认主题的颜色
/// @param defaultColor <#defaultColor description#>
+(UIColor *)textColorDefault:(NSString *)defaultColor;


+(UIColor *)viewColorDefault:(NSString *)defaultColor;

// 颜色转换：iOS中（以#开头）十六进制的颜色转换为UIColor(RGB)
+ (UIColor *) colorWithHexString: (NSString *)color;


@end

NS_ASSUME_NONNULL_END

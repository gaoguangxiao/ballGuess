//
//  UIColor+Compare.h
//  MXSFramework
//
//  Created by gaoguangxiao on 2020/4/24.
//  Copyright © 2020 MXS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Compare)

/// 获取字体颜色
/// @param a 旧值
/// @param b 新值 大红色
+(UIColor *)getColorForCompare:(NSString *)a andB:(NSString *)b;

/// 获取字体背景颜色
/// @param a 上一次的数值
/// @param b 当前的数值
+(UIColor *)getBackColorForCompare:(NSString *)a andB:(NSString *)b;

@end

NS_ASSUME_NONNULL_END

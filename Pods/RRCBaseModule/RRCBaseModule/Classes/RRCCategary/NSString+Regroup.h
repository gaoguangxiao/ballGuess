//
//  NSString+Regroup.h
//  MXSFramework
//
//  Created by gaoguangxiao on 2020/4/22.
//  Copyright © 2020 MXS. All rights reserved.
//  字符串重组 0.25 -> 0/0.5

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Regroup)

+(NSString *)regroupPointCount:(NSString *)decimalString;

/// 截取字数返回...
/// @param toIndex <#toIndex description#>
-(NSString *)regrouSubstringToIndex:(NSInteger)toIndex;
@end

NS_ASSUME_NONNULL_END

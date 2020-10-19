//
//  UILabel+LineAndWordSpace.h
//  DyStudent
//
//  Created by 梁永升 on 2018/8/29.
//  Copyright © 2018年 梁永升. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (DYLineWordSpace)

/**
 *  改变行间距
 */
- (NSMutableAttributedString *)changeLineSpace:(float)space;


/// 改变行间距 还可以定义 显示模式
/// @param space 间距
/// @param lineBreakMode 字符不够显示模式
- (NSMutableAttributedString *)changeLineSpace:(float)space andLineBreakMode:(NSLineBreakMode)lineBreakMode;

/**
 *  改变字间距
 */
- (NSMutableAttributedString *)changeWordSpace:(float)space;

/**
 *  改变行间距和字间距
 */
- (NSMutableAttributedString *)changeLineSpace:(float)lineSpace WordSpace:(float)wordSpace;

/**
 *  改变一段字符串中某些字符的颜色

 @param color 指定的颜色
 @param text 指定的字符
 @return 处理之后的富文本
 */
-(NSMutableAttributedString *)changeTextColor:(UIColor *)color text:(NSString *)text;


/// 改变一段字符串字符颜色并设置间距
/// @param color 字符串颜色
/// @param text 字符串
/// @param font 字体大小
/// @param space 间距
-(NSMutableAttributedString *)changeTextColor:(UIColor *)color text:(NSString *)text andFont:(UIFont *)font andLineSpace:(float)space andOtherFont:(UIFont *)otherFont andOtherColor:(UIColor *)otherColor;
@end

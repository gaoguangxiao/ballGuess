//
//  UILabel+LineAndWordSpace.m
//  DyStudent
//
//  Created by 梁永升 on 2018/8/29.
//  Copyright © 2018年 梁永升. All rights reserved.
//

#import "NSString+DYLineWordSpace.h"

@implementation NSString (DYLineWordSpace)

- (NSMutableAttributedString *)changeLineSpace:(float)space {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self length])];
    return attributedString;
}

- (NSMutableAttributedString *)changeLineSpace:(float)space andLineBreakMode:(NSLineBreakMode)lineBreakMode{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    paragraphStyle.lineBreakMode = lineBreakMode;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self length])];
    return attributedString;
}

- (NSMutableAttributedString *)changeWordSpace:(float)space {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self attributes:@{NSKernAttributeName:@(space)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self length])];
    return attributedString;
}

- (NSMutableAttributedString *)changeLineSpace:(float)lineSpace WordSpace:(float)wordSpace {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self attributes:@{NSKernAttributeName:@(wordSpace)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self length])];
    return attributedString;
}

-(NSMutableAttributedString *)changeTextColor:(UIColor *)color text:(NSString *)text{
    NSRange range = [self rangeOfString:text];
    NSMutableAttributedString *tip = [[NSMutableAttributedString alloc] initWithString:self];
    [tip addAttribute:NSForegroundColorAttributeName value:color range:range];
    return tip;
}

-(NSMutableAttributedString *)changeTextColor:(UIColor *)color text:(NSString *)text andFont:(UIFont *)font andLineSpace:(float)space andOtherFont:(UIFont *)otherFont andOtherColor:(UIColor *)otherColor{
    
    NSMutableAttributedString *tip = [[NSMutableAttributedString alloc] initWithString:self];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    
    NSString *awayRang = text;
    NSString *awayName = self;
    
    [tip addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, awayName.length)];
    
    [tip addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, awayRang.length)];
    [tip addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, awayRang.length)];
    
    [tip addAttribute:NSForegroundColorAttributeName value:otherColor range:NSMakeRange(awayRang.length,awayName.length - awayRang.length)];
    [tip addAttribute:NSFontAttributeName value:otherFont range:NSMakeRange(awayRang.length,awayName.length - awayRang.length)];
    return tip;
}
@end

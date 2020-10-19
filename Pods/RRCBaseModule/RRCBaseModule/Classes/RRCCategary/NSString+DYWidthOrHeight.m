//
//  NSString+WidthOrHeight.m
//  dianbo17
//
//  Created by Apple on 16/4/13.
//  Copyright © 2016年 17dianbo. All rights reserved.
//

#import "NSString+DYWidthOrHeight.h"

@implementation NSString (DYWidthOrHeight)

- (float)LabelHeight:(float)fontSize width:(float)width{
    CGSize size = CGSizeMake(width, 20000.0f);
    size = [self boundingRectWithSize:size options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]} context:nil].size;
    return size.height;
}


- (float)LabelWidth:(float)fontSize{
    CGSize maxSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
    float width = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]} context:nil].size.width;
    return width;
}

- (float)LabelBoldWidth:(float)fontSize{
    CGSize maxSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
    float width = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:fontSize]} context:nil].size.width;
    return width;
}

@end

//
//  RRCLabel.h
//  MXSFramework
//
//  Created by 晓松 on 2018/9/29.
//  Copyright © 2018年 MXS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRCLabel : UILabel
@property (nonatomic, assign) UIEdgeInsets edgeInsets; // 控制字体与控件边界的间隙


/**
 是否启动数目layer自动加圆角,一位数字圆
 */
@property (nonatomic, assign) BOOL isLayerCount;

/**
 设置富文本行高

 @param lineSpacing lineSpacing description
 @param ContentStr ContentStr description
 @return return value description
 */
-(NSMutableAttributedString *)lineSpace:(CGFloat)lineSpacing withContentStr:(NSString *)ContentStr;

/**
 计算富文本高度

 @param text text description
 @param lineSpeace lineSpeace description
 @param font font description
 @param width width description
 @return return value description
 */
-(CGFloat)getSpaceLabelHeightwithText:(NSString *)text Speace:(CGFloat)lineSpeace withFont:(UIFont*)font withWidth:(CGFloat)width;
@end

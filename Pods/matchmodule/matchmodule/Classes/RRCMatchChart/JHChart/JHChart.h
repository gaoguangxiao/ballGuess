//
//  JHChart.h
//  JHChartDemo
//
//  Created by 简豪 on 16/4/10.
//  Copyright © 2016年 JH. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define P_M(x,y) CGPointMake(x, y)

#define weakSelf(weakSelf)  __weak typeof(self) weakself = self;
#define XORYLINEMAXSIZE CGSizeMake(CGFLOAT_MAX,30)
#define K_ChartViewTag 1000
@interface JHChart : UIView


/**
 *  The margin value of the content view chart view
 *  图表的边界值
 */
@property (nonatomic, assign) UIEdgeInsets contentInsets;


/**
 *  The origin of the chart is different from the meaning of the origin of the chart. 
    As a pie chart and graph center ring. The line graph represents the origin.
 *  图表的原点值（如果需要）
 */
@property (assign, nonatomic)  CGPoint chartOrigin;


/**
 *  Name of chart. The name is generally not displayed, just reserved fields
 *  图表名称
 */
@property (copy, nonatomic) NSString * chartTitle;


/**
 *  The fontsize of Y line text.Default id 8;
 */
@property (nonatomic,assign) CGFloat yDescTextFontSize;

/*!
 * if animationDuration <= 0,this chart will display without animation.Default is 2.0;
 */
@property (nonatomic , assign)NSTimeInterval animationDuration;

/**
 *  The fontsize of X line text.Default id 8;
 */
@property (nonatomic,assign) CGFloat xDescTextFontSize;


/**
 *  X, Y axis line color
 */
@property (nonatomic, strong) UIColor * xAndYLineColor;

/**
 绘制时 是否展示动画,默认展示
 */
@property(nonatomic, assign) BOOL isHiddenAnimations;
/**
 *  Start drawing chart.
 */
- (void)showAnimation;

/**
 *  Clear current chart when refresh
 */
- (void)clear;

/**
 chart view tap with view's tag
 */
- (void)chartViewTapEvent:(NSInteger)viewTag;


/**
 button action

 @param buttonTag <#buttonTag description#>
 */
- (void)chartViewButtonEvent:(NSInteger)buttonTag;

/// Draw a line according to the conditions
/// @param context 上下文
/// @param start Draw Starting Point
/// @param end Draw Ending Point
/// @param isDotted Is the dotted line
/// @param color Line color
- (void)drawLineWithContext:(CGContextRef )context
               andStarPoint:(CGPoint )start
                andEndPoint:(CGPoint)end
            andIsDottedLine:(BOOL)isDotted
                   andColor:(UIColor *)color;

- (void)drawLineDotWidthWithContext:(CGContextRef )context andStarPoint:(CGPoint )start andEndPoint:(CGPoint)end andIsDottedLine:(BOOL)isDotted andColor:(UIColor *)color;


/// Draw a piece of text at a point
/// @param text text
/// @param context 上下文
/// @param point Draw position
/// @param color TextColor
/// @param fontSize Text font size
- (void)drawText:(NSString *)text
      andContext:(CGContextRef )context
         atPoint:(CGPoint )point
       WithColor:(UIColor *)color
     andFontSize:(CGFloat)fontSize;


/// 绘制图片
/// @param text 图片名字
/// @param rect 位置
- (void)drawImageText:(NSString *)text
              atPoint:(CGRect)rect;

- (void)drawImageView:(NSString *)text
           andContext:(CGContextRef )context
               atRect:(CGRect )rect;

/**
 *  Similar to the above method
 *
 */
- (void)drawText:(NSString *)text
         context:(CGContextRef )context
         atPoint:(CGRect )rect
       WithColor:(UIColor *)color
            font:(UIFont*)font;

- (void)drawTitleText:(NSString *)text
              atPoint:(CGRect )rect
            WithColor:(UIColor *)color
                 font:(UIFont*)font;

-(void)drawViewWithTag:(NSInteger)tag andContext:(CGContextRef )context atPoint:(CGRect )rect;

//绘制统计but
-(void)drawBtn:(NSString *)TitleName
       andRect:(CGRect)rect
       andFont:(UIFont *)font
  andbackColor:(UIColor *)color;

/**
 *  Determine the width of a certain segment of text in the default font.
 */
- (CGFloat)getTextWithWhenDrawWithText:(NSString *)text;

/**
 *  Draw a rectangle at a point
 *  p:Draw position
 *
 */
- (void)drawQuartWithColor:(UIColor *)color
             andBeginPoint:(CGPoint)p
                andContext:(CGContextRef)contex;

/// Draw a circle at a point
/// @param redius Circle redius
/// @param color color
/// @param p Draw position
/// @param contex 上下文
- (void)drawPointWithRedius:(CGFloat)redius
                   andColor:(UIColor *)color
                   andPoint:(CGPoint)p
                 andContext:(CGContextRef)contex;

/// According to the relevant conditions to determine the width of the text
/// @param maxSize Maximum range of text
/// @param fontSize Text font
/// @param aimString Text that needs to be measured
- (CGSize)sizeOfStringWithMaxSize:(CGSize)maxSize
                         textFont:(CGFloat)fontSize
                        aimString:(NSString *)aimString;
@end

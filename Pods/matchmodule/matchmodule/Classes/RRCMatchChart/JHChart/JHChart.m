//
//  JHChart.m
//  JHChartDemo
//
//  Created by 简豪 on 16/4/10.
//  Copyright © 2016年 JH. All rights reserved.
//

#import "JHChart.h"
#import "RRCDeviceConfigure.h"
@interface JHChart()



@end
@implementation JHChart

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _xDescTextFontSize = _yDescTextFontSize = 8.0;
        self.xAndYLineColor = [UIColor darkGrayColor];
        self.contentInsets = UIEdgeInsetsMake(10, 20, 10, 10);
        self.chartOrigin = P_M(self.contentInsets.left, CGRectGetHeight(self.frame) - self.contentInsets.bottom);
        self.animationDuration = 2.0;
    }
    return self;
}

-(void)showAnimation{
    
}


-(void)clear{
    
}




/**
 *  绘制线段
 *
 *  @param context  图形绘制上下文
 *  @param start    起点
 *  @param end      终点
 *  @param isDotted 是否是虚线
 *  @param color    线段颜色
 */
- (void)drawLineDotWidthWithContext:(CGContextRef )context andStarPoint:(CGPoint )start andEndPoint:(CGPoint)end andIsDottedLine:(BOOL)isDotted andColor:(UIColor *)color{
    //    移动到点
    CGContextMoveToPoint(context, start.x, start.y);
    //    连接到
    CGContextAddLineToPoint(context, end.x, end.y);
    CGContextSetLineWidth(context, 1.0);
    [color setStroke];
    if (isDotted) {
        CGFloat ss[] = {4.5,4};
        
        CGContextSetLineDash(context, 0, ss, 2);
    }
    CGContextMoveToPoint(context, end.x, end.y);
    
    CGContextDrawPath(context, kCGPathFillStroke);
}
- (void)drawLineWithContext:(CGContextRef )context andStarPoint:(CGPoint )start andEndPoint:(CGPoint)end andIsDottedLine:(BOOL)isDotted andColor:(UIColor *)color{
    //    移动到点
    CGContextMoveToPoint(context, start.x, start.y);
    //    连接到
    CGContextAddLineToPoint(context, end.x, end.y);

    CGContextSetLineWidth(context, 1.0);

    [color setStroke];

    if (isDotted) {
        CGFloat ss[] = {1.5,2};

        CGContextSetLineDash(context, 0, ss, 2);
    }
    CGContextMoveToPoint(context, end.x, end.y);

    CGContextDrawPath(context, kCGPathFillStroke);
}

/**
 *  绘制文字
 *
 *  @param text    文字内容
 *  @param context 图形绘制上下文
 *  @param rect    绘制点
 *  @param color   绘制颜色
 */
- (void)drawText:(NSString *)text andContext:(CGContextRef )context atPoint:(CGPoint )rect WithColor:(UIColor *)color andFontSize:(CGFloat)fontSize{

    [[NSString stringWithFormat:@"%@",text] drawAtPoint:rect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSForegroundColorAttributeName:color}];

    [color setFill];

    CGContextDrawPath(context, kCGPathFill);

}

- (void)drawImageText:(NSString *)text atPoint:(CGRect)rect{
    UIImage *imageName = [UIImage imageNamed:text];
    [imageName drawInRect:rect];
}

- (void)drawImageView:(NSString *)text andContext:(CGContextRef )context atRect:(CGRect )rect{
    UIImage *imageName = [UIImage imageNamed:text];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:imageName];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.frame = rect;
    [self addSubview:imageView];
}

- (void)drawText:(NSString *)text context:(CGContextRef )context atPoint:(CGRect )rect WithColor:(UIColor *)color font:(UIFont*)font{

    UILabel *cacheLabel = [[UILabel alloc] initWithFrame:rect];
    cacheLabel.textAlignment = NSTextAlignmentCenter;
    cacheLabel.numberOfLines = 0;
    cacheLabel.font = font;
    cacheLabel.text = text;
    cacheLabel.textColor = color;
    [self addSubview:cacheLabel];
}

- (void)drawTitleText:(NSString *)text atPoint:(CGRect )rect WithColor:(UIColor *)color font:(UIFont*)font{
    
    UILabel *cacheLabel = [[UILabel alloc] initWithFrame:rect];
    cacheLabel.textAlignment = NSTextAlignmentLeft;
    cacheLabel.font = font;
    cacheLabel.text = text;
    cacheLabel.textColor = color;
    [self addSubview:cacheLabel];
}

-(void)drawViewWithTag:(NSInteger)tag andContext:(CGContextRef )context atPoint:(CGRect )rect{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = rect;
    btn.tag   = tag + K_ChartViewTag;
    [btn addTarget:self action:@selector(chartViewTap:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}

-(void)drawBtn:(NSString *)TitleName andRect:(CGRect)rect andFont:(UIFont *)font andbackColor:(UIColor *)color{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.titleLabel.font = font;
//    btn.backgroundColor = color;
    CGFloat deleteWidth = rect.size.width;
    btn.frame = CGRectMake(rect.origin.x - deleteWidth, rect.origin.y, deleteWidth, rect.size.height);
    [btn addTarget:self action:@selector(chartViewButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    
    UIImage *imageName = [UIImage imageNamed:@"赛事统计"];
    [imageName drawInRect:CGRectMake(rect.origin.x - 32 * Device_Ccale, rect.origin.y, 32 * Device_Ccale, 16 * Device_Ccale)];
    
    //圆角设置
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:btn.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomLeft cornerRadii:CGSizeMake(3*Device_Ccale, 3*Device_Ccale)];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.path = maskPath.CGPath;
//    maskLayer.strokeColor = color.CGColor;
//    maskLayer.lineWidth = Device_Ccale;
//    maskLayer.fillColor = [UIColor clearColor].CGColor;
//    maskLayer.frame = btn.bounds;
//    [btn.layer addSublayer:maskLayer];
}
/**
 *  判断文本宽度
 *
 *  @param text 文本内容
 *
 *  @return 文本宽度
 */
- (CGFloat)getTextWithWhenDrawWithText:(NSString *)text{
    
    CGSize size = [[NSString stringWithFormat:@"%@",text] boundingRectWithSize:CGSizeMake(100, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:7]} context:nil].size;
    
    return size.width;
}


/**
 *  绘制长方形
 *
 *  @param color  填充颜色
 *  @param p      开始点
 *  @param contex 图形上下文
 */
- (void)drawQuartWithColor:(UIColor *)color andBeginPoint:(CGPoint)p andContext:(CGContextRef)contex{
    
    CGContextAddRect(contex, CGRectMake(p.x, p.y, 10, 10));
    [color setFill];
    [color setStroke];
    CGContextDrawPath(contex, kCGPathFillStroke);
    
    
}


- (void)drawPointWithRedius:(CGFloat)redius andColor:(UIColor *)color andPoint:(CGPoint)p andContext:(CGContextRef)contex{
    
    CGContextAddArc(contex, p.x, p.y, redius, 0, M_PI * 2, YES);
    [color setFill];
    CGContextDrawPath(contex, kCGPathFill);
    
}

/**
 *  返回字符串的占用尺寸
 *
 *  @param maxSize   最大尺寸
 *  @param fontSize  字号大小
 *  @param aimString 目标字符串
 *
 *  @return 占用尺寸
 */
- (CGSize)sizeOfStringWithMaxSize:(CGSize)maxSize textFont:(CGFloat)fontSize aimString:(NSString *)aimString{
    
    
    return [[NSString stringWithFormat:@"%@",aimString] boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
    
}
-(void)chartViewButton:(UIButton *)sender{
    [self chartViewButtonEvent:sender.tag - K_ChartViewTag];
}
-(void)chartViewTap:(UIButton *)sender{
    [self chartViewTapEvent:sender.tag - K_ChartViewTag];
}
-(void)dealloc{
#if DEBUG
    NSLog(@"%@ %ld has dealloc",NSStringFromClass([self class]),self.tag);
#endif
}

@end

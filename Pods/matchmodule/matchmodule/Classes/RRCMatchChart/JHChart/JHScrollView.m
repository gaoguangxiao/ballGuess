//
//  JHScrollView.m
//  MXSFramework
//
//  Created by gaoguangxiao on 2019/9/4.
//  Copyright © 2019 MXS. All rights reserved.
//

#import "JHScrollView.h"
#import "JHColumnItem.h"
#import "DYUIViewExt.h"
#import "RRCDeviceConfigure.h"
#import "YBColorConfigure.h"
@implementation JHScrollView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


-(void)drawRect:(CGRect)rect{
    if(self.isLongPress && self.showViewArr && self.showViewArr.count > 0){
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        int nowPoint = (_currentLoc.x) /self.pointGap;
//        NSLog(@"%f",_currentLoc.x/self.pointGap);
//        NSLog(@"_currentLoc.x:%f--%d",_currentLoc.x,nowPoint);
        if(nowPoint >= 0 && nowPoint <= self.showViewArr.count - 1) {
            
            CGFloat chartHeight = self.height - 30;
            CGPoint selectPoint = CGPointMake((nowPoint + 1)*self.pointGap + self.pointGap/2, chartHeight);
            if (self.showViewArr.count == 7) {
                selectPoint = CGPointMake(nowPoint*self.pointGap + self.pointGap/2 + 1.5, chartHeight);;
            }
            
            JHColumnItem *itemColume = self.showViewArr[nowPoint];
            
            NSString *text = itemColume.columnItemTextDesc;
            if (text && text.length) {
                NSArray *itemColumeArr = [text componentsSeparatedByString:@"|"];
                
                NSDictionary *themeTimeAttr = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:10 * Device_Ccale],NSForegroundColorAttributeName:RRCThemeViewColor};
                NSDictionary *nomorTimeAttr = @{NSFontAttributeName : [UIFont systemFontOfSize:10 * Device_Ccale],NSForegroundColorAttributeName:RRCGrayTextColor};
                
                CGSize timeSize = CGSizeZero;
                CGPoint drawPoint = CGPointZero;
                
                if (itemColumeArr.count == 2) {
                   
                    timeSize = [[NSString stringWithFormat:@"%@",itemColumeArr.firstObject]sizeWithAttributes:themeTimeAttr];
                    
                    if(_currentLoc.x  <= self.width/2) {
                         drawPoint = CGPointMake(selectPoint.x, 0);
                     }else{
                         drawPoint = CGPointMake(selectPoint.x - timeSize.width, 0);
                     }
                    
                    [itemColumeArr.firstObject drawAtPoint:CGPointMake(drawPoint.x, 0) withAttributes:themeTimeAttr];
                    
                    [itemColumeArr.lastObject drawAtPoint:CGPointMake(drawPoint.x, timeSize.height + 3) withAttributes:nomorTimeAttr];
                                       
                }else{
                    NSDictionary *timeAttr = @{NSFontAttributeName : [UIFont systemFontOfSize:10 * Device_Ccale],NSForegroundColorAttributeName:RRCHighLightTitleColor};
                    timeSize = [[NSString stringWithFormat:@"%@",text] sizeWithAttributes:timeAttr];
                     //画文字所在的位置  动态变化
                     
                     if(_currentLoc.x  <= self.width/2) {
                         drawPoint = CGPointMake(selectPoint.x, 0);
                     }else{
                         drawPoint = CGPointMake(selectPoint.x - timeSize.width, 0);
                     }
                    
                     [text drawAtPoint:CGPointMake(drawPoint.x, 0) withAttributes:themeTimeAttr];
                }
                //
                
                [self drawLineDotWidthWithContext:context andStarPoint:CGPointMake(selectPoint.x, self.height - 20) andEndPoint:CGPointMake(selectPoint.x, 30) andIsDottedLine:YES andColor:RRCThemeViewColor];
            }
        }
    }
}
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
@end

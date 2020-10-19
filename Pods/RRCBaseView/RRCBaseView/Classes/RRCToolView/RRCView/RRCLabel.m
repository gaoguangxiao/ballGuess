//
//  RRCLabel.m
//  MXSFramework
//
//  Created by 晓松 on 2018/9/29.
//  Copyright © 2018年 MXS. All rights reserved.
//

#import "RRCLabel.h"
#import "RRCDeviceConfigure.h"
#import <Masonry/Masonry.h>
@implementation RRCLabel
- (instancetype)init {
    if (self = [super init]) {
        _edgeInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _edgeInsets = UIEdgeInsetsZero;
    }
    return self;
}

 // 修改绘制文字的区域，edgeInsets增加bounds
-(CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines
{
    
    /*
     调用父类该方法
     注意传入的UIEdgeInsetsInsetRect(bounds, self.edgeInsets),bounds是真正的绘图区域
     */
    CGRect rect = [super textRectForBounds:UIEdgeInsetsInsetRect(bounds,
                                                                 self.edgeInsets) limitedToNumberOfLines:numberOfLines];
    //根据edgeInsets，修改绘制文字的bounds
    rect.origin.x -= self.edgeInsets.left;
    rect.origin.y -= self.edgeInsets.top;
    rect.size.width += self.edgeInsets.left + self.edgeInsets.right;
    rect.size.height += self.edgeInsets.top + self.edgeInsets.bottom;
    return rect;
}

+ (UIEdgeInsets)edgeInsets
{
    /*- (CGRect)boundingRectWithSize:(CGSize)size options:(NSStringDrawingOptions)options attributes:(nullable NSDictionary<NSString *, id> *)attributes context:(nullable NSStringDrawingContext *)context NS_AVAILABLE(10_11, 7_0);
     方法计算label的大小时，由于不会调用textRectForBounds方法，并不会计算自己通过edgeInsets插入的内边距，而是实际的大小，因此手动返回进行修正*/
    return self.edgeInsets;
}

//绘制文字
- (void)drawTextInRect:(CGRect)rect
{
    //令绘制区域为原始区域，增加的内边距区域不绘制
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}


-(NSMutableAttributedString *)lineSpace:(CGFloat)lineSpacing withContentStr:(NSString *)ContentStr{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:ContentStr];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];//调整行间距
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [ContentStr length])];
    return attributedString;
}

/**
 *  计算富文本字体高度
 *
 *  @param lineSpeace 行高
 *  @param font       字体
 *  @param width      字体所占宽度
 *
 *  @return 富文本高度
 */
-(CGFloat)getSpaceLabelHeightwithText:(NSString *)text Speace:(CGFloat)lineSpeace withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = lineSpeace;
    style.lineBreakMode = NSLineBreakByCharWrapping;
    [attributeString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
    [attributeString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, text.length)];
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
    CGRect rect = [attributeString boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:options context:nil];
    //判断内容是否只有一行 : (目前高度 - 字体高度) <= 行间距
    if ((rect.size.height - font.lineHeight) <= lineSpeace){
        //如果只有一行，进行判断内容中是否全部为汉字
        if ([self containChinese:text]) {
            //修正后高度为： 目前高度 - 一个行间距
            rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height-lineSpeace);
        }
    }
    CGFloat realHeight      = (kScreenWidth  * (rect.size.height + self.edgeInsets.top + self.edgeInsets.bottom))/kScreenWidth;
    return realHeight;
}
//判断内容中是否全部为汉字
- (BOOL)containChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){
            return YES;
        }
    }
    return NO;
}

-(void)setText:(NSString *)text{
    [super setText:text];
    
    //设置文本圆角背景显示，一个数圆角是圆
    if (self.isLayerCount) {
        self.layer.masksToBounds = YES;
        
        if ([self.text integerValue] >= 100) {
            self.text = @"99+";
        }
        NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:self.font.pointSize]};
        CGSize size = [self.text sizeWithAttributes:attrs];
        CGFloat width = size.width + 4 > self.frame.size.height ? size.width + 4 : self.frame.size.height;//高度外部已经具备了，需要定制宽度
        if ([self.text integerValue] < 10) {
            //小于10  切圆形
            self.layer.cornerRadius  = self.frame.size.height/2;
            width = self.frame.size.height;    
        }else{
            //否则 矩形
            self.layer.cornerRadius  = self.frame.size.height/2;
        }
        if (self.superview != nil) {
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(width);
            }];
        }
    }
 
}
@end

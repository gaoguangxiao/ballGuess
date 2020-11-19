//
//  RRCAlertManager.m
//  AFNetworking
//
//  Created by gaoguangxiao on 2020/5/7.
//

#import "RRCAlertManager.h"
#import "RRCDeviceConfigure.h"
#import "YBColorConfigure.h"
#import "MBProgressHUD.h"
@interface RRCAlertManager ()

@property (nonatomic, strong) UIView *drawView;

@end

@implementation RRCAlertManager

ImplementSingleton(RRCAlertManager);


-(void)showPostingWithtitle:(NSString *)title{
    [self showPostingWithtitle:title andTopMargin:0];
}

-(void)showPostingWithtitle:(NSString *)title andTopMargin:(CGFloat)top{
    
    MBProgressHUD *mb = [[MBProgressHUD alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    mb.mode           = MBProgressHUDModeText;
    mb.margin         = 12 * Device_Ccale;
    mb.label.font     = [UIFont systemFontOfSize:16.0 * Device_Ccale];
    mb.removeFromSuperViewOnHide = YES;
    mb.offset        = CGPointMake(0, top);
    
    [[UIApplication sharedApplication].keyWindow addSubview:mb];
    mb.label.text = title;
    [mb showAnimated:YES];
    [mb hideAnimated:YES afterDelay:1.0];
}

-(void)showChoseWithtitle:(NSString *)title array:(NSArray *)array DoneBlock:(void (^)(NSInteger))block{
    
    
    [self configAlert];
    
    self.doneBlock = block;
    //
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = RRCUnitViewColor;
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 5.0 *Device_Ccale;
    [self.drawView addSubview:bgView];
    bgView.frame = CGRectMake((kScreenWidth - 250 * Device_Ccale)/2, (kScreenHeight - 66 * Device_Ccale)/2, 250*Device_Ccale, 0*Device_Ccale);

    UILabel *  titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(12 * Device_Ccale, 17 * Device_Ccale, bgView.frame.size.width - 12 * Device_Ccale, 0)];
    titleLabel.backgroundColor = RRCUnitViewColor;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:kSafeString(title)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5 * Device_Ccale];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [kSafeString(title) length])];
    titleLabel.attributedText = attributedString;
    titleLabel.numberOfLines = 6;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:16.0*Device_Ccale];
    titleLabel.textColor = RRCThemeTextColor;
    [bgView addSubview:titleLabel];
    
    [titleLabel sizeToFit];
    
    CGSize sizeLabel = titleLabel.bounds.size;
    CGRect updateRect   = titleLabel.frame;
    //
    updateRect.size.height = sizeLabel.height;
    updateRect.size.width  = bgView.frame.size.width - 24 * Device_Ccale;
    
    titleLabel.frame = updateRect;

    CGFloat titleOffy = titleLabel.frame.origin.y + titleLabel.frame.size.height + 17 * Device_Ccale;
    
    bgView.frame = CGRectMake((kScreenWidth - 250 * Device_Ccale)/2, (kScreenHeight - 66 * Device_Ccale)/2, 250*Device_Ccale,titleOffy +  48 * Device_Ccale);
    
    for (int i = 0; i < array.count; i ++) {
        UIButton * bnt = [UIButton buttonWithType:UIButtonTypeCustom];
        [bnt setTitle:array[i] forState:UIControlStateNormal];
        if (i == 0) {
            [bnt setTitleColor:RRCGrayTextColor forState:UIControlStateNormal];
        }else{
            [bnt setTitleColor:RRCHighLightTitleColor forState:UIControlStateNormal];
        }
        bnt.tag = i;
        [bnt setBackgroundColor:RRCUnitViewColor];
        bnt.titleLabel.font = [UIFont systemFontOfSize:16.0*Device_Ccale];
        [bnt addTarget:self action:@selector(doneBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [bnt addTarget:self action:@selector(doneBtnClickedHighlighted:) forControlEvents:UIControlEventTouchDown];
        [bgView addSubview:bnt];
        bnt.frame = CGRectMake(i * 138*Device_Ccale, titleOffy , 115 * Device_Ccale, 48 * Device_Ccale);
       
    }
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = RRCLineViewColor;
    [bgView addSubview:lineView];
    lineView.frame = CGRectMake(0, titleOffy, bgView.frame.size.width, 1 * Device_Ccale);
    
}

- (void)doneBtnClicked:(UIButton *)sender{
    [UIView animateWithDuration:0.35 animations:^{
        [self.drawView removeFromSuperview];
    }];
    
    if (self.doneBlock) {
        self.doneBlock(sender.tag);
    }
    
    //清理视图的所有子视图
    for (UIView *s in self.drawView.subviews) {
        [s removeFromSuperview];
    }
}

-(void)doneBtnClickedHighlighted:(UIButton *)sender{
    
}

- (void)configAlert{
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    
    //移除原来视图
//    [self subviesRemoveView];
    _drawView = [[UIView alloc] initWithFrame:win.bounds];
    _drawView.backgroundColor = [UIColor clearColor];
    
    UIView *maskView = [[UIView alloc] initWithFrame:_drawView.bounds];
    maskView.userInteractionEnabled = YES;
    maskView.alpha = 0.3f;
    maskView.backgroundColor = [UIColor blackColor];
    [_drawView addSubview:maskView];
    
//    [self exChangeOut:_drawView dur:0.0f];
    [win addSubview:_drawView];
}
@end

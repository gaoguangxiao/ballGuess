//
//  RRCProgressHUD.m
//  MXSFramework
//
//  Created by gaoguangxiao on 2019/5/16.
//  Copyright © 2019 MXS. All rights reserved.
//

#import "RRCProgressHUD.h"
#import "Masonry.h"
#import "RRCDeviceConfigure.h"
#import "YBColorConfigure.h"

#import "UIImage+FIXbaseModule.h"
@interface RRCProgressHUD ()

@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UIImageView *zuqiucaifuLabel;

@end

@implementation RRCProgressHUD

+ (instancetype)showRRCAddedTo:(UIView *)view animated:(BOOL)animated{
    RRCProgressHUD *hud = [[self alloc] initWithView:view];
    [view addSubview:hud];
    [hud showAnimated:animated];
    return hud;
}

+ (instancetype)showLoadView:(UIView *)view andHeight:(CGFloat)height{
    RRCProgressHUD *hud = [[self alloc] initWithRect:CGRectMake(0, 0, kScreenWidth, height)];
    hud.backgroundColor = RRCUnitViewColor;
    [view addSubview:hud];
    [hud showAnimated:YES];
    return hud;
}
+ (instancetype)showRRCAddedTo:(UIView *)view rect:(CGRect)rect{
    RRCProgressHUD *hud = [[self alloc]initWithRect:rect];
    [view addSubview:hud];
    [hud showAnimated:YES];
    return hud;
}
- (id)initWithRect:(CGRect)rect{
    return [self initWithFrame:rect];
}
- (id)initWithView:(UIView *)view {
    NSAssert(view, @"View must not be nil.");
    return [self initWithFrame:view.bounds];
}


+ (BOOL)hideRRCForView:(UIView *)view animated:(BOOL)animated {
    RRCProgressHUD *hud = [self HUDForView:view];
    if (hud != nil) {
        [hud removeFromSuperview];
        return YES;
    }
    return NO;
}
+ (RRCProgressHUD *)HUDForView:(UIView *)view {
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            RRCProgressHUD *hud = (RRCProgressHUD *)subview;
            return hud;
        }
    }
    return nil;
}

-(void)updateActivityMaginTop:(CGFloat)top{
    [self.activityIndicator mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(-top);
    }];
}

#pragma mark - 私有方法
-(void)showAnimated:(BOOL)animated{
    if (!self.activityIndicator) {
        self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
        [self addSubview:self.activityIndicator];
        //设置小菊花的frame
        //设置小菊花颜色
        self.activityIndicator.color = RRCActivityColor;
        //刚进入这个界面会显示控件，并且停止旋转也会显示，只是没有在转动而已，没有设置或者设置为YES的时候，刚进入页面不会显示
        [self.activityIndicator startAnimating];
        self.activityIndicator.hidesWhenStopped = YES;
        [self.activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(-20);
        }];
        
        self.zuqiucaifuLabel = [[UIImageView alloc]init];
        self.zuqiucaifuLabel.image = [UIImage fixbaseModuleImageNamed:@"足球财"];
        [self.zuqiucaifuLabel sizeToFit];
        [self addSubview:self.zuqiucaifuLabel];
        [self.zuqiucaifuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(self.activityIndicator.mas_bottom).offset(10);
        }];
    }
    
}
@end

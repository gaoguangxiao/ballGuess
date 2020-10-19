//
//  RRCNavigationView.m
//  MXSFramework
//
//  Created by gaoguangxiao on 2019/5/31.
//  Copyright © 2019 MXS. All rights reserved.
//

#import "RRCNavigationView.h"

@implementation RRCNavigationView

-(instancetype)initWithFrame:(CGRect)frame andnaviTitle:(NSString *)title{
    if (self = [super initWithFrame:frame]) {
        [self configureBarWithTtitle:title];
    }
    return self;
}

-(void)configureBarWithTtitle:(NSString *)title{

    [self addSubview:self.leftButton];
    self.leftButton.frame = CGRectMake(0, kHeightNavigationStatusBar, 44, 44);
    
    [self addSubview:self.titlelabel2];
    [self.titlelabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(kHeightNavigationStatusBar);
        make.height.mas_equalTo(44);
    }];
    self.titlelabel2.text = title;
    
    [self addSubview:self.lineView];
}

-(void)setRightBtnTitle:(NSString *)rightTitle{
    self.rightBtn = [[UIButton alloc]init];
    [self addSubview:self.rightBtn];
    
    [self.rightBtn addTarget:self action:@selector(setBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightBtn setTitle:rightTitle forState:UIControlStateNormal];
    self.rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [self.rightBtn sizeToFit];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12*Device_Ccale);
        make.top.mas_equalTo(self).mas_offset(kHeightNavigationStatusBar);
        make.height.mas_equalTo(44);
    }];
    
    [self.rightBtn setTitleColor:RRCWhiteTextColor forState:UIControlStateNormal];
    self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:16 * Device_Ccale];
}

-(void)setLeftTitle:(NSString *)leftTitle{
    self.leftButton.frame = CGRectMake(0, 0, 50, self.frame.size.height);
    [self.leftButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self.leftButton setTitle:leftTitle forState:UIControlStateNormal];
    [self.leftButton setTitleColor:RRCViceTextColor forState:UIControlStateNormal];
    self.leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.leftButton.titleLabel.font = K_FontSizeSmall;
    [self.leftButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12*Device_Ccale);
        make.top.mas_equalTo(self);
        make.height.mas_equalTo(self);
        make.width.mas_equalTo(44 * Device_Ccale);
    }];
}

-(void)backClick:(UIButton *)sender{
    if (self.leftAction) {
        //重写左边按钮点击方法
        self.leftAction();
    }else{
        //默认返回上一个控制器
        [self.naviViewController.navigationController popViewControllerAnimated:YES];
    }
    
}

- (UIViewController *)naviViewController{
    
    id next = self.nextResponder;
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return next;
        }
        next = [next nextResponder];
    } while (next != nil);
    
    if(next == nil){
        next = [[UIApplication sharedApplication] delegate].window.rootViewController;
        if([next isKindOfClass:[UINavigationController class]]){
            next = ((UINavigationController *)next).topViewController;
        }
        return next;
    }
    return nil;
}

-(void)setBtnClick:(UIButton *)sender{
    if (self.rightAction) {
        self.rightAction();
    }
}

-(UIButton *)leftButton{
    if (!_leftButton) {
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setImage:[UIImage imageNamed:@"返回白色"] forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}
-(UILabel *)titlelabel2{
    if (!_titlelabel2) {
        _titlelabel2 = [[UILabel alloc]init];
        _titlelabel2.alpha = 1.0;
        _titlelabel2.tag = 909;
        _titlelabel2.text = @"zqcf";
        _titlelabel2.textAlignment = NSTextAlignmentCenter;
        _titlelabel2.font = [UIFont systemFontOfSize:18*Device_Ccale];
        _titlelabel2.textColor = RRCWhiteTextColor;
        _titlelabel2.backgroundColor = [UIColor clearColor];
    }
    return _titlelabel2;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 0.5, kScreenWidth, 0.5)];
        _lineView.backgroundColor = RRCLineViewColor;
    }
    return _lineView;
}

@end

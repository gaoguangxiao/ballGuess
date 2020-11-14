//
//  RRCLiveUnusualView.m
//  MXSFramework
//
//  Created by 人人彩 on 2019/7/19.
//  Copyright © 2019 MXS. All rights reserved.
//

#import "RRCLiveUnusualView.h"
#import "YBColorConfigure.h"
#import "RRCDeviceConfigure.h"
#import "Masonry.h"
@interface RRCLiveUnusualView ()
@end
@implementation RRCLiveUnusualView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUnusual];
    }
    return self;
}

-(void)initUnusual{
    
    [self addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(0);
        make.height.mas_offset(16*Device_Ccale);
        make.centerX.mas_equalTo(self);
    }];
    
    [self addSubview:self.retryBtn];
    [self.retryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLab.mas_bottom).with.mas_offset(20*Device_Ccale);
        make.size.mas_offset(CGSizeMake(92*Device_Ccale, 32*Device_Ccale));
        make.centerX.mas_equalTo(self.mas_centerX).mas_offset(-54*Device_Ccale);
    }];
    
    [self addSubview:self.switchPlay];
    [self.switchPlay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.retryBtn);
        make.left.mas_equalTo(self.retryBtn.mas_right).with.mas_offset(16*Device_Ccale);
        make.size.mas_offset(CGSizeMake(92*Device_Ccale, 32*Device_Ccale));
    }];
}

-(void)setIsShowSwitch:(BOOL)isShowSwitch{
    _isShowSwitch = isShowSwitch;
    self.switchPlay.hidden = !isShowSwitch;
    [self.retryBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        if (isShowSwitch) {
            make.centerX.mas_equalTo(self.mas_centerX).mas_offset(-54*Device_Ccale);
        }else{
            make.centerX.mas_equalTo(self.mas_centerX).mas_offset(0*Device_Ccale);
        }
    }];
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    return YES;
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *view = [super hitTest:point withEvent:event];
    if ([view isKindOfClass:[UIButton class]]) {
        return view;
    }
    return nil;
}

-(void)retryBtnAction{
    if (self.UnusualBlock) {
        self.UnusualBlock(YES);
    }
}

-(void)switchPlayAction{
    self.switchPlay.selected = !self.switchPlay.selected;
    if (self.swithPlayBlock) {
        self.swithPlayBlock(self.switchPlay.selected);
    }
}

#pragma mark----GET----
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab= [[UILabel alloc] init];
        _titleLab.font = [UIFont systemFontOfSize:16*Device_Ccale];
        _titleLab.text = @"直播异常，请稍侯重试";
        _titleLab.textColor = RRCWhiteTextColor;
    }
    return _titleLab;
}

-(UIButton *)retryBtn{
    if (!_retryBtn) {
        _retryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _retryBtn.layer.cornerRadius = Device_Ccale;
        _retryBtn.layer.masksToBounds = YES;
        [_retryBtn setTitle:@"重试" forState:0];
        [_retryBtn setTitleColor:RRCWhiteTextColor forState:0];
        _retryBtn.backgroundColor = RRCThemeViewColor;
        [_retryBtn addTarget:self action:@selector(retryBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _retryBtn.titleLabel.font = [UIFont systemFontOfSize:14*Device_Ccale];
    }
    return _retryBtn;
}

-(UIButton *)switchPlay{
    if (!_switchPlay) {
        _switchPlay = [UIButton buttonWithType:UIButtonTypeCustom];
        [_switchPlay setTitle:@"切换播放源" forState:0];
        [_switchPlay setTitleColor:RRCWhiteTextColor forState:0];
        _switchPlay.titleLabel.font = [UIFont systemFontOfSize:14*Device_Ccale];
        _switchPlay.layer.cornerRadius = Device_Ccale;
        _switchPlay.layer.borderColor = RRCWhiteTextColor.CGColor;
        _switchPlay.layer.borderWidth = .5;
        [_switchPlay addTarget:self action:@selector(switchPlayAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchPlay;
}
@end

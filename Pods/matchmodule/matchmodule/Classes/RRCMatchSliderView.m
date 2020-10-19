//
//  RRCMatchSliderView.m
//  MXSFramework
//
//  Created by 人人彩 on 2020/4/13.
//  Copyright © 2020 MXS. All rights reserved.
//

#import "RRCMatchSliderView.h"
#import "DYUIViewExt.h"

@interface RRCMatchSliderView ()
@property (nonatomic,strong) UILabel *nameLab;
@property (nonatomic,strong) UILabel *leftNum;
@property (nonatomic,strong) UILabel *rightNum;
@property (nonatomic,strong) UIView *baseView;
@property (nonatomic,strong) UIView *redView;
@property (nonatomic,strong) UIView *blueView;
@end
@implementation RRCMatchSliderView

-(void)setUpView{
    
    [self addSubview:self.nameLab];
    [self addSubview:self.leftNum];
    [self addSubview:self.rightNum];
    [self addSubview:self.baseView];
    [self.baseView addSubview:self.redView];
    [self.baseView addSubview:self.blueView];
}

-(void)setStatisModel:(RRCMatchLiveDataStatisModel *)statisModel{
    _statisModel = statisModel;
    self.nameLab.text = statisModel.type;
    self.leftNum.text = statisModel.home;
    self.rightNum.text = statisModel.away;
    
    float leftRate = 0.5;
    
    NSString *homeRate = statisModel.home;//0%/0 -> 0
    if ([statisModel.home containsString:@"%"]) {
        homeRate = [statisModel.home stringByReplacingOccurrencesOfString:@"%" withString:@""];
        if (homeRate.integerValue == 0) {
            self.leftNum.text = [NSString stringWithFormat:@"%@",@"0"];
        }
    }else if ([statisModel.home isEqualToString:@"*"]){
        homeRate = @"1.";
        self.leftNum.font = [UIFont systemFontOfSize:18*Device_Ccale];
    }
    NSString *awayRate = statisModel.away;
    if ([statisModel.away containsString:@"%"]) {
        awayRate = [statisModel.away stringByReplacingOccurrencesOfString:@"%" withString:@""];
        if (awayRate.integerValue == 0) {
            self.rightNum.text = [NSString stringWithFormat:@"%@",@"0"];
        }
    }else if ([statisModel.away isEqualToString:@"*"]){
        awayRate = @"1.";
        self.rightNum.font = [UIFont systemFontOfSize:18*Device_Ccale];
    }

    if ([awayRate floatValue] == [homeRate floatValue]) {
        leftRate = 0.5;
    }else{
        leftRate = [homeRate floatValue]/([awayRate floatValue] + [homeRate floatValue]);
    }

    self.redView.width = self.baseView.width*leftRate;
    self.blueView.left = self.redView.right;
    self.blueView.width = self.baseView.width*(1-leftRate);
}

-(void)setSliderStyle:(RRCMatchSliderSyle)sliderStyle{
    _sliderStyle = sliderStyle;
    if (sliderStyle == LiveDataStatistics) {
        self.leftNum.left = 0;
        self.leftNum.top = 0;
        self.leftNum.width = 100*Device_Ccale;
        self.rightNum.width = 100*Device_Ccale;
        self.leftNum.textAlignment = NSTextAlignmentLeft;
        self.rightNum.right = self.width;
        self.rightNum.top = 0;
        self.rightNum.textAlignment = NSTextAlignmentRight;
    
        self.baseView.left = 0;
        self.baseView.width = self.width;
        self.redView.width = self.baseView.width/2.;
        self.blueView.left = self.baseView.width/2.;
        self.blueView.width = self.baseView.width/2.;
    }else if(sliderStyle == MatchEventList){
        
        self.baseView.frame = self.bounds;
        self.baseView.layer.cornerRadius = 8*Device_Ccale;
        self.baseView.layer.masksToBounds = YES;
        self.redView.height = self.blueView.height = self.baseView.height;
        self.redView.width = self.blueView.width = self.baseView.width/2.;
        self.blueView.left = self.baseView.width/2.;
        
        [self bringSubviewToFront:self.nameLab];
        [self bringSubviewToFront:self.leftNum];
        [self bringSubviewToFront:self.rightNum];
        
        self.nameLab.height = self.height;
        self.nameLab.font = [UIFont systemFontOfSize:10*Device_Ccale];
        self.nameLab.textColor = RRCWhiteTextColor;
        
        self.leftNum.frame = CGRectMake(8*Device_Ccale, 0, 50*Device_Ccale, self.height);
        self.leftNum.textAlignment = NSTextAlignmentLeft;
        self.leftNum.font = [UIFont systemFontOfSize:10*Device_Ccale];
        self.leftNum.textColor = RRCWhiteTextColor;
        
        self.rightNum.frame = CGRectMake(self.width - 58*Device_Ccale, 0, 50*Device_Ccale, self.height);
        self.rightNum.textAlignment = NSTextAlignmentRight;
        self.rightNum.font = [UIFont systemFontOfSize:10*Device_Ccale];
        self.rightNum.textColor = RRCWhiteTextColor;
    }
}

-(void)setNameStr:(NSString *)nameStr{
    _nameStr = nameStr;
    _nameLab.text = nameStr;
}

#pragma mark -------GET-------
-(UILabel *)nameLab{
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 12*Device_Ccale)];
        _nameLab.text = @"射正球门";
        _nameLab.font = [UIFont boldSystemFontOfSize:12*Device_Ccale];
        _nameLab.textColor = RRCThemeTextColor;
        _nameLab.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLab;
}

-(UILabel *)leftNum{
    if (!_leftNum) {
        _leftNum = [[UILabel alloc] initWithFrame:CGRectMake(0, self.nameLab.bottom + 12*Device_Ccale, 17*Device_Ccale, 12*Device_Ccale)];
        _leftNum.font = [UIFont systemFontOfSize:12*Device_Ccale];
        _leftNum.textColor = RRCThemeTextColor;
        _leftNum.textAlignment = NSTextAlignmentRight;
    }
    return _leftNum;
}

-(UILabel *)rightNum{
    if (!_rightNum) {
        _rightNum = [[UILabel alloc] initWithFrame:CGRectMake(0, self.nameLab.bottom + 12*Device_Ccale, 17*Device_Ccale, 12*Device_Ccale)];
        _rightNum.right = self.width;
        _rightNum.font = [UIFont systemFontOfSize:12*Device_Ccale];
        _rightNum.textColor = RRCThemeTextColor;
    }
    return _rightNum;
}

-(UIView *)baseView{
    if (!_baseView) {
        _baseView = [[UIView alloc] initWithFrame:CGRectMake(self.leftNum.right + 8*Device_Ccale, self.height - 6*Device_Ccale, 122*Device_Ccale, 6*Device_Ccale)];
        _baseView.layer.masksToBounds = YES;
        _baseView.layer.cornerRadius = 3*Device_Ccale;
    }
    return _baseView;
}

-(UIView *)redView{
    if (!_redView) {
        _redView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,self.baseView.width/2., 6*Device_Ccale)];
        _redView.backgroundColor = RRCThemeViewColor;
    }
    return _redView;
}

-(UIView *)blueView{
    if (!_blueView) {
        _blueView = [[UIView alloc] initWithFrame:CGRectMake(self.baseView.width/2., 0, self.baseView.width/2., 6*Device_Ccale)];
        _blueView.backgroundColor = RRC4A74FFColor;
    }
    return _blueView;
}
@end

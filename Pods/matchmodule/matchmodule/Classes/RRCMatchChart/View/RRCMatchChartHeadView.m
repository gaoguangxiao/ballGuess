//
//  RRCMatchHeadView.m
//  MXSFramework
//
//  Created by renrencai on 2019/4/18.
//  Copyright © 2019年 MXS. All rights reserved.
//

#import "RRCMatchChartHeadView.h"
#import "RRCDeviceConfigure.h"
#import "YBColorConfigure.h"
#import "DYUIViewExt.h"
@interface RRCMatchChartHeadView (){
    UIImageView *_selectImg;
}
@property (nonatomic , strong) UIButton *deleteMatchBtn;
@end

@implementation RRCMatchChartHeadView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initGameHead];
    }
    return self;
}
-(void)initGameHead{

    [self addSubview:self.baseImg];
    self.baseImg.frame = CGRectMake(0, 12*Device_Ccale, self.width, 32*Device_Ccale);
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.baseImg.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.baseImg.bounds;
    maskLayer.path = maskPath.CGPath;
    self.baseImg.layer.mask = maskLayer;
    
    [self.baseImg addSubview:self.titleLab];
    _titleLab.frame = CGRectMake(0, 0, self.baseImg.width, self.baseImg.height);
   
    [self.baseImg addSubview:self.deleteMatchBtn];
    self.deleteMatchBtn.frame = CGRectMake(self.baseImg.width - self.baseImg.height, 0, self.baseImg.height, self.baseImg.height);
}

-(void)setMatchInfoState:(RRCMatchInfoListState)matchInfoState{
    _matchInfoState = matchInfoState;
    if (self.matchInfoState == RRCMatchInfoListStatePreview) {
        _selectImg.hidden = YES;
        self.deleteMatchBtn.hidden = YES;
    }else{
        
    }
}

-(void)tapAction{
    if (self.deleteMatchInfoBlock) {
        self.deleteMatchInfoBlock(self.matchId);
    }
    
}

#pragma mark - getter and setter
-(UIButton *)deleteMatchBtn{
    if (!_deleteMatchBtn) {
        _deleteMatchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteMatchBtn setImage:[UIImage imageNamed:@"matchmoduleDeleteMatch"] forState:UIControlStateNormal];
        [_deleteMatchBtn addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteMatchBtn;
}
-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.textColor = RRCWhiteTextColor;
        _titleLab.font = [UIFont systemFontOfSize:16*Device_Ccale];
        _titleLab.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLab;
}
-(UIImageView *)baseImg{
    if (!_baseImg) {
        _baseImg = [UIImageView new];
        _baseImg.userInteractionEnabled = YES;
        _baseImg.backgroundColor = RRCThemeViewColor;
    }
    return _baseImg;
}
@end

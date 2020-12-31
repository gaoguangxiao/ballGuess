//
//  RRCCheckCollectionCell.m
//  MXSFramework
//
//  Created by gaoguangxiao on 2019/7/13.
//  Copyright © 2019 MXS. All rights reserved.
//

#import "RRCCheckCollectionCell.h"

@interface RRCCheckCollectionCell ()
@property (nonatomic,strong) UILabel *resultLab;
@property (nonatomic,strong) UIButton *leagueLayerBtn;


@end

@implementation RRCCheckCollectionCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self displayCell];
    }
    return self;
}

-(void)displayCell{
    
    [self.contentView addSubview:self.leagueLayerBtn];
    [self.leagueLayerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
    }];
    
    [self.contentView addSubview:self.nameLab];
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(8 * Device_Ccale);
        make.top.mas_offset(5 * Device_Ccale);
//        make.height.mas_equalTo(20 * Device_Ccale);
        make.right.mas_offset(-8*Device_Ccale);
    }];
    
    [self.contentView addSubview:self.resultLab];
    [self.resultLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-8*Device_Ccale);
        make.top.mas_equalTo(self);
    }];
    
    [self.contentView addSubview:self.yzLab];
    [self.yzLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(8*Device_Ccale);
        make.right.mas_offset(-8 * Device_Ccale);
        make.top.mas_equalTo(self.nameLab.mas_bottom).offset(5 * Device_Ccale);
    }];
    
    [self.contentView addSubview:self.dxqLab];
    [self.dxqLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(8*Device_Ccale);
        make.right.mas_offset(-8 * Device_Ccale);
        make.top.mas_equalTo(self.yzLab.mas_bottom).offset(5 * Device_Ccale);
    }];
    
    [self.contentView addSubview:self.bdLab];
    [self.bdLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(8*Device_Ccale);
        make.top.mas_equalTo(self.dxqLab.mas_bottom).offset(5 * Device_Ccale);
    }];
    
    [self.contentView addSubview:self.jcLab];
    [self.jcLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(8*Device_Ccale);
        make.top.mas_equalTo(self.bdLab.mas_bottom).offset(5 * Device_Ccale);
    }];
    
    
}

//-(void)setChoseTitle:(NSString *)choseTitle{
//    self.nameLab.text = choseTitle;
//}
//
//-(void)setChoseContent:(NSString *)choseContent{
//    self.resultLab.text = choseContent;
//    
//    if (choseContent.length) {
//        
//        [self.nameLab mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(8*Device_Ccale);
//            make.top.bottom.mas_offset(0);
//            make.right.mas_offset(-8*Device_Ccale);
//        }];
//        self.nameLab.textAlignment = NSTextAlignmentLeft;
//    }else{
//        
//        [self.nameLab mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.bottom.right.mas_equalTo(self.contentView);
//        }];
//        self.nameLab.textAlignment = NSTextAlignmentCenter;
//    }
//}

-(void)setChoseNormalBackImage:(UIImage *)choseNormalBackImage{
    [self.leagueLayerBtn setBackgroundImage:choseNormalBackImage forState:UIControlStateNormal];
}

-(void)setChoseSelectBackImage:(UIImage *)choseSelectBackImage{
    [self.leagueLayerBtn setBackgroundImage:choseSelectBackImage forState:UIControlStateSelected];
}

-(void)setSelectStatus:(BOOL)selectStatus{
    _selectStatus = selectStatus;
    self.leagueLayerBtn.selected = selectStatus;
    
    if (selectStatus) {
        self.nameLab.textColor  = RRCHighLightTitleColor;
    }else{
        self.nameLab.textColor  = RRCGrayTextColor;
    }
}

-(void)dealloc{
    
}

-(UIButton *)leagueLayerBtn{
    if (!_leagueLayerBtn) {
        _leagueLayerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leagueLayerBtn setBackgroundImage:[UIImage imageNamed:@"赛事未选条件边框"] forState:UIControlStateNormal];
        [_leagueLayerBtn setBackgroundImage:[UIImage imageNamed:@"赛事选中条件边框"] forState:UIControlStateSelected];
        _leagueLayerBtn.userInteractionEnabled = NO;
    }
    return _leagueLayerBtn;
}

-(UILabel *)nameLab{
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] init];
        _nameLab.font = [UIFont systemFontOfSize:12*Device_Ccale];
        _nameLab.textColor = RRCHighLightTitleColor;
//        _nameLab.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLab;
}

-(UILabel *)resultLab{
    if (!_resultLab) {
        _resultLab = [[UILabel alloc] init];
        _resultLab.textColor = RRCGrayTextColor;
        _resultLab.font = [UIFont systemFontOfSize:12*Device_Ccale];
    }
    return _resultLab;
}

-(UILabel *)dxqLab{
    if (!_dxqLab) {
        _dxqLab = [[UILabel alloc] init];
        _dxqLab.textColor = RRCGrayTextColor;
        _dxqLab.font = [UIFont systemFontOfSize:12*Device_Ccale];
        _dxqLab.numberOfLines = 0;
    }
    return _dxqLab;
}

-(UILabel *)yzLab{
    if (!_yzLab) {
        _yzLab = [[UILabel alloc] init];
        _yzLab.textColor = RRCGrayTextColor;
        _yzLab.font = [UIFont systemFontOfSize:12*Device_Ccale];
        _yzLab.numberOfLines = 0;
    }
    return _yzLab;
}

-(UILabel *)bdLab{
    if (!_bdLab) {
        _bdLab = [[UILabel alloc] init];
        _bdLab.textColor = RRCGrayTextColor;
        _bdLab.font = [UIFont systemFontOfSize:12*Device_Ccale];
        _bdLab.numberOfLines = 2;
    }
    return _bdLab;
}

-(UILabel *)jcLab{
    if (!_jcLab) {
        _jcLab = [[UILabel alloc]init];
        _jcLab.textColor = RRCGrayTextColor;
        _jcLab.font = [UIFont systemFontOfSize:12*Device_Ccale];
        _jcLab.numberOfLines = 2;
    }
    return _jcLab;
}
@end

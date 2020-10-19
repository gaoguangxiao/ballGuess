//
//  RRCCommanySelectCell.m
//  MXSFramework
//
//  Created by 人人彩 on 2020/4/15.
//  Copyright © 2020 MXS. All rights reserved.
//

#import "RRCCheckBoxCell.h"
@interface RRCCheckBoxCell ()
@property (nonatomic,strong) RRCCheckBoxView *selectView;
@end
@implementation RRCCheckBoxCell

-(void)creatCell{
    self.lineView.hidden = YES;
    [self.contentView addSubview:self.selectView];
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

-(void)setChoseTitle:(NSString *)choseTitle{
    self.selectView.choseTitle = choseTitle;
}

-(void)setSelectStatus:(BOOL)selectStatus{
    self.selectView.selectStatus = selectStatus;
}

#pragma mark----GET----
-(RRCCheckBoxView *)selectView{
    if (!_selectView) {
        _selectView = [[RRCCheckBoxView alloc] init];
    }
    return _selectView;
}

@end

#pragma mark -------RRCCheckBoxView------
@interface RRCCheckBoxView ()
@property (nonatomic,strong) UILabel *nameTitle;
@property (nonatomic,strong) UIImageView *selectIcon;
@end
@implementation RRCCheckBoxView

-(void)setUpView{
    
    [self addSubview:self.nameTitle];
    [self.nameTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(12*Device_Ccale);
        make.top.bottom.mas_offset(0);
    }];
    
    [self addSubview:self.selectIcon];
    [self.selectIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-12*Device_Ccale);
        make.centerY.mas_equalTo(self.nameTitle);
        make.size.mas_offset(CGSizeMake(16*Device_Ccale, 16*Device_Ccale));
    }];
    
    self.selectTextColor = RRCHighLightTitleColor;
    self.normalTextColor = RRCThemeTextColor;
}

-(void)setChoseTitle:(NSString *)choseTitle{
    self.nameTitle.text = choseTitle;
}

-(void)setSelectTextColor:(UIColor *)selectTextColor{
    _selectTextColor = selectTextColor;
}

-(void)setNormalTextColor:(UIColor *)normalTextColor{
    _normalTextColor = normalTextColor;
}

-(void)setSelectStatus:(BOOL)selectStatus{
    _selectStatus = selectStatus;
    
    if (selectStatus) {
        _selectIcon.image = [UIImage imageNamed:@"selectGame"];
        _nameTitle.textColor = _selectTextColor;
    }else{
        _selectIcon.image = [UIImage imageNamed:@"未选择公司"];
        _nameTitle.textColor = _normalTextColor;
    }
    
}


#pragma mark - GET
-(UILabel *)nameTitle{
    if (!_nameTitle) {
        _nameTitle = [[UILabel alloc] init];
        _nameTitle.font = [UIFont systemFontOfSize:14*Device_Ccale];
        _nameTitle.textColor = RRCThemeTextColor;
    }
    return _nameTitle;
}

-(UIImageView *)selectIcon{
    if (!_selectIcon) {
        _selectIcon = [[UIImageView alloc] init];
        _selectIcon.image = [UIImage imageNamed:@"未选择公司"];
    }
    return _selectIcon;
}
@end

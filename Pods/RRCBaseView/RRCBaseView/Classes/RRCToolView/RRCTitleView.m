//
//  RRCTitleView.m
//  MXSFramework
//
//  Created by gaoguangxiao on 2020/4/16.
//  Copyright © 2020 MXS. All rights reserved.
//

#import "RRCTitleView.h"

@implementation RRCTitleView

-(void)setUpView{
    
    [self addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(12 * Device_Ccale);
        make.centerY.mas_equalTo(self);
    }];
    
}

-(UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = K_FontSizeBig;
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.textColor = RRCThemeTextColor;
    }
    return _titleLab;
}

@end

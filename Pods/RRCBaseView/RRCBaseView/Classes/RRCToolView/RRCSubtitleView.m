//
//  RRCSubtitleView.m
//  MXSFramework
//
//  Created by gaoguangxiao on 2020/4/16.
//  Copyright © 2020 MXS. All rights reserved.
//

#import "RRCSubtitleView.h"

@interface RRCSubtitleView ()

@end

@implementation RRCSubtitleView

-(void)setUpView{
    [super setUpView];
    
    [self addSubview:self.nextImageView];
    [self addSubview:self.detailLabel];
    
    [self.nextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-12*Device_Ccale);
        make.width.mas_equalTo(6 * Device_Ccale);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(self.titleLab.mas_right).offset(16 * Device_Ccale);
        make.right.mas_equalTo(self.nextImageView.mas_left).offset(-6 * Device_Ccale);
    }];
    
}


-(void)setDict:(NSDictionary *)dict{
    if (dict[@"detailText"]) {
        self.detailLabel.text = dict[@"detailText"];
    }
    
    if (dict[@"nextImage"]) {
        self.nextImageView.image = [UIImage imageNamed:dict[@"nextImage"]];
    }
}

#pragma mark - Getter
-(UILabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc]init];
        _detailLabel.textColor = RRCThemeTextColor;
        _detailLabel.font = [UIFont systemFontOfSize:12*Device_Ccale];
        _detailLabel.textAlignment = NSTextAlignmentRight;
    }
    return _detailLabel;
}

-(UIImageView *)nextImageView{
    if (!_nextImageView) {
        _nextImageView = [[UIImageView alloc]init];
        _nextImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _nextImageView;
}
@end

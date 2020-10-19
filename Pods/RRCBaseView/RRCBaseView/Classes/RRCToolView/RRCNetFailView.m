//
//  RRCNetFailView.m
//  MXSFramework
//
//  Created by renrencai on 2019/5/8.
//  Copyright © 2019 MXS. All rights reserved.
//

#import "RRCNetFailView.h"
#import "YBColorConfigure.h"
#import "RRCDeviceConfigure.h"
#import "Masonry.h"
@interface RRCNetFailView ()
@property (strong, nonatomic) UILabel *alertLabel;
@property (strong, nonatomic) UIImageView *alertImage;
@property (strong, nonatomic) UIButton *alertButton;
@end

@implementation RRCNetFailView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RRCUnitViewColor;
    }
    return self;
}
#pragma mark - 无网络
-(void)loadAlertNetFailView{
    RRCNoDataModel *nodataModel = [[RRCNoDataModel alloc]init];
    nodataModel.noDataType = RRCEmptyTypeAll;
    nodataModel.text = @"请检查您的网络连接";
    nodataModel.imageName = @"无网络连接";
    nodataModel.responseText = @"重新连接";
    nodataModel.responseType = 1;
    [self alertViewModel:nodataModel withY:0 reloadBtn:^(UIButton *btnBlock) {
        
        [self hiddenNetFailView];
        
        [self reloadNetWorking:btnBlock];
    }];
}
-(void)hiddenNetFailView{
    [self removeFromSuperview];
}

-(void)reloadNetWorking:(UIButton *)sender{
    if (self.reloadNetBlock) {
        self.reloadNetBlock(sender);
    }
}

-(void)alertViewModel:(RRCNoDataModel *)dataModel withY:(CGFloat)Y reloadBtn:(reloadNetFailBlock)reloaBtnBlock{
    
    if (dataModel.noDataType == RRCEmptyTypeImage) {
        
    }else if (dataModel.noDataType == RRCEmptyTypeImageAndText){
        [self addSubview:self.alertImage];
        [self.alertImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.centerY.mas_offset(dataModel.topMargin);
        }];
        if (dataModel.imageName.length > 0) {
            self.alertImage.image = [UIImage imageNamed:dataModel.imageName];
        }
        
        [self addSubview:self.alertLabel];
        [self.alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(self.alertImage.mas_bottom).offset(8);
        }];
        self.alertLabel.text = dataModel.text;
    }else if (dataModel.noDataType == RRCEmptyTypeAll){
        
        [self addSubview:self.alertImage];
        [self.alertImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.centerY.mas_offset(dataModel.topMargin);
        }];
        if (dataModel.imageName.length > 0) {
            self.alertImage.image = [UIImage imageNamed:dataModel.imageName];
        }
        
        [self addSubview:self.alertLabel];
        [self.alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(self.alertImage.mas_bottom).offset(8);
        }];
        self.alertLabel.text = dataModel.text;
        
        //响应按钮
        [self addSubview:self.alertButton];
        [self.alertButton setTitle:dataModel.responseText forState:UIControlStateNormal];
        self.alertButton.tag = dataModel.responseType;
        
        if (dataModel.responseType) {
            self.reloadNetBlock = reloaBtnBlock;
            [self.alertButton addTarget:self action:@selector(reloadNetWorking:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [self.alertButton addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        [self.alertButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(self.alertLabel.mas_bottom).offset(20);
            make.width.mas_equalTo(144 * Device_Ccale);
            make.height.mas_equalTo(40 * Device_Ccale);
        }];
    }
}

-(void)loginBtnClick:(UIButton *)sender{
    if (self.reloadNetBlock) {
        self.reloadNetBlock(sender);
    }
}

#pragma mark - Getter
-(UIImageView *)alertImage{
    if (!_alertImage) {
        _alertImage = [UIImageView new];
    }
    return _alertImage;
}
-(UILabel *)alertLabel{
    if (!_alertLabel) {
        _alertLabel = [UILabel new];
        _alertLabel = [[UILabel alloc]init];
        
        _alertLabel.font = [UIFont systemFontOfSize:14*Device_Ccale];
        
        _alertLabel.textColor = RRCGrayTextColor;
        _alertLabel.textAlignment = NSTextAlignmentCenter;
        _alertLabel.numberOfLines = 0;
    }
    return _alertLabel;
}
-(UIButton *)alertButton{
    if (!_alertButton) {
        _alertButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_alertButton setTitleColor:RRCWhiteTextColor forState:UIControlStateNormal];
        _alertButton.backgroundColor = RRCThemeViewColor;
        _alertButton.titleLabel.font = [UIFont systemFontOfSize:16 * Device_Ccale];
        _alertButton.layer.masksToBounds = YES;
        _alertButton.layer.cornerRadius = 3.0f;
    }
    return _alertButton;
}
@end

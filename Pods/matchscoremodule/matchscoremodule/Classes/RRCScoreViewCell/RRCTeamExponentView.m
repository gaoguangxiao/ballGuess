//
//  RRCTeamExponentView.m
//  matchscoremodule
//
//  Created by gaoguangxiao on 2020/5/19.
//

#import "RRCTeamExponentView.h"
#import "RRCTScoreModel.h"
#import "UIImage+Matchscoremodule.h"
@interface RRCTeamExponentView ()

@property (nonatomic, strong)UILabel *JPSKCOUNT;
@property (nonatomic, strong)UILabel *DXQCOUNT;

@property (nonatomic, strong)UIButton *recommendCount;
@property (nonatomic, strong)UIImageView *recommendImage;
@property (nonatomic, strong)UIView *openEventLineView;
@property (nonatomic, strong)UIButton *openEventBtn;

@property(nonatomic, strong) RRCTScoreModel *t_scoreModel;
@end

@implementation RRCTeamExponentView

-(void)setViewColor{
    [super setViewColor];
    
    self.backgroundColor = [UIColor clearColor];
}

-(void)setUpView{
    [self addSubview:self.JPSKCOUNT];
    [self addSubview:self.DXQCOUNT];
    [self addSubview:self.recommendCount];
//    [self addSubview:self.recommendImage];
    
    [self addSubview:self.openEventLineView];
    [self addSubview:self.openEventBtn];
    
    [self.JPSKCOUNT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12 * Device_Ccale);
        make.top.mas_equalTo(self);
    }];
    
    [self.DXQCOUNT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.JPSKCOUNT.mas_right).offset(12 * Device_Ccale);
        make.centerY.mas_equalTo(self.JPSKCOUNT);
    }];
    
    [self.recommendCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.openEventLineView.mas_left).offset(-8 * Device_Ccale);
        make.centerY.mas_equalTo(self.DXQCOUNT.mas_centerY);
        make.height.mas_equalTo(15 * Device_Ccale);
    }];
    
    [self.openEventLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.openEventBtn.mas_left);
        make.centerY.mas_equalTo(self.recommendCount.mas_centerY);
        make.width.mas_equalTo(1 * Device_Ccale);
        make.height.mas_equalTo(9 * Device_Ccale);
    }];
    
    [self.openEventBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(self.openEventLineView.mas_right);
        make.bottom.mas_equalTo(self);
        make.width.mas_equalTo(42 * Device_Ccale);
        make.top.mas_equalTo(self);
    }];
    
    
}

-(void)setupTeamExponentData:(RRCTScoreModel *)scoreModel{
    
    self.t_scoreModel = scoreModel;
    
    _JPSKCOUNT.text = [NSString stringWithFormat:@"亚：%@ %@ %@",kSafeString(scoreModel.HJSPL),kSafeString(scoreModel.JSPKDesc),kSafeString( scoreModel.WJSPL)];
    _DXQCOUNT.text  = [NSString stringWithFormat:@"大：%@ %@ %@",kSafeString(scoreModel.DXQ_HJSPL),kSafeString(scoreModel.DXQDesc),kSafeString(scoreModel.DXQ_WJSPL)];
    
    [self yaAndDxTitleColor];
    
    if ([scoreModel.recommendNum integerValue] == 0) {
        [_recommendCount setTitle:@"" forState:UIControlStateNormal];
        _recommendImage.hidden = YES;
    }else{
        [_recommendCount setTitle:[NSString stringWithFormat:@"%@分析推荐",scoreModel.recommendNum] forState:UIControlStateNormal];
        _recommendImage.hidden = NO;
    }
    
    //包含事件
    if (scoreModel.isContainsMatchEvent && scoreModel.isShowOpenEvent) {
        
        _openEventBtn.selected = scoreModel.isOpenEvent;
        
        if (scoreModel.isOpenEvent) {
            [_openEventBtn setTitle:@"收起" forState:UIControlStateNormal];
        }else{
            [_openEventBtn setTitle:@"展开" forState:UIControlStateNormal];
        }
        
        //分析推荐 和 打开事件按钮中间横线，有事件
        if (scoreModel.recommendNum.integerValue) {
            
            _openEventLineView.hidden = NO;
            
        }else{
            
            _openEventLineView.hidden = YES;
        }
        
        //
        [_openEventBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(42 * Device_Ccale);
        }];
    }else{
        [_openEventBtn setTitle:@"" forState:UIControlStateNormal];
        
        _openEventLineView.hidden = YES;
        //没有比赛事件
        [_openEventBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(3 * Device_Ccale);
        }];
        
    }
    
}

-(void)yaAndDxTitleColor{
    //亚盘颜色
    //    scoreModel.HJSPLFlag;scoreModel.JSPKFlag;scoreModel.WJSPLFlag;
    NSMutableAttributedString *jpskTip = [[NSMutableAttributedString alloc]initWithString:_JPSKCOUNT.text];
    if ([self.t_scoreModel.HJSPLFlag integerValue] == 1 && self.t_scoreModel.HJSPLFlagTimer) {//上升
        
        [jpskTip addAttribute:NSForegroundColorAttributeName value:RRCHighLightTitleColor range:NSMakeRange(2, self.t_scoreModel.HJSPL.length)];
    
    }else if ([self.t_scoreModel.HJSPLFlag integerValue] == 2 && self.t_scoreModel.HJSPLFlagTimer){
        
        [jpskTip addAttribute:NSForegroundColorAttributeName value:RRC04BD2CColor range:NSMakeRange(2, self.t_scoreModel.HJSPL.length)];
        
    }else{
        
        [jpskTip addAttribute:NSForegroundColorAttributeName value:RRCGrayTextColor range:NSMakeRange(2, self.t_scoreModel.HJSPL.length)];
    
    }
    
    if ([self.t_scoreModel.JSPKFlag integerValue] == 1 && self.t_scoreModel.JSPKFlagTimer) {
        
        [jpskTip addAttribute:NSForegroundColorAttributeName value:RRCHighLightTitleColor range:NSMakeRange(3 + self.t_scoreModel.HJSPL.length, self.t_scoreModel.JSPKDesc.length)];
        
    }else if ([self.t_scoreModel.JSPKFlag integerValue] == 2&& self.t_scoreModel.JSPKFlagTimer){
        
        [jpskTip addAttribute:NSForegroundColorAttributeName value:RRC04BD2CColor range:NSMakeRange(3 + self.t_scoreModel.HJSPL.length, self.t_scoreModel.JSPKDesc.length)];
        
    }else{
        
        if ([self.t_scoreModel.JSPKDesc isEqualToString:@"-"] || [self.t_scoreModel.JSPKDesc isEqualToString:@"封"]) {
            [jpskTip addAttribute:NSForegroundColorAttributeName value:RRCGrayTextColor range:NSMakeRange(3 + self.t_scoreModel.HJSPL.length, self.t_scoreModel.JSPKDesc.length)];
        }else{
            [jpskTip addAttribute:NSForegroundColorAttributeName value:RRCThemeTextColor range:NSMakeRange(3 + self.t_scoreModel.HJSPL.length, self.t_scoreModel.JSPKDesc.length)];
        }
    }
    
    if ([self.t_scoreModel.WJSPLFlag integerValue] == 1 && self.t_scoreModel.WJSPLFlagTimer) {
        
        [jpskTip addAttribute:NSForegroundColorAttributeName value:RRCHighLightTitleColor range:NSMakeRange(4 + self.t_scoreModel.HJSPL.length + self.t_scoreModel.JSPKDesc.length, self.t_scoreModel.WJSPL.length)];
    
    }else if ([self.t_scoreModel.WJSPLFlag integerValue] == 2 && self.t_scoreModel.WJSPLFlagTimer){
        
        [jpskTip addAttribute:NSForegroundColorAttributeName value:RRC04BD2CColor range:NSMakeRange(4 + self.t_scoreModel.HJSPL.length + self.t_scoreModel.JSPKDesc.length, self.t_scoreModel.WJSPL.length)];
    
    }else{
       
        [jpskTip addAttribute:NSForegroundColorAttributeName value:RRCGrayTextColor range:NSMakeRange(4 + self.t_scoreModel.HJSPL.length + self.t_scoreModel.JSPKDesc.length, self.t_scoreModel.WJSPL.length)];
    }
    
    _JPSKCOUNT.attributedText = jpskTip;
    
    //大小球DXQCOUNT
    NSMutableAttributedString *dxqTip = [[NSMutableAttributedString alloc]initWithString:_DXQCOUNT.text];
    if ([self.t_scoreModel.DXQ_HJSPLFlag integerValue] == 1 && self.t_scoreModel.DXQ_HJSPLFlagTimer) {//上升
        [dxqTip addAttribute:NSForegroundColorAttributeName value:RRCHighLightTitleColor range:NSMakeRange(2, self.t_scoreModel.DXQ_HJSPL.length)];
    }else if ([self.t_scoreModel.DXQ_HJSPLFlag integerValue] == 2 && self.t_scoreModel.DXQ_HJSPLFlagTimer){
        [dxqTip addAttribute:NSForegroundColorAttributeName value:RRC04BD2CColor range:NSMakeRange(2, self.t_scoreModel.DXQ_HJSPL.length)];
    }else{
        [dxqTip addAttribute:NSForegroundColorAttributeName value:RRCGrayTextColor range:NSMakeRange(2, self.t_scoreModel.DXQ_HJSPL.length)];
    }
    
    if ([self.t_scoreModel.DXQ_JSPKFlag integerValue] == 1 && self.t_scoreModel.DXQ_JSPKFlagTimer) {
        [dxqTip addAttribute:NSForegroundColorAttributeName value:RRCHighLightTitleColor range:NSMakeRange(3 + self.t_scoreModel.DXQ_HJSPL.length, self.t_scoreModel.DXQDesc.length)];
    }else if ([self.t_scoreModel.DXQ_JSPKFlag integerValue] == 2&& self.t_scoreModel.DXQ_JSPKFlagTimer){
        [dxqTip addAttribute:NSForegroundColorAttributeName value:RRC04BD2CColor range:NSMakeRange(3 + self.t_scoreModel.DXQ_HJSPL.length, self.t_scoreModel.DXQDesc.length)];
    }else{
        if ([self.t_scoreModel.DXQDesc isEqualToString:@"-"] || [self.t_scoreModel.DXQDesc isEqualToString:@"封"]) {
            [dxqTip addAttribute:NSForegroundColorAttributeName value:RRCGrayTextColor range:NSMakeRange(3 + self.t_scoreModel.DXQ_HJSPL.length, self.t_scoreModel.DXQDesc.length)];
        }else{
            [dxqTip addAttribute:NSForegroundColorAttributeName value:RRCThemeTextColor range:NSMakeRange(3 + self.t_scoreModel.DXQ_HJSPL.length, self.t_scoreModel.DXQDesc.length)];
        }
    }
    
    if ([self.t_scoreModel.DXQ_WJSPLFlag integerValue] == 1 && self.t_scoreModel.DXQ_WJSPLFlagTimer) {
        [dxqTip addAttribute:NSForegroundColorAttributeName value:RRCHighLightTitleColor range:NSMakeRange(4 + self.t_scoreModel.DXQ_HJSPL.length + self.t_scoreModel.DXQDesc.length, self.t_scoreModel.DXQ_WJSPL.length)];
    }else if ([self.t_scoreModel.DXQ_WJSPLFlag integerValue] == 2 && self.t_scoreModel.DXQ_WJSPLFlagTimer){
        [dxqTip addAttribute:NSForegroundColorAttributeName value:RRC04BD2CColor range:NSMakeRange(4 + self.t_scoreModel.DXQ_HJSPL.length + self.t_scoreModel.DXQDesc.length, self.t_scoreModel.DXQ_WJSPL.length)];
    }else{
        [dxqTip addAttribute:NSForegroundColorAttributeName value:RRCGrayTextColor range:NSMakeRange(4 + self.t_scoreModel.DXQ_HJSPL.length + self.t_scoreModel.DXQDesc.length, self.t_scoreModel.DXQ_WJSPL.length)];
    }
    _DXQCOUNT.attributedText = dxqTip;
}

#pragma mark - Event Response
-(void)eventStateChange:(UIButton *)sender{
//    sender.selected = sender.isSelected;
    if (self.EventChangeBlock) {
        self.EventChangeBlock(!sender.selected);
    }
}

#pragma mark - Getter
-(UIButton *)recommendCount{
    if (!_recommendCount) {
        _recommendCount = [UIButton buttonWithType:UIButtonTypeCustom];
        _recommendCount.titleLabel.font = K_FontSizeTiny;
        [_recommendCount setTitleColor:RRCHighLightTitleColor forState:UIControlStateNormal];
    }
    return _recommendCount;
}

-(UIImageView *)recommendImage{
    if (!_recommendImage) {
        _recommendImage = [[UIImageView alloc]initWithImage:[UIImage matchscoremoduleImageNamed:@"matchscoremodule_redenter"]];
    }
    return _recommendImage;
}

-(UILabel *)JPSKCOUNT{
    if (!_JPSKCOUNT) {
        _JPSKCOUNT = [[UILabel alloc]init];
        _JPSKCOUNT.font = K_FontSizeViceTiny;
        _JPSKCOUNT.textColor = RRCGrayTextColor;
    }
    return _JPSKCOUNT;
}

-(UILabel *)DXQCOUNT{
    if (!_DXQCOUNT) {
        _DXQCOUNT = [[UILabel alloc]init];
        _DXQCOUNT.font = K_FontSizeViceTiny;
        _DXQCOUNT.textColor = RRCGrayTextColor;
    }
    return _DXQCOUNT;
}

-(UIView *)openEventLineView{
    if (!_openEventLineView) {
        _openEventLineView = [[UIView alloc]init];
        _openEventLineView.backgroundColor = RRCLineViewColor;
    }
    return _openEventLineView;
}
-(UIButton *)openEventBtn{
    if (!_openEventBtn) {
        _openEventBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_openEventBtn setTitle:@"展开" forState:UIControlStateNormal];
        _openEventBtn.titleEdgeInsets = UIEdgeInsetsMake(- 12 * Device_Ccale, 0, 0, 0);
        _openEventBtn.titleLabel.font = K_FontSizeViceTiny;
        [_openEventBtn setTitleColor:RRCGrayTextColor forState:UIControlStateNormal];
        [_openEventBtn addTarget:self action:@selector(eventStateChange:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openEventBtn;
}
@end

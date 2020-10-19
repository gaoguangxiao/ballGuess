//
//  RRCTeamVSScoreView.m
//  matchscoremodule
//
//  Created by gaoguangxiao on 2020/5/16.
//

#import "RRCTeamVSScoreView.h"
#import "RRCTScoreModel.h"
#import "NSString+DYWidthOrHeight.h"
#import "UIImage+Matchscoremodule.h"
#import "NSString+DYLineWordSpace.h"

#import "DYUIViewExt.h"
#import "RRCLabel.h"
@interface RRCTeamVSScoreView ()

/// 直播按钮
@property (nonatomic , strong) UIButton *liveIconBtn;
//比分
@property (nonatomic , strong) UILabel *warScore;

//主队名字
@property (nonatomic , strong) UILabel *homeName;
//主队副名字
@property (nonatomic , strong) UILabel *homeSecondName;
//主队扩展信息
@property (nonatomic , strong) UILabel *homeExtensionsName;
//主牌
@property (nonatomic , strong) RRCLabel *homeBrand1;
//备用的牌子
@property (nonatomic , strong) RRCLabel *homeBrand2;

//客队名字
@property (nonatomic , strong) UILabel *awayName;
//客队副名字
@property (nonatomic , strong) UILabel *awaySecodName;
//客队扩展信息
@property (nonatomic , strong) UILabel *awayExtensionsName;
//客队主牌
@property (nonatomic , strong) RRCLabel *awayBrand1;
//客队备用的牌子
@property (nonatomic , strong) RRCLabel *awayBrand2;

@property(nonatomic, strong) RRCTScoreModel *local_scoreModel;
/// 计算主客队名字宽度的Label控件
@property (nonatomic , strong) UILabel *calculateLabel;
@end

@implementation RRCTeamVSScoreView

-(void)setViewColor{
    [super setViewColor];
    
    self.backgroundColor = [UIColor clearColor];
}

-(void)setUpView{
    
    //    NSLog(@"%@",self);
    
    [self addSubview:self.calculateLabel];
    [self addSubview:self.liveIconBtn];
    
    [self addSubview:self.collectStatusBtn];
    [self addSubview:self.warScore];
    [self addSubview:self.homeName];
    [self addSubview:self.homeSecondName];
    [self addSubview:self.homeExtensionsName];
    [self addSubview:self.homeBrand1];
    [self addSubview:self.homeBrand2];
    
    [self addSubview:self.awayName];
    [self addSubview:self.awaySecodName];
    [self addSubview:self.awayExtensionsName];
    [self addSubview:self.awayBrand1];
    [self addSubview:self.awayBrand2];
    [self.collectStatusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(50 * Device_Ccale);
    }];
    
    [self.liveIconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_offset(-12 * Device_Ccale);
        make.width.mas_offset(16 * Device_Ccale);
        make.centerY.mas_equalTo(self);
    }];
    
    [self.warScore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(38 * Device_Ccale);
        make.centerY.mas_equalTo(self);
    }];
    
    [self.homeName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.warScore.mas_left).offset(-12 * Device_Ccale);
        make.height.mas_equalTo(13 * Device_Ccale);
        make.centerY.mas_equalTo(self);
    }];
    
    [self.homeSecondName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(self.homeName);
        make.height.mas_equalTo(13 * Device_Ccale);
        make.top.mas_equalTo(self.homeName.mas_bottom).offset(5 * Device_Ccale);
    }];
    
    [self.homeExtensionsName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0);
        make.top.mas_equalTo(self.homeName.mas_top).offset(0.5 * Device_Ccale);//主队名字上下偏移
        make.height.mas_equalTo(12 * Device_Ccale);
        make.right.mas_equalTo(self.homeName.mas_left).offset(-3.5 * Device_Ccale);
    }];
    
    //主队信息
    [self.homeBrand1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_greaterThanOrEqualTo(self.collectStatusBtn.mas_right);
        make.width.mas_equalTo(0);
        make.centerY.mas_equalTo(self.homeExtensionsName.mas_centerY);
        make.right.mas_equalTo(self.homeExtensionsName.mas_left).offset(-3 * Device_Ccale);
    }];
    
    //两个以上【备用的】
    [self.homeBrand2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_greaterThanOrEqualTo(self.collectStatusBtn.mas_right);
        make.right.mas_equalTo(self.homeBrand1.mas_left).offset(-4 * Device_Ccale);
        make.width.mas_equalTo(0);
        make.top.mas_equalTo(self.homeBrand1.mas_top);
    }];
    
    //客队
    [self.awayName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.warScore.mas_right).offset(12 * Device_Ccale);
        make.height.mas_equalTo(13 * Device_Ccale);
        make.right.mas_equalTo(self.awayExtensionsName.mas_left).offset(- 3.5 * Device_Ccale);
        make.centerY.mas_equalTo(self);
    }];
    
    [self.awaySecodName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(13 * Device_Ccale);
        make.right.left.mas_equalTo(self.awayName);
        make.top.mas_equalTo(self.awayName.mas_bottom).offset(5 * Device_Ccale);
    }];
    
    [self.awayBrand1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_lessThanOrEqualTo(self.liveIconBtn.mas_left).offset(-3.5 * Device_Ccale);
        make.width.mas_equalTo(0);
        make.centerY.mas_equalTo(self.awayExtensionsName.mas_centerY);
    }];
    
    //两个以上【备用的】
    [self.awayBrand2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_lessThanOrEqualTo(self.liveIconBtn.mas_left).offset(-3.5 * Device_Ccale);
        make.left.mas_equalTo(self.awayBrand1.mas_right).offset(4 * Device_Ccale);
        make.width.mas_equalTo(0);
        make.centerY.mas_equalTo(self.awayBrand1.mas_centerY);
    }];
    
    [self.awayExtensionsName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.awayBrand1.mas_left).offset(-3 * Device_Ccale);
        make.width.mas_equalTo(0);
        make.height.mas_equalTo(12 * Device_Ccale);
        make.top.mas_equalTo(self.awayName.mas_top).offset(0.5 * Device_Ccale);//主队名字上下偏移
    }];
    
}

-(void)setupTeamData:(RRCTScoreModel *)scoreModel{
    
    self.local_scoreModel = scoreModel;
    
    //收藏按钮
    self.collectStatusBtn.selected = [scoreModel.collectStatus integerValue] == 1;
    if (scoreModel.isShowCollectStatusBtn) {
        _collectStatusBtn.hidden = NO;
        
        [_collectStatusBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(50 * Device_Ccale);
        }];
        
    }else{
        
        _collectStatusBtn.hidden = YES;
        
        [_collectStatusBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(12 * Device_Ccale);
        }];
        
    }
    //    NSLog(@"%@",scoreModel.collectStatus);
    
    //布局直播按钮
    if ([scoreModel.live integerValue] == 1 || scoreModel.dhlive) {
        
        _liveIconBtn.hidden = NO;
        
        [_liveIconBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-12 * Device_Ccale);
            make.width.mas_offset(16 * Device_Ccale);
        }];
        
    }else{
        
        _liveIconBtn.hidden = YES;
        //直播距离右边视图间距3.5.因此直播按钮隐藏时右边视图距离右边8.5
        [_liveIconBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-8.5 * Device_Ccale);
            make.width.mas_offset(0 * Device_Ccale);
        }];
        
    }
    //当动画直播和视频直播都存在时显示视频直播【只有1才正常】
    //当动画直播、视频直播 显示视频直播 1-1 1-0 0-1 0-0
    if ([scoreModel.live integerValue] == 1 && scoreModel.dhlive) {
        [_liveIconBtn setImage:[UIImage matchscoremoduleImageNamed:@"matchscoremodule_matchLive"] forState:UIControlStateNormal];
    }else if ([scoreModel.live integerValue] == 1 && scoreModel.dhlive == 0){
        [_liveIconBtn setImage:[UIImage matchscoremoduleImageNamed:@"matchscoremodule_matchLive"] forState:UIControlStateNormal];
    }else if ([scoreModel.live integerValue] != 1 && scoreModel.dhlive){
        [_liveIconBtn setImage:[UIImage matchscoremoduleImageNamed:@"matchscoremodule_dhlive"] forState:UIControlStateNormal];
    }else{
        
    }
    
    //    [_liveIconBtn setImage:[UIImage matchscoremoduleImageNamed:@"matchscoremodule_matchLive"] forState:UIControlStateNormal];
    //    [_liveIconBtn setImage:[UIImage matchscoremoduleImageNamed:@"matchscoremodule_dhlive"] forState:UIControlStateNormal];
    //    _liveIconBtn.hidden = YES;
    //    self.liveIconBtn.hidden = [scoreModel.live integerValue] != 1;
    
    //    NSLog(@"直播源有没：%@",scoreModel.live);
    
    //比赛状态
    if ([scoreModel.state integerValue] == 0) {
        //比分
        _warScore.text      = [NSString stringWithFormat:@"VS"];
        _warScore.textColor = RRCGrayTextColor;
    }else if ([scoreModel.state integerValue] == 1 ||[scoreModel.state integerValue] == 3){
        
        _warScore.text   = [NSString stringWithFormat:@"%@-%@",scoreModel.homeScore,scoreModel.awayScore];
        _warScore.textColor = RRC0F9958Color;
        
    }else if ([scoreModel.state integerValue] == 2 ||[scoreModel.state integerValue] == 4||[scoreModel.state integerValue] == 5){//中场
        
        _warScore.text   = [NSString stringWithFormat:@"%@-%@",scoreModel.homeScore,scoreModel.awayScore];
        _warScore.textColor = RRC0F9958Color;//0F9958
    }else if ([scoreModel.state integerValue] == -1){
        
        _warScore.text   = [NSString stringWithFormat:@"%@-%@",scoreModel.homeScore,scoreModel.awayScore];
        _warScore.textColor = RRCHighLightTitleColor;
    }else{
        _warScore.text      = [NSString stringWithFormat:@"VS"];
        _warScore.textColor = RRCGrayTextColor;
    }
    
    //更改样式
    if (scoreModel.enterballNumber.boolValue) {
        if (scoreModel.enterballMember == 1) {
            _homeName.textColor = RRCHighLightTitleColor;
            _awayName.textColor = RRCThemeTextColor;
        }else if(scoreModel.enterballMember == 2){
            _awayName.textColor = RRCHighLightTitleColor;
            _homeName.textColor = RRCThemeTextColor;
        }
    }else{
        _homeName.textColor = RRCThemeTextColor;
        _awayName.textColor = RRCThemeTextColor;
    }
    _homeSecondName.textColor = _homeName.textColor;
    _awaySecodName.textColor  = _awayName.textColor;
    
    [self layoutIfNeeded];
    //    NSLog(@"比分宽度：%f",_warScore.width);
    [self resetHomeMasonry];
    [self handleHomeNameShow:scoreModel];
    
    [self resetAwayMasnory];
    [self handleAwayNameShow:scoreModel];
}

//重置主队约束
-(void)resetHomeMasonry{
    [self.homeName mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.warScore.mas_left).offset(-12 * Device_Ccale);
        make.centerY.mas_equalTo(self);
    }];
    
    [self.homeSecondName mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(self.homeName);
    }];
    
    [self.homeExtensionsName mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(0);
        make.right.mas_equalTo(self.homeName.mas_left).offset(-3.5 * Device_Ccale);
    }];
    
    [self.homeBrand1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_greaterThanOrEqualTo(self.collectStatusBtn.mas_right);
        make.width.mas_equalTo(0);
        make.right.mas_equalTo(self.homeExtensionsName.mas_left).offset(-3 * Device_Ccale);
    }];
    
    [self.homeBrand2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_greaterThanOrEqualTo(self.collectStatusBtn.mas_right);
        make.right.mas_equalTo(self.homeBrand1.mas_left).offset(-4 * Device_Ccale);
        make.width.mas_equalTo(0);
    }];
}

-(void)resetAwayMasnory{
    //客队
    [self.awayName mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.warScore.mas_right).offset(12 * Device_Ccale);
        make.right.mas_equalTo(self.awayExtensionsName.mas_left).offset(- 3.5 * Device_Ccale);
        make.centerY.mas_equalTo(self);
    }];
    
    [self.awaySecodName mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(self.awayName);
        make.top.mas_equalTo(self.awayName.mas_bottom).offset(5 * Device_Ccale);
    }];
    
    [self.awayBrand1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_lessThanOrEqualTo(self.liveIconBtn.mas_left).offset(-3.5 * Device_Ccale);
        make.width.mas_equalTo(0);
    }];
    
    [self.awayBrand2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_lessThanOrEqualTo(self.liveIconBtn.mas_left).offset(-3.5 * Device_Ccale);
        make.left.mas_equalTo(self.awayBrand1.mas_right).offset(4 * Device_Ccale);
        make.width.mas_equalTo(0);
    }];
    
    [self.awayExtensionsName mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.awayBrand1.mas_left).offset(-3 * Device_Ccale);
        make.width.mas_equalTo(0);
    }];
}

-(void)handleHomeNameShow:(RRCTScoreModel *)scoreModel{
    
    _homeBrand1.hidden = YES;
    _homeBrand2.hidden = YES;
    CGFloat homeLeftMargin = 0;
    CGFloat homeBrand1Width = 0;
    CGFloat homeBrand2Width = 0;
    _homeBrand1.text = @"";
    _homeBrand2.text = @"";
    
    if ([scoreModel.yellow1 integerValue] && [scoreModel.red1 integerValue]) {
        _homeBrand1.hidden = NO;
        _homeBrand2.hidden = NO;
        _homeBrand1.backgroundColor = RRCFFC60AColor;
        _homeBrand2.backgroundColor = RRCThemeViewColor;
        
        _homeBrand1.text = [NSString stringWithFormat:@"%@",kSafeString(scoreModel.yellow1)];
        homeBrand1Width = [self.homeBrand1 sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
        //                NSLog(@"红牌宽度：%f",homeBrand1Width);
        [_homeBrand1 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(homeBrand1Width);
        }];
        
        //第二个牌子更新
        _homeBrand2.text = [NSString stringWithFormat:@"%@",kSafeString(scoreModel.red1)];//最右边
        homeBrand2Width = [self.homeBrand2 sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
        //                NSLog(@"黄牌宽度：%f",homeBrand2Width);
        [self.homeBrand2 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(homeBrand2Width);
        }];
        homeLeftMargin = homeBrand1Width + 4 * Device_Ccale + homeBrand2Width;
        
    }
    else if (scoreModel.red1.integerValue){
        _homeBrand1.hidden = NO;
        
        _homeBrand1.text = kSafeString(scoreModel.red1);
        _homeBrand1.backgroundColor = RRCThemeViewColor;
        homeBrand1Width = [self.homeBrand1 sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
        //                NSLog(@"红牌宽度：%f",homeBrand1Width);
        [_homeBrand1 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(homeBrand1Width);
        }];
        homeLeftMargin = homeBrand1Width;
    }
    else if (scoreModel.yellow1.integerValue){
        _homeBrand1.hidden = NO;
        _homeBrand1.backgroundColor = RRCFFC60AColor;
        _homeBrand1.text = kSafeString(scoreModel.yellow1);
        homeBrand1Width = [self.homeBrand1 sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
        //        NSLog(@"黄牌宽度：%f",homeBrand1Width);
        [_homeBrand1 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(homeBrand1Width);
        }];
        homeLeftMargin = homeBrand1Width;
    }
    
    _homeExtensionsName.text = kSafeString(scoreModel.homeTeamRanking);
    
    CGFloat homeExtensionsWidth = [self.homeExtensionsName sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
    
    [_homeExtensionsName mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(homeExtensionsWidth);
    }];
    //    NSLog(@"排名宽度:%f ",homeExtensionsWidth);
    //如果有牌 以及 排名 那么中间有3的间距
    if (homeLeftMargin > 0 && homeExtensionsWidth > 0) {
        homeLeftMargin += 3 * Device_Ccale;
    }
    
    //排名宽度
    if (homeExtensionsWidth > 0) {
        homeLeftMargin += homeExtensionsWidth;
    }
    //        NSLog(@"宽度总和【如果两个牌子间距4】：%f",homeLeftMargin);
    
    //主队名字距离左边 如果有牌3.5 联赛排名
    if (_homeExtensionsName.text.length || _homeBrand1.text.length) {
        homeLeftMargin += 3.5 * Device_Ccale;
    }
    
    if (_homeExtensionsName.text.length) {
        if (_homeBrand1.text.length == 0) {
            //            没有红黄牌时，此牌距离左边按钮应该为0
            [_homeBrand1 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.homeExtensionsName.mas_left).offset(0 * Device_Ccale);
            }];
        }else{
            [_homeBrand1 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.homeExtensionsName.mas_left).offset(-3 * Device_Ccale);
            }];
        }
        //调整主队名字距离排名间距
        [_homeExtensionsName mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.homeName.mas_left).offset(-3.5 * Device_Ccale);
        }];
        
    }else if (_homeBrand1.text.length){
        [_homeBrand1 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.homeExtensionsName.mas_left).offset(-3 * Device_Ccale);
        }];
        
        [_homeExtensionsName mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.homeName.mas_left).offset(0 * Device_Ccale);
        }];
        
    }else{
        [_homeBrand1 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.homeExtensionsName.mas_left).offset(-3 * Device_Ccale);
        }];
        [_homeExtensionsName mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.homeName.mas_left).offset(3.5 * Device_Ccale);
        }];
    }
    //    NSLog(@"排名以及红黄牌所占间距【牌左边一直到排名右边 外加3.5间距】：%f",homeLeftMargin);
    CGFloat scoreWidth = self.warScore.width/2 + 12 * Device_Ccale;
    //    NSLog(@"收藏按钮宽度:%f",self.collectStatusBtn.width);
    CGFloat otherWidth = self.collectStatusBtn.width + scoreWidth + homeLeftMargin;
    
    CGFloat homeContentWidth =  kScreenWidth/2 - otherWidth;
    
    NSString *leftText = scoreModel.home;
    float homeNameSize = [leftText LabelWidth:13 * Device_Ccale];
    
//    NSLog(@"leftText:%@-homeContentWidth:%f-homeNameSize:%f",leftText,homeContentWidth,homeNameSize);
    if (homeNameSize > homeContentWidth) {//两行显示
        
        NSArray *nameArr = [self arrayFirstHome:homeContentWidth andName:leftText];
        scoreModel.layoutHomeNameWidth = [nameArr.firstObject floatValue];
        if (nameArr.count == 2) {
            scoreModel.firstHomeString = nameArr.lastObject;
        }else if (nameArr.count == 3){
            scoreModel.firstHomeString = nameArr[1];
            scoreModel.secondHomeString = nameArr.lastObject;
        }
    }else{//一行显示
        scoreModel.layoutHomeNameWidth = homeNameSize;
        scoreModel.firstHomeString = leftText;
        scoreModel.secondHomeString = @"";
    }
    
    if (scoreModel.secondHomeString.length) {
        [_homeName mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self).offset(-8 * Device_Ccale);
        }];
        
    }else{
        [_homeName mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
        }];
    }
  
    _homeName.text = scoreModel.firstHomeString;
    _homeSecondName.text = scoreModel.secondHomeString;
}

-(void)handleAwayNameShow:(RRCTScoreModel *)scoreModel{
    
    _awayBrand1.hidden = YES;
    _awayBrand2.hidden = YES;
    CGFloat awayLeftMargin = 0;
    CGFloat awayBrand1Width = 0;
    CGFloat awayBrand2Width = 0;
    _awayBrand1.text = @"";
    _awayBrand2.text = @"";
    
    if ([scoreModel.yellow2 integerValue] && [scoreModel.red2 integerValue]) {
        _awayBrand1.hidden = NO;
        _awayBrand2.hidden = NO;
        _awayBrand1.backgroundColor = RRCFFC60AColor;
        _awayBrand2.backgroundColor = RRCThemeViewColor;
        
        //第二个牌子更新
        _awayBrand2.text = [NSString stringWithFormat:@"%@",kSafeString(scoreModel.red2)];//最右边
        awayBrand2Width = [self.awayBrand2 sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
        //        NSLog(@"红牌宽度：%f",awayBrand2Width);
        [self.awayBrand2 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(awayBrand2Width);
        }];
        
        _awayBrand1.text = [NSString stringWithFormat:@"%@",kSafeString(scoreModel.yellow2)];
        awayBrand1Width = [self.awayBrand1 sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
        //        NSLog(@"黄牌宽度：%f",awayBrand1Width);
        [self.awayBrand1 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(awayBrand1Width);
        }];
        
        awayLeftMargin = awayBrand1Width + 4 * Device_Ccale + awayBrand2Width;
        
    }
    else if (scoreModel.red2.integerValue){
        _awayBrand1.hidden = NO;
        
        _awayBrand1.text = kSafeString(scoreModel.red2);
        _awayBrand1.backgroundColor = RRCThemeViewColor;
        awayBrand1Width = [self.awayBrand1 sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
        //        NSLog(@"红牌宽度：%f",awayBrand1Width);
        [self.awayBrand1 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(awayBrand1Width);
        }];
        
        awayLeftMargin = awayBrand1Width;
    }
    else if (scoreModel.yellow2.integerValue){
        _awayBrand1.hidden = NO;
        _awayBrand1.backgroundColor = RRCFFC60AColor;
        _awayBrand1.text = kSafeString(scoreModel.yellow2);
        awayBrand1Width = [self.awayBrand1 sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
        //        NSLog(@"黄牌宽度：%f",awayBrand1Width);
        [self.awayBrand1 mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(awayBrand1Width);
        }];
        
        awayLeftMargin = awayBrand1Width;
    }
    
    _awayExtensionsName.text = kSafeString(scoreModel.awayTeamRanking);
    CGFloat awayExtensionsWidth = [self.awayExtensionsName sizeThatFits:CGSizeMake(MAXFLOAT, MAXFLOAT)].width;
    //排名宽度
    if (awayExtensionsWidth > 0) {
        awayLeftMargin += awayExtensionsWidth;
    }
    
    //    NSLog(@"排名宽度:%f ",awayExtensionsWidth);
    [self.awayExtensionsName mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(awayExtensionsWidth);
    }];
    
    //        NSLog(@"宽度总和【如果两个牌子间距4】：%f",awayLeftMargin);
    //如果有牌 以及 排名 那么中间有3的间距
    if (awayLeftMargin > 0 && awayExtensionsWidth > 0) {
        awayLeftMargin += 3 * Device_Ccale;
    }
    
    //主队名字距离左边 如果有牌3.5 联赛排名
    if (_awayExtensionsName.text.length || _awayBrand1.text.length) {
        awayLeftMargin += 3.5 * Device_Ccale;
    }
    
    if (_awayExtensionsName.text.length) {
        [self.awayName mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.awayExtensionsName.mas_left).offset(-3.5 * Device_Ccale);
        }];
    }else if (_awayBrand1.text.length){
        [self.awayName mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.awayExtensionsName.mas_left).offset(0 * Device_Ccale);
        }];
    }else{
        //名字_3.5_排名_3_牌4牌_3.5_按钮 【13.5】
        //-3.5 + _3_ + _3.5_ -> 6.5
        [self.awayName mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.awayExtensionsName.mas_left).offset(6.5 * Device_Ccale);
        }];
        
    }
    
    //    //    [self layoutIfNeeded];
    //    //    NSLog(@"排名以及红黄牌所占间距【牌左边一直到排名右边 外加3.5间距】：%f",awayLeftMargin);
    CGFloat scoreWidth = 0;
    if (self.liveIconBtn.width == 0) {
        scoreWidth = self.warScore.width/2 + 12 * Device_Ccale + 12 * Device_Ccale;
    }else{
        scoreWidth = self.warScore.width/2 + 12 * Device_Ccale + 15.5 * Device_Ccale;
    }
    //    NSLog(@"行数：%@、直播宽度：%f",scoreModel.time,self.liveIconBtn.width);
    CGFloat otherWidth = self.liveIconBtn.width + scoreWidth + awayLeftMargin;
    //    NSLog(@"其他间距：%f",otherWidth);
    CGFloat awayContentWidth =  kScreenWidth/2 - otherWidth;
    //    NSLog(@"awayContentWidth:%f",awayContentWidth);
    NSString *awayName = scoreModel.away;
    float awayNameSize = [awayName LabelWidth:13 * Device_Ccale];
    if (awayNameSize > awayContentWidth) {//两行显示
        
        NSArray *nameArr = [self arrayFirstHome:awayContentWidth andName:awayName];
        scoreModel.layoutAwayNameWidth = [nameArr.firstObject floatValue];
        if (nameArr.count == 2) {
            scoreModel.firstAwayString = nameArr.lastObject;
        }else if (nameArr.count == 3){
            scoreModel.firstAwayString = nameArr[1];
            scoreModel.secondAwayString = nameArr.lastObject;
        }
    }else{//一行显示
        scoreModel.layoutAwayNameWidth = awayNameSize;
        scoreModel.firstAwayString = awayName;
        scoreModel.secondAwayString = @"";
    }
    
    if (scoreModel.secondAwayString.length) {
        
        [_awayName mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self).offset(-10 * Device_Ccale);
            make.width.mas_lessThanOrEqualTo(scoreModel.layoutAwayNameWidth);
        }];
        
        _awayName.text = scoreModel.firstAwayString;
        
        _awaySecodName.text = scoreModel.secondAwayString;
        
    }else{
        
        [_awayName mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.width.mas_lessThanOrEqualTo(scoreModel.layoutAwayNameWidth);
        }];
        
        _awayName.text = scoreModel.firstAwayString;
        _awaySecodName.text = @"";
    }
    //    NSArray *awayNameArray = [self getLinesArrayOfStringInLabel:leftText font:_awayName.font andLableWidth:awayContentWidth];
    //    NSString *awayNameString = awayNameArray.firstObject;
    //    if (awayNameArray.count == 2) {
    //        //        NSLog(@"awayNameString:--%@/awayContentWidth:%f",awayNameString,awayContentWidth);
    //        awayNameString = [NSString stringWithFormat:@"%@%@",awayNameString,awayNameArray.lastObject];
    //        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:awayNameString];
    //
    //        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //        [paragraphStyle setLineSpacing:5 * Device_Ccale];
    //        paragraphStyle.alignment = NSTextAlignmentLeft;
    //        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    //        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedString.length)];
    //        _awayName.attributedText = attributedString;
    //
    //    }else{
    //        _awayName.text = awayNameString;
    //    }
    [_awayName sizeToFit];
    //    NSLog(@"_awayName.text:--%@/%f",_awayName.text,_awayName.frame.size.width);
}

-(NSArray *)arrayFirstHome:(float)contentWidth andName:(NSString *)name{
    NSInteger firstCharNumber = 0;
    //第一行字符 所需要的宽度
    float firstHomeNameSize = 0;
    for (NSInteger i = 0; i < [name length]; i++){
        //先计算，如果已经大于 当字符宽度够大了就跳出循环/在一定范围
        if (fabsf(firstHomeNameSize - contentWidth) < 14 * Device_Ccale || firstHomeNameSize - contentWidth > 0) {
            firstCharNumber = i;
            //超出距离时，用最小的宽度
            if (firstHomeNameSize > contentWidth) {
                firstHomeNameSize = contentWidth;
            }
            break;
        }
        NSString *character = [name substringWithRange:NSMakeRange(i, 1)];
        firstHomeNameSize = firstHomeNameSize + [self LabelWidth:13 * Device_Ccale andText:character];
        
    }
    if (firstCharNumber == 0) {
        firstCharNumber = name.length;
    }
    //处理字体宽度稍微大于剩余宽度
    NSString *firstRowString = [name substringToIndex:firstCharNumber];
    
    NSString *secondRowString = [name substringFromIndex:firstCharNumber];
    if (secondRowString.length > 0) {
        return @[@(firstHomeNameSize),firstRowString,secondRowString];
    }else{
        return @[@(firstHomeNameSize),firstRowString];
    }
    
}

- (float)LabelWidth:(float)fontSize andText:(NSString *)text{
    CGSize maxSize = CGSizeMake(MAXFLOAT, 20);
    float width = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:fontSize]} context:nil].size.width;
    return width;
}
#pragma mark - Getter

-(UIButton *)collectStatusBtn{
    if (!_collectStatusBtn) {
        _collectStatusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_collectStatusBtn setImage:[UIImage matchscoremoduleImageNamed:@"赛事未关注"] forState:UIControlStateNormal];
        [_collectStatusBtn setImage:[UIImage matchscoremoduleImageNamed:@"赛事已关注"] forState:UIControlStateSelected];
    }
    return _collectStatusBtn;
}

-(UIButton *)liveIconBtn{
    if (!_liveIconBtn) {
        _liveIconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_liveIconBtn setImage:[UIImage matchscoremoduleImageNamed:@"matchLive"] forState:UIControlStateNormal];
    }
    return _liveIconBtn;
}

-(UILabel *)warScore{
    if (!_warScore) {
        _warScore = [[UILabel alloc]initWithFrame:CGRectZero];
        _warScore.font   = [UIFont fontWithName:@"Helvetica-Bold" size:14 * Device_Ccale];
        _warScore.textAlignment = NSTextAlignmentCenter;
    }
    return _warScore;
}

-(UILabel *)homeName{
    if (!_homeName) {
        _homeName = [[UILabel alloc]initWithFrame:CGRectZero];
        _homeName.font = [UIFont fontWithName:@"Helvetica-Bold" size:13 * Device_Ccale];
        _homeName.numberOfLines = 1;
        _homeName.lineBreakMode = NSLineBreakByWordWrapping;
        _homeName.textAlignment = NSTextAlignmentRight;
    }
    return _homeName;
}

-(UILabel *)homeSecondName{
    if (!_homeSecondName) {
        _homeSecondName = [[UILabel alloc]initWithFrame:CGRectZero];
        _homeSecondName.font = [UIFont fontWithName:@"Helvetica-Bold" size:13 * Device_Ccale];
        _homeSecondName.numberOfLines = 1;
        _homeSecondName.textAlignment = NSTextAlignmentRight;
    }
    return _homeSecondName;
}
-(RRCLabel *)homeBrand1{
    if (!_homeBrand1) {
        _homeBrand1 = [[RRCLabel alloc]init];
        _homeBrand1.font = K_FontSizeNMFont;
        _homeBrand1.textColor = RRCWhiteTextColor;
        _homeBrand1.edgeInsets = UIEdgeInsetsMake(0, 2, 0, 2);
    }
    return _homeBrand1;
}

-(RRCLabel *)homeBrand2{
    if (!_homeBrand2) {
        _homeBrand2 = [[RRCLabel alloc]init];
        _homeBrand2.font = K_FontSizeNMFont;
        _homeBrand2.textColor = RRCWhiteTextColor;
        _homeBrand2.edgeInsets = UIEdgeInsetsMake(0, 2, 0, 2);
    }
    return _homeBrand2;
}
-(UILabel *)homeExtensionsName{
    if (!_homeExtensionsName) {
        _homeExtensionsName = [[UILabel alloc]init];
        _homeExtensionsName.font = K_FontSizeTiny;
        _homeExtensionsName.textColor = RRCGrayTextColor;
    }
    return _homeExtensionsName;
}

-(UILabel *)awayName{
    if (!_awayName) {
        _awayName = [[UILabel alloc]initWithFrame:CGRectZero];
        _awayName.font = [UIFont fontWithName:@"Helvetica-Bold" size:13 * Device_Ccale];
        _awayName.numberOfLines = 1;
        _awayName.lineBreakMode = NSLineBreakByWordWrapping;
        _awayName.textAlignment = NSTextAlignmentLeft;
    }
    return _awayName;
}

-(UILabel *)awaySecodName{
    if (!_awaySecodName) {
        _awaySecodName = [[UILabel alloc]initWithFrame:CGRectZero];
        _awaySecodName.font = [UIFont fontWithName:@"Helvetica-Bold" size:13 * Device_Ccale];
        _awaySecodName.numberOfLines = 1;
        _awaySecodName.textAlignment = NSTextAlignmentLeft;
    }
    return _awaySecodName;
}

-(RRCLabel *)awayBrand1{
    if (!_awayBrand1) {
        _awayBrand1 = [[RRCLabel alloc]init];
        _awayBrand1.font = K_FontSizeNMFont;
        _awayBrand1.textColor = RRCWhiteTextColor;
        _awayBrand1.edgeInsets = UIEdgeInsetsMake(0, 2, 0, 2);
    }
    return _awayBrand1;
}

-(RRCLabel *)awayBrand2{
    if (!_awayBrand2) {
        _awayBrand2 = [[RRCLabel alloc]init];
        _awayBrand2.font = K_FontSizeNMFont;
        _awayBrand2.textColor = RRCWhiteTextColor;
        _awayBrand2.edgeInsets = UIEdgeInsetsMake(0, 2, 0, 2);
    }
    return _awayBrand2;
}
-(UILabel *)awayExtensionsName{
    if (!_awayExtensionsName) {
        _awayExtensionsName = [[UILabel alloc]init];
        _awayExtensionsName.font = K_FontSizeTiny;
        _awayExtensionsName.textColor = RRCGrayTextColor;
    }
    return _awayExtensionsName;
}

-(UILabel *)calculateLabel{
    if (!_calculateLabel) {
        _calculateLabel = [[UILabel alloc]init];
        _calculateLabel.font = [UIFont boldSystemFontOfSize:13 * Device_Ccale];
    }
    return _calculateLabel;
}
@end

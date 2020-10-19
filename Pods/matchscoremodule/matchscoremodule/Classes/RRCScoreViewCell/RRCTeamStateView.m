//
//  RRCTeamStateView.m
//  matchscoremodule
//
//  Created by gaoguangxiao on 2020/5/19.
//

#import "RRCTeamStateView.h"
#import "RRCTScoreModel.h"
#import "UIImage+GIF.h"
#import "UIImage+Matchscoremodule.h"
#import "NSBundle+Resources.h"
@interface RRCTeamStateView (){
     
}
@property (nonatomic, strong) UIImageView *topStatusImageView;//置顶状态
@property (nonatomic, strong) UILabel *leagueName;//联赛名字
@property (nonatomic, strong) UILabel *matchTime; //赛事时间
@property (nonatomic, strong) UILabel *downTime;  //比分时间
@property (nonatomic, strong) UIImageView *angleImageView;//闪动图标
@property (nonatomic, strong) UILabel *halfbc1;   //半角
@property (nonatomic, strong) UILabel *cornerBall;//全角

@property(nonatomic, strong) RRCTScoreModel *t_scoreModel;
@end

@implementation RRCTeamStateView

-(void)setViewColor{
    [super setViewColor];
    
    self.backgroundColor = [UIColor clearColor];
}

-(void)setUpView{
    
    [self addSubview:self.topStatusImageView];
    [self addSubview:self.leagueName];
    [self addSubview:self.matchTime];
    [self addSubview:self.downTime];
    [self addSubview:self.angleImageView];
    [self addSubview:self.cornerBall];
    
    [self.topStatusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.width.height.mas_equalTo(10);
    }];
    
    [self.leagueName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12 * Device_Ccale);
        make.bottom.mas_equalTo(self);
    }];
    
    [self.matchTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leagueName.mas_right).offset(5 * Device_Ccale);
        make.centerY.mas_equalTo(self.leagueName.mas_centerY);
    }];
    
    [self.downTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self.matchTime);
    }];
    
    [self.angleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(2 * Device_Ccale);
        make.height.mas_equalTo(4 * Device_Ccale);
        make.left.mas_equalTo(self.downTime.mas_right).offset(1 * Device_Ccale);
        make.top.mas_equalTo(self.downTime.mas_top).offset(2 * Device_Ccale);
    }];
    
    [self.cornerBall mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.matchTime);
        make.right.mas_equalTo(-12 * Device_Ccale);
    }];

}

-(void)setupTeamStateData:(RRCTScoreModel *)scoreModel{
    
    self.t_scoreModel = scoreModel;
    
    _leagueName.text = scoreModel.league;
    _leagueName.textColor = RRCTEXTCOLOR(scoreModel.color);
    
    _matchTime.text  = [NSString stringWithFormat:@"%@",kSafeString(scoreModel.hmd)];
    
    _topStatusImageView.hidden = scoreModel.topStatus == 1 ? NO : YES;
    
    _downTime.text   = [NSString stringWithFormat:@"%@",kSafeString(scoreModel.stateDesc)];
    
    //比赛状态
    if ([scoreModel.state integerValue] == 0) {
        //未开
        _downTime.textColor = RRCGrayTextColor;
    }else if ([scoreModel.state integerValue] == 1 ||[scoreModel.state integerValue] == 3){
        //比赛中 2中场
        _downTime.textColor = RRC4A74FFColor;
    }else if ([scoreModel.state integerValue] == 2 ||[scoreModel.state integerValue] == 4||[scoreModel.state integerValue] == 5){//中场
        _downTime.textColor = RRC4A74FFColor;
    }else if ([scoreModel.state integerValue] == -1){
        //完
        _downTime.textColor = RRCHighLightTitleColor;
    }else{
        _downTime.textColor = RRCGrayTextColor;
    }
    
    [self halfAndCornerisHidden];
    
    [self matchDownTimeCountFlash];
}

#pragma mark - 处理半角隐藏
-(void)halfAndCornerisHidden{

    NSString *bc_text = @"";
    //赛程界面全部隐藏
    BOOL isShowHalf = self.t_scoreModel.isShowHalf;
    
    //定时，如果
    //【周一008】 半 - 角
    if (self.t_scoreModel.NameOrNum != nil && self.t_scoreModel.NameOrNum.length) {
        bc_text = [NSString stringWithFormat:@"%@",kSafeString(self.t_scoreModel.NameOrNum)];
    }
    
    if (self.t_scoreModel.bc1 != nil && self.t_scoreModel.bc1.length && isShowHalf) {
        bc_text = [NSString stringWithFormat:@"%@ 半:%@",bc_text,self.t_scoreModel.bc1];
    }
    
    if (self.t_scoreModel.bc2 != nil && self.t_scoreModel.bc2.length && isShowHalf) {
        bc_text = [NSString stringWithFormat:@"%@-%@",bc_text,self.t_scoreModel.bc2];
    }
    
    if (self.t_scoreModel.corner1 != nil && self.t_scoreModel.corner1.length && isShowHalf) {
        bc_text = [NSString stringWithFormat:@"%@ 角:%@",bc_text,self.t_scoreModel.corner1];
    }
    if (self.t_scoreModel.corner2 != nil && self.t_scoreModel.corner2.length && isShowHalf) {
        bc_text = [NSString stringWithFormat:@"%@-%@",bc_text,self.t_scoreModel.corner2];
    }
    //角label显示
    _cornerBall.text = [NSString stringWithFormat:@"%@",bc_text];
    
}

#pragma mark - 闪动逗号
-(void)matchDownTimeCountFlash{
    //判断是否需要创建定时器了
    if ([self.t_scoreModel.state integerValue] == 1 ||[self.t_scoreModel.state integerValue] == 3) {
        NSBundle *gifBundle = [NSBundle bundleName:@"matchscoremodule" andResourcesBundleName:@""];
        NSString * filePath = [gifBundle pathForResource:@"game_sec_gif" ofType:@"gif"];
        NSData * imageData = [NSData dataWithContentsOfFile:filePath];
        _angleImageView.image = [UIImage sd_animatedGIFWithData:imageData];
        self.angleImageView.hidden = NO;
    }else{
        self.angleImageView.hidden = YES;
    }
}

#pragma mark - Getter
-(UIImageView *)topStatusImageView{
    if (!_topStatusImageView) {
        _topStatusImageView = [[UIImageView alloc]init];
        _topStatusImageView.image = [UIImage matchscoremoduleImageNamed:@"matchscoremodule_赛事置顶"];
    }
    return _topStatusImageView;
}

-(UILabel *)leagueName{
    if (!_leagueName) {
        _leagueName = [[UILabel alloc]init];
        _leagueName.font = K_FontSizeViceTiny;
    }
    return _leagueName;
}

-(UILabel *)matchTime{
    if (!_matchTime) {
        _matchTime = [[UILabel alloc]init];
        _matchTime.font = K_FontSizeViceTiny;
        _matchTime.textColor = RRCGrayTextColor;
    }
    return _matchTime;
}

-(UILabel *)downTime{
    if (!_downTime) {
        _downTime = [[UILabel alloc]init];
        _downTime.font = K_FontSizeViceTiny;
    }
    return _downTime;
}

-(UIImageView *)angleImageView{
    if (!_angleImageView) {
        _angleImageView = [[UIImageView alloc]init];
        
    }
    return _angleImageView;
}

-(UILabel *)cornerBall{
    if (!_cornerBall) {
        _cornerBall = [[UILabel alloc]init];
        _cornerBall.font = K_FontSizeViceTiny;
        _cornerBall.textColor = RRCGrayTextColor;
    }
    return _cornerBall;
}
@end

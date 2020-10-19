//
//  RRCEnterBallCell.m
//  MXSFramework
//
//  Created by gaoguangxiao on 2019/7/10.
//  Copyright © 2019 MXS. All rights reserved.
//

#import "RRCEnterBallView.h"
#import "RRCTScoreModel.h"
#import <AudioToolbox/AudioToolbox.h>
#import "RRCConfigManager.h"
#import <AVFoundation/AVFoundation.h>
@interface RRCEnterBallView (){

    
}
@property (nonatomic, strong) UILabel *stateDes;
@property (nonatomic, strong) UILabel *leagueName;
@property (nonatomic, strong) UIView  *stateHomelineView;
@property (nonatomic, strong) UILabel *homeScore;
@property (nonatomic, strong) UILabel *awayScore;
@property (nonatomic, strong) UILabel *homeName;
@property (nonatomic, strong) UILabel *awayName;

@property (nonatomic, strong) RRCTScoreModel *ts_coreModel;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end

@implementation RRCEnterBallView

-(void)setUpView{
    
    self.backgroundColor = RRCViewCOLOR(@"#3A76FF");
    [self addSubview:self.stateDes];
    [self addSubview:self.leagueName];
    [self addSubview:self.stateHomelineView];
    
    [self addSubview:self.homeName];
    [self addSubview:self.homeScore];
    
    [self addSubview:self.awayName];
    [self addSubview:self.awayScore];
    
    [self.stateDes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15 * Device_Ccale);
        make.left.mas_equalTo(self);
        make.width.mas_equalTo(80 * Device_Ccale);
    }];
    
    [self.leagueName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-17 * Device_Ccale);
        make.left.right.mas_equalTo(self.stateDes);
    }];
    
    [self.stateHomelineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.stateDes.mas_right).offset(5 * Device_Ccale);
        make.width.mas_equalTo(1 * Device_Ccale);
        make.top.mas_equalTo(12 * Device_Ccale);
        make.bottom.mas_equalTo(-12 * Device_Ccale);
    }];
    
    [self.homeName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12 * Device_Ccale);
        make.left.mas_equalTo(self.stateHomelineView.mas_right).offset(15 * Device_Ccale);
        
    }];
    
    [self.homeScore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.homeName);
        make.right.mas_equalTo(-12 * Device_Ccale);
    }];
    
    [self.awayName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-12 * Device_Ccale);
        make.left.mas_equalTo(self.homeName.mas_left);
    }];
    
    [self.awayScore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.awayName);
        make.right.mas_equalTo(-12 * Device_Ccale);
    }];
}

-(void)setupBrandscoreMode:(RRCTScoreModel *)scoreModel{
    
    self.ts_coreModel = scoreModel;
    
    _stateDes.text   = [NSString stringWithFormat:@"%@'",scoreModel.stateDesc];// scoreModel.stateDesc;
    
    _leagueName.text = scoreModel.league;
    
    _homeName.text   = scoreModel.home;
    _awayName.text   = scoreModel.away;
    
    _homeScore.text = scoreModel.homeScore;
    _awayScore.text = scoreModel.awayScore;
    
    if ([scoreModel.flag integerValue] == 1) {
        _homeName.textColor = RRCFFC60AColor;
        _homeName.font = [UIFont boldSystemFontOfSize:15];
        
        _homeScore.textColor = RRCFFC60AColor;
        _homeScore.font = [UIFont boldSystemFontOfSize:15];
        
        _awayName.alpha = 0.66;
        _awayScore.alpha = 0.66;
    }else if([scoreModel.flag integerValue] == 2){
        _awayName.textColor = RRCFFC60AColor;
        _awayName.font = [UIFont boldSystemFontOfSize:15];
        
        _awayScore.textColor = RRCFFC60AColor;
        _awayScore.font = [UIFont boldSystemFontOfSize:15];
        
        _homeName.alpha = 0.66;
        _homeScore.alpha = 0.66;
    }
}

-(void)playUrl:(NSString *)playUrl{
    
    RRCMatchSetModel *configModel = [[RRCConfigManager sharedRRCConfigManager]loadPushLocalSet];
    if ([configModel.applicationIsActive integerValue] == 0) {
        return;
    }
    if ([configModel.vibration_open integerValue] && configModel.selectIndex == 0) {
        //震动 逻辑
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }else{
        if ([configModel.focus_vibration_open integerValue] && [self.ts_coreModel.collectStatus integerValue]) {
            //震动 逻辑
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }else{
            NSLog(@"设置进球震动关闭");
        }
    }
    
    
    if ([configModel.voice_open integerValue] && configModel.selectIndex == 0) {
        [self playEnterBallVoice:playUrl];
    }else{
        if ([configModel.focus_voice_open integerValue] && [self.ts_coreModel.collectStatus integerValue]) {
            [self playEnterBallVoice:playUrl];
        }else{
            NSLog(@"设置关注进球声音关闭");
        }
    }
    
}
-(void)playEnterBallVoice:(NSString *)playUrl{
    //获取设置，是否需要声音
    //    NSLog(@"播放进球声音");
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:playUrl] error:&error];
    
    if (!error&&self.audioPlayer) {
        self.audioPlayer.numberOfLoops = 0;//播放一次
        [self.audioPlayer prepareToPlay];
        [self.audioPlayer play];
    }
    
}
-(void)dealloc{
    self.audioPlayer = nil;
}

#pragma mark - Event Response

- (IBAction)EnterViewSelect:(UIControl *)sender {
    NSLog(@"测试：点击了进球视图");
}

#pragma mark - Getter
-(UILabel *)stateDes{
    if (!_stateDes) {
        _stateDes = [[UILabel alloc]init];
        _stateDes.textColor = RRCWhiteTextColor;
        _stateDes.font = K_FontSizeTiny;
     _stateDes.textAlignment = NSTextAlignmentCenter;
    }
    return _stateDes;
}

-(UILabel *)leagueName{
    if (!_leagueName) {
        _leagueName = [[UILabel alloc]init];
        _leagueName.textColor = RRCWhiteTextColor;
        _leagueName.font = K_FontSizeTiny;
        _leagueName.textAlignment = NSTextAlignmentCenter;
    }
    return _leagueName;
}

-(UIView *)stateHomelineView{
    if (!_stateHomelineView) {
        _stateHomelineView = [[UIView alloc]init];
        _stateHomelineView.backgroundColor = RRCWhiteTextColor;
    }
    return _stateHomelineView;
}

-(UILabel *)homeName{
    if (!_homeName) {
        _homeName = [[UILabel alloc]init];
        _homeName.textColor = RRCWhiteTextColor;
        _homeName.font = K_FontSizeNormal;
    }
    return _homeName;
}

-(UILabel *)homeScore{
    if (!_homeScore) {
        _homeScore = [[UILabel alloc]init];
        _homeScore.textColor = RRCWhiteTextColor;
        _homeScore.font = K_FontSizeNormal;
    }
    return _homeScore;
}

-(UILabel *)awayName{
    if (!_awayName) {
        _awayName = [[UILabel alloc]init];
        _awayName.textColor = RRCWhiteTextColor;
        _awayName.font = K_FontSizeNormal;
    }
    return _awayName;
}

-(UILabel *)awayScore{
    if (!_awayScore) {
        _awayScore = [[UILabel alloc]init];
        _awayScore.textColor = RRCWhiteTextColor;
        _awayScore.font = K_FontSizeNormal;
    }
    return _awayScore;
}
@end


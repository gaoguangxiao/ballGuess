//
//  RRCTeamVSEventView.m
//  matchscoremodule
//
//  Created by gaoguangxiao on 2020/5/19.
//

#import "RRCTeamVSEventView.h"

#import "RRCMatchProgressView.h"
#import "RRCMatchStadiumView.h"
#import "RRCMatchSliderView.h"

#import "RRCTScoreModel.h"
#import "UIImage+Matchscoremodule.h"
@interface RRCTeamVSEventView ()

@property (nonatomic, strong) RRCMatchProgressView *eventProgressView;  //比赛事件
@property (nonatomic, strong) RRCMatchStadiumView *eventStadium;       //事件体育场

@property(nonatomic, strong) RRCTScoreModel *t_scoreModel;

@property (nonatomic, strong)UIButton *openEventBtn;
@end

@implementation RRCTeamVSEventView

-(void)setUpView{
    [self addSubview:self.eventProgressView];
    [self addSubview:self.eventStadium];
    [self addSubview:self.openEventBtn];
    
    [self.eventProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.left.mas_equalTo(12 * Device_Ccale);
        make.right.mas_equalTo(-12 * Device_Ccale);
        make.height.mas_equalTo(44 * Device_Ccale);
    }];
    
    [self.eventStadium mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.eventProgressView.mas_bottom).offset(0 * Device_Ccale);
        make.left.mas_equalTo(self).offset(12 * Device_Ccale);
        make.height.mas_equalTo(113 * Device_Ccale);
        make.width.mas_equalTo(201 * Device_Ccale);//201 + 12
    }];
    
    [self.openEventBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(12 * Device_Ccale);
        make.width.mas_equalTo(42 * Device_Ccale);
        make.top.mas_equalTo(self);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewEventAction:)];
    [self addGestureRecognizer:tap];
    
}

-(void)viewEventAction:(UITapGestureRecognizer *)tap{
    if (self.viewActionBlock) {
        self.viewActionBlock(_t_scoreModel.ID);
    }
}

#pragma mark - Event Response
-(void)eventStateChange:(UIButton *)sender{

    if (self.EventChangeBlock) {
        self.EventChangeBlock(!sender.selected);
    }
}


#pragma mark - init Data
-(void)setupTeamVsEventData:(RRCTScoreModel *)scoreModel{
    
    self.t_scoreModel = scoreModel;
    
    self.eventStadium.isOpenStadiumAll = scoreModel.isOpenStadium;
    
    self.openEventBtn.selected = scoreModel.isOpenEvent;
    
    if (scoreModel.dhlive == 1) {
        self.eventStadium.stadiumUrl = kSafeString(scoreModel.dhUrl1);
        self.eventStadium.stadiumUrlTypeArr = @[@1];
    }else if(scoreModel.dhlive == 2){
        self.eventStadium.stadiumUrl = kSafeString(scoreModel.dhUrl2);
        self.eventStadium.stadiumUrlTypeArr = @[@2];
    }else if(scoreModel.dhlive == 3){
        self.eventStadium.stadiumUrl = kSafeString(scoreModel.dhUrl1);
        self.eventStadium.stadiumUrlTypeArr = @[@1,@2];
        self.eventStadium.stadiumUrlArr = @[kSafeString(scoreModel.dhUrl1),kSafeString(scoreModel.dhUrl2)];
    }
    
    self.eventProgressView.progressDic = scoreModel.comepetitionEvents;
    
    for (UIView *s in self.subviews) {
        if ([s isKindOfClass:NSClassFromString(@"RRCMatchSliderView")]) {
            [s removeFromSuperview];
        }
    }
    
    if (scoreModel.isOpenEvent) {
        CGFloat eventWidth = 0;
        CGFloat eventOffY =  44 * Device_Ccale;
        self.eventStadium.compressionImageBtn.selected = scoreModel.isOpenStadium;
        
        if (scoreModel.isOpenStadium) {
            
            eventWidth = kScreenWidth;
            eventOffY += 197 * Device_Ccale + 10 * Device_Ccale;
            
            [self.eventStadium mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(kScreenWidth - 24 * Device_Ccale);
                make.height.mas_equalTo(197 * Device_Ccale);
            }];
            
            CGFloat halfEventWidth = (eventWidth - 23 * Device_Ccale - 24 * Device_Ccale)/2;
            
            for (NSInteger i = 0; i < scoreModel.shotsStatisModelArr.count; i++) {
                if (i == 0) {
                    RRCMatchSliderView *matchSliderView = [[RRCMatchSliderView alloc]initWithFrame:CGRectMake(12 * Device_Ccale, eventOffY, kScreenWidth - 24 * Device_Ccale, 25 * Device_Ccale)];
                    matchSliderView.sliderStyle = LiveDataStatistics;
                    matchSliderView.statisModel = scoreModel.shotsStatisModelArr[i];
                    [self addSubview:matchSliderView];
                }else if (i == 1 || i == 2){
                    
                    RRCMatchSliderView *matchSliderView = [[RRCMatchSliderView alloc]initWithFrame:CGRectMake(i == 1 ? 12 * Device_Ccale : halfEventWidth + 35 * Device_Ccale, eventOffY + 25 * Device_Ccale + 15 * Device_Ccale, halfEventWidth, 25 * Device_Ccale)];
                    matchSliderView.sliderStyle = LiveDataStatistics;
                    matchSliderView.statisModel = scoreModel.shotsStatisModelArr[i];
                    [self addSubview:matchSliderView];
                }else{
                    
                    RRCMatchSliderView *matchSliderView = [[RRCMatchSliderView alloc]initWithFrame:CGRectMake(i == 3 ? 12 * Device_Ccale : halfEventWidth + 35 * Device_Ccale, eventOffY + 80 * Device_Ccale, halfEventWidth, 25 * Device_Ccale)];
                    matchSliderView.sliderStyle = LiveDataStatistics;
                    matchSliderView.statisModel = scoreModel.shotsStatisModelArr[i];
                    [self addSubview:matchSliderView];
                }
            }
        }else{
            eventWidth = kScreenWidth - 201 * Device_Ccale - 36 * Device_Ccale;
            //24 + 201
            [self.eventStadium mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(201 * Device_Ccale);
                make.height.mas_equalTo(113 * Device_Ccale);
            }];
            
            for (NSInteger i = 0; i < scoreModel.shotsStatisModelArr.count; i++) {
                RRCMatchSliderView *matchSliderView = [[RRCMatchSliderView alloc]initWithFrame:CGRectMake(225 * Device_Ccale, i * (15 * Device_Ccale + 9 * Device_Ccale) + eventOffY, eventWidth, 15 * Device_Ccale)];
                matchSliderView.sliderStyle = MatchEventList;
                matchSliderView.statisModel = scoreModel.shotsStatisModelArr[i];
                [self addSubview:matchSliderView];
            }
        }
        
    }else{
    }
    
    
    //    self.eventAnalysisRight.statisModel = scoreModel.shotsStatisModelArr.firstObject;
    
    
}

//更新动画直播事件数据，不更新网址
-(void)updateTeamVsEventData:(RRCTScoreModel *)scoreModel{
    
    self.eventStadium.isOpenStadiumAll = scoreModel.isOpenStadium;
    
    self.eventProgressView.progressDic = scoreModel.comepetitionEvents;
    
    for (UIView *s in self.subviews) {
        if ([s isKindOfClass:NSClassFromString(@"RRCMatchSliderView")]) {
            [s removeFromSuperview];
        }
    }
    
    if (scoreModel.isOpenEvent) {
        CGFloat eventWidth = 0;
        CGFloat eventOffY =  44 * Device_Ccale;
        self.eventStadium.compressionImageBtn.selected = scoreModel.isOpenStadium;
        
        if (scoreModel.isOpenStadium) {
            
            eventWidth = kScreenWidth;
            eventOffY += 197 * Device_Ccale + 10 * Device_Ccale;
            
            [self.eventStadium mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(kScreenWidth - 24 * Device_Ccale);
                make.height.mas_equalTo(197 * Device_Ccale);
            }];
            
            CGFloat halfEventWidth = (eventWidth - 23 * Device_Ccale - 24 * Device_Ccale)/2;
            
            for (NSInteger i = 0; i < scoreModel.shotsStatisModelArr.count; i++) {
                if (i == 0) {
                    RRCMatchSliderView *matchSliderView = [[RRCMatchSliderView alloc]initWithFrame:CGRectMake(12 * Device_Ccale, eventOffY, kScreenWidth - 24 * Device_Ccale, 25 * Device_Ccale)];
                    matchSliderView.sliderStyle = LiveDataStatistics;
                    matchSliderView.statisModel = scoreModel.shotsStatisModelArr[i];
                    [self addSubview:matchSliderView];
                }else if (i == 1 || i == 2){
                    
                    RRCMatchSliderView *matchSliderView = [[RRCMatchSliderView alloc]initWithFrame:CGRectMake(i == 1 ? 12 * Device_Ccale : halfEventWidth + 35 * Device_Ccale, eventOffY + 25 * Device_Ccale + 15 * Device_Ccale, halfEventWidth, 25 * Device_Ccale)];
                    matchSliderView.sliderStyle = LiveDataStatistics;
                    matchSliderView.statisModel = scoreModel.shotsStatisModelArr[i];
                    [self addSubview:matchSliderView];
                }else{
                    
                    RRCMatchSliderView *matchSliderView = [[RRCMatchSliderView alloc]initWithFrame:CGRectMake(i == 3 ? 12 * Device_Ccale : halfEventWidth + 35 * Device_Ccale, eventOffY + 80 * Device_Ccale, halfEventWidth, 25 * Device_Ccale)];
                    matchSliderView.sliderStyle = LiveDataStatistics;
                    matchSliderView.statisModel = scoreModel.shotsStatisModelArr[i];
                    [self addSubview:matchSliderView];
                }
            }
        }else{
            eventWidth = kScreenWidth - 201 * Device_Ccale - 36 * Device_Ccale;
            //24 + 201
            [self.eventStadium mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(201 * Device_Ccale);
                make.height.mas_equalTo(113 * Device_Ccale);
            }];
            
            for (NSInteger i = 0; i < scoreModel.shotsStatisModelArr.count; i++) {
                RRCMatchSliderView *matchSliderView = [[RRCMatchSliderView alloc]initWithFrame:CGRectMake(225 * Device_Ccale, i * (15 * Device_Ccale + 9 * Device_Ccale) + eventOffY, eventWidth, 15 * Device_Ccale)];
                matchSliderView.sliderStyle = MatchEventList;
                matchSliderView.statisModel = scoreModel.shotsStatisModelArr[i];
                [self addSubview:matchSliderView];
            }
        }
        
    }else{
    }
    
    
    //    self.eventAnalysisRight.statisModel = scoreModel.shotsStatisModelArr.firstObject;
    
    
}
#pragma mark - Getter
-(RRCMatchProgressView *)eventProgressView{
    if (!_eventProgressView) {
        _eventProgressView = [[RRCMatchProgressView alloc] initWithFrame:CGRectMake(12*Device_Ccale, 172*Device_Ccale, kScreenWidth - 24*Device_Ccale, 44*Device_Ccale)];
    }
    return _eventProgressView;
}

-(RRCMatchStadiumView *)eventStadium{
    if (!_eventStadium) {
        _eventStadium = [[RRCMatchStadiumView alloc]init];
//        [_eventStadium.compressionImageBtn setImage:[UIImage matchscoremoduleImageNamed:@"matchscoremodule_列表半屏"] forState:UIControlStateNormal];
//        [_eventStadium.compressionImageBtn setImage:[UIImage matchscoremoduleImageNamed:@"matchscoremodule_列表全屏"] forState:UIControlStateSelected];
        _eventStadium.showLoading = YES;
//        _eventStadium.compressionImageBtn.backgroundColor = RRCHighLightTitleColor;
//        [_eventStadium.compressionImageBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(0* Device_Ccale);
//            make.bottom.mas_equalTo(0*Device_Ccale);
//            make.width.height.mas_equalTo(40 * Device_Ccale);
//        }];
//        kWeakSelf;
//        _eventStadium.SizeChangeBlock = ^(BOOL isOpenStadiumEvent) {
//
//            if (weakSelf.StadiumSizeChangeBlock) {
//                weakSelf.StadiumSizeChangeBlock(isOpenStadiumEvent);
//            }
//        };
    }
    return _eventStadium;
}

-(UIButton *)openEventBtn{
    if (!_openEventBtn) {
        _openEventBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _openEventBtn.titleEdgeInsets = UIEdgeInsetsMake(- 12 * Device_Ccale, 0, 0, 0);
        _openEventBtn.titleLabel.font = K_FontSizeViceTiny;
//        _openEventBtn.backgroundColor = RRCHighLightTitleColor;
        [_openEventBtn setTitleColor:RRCGrayTextColor forState:UIControlStateNormal];
        [_openEventBtn addTarget:self action:@selector(eventStateChange:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openEventBtn;
}
@end


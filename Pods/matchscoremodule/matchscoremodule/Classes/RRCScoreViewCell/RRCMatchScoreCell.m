//
//  RRCMatchScoreCell.m
//  matchscoremodule
//
//  Created by gaoguangxiao on 2020/5/16.
//

#import "RRCMatchScoreCell.h"

#import "RRCTScoreModel.h"

#import "RRCTeamStateView.h"   //VS状态
#import "RRCTeamVSScoreView.h" //主客队名字
#import "RRCTeamExponentView.h"

#import "UIImage+Matchscoremodule.h"
#import "YZYHorizLabel.h"
#import "RRCAlertView.h"
@interface RRCMatchScoreCell ()

@property (nonatomic , strong) UIImageView *homeEnterBallbackImageView;//主队进球背景
@property (nonatomic , strong) UIImageView *awayEnterBallbackImageView;//客队进球背景

@property (nonatomic , strong) UIView *homeEnterView;//背景

@property (nonatomic , strong)RRCTeamStateView *teamStateView;
@property (nonatomic , strong)RRCTeamVSScoreView *teamVSScoreView;
@property (nonatomic , strong)RRCTeamExponentView *teamExponentView;
@property(nonatomic, strong) YZYHorizLabel *matchProgressInfoLabel;//比赛进行中的信息

@property(nonatomic, strong) RRCTScoreModel *t_scoreModel;

@property (nonatomic, strong)UIButton *openCellEventBtn;
@end

@implementation RRCMatchScoreCell

-(void)creatCell{
    
    [self.contentView addSubview:self.homeEnterView];
    
    [self.homeEnterView addSubview:self.homeEnterBallbackImageView];
    [self.homeEnterView addSubview:self.awayEnterBallbackImageView];
    
    [self.homeEnterView addSubview:self.teamStateView];
    [self.homeEnterView addSubview:self.teamVSScoreView];
    [self.homeEnterView addSubview:self.teamExponentView];
    
    [self.contentView addSubview:self.matchProgressInfoLabel];
    [self.contentView addSubview:self.eventPlaceholderView];
    
    [self.homeEnterView addSubview:self.openCellEventBtn];
    
    [self.homeEnterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.contentView);
        make.top.mas_equalTo(10 * Device_Ccale);
        make.bottom.mas_equalTo(0 * Device_Ccale);
    }];
    
    [self.homeEnterBallbackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.homeEnterView.mas_top);
        make.width.mas_equalTo(self.contentView).multipliedBy(0.5);
        make.height.mas_equalTo(self.homeEnterView);
    }];
    
    [self.awayEnterBallbackImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.homeEnterView.mas_top);
        make.right.mas_equalTo(self.contentView);
        make.width.mas_equalTo(self.contentView).multipliedBy(0.5);
        make.height.mas_equalTo(self.homeEnterView);
    }];
    
    //比赛事件展开高度98 125
    [self.teamStateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0 * Device_Ccale);
        make.left.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(23 * Device_Ccale);
    }];
    
    [self.teamVSScoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.teamStateView.mas_bottom);
        make.left.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(39 * Device_Ccale);
    }];
    
    [self.teamExponentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.teamVSScoreView.mas_bottom);
        make.left.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(35 * Device_Ccale);
    }];
    
    [self.openCellEventBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.teamVSScoreView.mas_bottom).offset(-12*Device_Ccale);
        make.right.mas_equalTo(self);
        make.height.mas_equalTo(35 * Device_Ccale);
        make.width.mas_equalTo(43 * Device_Ccale);
    }];
    

    [self.matchProgressInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.teamExponentView.mas_bottom);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(27 * Device_Ccale);
    }];
    
    
    [self.eventPlaceholderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.matchProgressInfoLabel.mas_bottom).offset(-12 * Device_Ccale);
        make.left.bottom.right.mas_equalTo(self.contentView);
    }];
    
}

-(void)setViewColor{
    [super setViewColor];
    
    self.contentView.backgroundColor = RRCSplitViewColor;
    
}

#pragma mark - Init Data
-(void)setupScoreModel:(RRCTScoreModel *)scoreModel{
    
    self.t_scoreModel = scoreModel;
    
    if (scoreModel.enableTop) {
        UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(contentLongPressAction:)];
        [self.contentView addGestureRecognizer:longPressGestureRecognizer];
    }
    
    
    [self.teamStateView setupTeamStateData:scoreModel];
    
    [self.teamVSScoreView setupTeamData:scoreModel];
    
    [self.teamExponentView setupTeamExponentData:scoreModel];
    
    if (scoreModel.overTimeShowStatus) {
        self.matchProgressInfoLabel.hidden = NO;
        [self.matchProgressInfoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(27 * Device_Ccale);
        }];
        [self.eventPlaceholderView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.matchProgressInfoLabel.mas_bottom).offset(-0 * Device_Ccale);
        }];
        [self.contentView layoutIfNeeded];
        [self.matchProgressInfoLabel setText:scoreModel.overTimeContent andLastOffx:scoreModel.offx];
    }else{
        self.matchProgressInfoLabel.hidden = YES;
        
        [self.matchProgressInfoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0 * Device_Ccale);
        }];
        
        [self.eventPlaceholderView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.matchProgressInfoLabel.mas_bottom).offset(-12 * Device_Ccale);
        }];
        
        [self.matchProgressInfoLabel destructionRunlbel];
    }
    
    if (scoreModel.isContainsMatchEvent && scoreModel.isShowOpenEvent) {
        self.openCellEventBtn.hidden     = NO;
        if (scoreModel.isOpenEvent) {
            self.eventPlaceholderView.hidden = NO;
        }else{
            self.eventPlaceholderView.hidden = YES;
        }
    }else{
        self.openCellEventBtn.hidden     = YES;
        self.eventPlaceholderView.hidden = YES;
    }
        
    self.homeEnterBallbackImageView.hidden = YES;
    self.awayEnterBallbackImageView.hidden = YES;
    if (scoreModel.enterballNumber.boolValue) {
        if (scoreModel.enterballMember == 1) {
            self.homeEnterBallbackImageView.hidden = NO;
        }else if(scoreModel.enterballMember == 2){
            self.awayEnterBallbackImageView.hidden = NO;
        }
    }
}

#pragma mark - Event Response
-(void)eventStateChange:(UIButton *)sender{
//    sender.selected = sender.isSelected;
   if (self.delegate && [self.delegate respondsToSelector:@selector(UpdateMatchEventStatus:andIndexPath:)]) {
       [self.delegate UpdateMatchEventStatus:!self.t_scoreModel.isOpenEvent andIndexPath:self.indexPath];
    }
}

#pragma mark - Event Response
- (void)CollectAction:(UIButton *)sender {
    sender.userInteractionEnabled = NO;
    //传当前收藏状态
    if (self.delegate && [self.delegate respondsToSelector:@selector(UpdatecollectStatusWithIndexPath:andMatchID:andCompleteStatus:)]) {
        [self.delegate UpdatecollectStatusWithIndexPath:self.indexPath andMatchID:kSafeString(self.t_scoreModel.ID) andCompleteStatus:^(BOOL isResult) {
            if (isResult) {
                sender.userInteractionEnabled = YES;
//                self.t_scoreModel.collectStatus = [self.t_scoreModel.collectStatus integerValue]?@"0":@"1";
//                self.teamVSScoreView.collectStatusBtn.selected = [self.t_scoreModel.collectStatus integerValue] == 1;
            }
        }];
    }
}

-(void)contentLongPressAction:(UILongPressGestureRecognizer *)LongPressGestureRecognizer{
    if (LongPressGestureRecognizer.state==UIGestureRecognizerStateBegan) {
        
        RRCAlertView *alertView = [RRCAlertView popoverView];
        alertView.showShade = YES; // 显示阴影背景
        NSString *contentString = [NSString stringWithFormat:@"联赛“%@”胜率",self->_t_scoreModel.league];//@"指定";
        UIColor *titleColor = RRCThemeTextColor;
        if (_t_scoreModel.topStatus) {
            contentString = @"取消";
            titleColor = RRCGrayTextColor;
        }
        RRCAlertAction *itemAction = [RRCAlertAction actionWithTitle:contentString titleColor:titleColor handler:^(RRCAlertAction *action) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(UpdateTopStatusWithisTop:andMatchID:andCompleteStatus:)]) {
                [self.delegate UpdateTopStatusWithisTop:self.indexPath andMatchID:self->_t_scoreModel.league andCompleteStatus:^(BOOL isResult) {
                    //                    self->_topStatusImageView.hidden = self.t_scoreModel.topStatus == 1 ? NO : YES;
                }];
            }
        }];
        RRCAlertAction *cancelAction = [RRCAlertAction actionWithTitle:@"取消" handler:^(RRCAlertAction *action) {
        }];
        
        NSMutableArray *actionArrAll = [NSMutableArray arrayWithObjects:@[itemAction], @[cancelAction], nil];
        [alertView showWithActions:actionArrAll];
    }
}


-(void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if (!newSuperview) {
        [_matchProgressInfoLabel destructionRunlbel];
    }
    
}
-(void)dealloc{
    //    NSLog(@"--%@--dealloc",self.class);
}

#pragma mark - YZYHorizLabelDelegate
-(void)textRunviewDistance:(CGFloat)x{
    self.t_scoreModel.offx = x;
}

#pragma mark - Getter
-(UIView *)homeEnterView{
    if (!_homeEnterView) {
        _homeEnterView = [[UIView alloc]init];
        _homeEnterView.backgroundColor = RRCWhiteDarkColor;
    }
    return _homeEnterView;
}

-(UIImageView *)homeEnterBallbackImageView{
    if (!_homeEnterBallbackImageView) {
        _homeEnterBallbackImageView = [[UIImageView alloc]initWithImage:[UIImage matchscoremoduleImageNamed:@"FFCAD7FFFFFF"]];
    }
    return _homeEnterBallbackImageView;
}

-(UIImageView *)awayEnterBallbackImageView{
    if (!_awayEnterBallbackImageView) {
        _awayEnterBallbackImageView = [[UIImageView alloc]initWithImage:[UIImage matchscoremoduleImageNamed:@"FFFFFFFFCAD7"]];
    }
    return _awayEnterBallbackImageView;
}

-(RRCTeamStateView *)teamStateView{
    if (!_teamStateView) {
        _teamStateView = [[RRCTeamStateView alloc]init];
    }
    return _teamStateView;
}

-(RRCTeamVSScoreView *)teamVSScoreView{
    if (!_teamVSScoreView) {
        _teamVSScoreView = [[RRCTeamVSScoreView alloc]initWithFrame:CGRectZero];
        [_teamVSScoreView.collectStatusBtn addTarget:self action:@selector(CollectAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _teamVSScoreView;
}

-(RRCTeamExponentView *)teamExponentView{
    if (!_teamExponentView) {
        _teamExponentView = [[RRCTeamExponentView alloc]initWithFrame:CGRectZero];
        kWeakSelf;
        _teamExponentView.EventChangeBlock = ^(BOOL isOpenEvent) {
            //本身高度扩展
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(UpdateMatchEventStatus:andIndexPath:)]) {
                [weakSelf.delegate UpdateMatchEventStatus:isOpenEvent andIndexPath:weakSelf.indexPath];
            }
        };
    }
    return _teamExponentView;
}

-(YZYHorizLabel *)matchProgressInfoLabel{
    if (!_matchProgressInfoLabel) {
        _matchProgressInfoLabel = [YZYHorizLabel new];
        _matchProgressInfoLabel.textColor = RRCHighLightTitleColor;
        _matchProgressInfoLabel.font = K_FontSizeViceTiny;
        _matchProgressInfoLabel.textAlignment = NSTextAlignmentCenter;
        _matchProgressInfoLabel.backgroundColor = RRCFFEBEEColor;
        _matchProgressInfoLabel.separationMargin = kScreenWidth/3;
        _matchProgressInfoLabel.delegate = self;
    }
    return _matchProgressInfoLabel;
}

- (UIButton *)eventPlaceholderView{
    if (!_eventPlaceholderView) {
        _eventPlaceholderView = [UIButton buttonWithType:UIButtonTypeCustom];
        _eventPlaceholderView.backgroundColor = RRCUnitViewColor;
    }
    return _eventPlaceholderView;
}

-(UIButton *)openCellEventBtn{
    if (!_openCellEventBtn) {
        _openCellEventBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _openCellEventBtn.backgroundColor = RRCHighLightTitleColor;
        [_openCellEventBtn addTarget:self action:@selector(eventStateChange:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openCellEventBtn;
}
@end

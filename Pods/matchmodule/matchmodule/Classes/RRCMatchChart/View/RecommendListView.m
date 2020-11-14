//
//  RecommendListView.m
//  MXSFramework
//
//  Created by 人人彩 on 2019/4/18.
//  Copyright © 2019 MXS. All rights reserved.
//

#import "RecommendListView.h"
#import "RRCMatchListView.h"

#import "RRCNetFailView.h"

#import "DYUIViewExt.h"
#import "RRCProgressHUD.h"
#import "RRCMatchManager.h"
#import "RRCMatchChartConfig.h"
//#import "PostDetailController.h"
static NSString *const SelectGameHeadId = @"SelectGameHead_Id";
@interface RecommendListView ()<RRCMatchHandleProtocol>
@property (nonatomic,strong) UIView *baseView;

@property (nonatomic , strong) RRCMatchListView *matchListView;
@end
@implementation RecommendListView

-(NSMutableArray *)matchListShowArr{
    if (!_matchListShowArr) {
        _matchListShowArr = [NSMutableArray new];
    }
    return _matchListShowArr;
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initGame];
    }
    return self;
}

-(void)initGame{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5];
    
    self.baseView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight - kHeightNavigation + 5*Device_Ccale)];
    self.baseView.layer.cornerRadius = 8*Device_Ccale;
    self.baseView.backgroundColor = RRCUnitViewColor;
    [self addSubview:self.baseView];
    
    UIView *imgBack = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32*Device_Ccale, 32*Device_Ccale)];
    [imgBack addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenGameScreen)]];
    [_baseView addSubview:imgBack];
    
    UIImageView *deleltImg = [[UIImageView alloc] initWithFrame:CGRectMake(13*Device_Ccale, 18*Device_Ccale, 14*Device_Ccale, 14*Device_Ccale)];
    deleltImg.image = [UIImage imageNamed:@"评论详情叉号"];
    [imgBack addSubview:deleltImg];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(50, 16*Device_Ccale, kScreenWidth - 100, 18*Device_Ccale)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:18*Device_Ccale];
    titleLab.textColor = RRCThemeTextColor;
    titleLab.text = @"已推荐";
    [self.baseView addSubview:titleLab];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 50*Device_Ccale, kScreenWidth, 1.0)];
    lineView.backgroundColor = RRCLineViewColor;
    [self.baseView addSubview:lineView];
    
    [self.baseView addSubview:self.matchListView];
    self.matchListView.matchListArr = self.matchListShowArr;
}

#pragma mark - Event response
-(void)reloadList{
    [self.matchListView reloadDataAndOffyToTop];
}

-(void)hiddenGameScreen{
    //    UIViewController *vc = (PostDetailController *)[AppToolManager getCurrentController];
    //if ([vc isKindOfClass:[PostDetailController class]]){
    //        PostDetailController *postDetail = (PostDetailController *)vc;
    //        [postDetail updataRecomment];
    //        [postDetail.commentItem showCommentView];
    //    }
    
    if (self.hiddnRecommendViewScreen) {
        self.hiddnRecommendViewScreen();
    }
    
    [UIView animateWithDuration:.2 animations:^{
        self.baseView.top = kScreenHeight;
        self.alpha = 0.1;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)showGameScreen{
    self.alpha = 0.1;
    [UIView animateWithDuration:.3 animations:^{
        self.baseView.top = kHeightNavigation;
        self.alpha = 1.0;
    }completion:^(BOOL finished) {
        
    }];
    
    kWeakSelf;
    [RRCProgressHUD showRRCAddedTo:self.baseView animated:YES];
    [[RRCMatchManager sharedRRCMatchManager] loadOnceRecommendedMatch:@{} andComplete:^(NSArray * _Nonnull loadArr, BOOL isLoadsuc, NSInteger code) {
        
        [RRCProgressHUD hideRRCForView:self.baseView animated:YES];
        if (isLoadsuc) {
            [weakSelf.matchListShowArr removeAllObjects];
            [weakSelf.matchListShowArr addObjectsFromArray:loadArr];
            [weakSelf reloadList];
            
            if (loadArr.count == 0) {
                [weakSelf loadDefaultZeroViewText:@"暂无推荐赛事" andImageName:@"libraryPlace"];
                weakSelf.defaultPageView.frame = CGRectMake(0,0, weakSelf.matchListView.width, kScreenHeight - kHeightNavigation - 51*Device_Ccale);
                [weakSelf.defaultPageView removeFromSuperview];
                [weakSelf.matchListView addSubview:weakSelf.defaultPageView];
            }
        }else{
            RRCNetFailView *faile =  [[RRCNetFailView alloc]initWithFrame:CGRectMake(0, 0, weakSelf.matchListView.width, kScreenHeight - kHeightNavigation - 51*Device_Ccale)];
            RRCNoDataModel *nodataModel = [[RRCNoDataModel alloc]init];
            nodataModel.noDataType = RRCEmptyTypeAll;
            nodataModel.text = @"请检查您的网络连接";
            nodataModel.imageName = @"无网络连接";
            nodataModel.responseText = @"重新连接";
            nodataModel.responseType = 1;
            nodataModel.emptyContentHeight = kScreenHeight - kHeightNavigation - 51*Device_Ccale;
            
            kWeakSelf;
            [faile alertViewModel:nodataModel withY:0 reloadBtn:^(UIButton * _Nonnull btnBlock) {
                [RRCProgressHUD showRRCAddedTo:weakSelf.matchListView animated:YES];//:self.view animated:YES];
                
                [weakSelf faileReloadData];
                
                [faile removeFromSuperview];
                
            }];
            [weakSelf.matchListView addSubview:faile];
        }
    }];
    
}

-(void)faileReloadData{
    kWeakSelf;
    [RRCProgressHUD showRRCAddedTo:self.baseView animated:YES];
    [[RRCMatchManager sharedRRCMatchManager] loadOnceRecommendedMatch:@{} andComplete:^(NSArray * _Nonnull loadArr, BOOL isLoadsuc, NSInteger code) {
        
        [RRCProgressHUD hideRRCForView:self.baseView animated:YES];
        if (isLoadsuc) {
            [weakSelf.matchListShowArr removeAllObjects];
            [weakSelf.matchListShowArr addObjectsFromArray:loadArr];
            [weakSelf reloadList];
            
            if (loadArr.count == 0) {
                [weakSelf loadDefaultZeroViewText:@"暂无推荐赛事" andImageName:@"libraryPlace"];
                weakSelf.defaultPageView.frame = CGRectMake(0,0, weakSelf.matchListView.width, kScreenHeight - kHeightNavigation - 51*Device_Ccale);
                [weakSelf.defaultPageView removeFromSuperview];
                [weakSelf.matchListView addSubview:weakSelf.defaultPageView];
            }
        }else{
            RRCNetFailView *faile =  [[RRCNetFailView alloc]initWithFrame:CGRectMake(0, 0, weakSelf.matchListView.width, kScreenHeight - kHeightNavigation - 51*Device_Ccale)];
            RRCNoDataModel *nodataModel = [[RRCNoDataModel alloc]init];
            nodataModel.noDataType = RRCEmptyTypeAll;
            nodataModel.text = @"请检查您的网络连接";
            nodataModel.imageName = @"无网络连接";
            nodataModel.responseText = @"重新连接";
            nodataModel.responseType = 1;
            nodataModel.emptyContentHeight = kScreenHeight - kHeightNavigation - 51*Device_Ccale;
            
            kWeakSelf;
            [faile alertViewModel:nodataModel withY:0 reloadBtn:^(UIButton * _Nonnull btnBlock) {
                [RRCProgressHUD showRRCAddedTo:weakSelf.matchListView animated:YES];//:self.view animated:YES];
                
                [weakSelf faileReloadData];
                
                [faile removeFromSuperview];
                
            }];
            [weakSelf.matchListView addSubview:faile];
        }
    }];
}

#pragma mark - RRCMatchHandleProtocol
-(void)deleteMatchInfoSuccessful{
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteMatchInfoSuccessful)]) {
        [self.delegate deleteMatchInfoSuccessful];
    }
}

-(void)deleteMatchWhileListCountZero{
    if (self.matchListView.matchConfig.isListZeroCancel) {
        [self performSelector:@selector(hiddenGameScreen) withObject:nil afterDelay:0.2];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteMatchWhileListCountZero)]) {
        [self.delegate deleteMatchWhileListCountZero];
    }
}

#pragma mark - Getter/setter
-(RRCMatchListView *)matchListView{
    if (!_matchListView) {
        RRCMatchChartConfig *matchConfig = [[RRCMatchChartConfig alloc]init];
        matchConfig.beginSpace = 12;
        matchConfig.isListZeroCancel = YES;
        _matchListView = [[RRCMatchListView alloc]initWithFrame:CGRectMake(12 * Device_Ccale, 51 * Device_Ccale, self.baseView.width - 24 * Device_Ccale, self.baseView.height - 5 * Device_Ccale - 51 * Device_Ccale)];
        _matchListView.delegate = self;
        _matchListView.matchConfig = matchConfig;
        _matchListView.matchInfoState = RRCMatchInfoListStateDelete;
    }
    return _matchListView;
}
@end

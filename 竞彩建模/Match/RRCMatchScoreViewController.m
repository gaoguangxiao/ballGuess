//
//  RRCMatchScoreViewController.m
//  matchscoremodule
//
//  Created by gaoguangxiao on 2020/5/16.
//

#import "RRCMatchScoreViewController.h"
#import <Masonry/Masonry.h>
#import "RRCMatchScoreCell.h"
#import "MJRefreshNormalHeader.h"
#import "RRCConfigManager.h"
#import "CGDataResult.h"
#import "RRCTScoreModel.h"
#import <MJExtension/MJExtension.h>
#import "NSBundle+Resources.h"
#import "RRCConfigManager.h"
#import "RRCMatchEnterBallView.h"
#import "RRCTeamVSEventView.h"
#import "RRCScoreViewModel.h"
#import "RRCProgressHUD.h"
#import "MXSRefreshHeader.h"
#import "RRCMatchLiveDataStatisModel.h"

#import "MBProgressHUD.h"
#import "ResultViewModel.h"
#import "ResultModel.h"

#import "GGCLeagueListViewController.h"
static NSString * const scoreCellIdentifier = @"RRCMatchScoreCell";
@interface RRCMatchScoreViewController ()<UITableViewDelegate,UITableViewDataSource,RRCMatchScoreCellDelegate,RRRCScoreViewModelDelegate>
{
    
    __weak IBOutlet UIButton *resetBtn;
    
    __weak IBOutlet UILabel *_matchID;
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) NSInteger matchType;//请求类型 0

@property (nonatomic, strong) NSString *pushleagueName;
//@property (nonatomic, strong) NSTimer *enterBallUpdateTimer;//进球变化倒计时
//@property (nonatomic, strong) RRCMatchEnterBallView *enterBallView;
//@property (nonatomic , strong)RRCTeamVSEventView *teamVSEventView;

@property (nonatomic, strong) RRCScoreViewModel *scoreViewModel;//视图数据model
@end

@implementation RRCMatchScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    
    self.tableView.mj_header = header;
    
    self.matchType = 1;
    
    _scoreViewModel = [RRCScoreViewModel new];
    _scoreViewModel.delegate = self;
    [self loadDefaultData];
    
    //登录状态改变刷新数据
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateMatchListInfo) name:K_APNNOTIFICATIONLOGIN object:nil];
}

-(void)dealloc{
    NSLog(@"%@ -- dealloc",self.class);
}

-(void)updateMatchListInfo{
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    dict[@"type"] = [NSString stringWithFormat:@"%ld",(long)self.matchType];
    dict[@"lotteryId"] = @"3";;
    dict[@"dxpk"] = @[];
    dict[@"yppk"] = @[];
    dict[@"leagues"] = @[];
    
    [_scoreViewModel requestWithMatchCondition:0 parameters:dict success:^(NSArray *loadArr, BOOL isLoadsuc) {
        
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
        
        [self.tableView reloadData];
        
    }];
}

#pragma mark - init Data
-(void)loadDefaultData{
    
    [RRCProgressHUD showRRCAddedTo:self.view animated:YES];

    NSMutableDictionary *dict = [NSMutableDictionary new];
    dict[@"type"] = [NSString stringWithFormat:@"%ld",(long)self.matchType];
    dict[@"lotteryId"] = @"3";
    dict[@"dxpk"] = @[];
    dict[@"yppk"] = @[];
    dict[@"leagues"] = @[];
    
    [_scoreViewModel requestWithMatchCondition:0 parameters:dict success:^(NSArray *loadArr, BOOL isLoadsuc) {
        
        [RRCProgressHUD hideRRCForView:self.view animated:NO];
        
        [self.tableView reloadData];
        
    }];
    
}

#pragma mark - 下拉刷新
-(void)requestData{
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    dict[@"type"] = [NSString stringWithFormat:@"%ld",(long)self.matchType];
    dict[@"lotteryId"] = @"3";;
    dict[@"dxpk"] = @[];
    dict[@"yppk"] = @[];
    dict[@"leagues"] = @[];
    
    [_scoreViewModel requestWithMatchCondition:0 parameters:dict success:^(NSArray *loadArr, BOOL isLoadsuc) {
        
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
        
        [self.tableView reloadData];
        
    }];
}

#pragma mark - Event Response
- (IBAction)resePredicttChange:(UIButton *)sender {

    self.matchType ++;
    
    if (self.matchType == 5) {
        self.matchType = 0;
    }
    
    [resetBtn setTitle:@[@"全部",@"一级",@"竞彩",@"北单",@"足彩"][self.matchType] forState:UIControlStateNormal];
    
    [self.tableView.mj_header beginRefreshing];
}

//一键全选
- (IBAction)allChoseMatch:(id)sender {
    
        [self choseAll];
        [self.tableView reloadData];
    
}

#pragma mark -开始预测
- (IBAction)scorePredictBall:(id)sender {
    
    //    NSLog(@"开始预测：");
    if (![CustomUtil isUserLogin]) {
        
        [self.navigationController presentViewController:CreateViewControllerWithNav(@"LoginViewController") animated:YES completion:nil];
        
        return;
    }

    //将选中的筛选出来
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    ResultViewModel *resultViewModel = [ResultViewModel new];
    NSMutableArray *waterModelArr = [NSMutableArray new];
    NSMutableArray *nameModelArr = [NSMutableArray new];
    for (NSInteger i = 0;i < self->_scoreViewModel.matchListCar.count;i++) {
        RRCTScoreModel *re =  self->_scoreViewModel.matchListCar[i];
        [nameModelArr addObject:re.home];
        ResultModel *m = [ResultModel new];
        m.dxq_dpk = re.DXQ_HJSPL;
        m.dxq_xpk = re.DXQ_WJSPL;
        m.yp_spk = re.HJSPL;
        m.yp_xpk = re.WJSPL;
        [waterModelArr addObject:m];
    }
    
    //判断是否可以预测 订单ID
    NSMutableDictionary *dict = [NSMutableDictionary new];
    dict[@"userForecastCount"] = [NSString stringWithFormat:@"%lu",_scoreViewModel.matchListCar.count];//传入预测数量
    [Service loadBmobObjectByParameters:dict andByStoreName:@"OrderForecastStore" constructingBodyWithBlock:^(CGDataResult *obj, BOOL b) {
        //扣款成功
        if (b) {
            [resultViewModel requestMultipleDataWithParameters:@{@"name":nameModelArr} andLocalArr:waterModelArr andComplete:^(NSArray * _Nonnull loadArr) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (loadArr.count) {
                    [[RRCAlertManager sharedRRCAlertManager]showPostingWithtitle:@"预测成功"];
                    
                    [self->_scoreViewModel reloadScoreListTopStatus:loadArr andLoadDeleteResult:^(BOOL isEnd) {
                        
                        [self clearList];
                        
                        [self.tableView reloadData];
                        
                    }];
                }else{
                    
                    [[RRCAlertManager sharedRRCAlertManager]showPostingWithtitle:@"预测失败"];
                }
                
            }];
            
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [[RRCAlertManager sharedRRCAlertManager]showPostingWithtitle:obj.errorMsg];
        }
    }];
}

#pragma mark - RRRCScoreViewModelDelegate
-(void)dataFinishload:(NSInteger)matchCondition andlistArray:(NSArray *)array{
    //存储全部数据
    if (matchCondition == 0) {
        //        RRCMatchSetModel *appSet = [[RRCConfigManager sharedRRCConfigManager]loadPushLocalSet];
        //        appSet.matchScoreListArr = array;
        //        [[RRCConfigManager sharedRRCConfigManager]updatePushLocalSetBySetModel:appSet];
    }
    //更新关注数据
    dispatch_async(dispatch_get_main_queue(), ^{
        self->_matchID.text = [NSString stringWithFormat:@"数量：%ld个",self->_scoreViewModel.matchListCar.count];
    });
    
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _scoreViewModel.listArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    RRCTScoreModel *tempScore = _scoreViewModel.listArray[indexPath.row];
    return tempScore.cellScoreHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RRCMatchScoreCell *cell = [tableView dequeueReusableCellWithIdentifier:scoreCellIdentifier];
    if (!cell) {
        cell = [[RRCMatchScoreCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:scoreCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //1、判断是否能够继续添加，每日限制五场
//    NSInteger foceCount = [CustomUtil getUserInfo].userForecast.integerValue;
    
//    if (foceCount > 0 && self->_scoreViewModel.matchListCar.count < foceCount) {
        [_scoreViewModel updateScoreListTopStatus:indexPath andLoadDeleteResult:^(BOOL isEnd) {

            self->_matchID.text = [NSString stringWithFormat:@"数量：%ld个",self->_scoreViewModel.matchListCar.count];

            [self.tableView reloadData];
            
        }];
//    }else{
//        [[RRCAlertManager sharedRRCAlertManager]showPostingWithtitle:@"预测数量已最大"];
//    }
    
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    RRCMatchScoreCell *matchScore = (RRCMatchScoreCell *)cell;
    matchScore.indexPath = indexPath;
    [matchScore setupScoreModel:_scoreViewModel.listArray[indexPath.row]];
    //    NSLog(@"位置：%ld",indexPath.row);
    
}

-(void)UpdateTopStatusWithisTop:(NSIndexPath *)indexPath andMatchID:(NSString *)matchID andCompleteStatus:(nonnull void (^)(BOOL))isResult{
    
    //跳转某条联赛
    GGCLeagueListViewController *Vc = [self.storyboard instantiateViewControllerWithIdentifier:@"GGCLeagueListViewController"];
    Vc.leagueName = matchID;
    [self.navigationController pushViewController:Vc animated:YES];
    
}

#pragma mark - Other Method
-(void)clearList{
    
    //清理选中的预测数据
    for (NSInteger i = 0;i < self.scoreViewModel.listArray.count;i++) {
        
        RRCTScoreModel *re = self.scoreViewModel.listArray[i];
        
        re.collectStatus = @"0";
    }
    
    RRCMatchSetModel *matchSet = [[RRCConfigManager sharedRRCConfigManager] loadPushLocalSet];
    matchSet.matchTopLisDict = [[NSMutableDictionary alloc]init];
    [[RRCConfigManager sharedRRCConfigManager]updatePushLocalSetBySetModel:matchSet];
    
    [self.scoreViewModel.matchListCar removeAllObjects];
    
    self->_matchID.text = [NSString stringWithFormat:@"数量：%ld个",self->_scoreViewModel.matchListCar.count];
    
}

-(void)choseAll{
    
    RRCMatchSetModel *matchSet = [[RRCConfigManager sharedRRCConfigManager] loadPushLocalSet];
    matchSet.matchTopLisDict = [[NSMutableDictionary alloc]init];
    [self.scoreViewModel.matchListCar removeAllObjects];
    
    for (NSInteger i = 0;i < self.scoreViewModel.listArray.count;i++) {
        
        RRCTScoreModel *re = self.scoreViewModel.listArray[i];
        
        if (![re.DXQDesc isEqualToString:@"-"] && ![re.JSPKDesc isEqualToString:@"-"]) {
            re.collectStatus = @"1";
            [self.scoreViewModel.matchListCar addObject:re];
        }
    }
    
    [[RRCConfigManager sharedRRCConfigManager]updatePushLocalSetBySetModel:matchSet];
    
    
    self->_matchID.text = [NSString stringWithFormat:@"数量：%ld个",self->_scoreViewModel.matchListCar.count];
}

#pragma mark - Getter

@end

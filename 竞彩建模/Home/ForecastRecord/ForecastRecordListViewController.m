//
//  GGCBigSmallBallViewController.m
//  竞彩建模
//
//  Created by gaoguangxiao on 2020/6/9.
//  Copyright © 2020 renrencai. All rights reserved.
//

#import "ForecastRecordListViewController.h"
#import "GGCRiceListCell.h"
#import "ResultViewModel.h"
#import "ResultModel.h"
#import "RRCProgressHUD.h"
#import "MXSRefreshHeader.h"
#import "MBProgressHUD.h"
#import <MJRefresh.h>

#import "RRCLeagueConditionViewController.h"
#import "RRCLeaguesModel.h"
@interface ForecastRecordListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) ResultViewModel *resultViewModel;

@property (nonatomic, assign) NSInteger current_page;
@property (nonatomic, assign) BOOL is_last_page;

//亚指胜率
@property (weak, nonatomic) IBOutlet UILabel *yzRate;
//大小球胜率
@property (weak, nonatomic) IBOutlet UILabel *dxqRate;
//波胆胜率
@property (weak, nonatomic) IBOutlet UILabel *bdRate;
//竞彩胜率
@property (weak, nonatomic) IBOutlet UILabel *jsRate;

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation ForecastRecordListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _resultViewModel = [[ResultViewModel alloc]init];
    
    self.navigationItem.title = @"预测记录";
    
    kWeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf refreshData];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (!weakSelf.is_last_page) {
            [weakSelf loadMore];
        }else{
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
    
    [self loadData];

}

-(void)loadData{
    
    self.current_page = 1;
    
    [RRCProgressHUD showLoadView:self.view andHeight:kScreenHeight];
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    dict[@"page_num"] = @(self.current_page);
    dict[@"page_size"] = @(10);
    
    [_resultViewModel previewMatchListWithParameters:dict Complete:^(NSArray * _Nonnull loadArr, NSInteger count) {
        if (loadArr.count == 0) {
            [self listZeroViewText:@"暂无数据" andImageName:@"" andView:self.tableView];
        }else{
            [self hiddenNoDataView];
        }
        self.is_last_page = count;
        
        [RRCProgressHUD hideRRCForView:self.view animated:YES];
        
        [self updateRateText];
        
        [self.tableView reloadData];
    }];
}

-(void)refreshData{
    self.current_page = 1;
    NSMutableDictionary *dict = [NSMutableDictionary new];
    dict[@"page_num"] = @(self.current_page);
    dict[@"page_size"] = @(10);
    [_resultViewModel previewMatchListWithParameters:dict Complete:^(NSArray * _Nonnull loadArr, NSInteger count) {
        
        self.navigationItem.title = [NSString stringWithFormat:@"【%@/%lu场】",self.resultViewModel.matchRateCount,(unsigned long)loadArr.count];
        
        [self.tableView.mj_header endRefreshing];
        
        if (loadArr.count == 0) {
            [self listZeroViewText:@"暂无数据" andImageName:@"" andView:self.tableView];
        }else{
            [self hiddenNoDataView];
        }
        
        [self updateRateText];
        
        self.is_last_page = count;
        
        [self.tableView reloadData];
    }];
}

-(void)loadMore{
    self.current_page ++;
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    dict[@"page_num"] = @(self.current_page);
    dict[@"page_size"] = @(10);
    
    [_resultViewModel previewLoadMoreMatchListWithParameters:dict Complete:^(NSArray * _Nonnull loadArr, NSInteger count) {
        
        self.is_last_page = count;
        
        [self.tableView.mj_footer endRefreshing];
        
        [self hiddenNoDataView];
        
        [self updateRateText];
        
        [self.tableView reloadData];
    }];
}

-(void)updateRateText{
    
    self.yzRate.text = _resultViewModel.yzRateText;
    
    self.dxqRate.text = _resultViewModel.dxqRateText;
    
    self.bdRate.text = _resultViewModel.yzdxqRRateText;
    
    self.jsRate.text = [NSString stringWithFormat:@"%@/%@",_resultViewModel.jcRateText,_resultViewModel.bdRateText];
    
}


#pragma mark - 日期筛选
- (IBAction)editMactchList:(UIButton *)sender {
    [self performSegueWithIdentifier:@"GGCDateRateViewController" sender:self];
    
}

#pragma mark - 联赛筛选

- (IBAction)leagueSort:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"RRCLeagueConditionViewController" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    RRCLeagueConditionViewController *Vc = segue.destinationViewController;
    
    kWeakSelf;
    Vc.submitChoseCondition = ^(NSArray * _Nonnull arr, NSString * _Nonnull title) {
        
        self.title = [NSString stringWithFormat:@"%@联赛【%lu场】",title,(unsigned long)arr.count];
        
        [weakSelf.resultViewModel sortMatchLeagueWithParameters:arr Complete:^(NSArray * _Nonnull loadArr) {
            
            [weakSelf updateRateText];
            
            [weakSelf.resultViewModel.listArray removeAllObjects];
            
            [weakSelf.resultViewModel.listArray addObjectsFromArray:arr];
            
            [weakSelf.tableView reloadData];
            
        }];
        
        
    };
}

#pragma mark - 滑动至开赛
- (IBAction)scrollOpenGame:(UIButton *)sender {
    
    [_resultViewModel scrollMatchOpenComplete:^(NSIndexPath * _Nonnull indexPath) {
        
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }];
    
//    [self.tableView setContentOffset:CGPointMake(0, 90)];
    
}

#pragma mark - tablewDelegate
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        ResultModel *r = _resultViewModel.listArray[indexPath.row];
        //        NSLog(@"%@",r.ID);
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [_resultViewModel deleteMatchListWithParameters:@{@"id":r.ID} Complete:^(BOOL isEnd) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [self.resultViewModel.listArray removeObjectAtIndex:indexPath.row];
            
            [self.tableView reloadData];
        }];
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    self.tableView.mj_footer.hidden = self.is_last_page;
    return _resultViewModel.listArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GGCRiceListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GGCRiceListCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"GGCRiceListCell" owner:self options:nil] objectAtIndex:0];
    }
    [cell setupResultModel:_resultViewModel.listArray[indexPath.row]];
    cell.didActionDelete = ^{
        
        ResultModel *re = self->_resultViewModel.listArray[indexPath.row];

        NSMutableDictionary *dict = [NSMutableDictionary new];
        //赛事基本信息
        dict[@"home"] = re.home;
        dict[@"homeScore"] = @"-";
        dict[@"away"] = re.away;
        dict[@"awayScore"] = @"-";
        dict[@"hmd"] = [NSString stringWithFormat:@"%@ %@",re.mmdd,re.hhmm];
        dict[@"league"] = re.league;
        //赛事关联ID
        dict[@"match_id"] = re.match_id;
        
        //大小球
        dict[@"dxq_pk_water"] = re.finishBigDif;//大小球下注水位0.87
        dict[@"dxq_dxdif"] = re.finishScoreBigDif;//大小球差值
        dict[@"dxq_money"] = re.finishBigMoney;//大小球下注筹码
        dict[@"dxq_pk"] = re.dxq_pk;
        
        //亚指
        dict[@"yz_pk_water"] = re.finishYazhiDif;//亚指下注水位0.87
        dict[@"yz_dxdif"] = re.finishScoreYazhiDif;//大小球差值
        dict[@"yz_money"] = re.finishYazhiMoney;//大小球下注筹码
        dict[@"yz_pk"] = re.yp_pk;
        
        //转loding
        [[HUDHelper sharedInstance]syncLoading:@"正在下注"];
        
        [Service loadBmobObjectByParameters:dict andByStoreName:@"BetOrderStore" constructingBodyWithBlock:^(CGDataResult *obj, BOOL b) {
           
            [[HUDHelper sharedInstance] syncStopLoadingMessage:@"下注完成"];
            
        }];
//        [self.tableView reloadData];
    
    };
    return cell;
}

@end

//
//  GGCBigSmallBallViewController.m
//  竞彩建模
//
//  Created by gaoguangxiao on 2020/6/9.
//  Copyright © 2020 renrencai. All rights reserved.
//

#import "GGCLeagueDeleteListVC.h"
#import "RRCLeafueDelcell.h"

#import "ResultViewModel.h"
#import "ResultModel.h"
#import "RRCProgressHUD.h"
#import "MXSRefreshHeader.h"
#import "MBProgressHUD.h"
#import <MJRefresh.h>
//
//#import "RRCLeagueConditionViewController.h"
//#import "RRCLeaguesModel.h"
@interface GGCLeagueDeleteListVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) ResultViewModel *resultViewModel;

@property (nonatomic, assign) NSInteger current_page;
@property (nonatomic, assign) BOOL is_last_page;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GGCLeagueDeleteListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _resultViewModel = [[ResultViewModel alloc]init];
    
    kWeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf refreshData];
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
                
        self.is_last_page = count;
        
        [self.tableView reloadData];
    }];
}

- (IBAction)deleAllData:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableArray *deArray = [NSMutableArray new];
    
    for (NSInteger i = 0; i < _resultViewModel.listArray.count; i++) {
        
        ResultModel *r = _resultViewModel.listArray[i];
        
        if (r.isEditDelete) {
            [deArray addObject:r.ID];
        }
        
        
    }
    
    if (deArray.count) {
        
//        NSLog(@"删除的ID：%@",deArray);
        
        [_resultViewModel deleteMatchArrListWithParameters:@{@"ids":deArray} Complete:^(BOOL isEnd) {
//
            [MBProgressHUD hideHUDForView:self.view animated:YES];
//
            [self.tableView.mj_header beginRefreshing];

        }];
    }
    
   
    
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
    RRCLeafueDelcell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRCLeafueDelcell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"RRCLeafueDelcell" owner:self options:nil] objectAtIndex:0];
    }
    [cell setLeResultModel:_resultViewModel.listArray[indexPath.row]];
//    cell.didActionDelete = ^{
//        
//        [self.tableView reloadData];
//    
//    };
    return cell;
}

@end

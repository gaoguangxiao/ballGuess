//
//  GGCBigSmallBallViewController.m
//  竞彩建模
//
//  Created by gaoguangxiao on 2020/6/9.
//  Copyright © 2020 renrencai. All rights reserved.
//

#import "GGCBetRecordListVC.h"
#import "RRCLeafueDelcell.h"

#import "ResultViewModel.h"
#import "ResultModel.h"
#import "RRCProgressHUD.h"
#import "MXSRefreshHeader.h"

#import <MJRefresh.h>
//

@interface GGCBetRecordListVC ()<UITableViewDelegate,UITableViewDataSource>
//@property (nonatomic, strong) ResultViewModel *resultViewModel;

@property (nonatomic, assign) NSInteger current_page;
@property (nonatomic, assign) BOOL is_last_page;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation GGCBetRecordListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //    _resultViewModel = [[ResultViewModel alloc]init];
    
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
    
    [Service loadBmobObjectByParameters:@{} andByStoreName:@"BetListOrderStore" constructingBodyWithBlock:^(CGDataResult *obj, BOOL b) {
        
        [RRCProgressHUD hideRRCForView:self.view animated:YES];
        
        if (b) {
            NSArray *loadArr = [RRCBetRecordModel mj_objectArrayWithKeyValuesArray:obj.data];
            
            if (loadArr.count == 0) {
                [self listZeroViewText:@"暂无数据" andImageName:@"" andView:self.tableView];
            }else{
                [self.dataArrayList addObjectsFromArray:loadArr];
                
                [self hiddenNoDataView];
                
                [self.tableView reloadData];
            }
            
            
        }else{
            
        }
    }];
    
}

-(void)refreshData{
    
    [Service loadBmobObjectByParameters:@{} andByStoreName:@"BetListOrderStore" constructingBodyWithBlock:^(CGDataResult *obj, BOOL b) {
        
        [self.tableView.mj_header endRefreshing];
        if (b) {
            NSArray *loadArr = [RRCBetRecordModel mj_objectArrayWithKeyValuesArray:obj.data];
            
            if (loadArr.count == 0) {
                [self listZeroViewText:@"暂无数据" andImageName:@"" andView:self.tableView];
            }else{
                
                [self.dataArrayList removeAllObjects];
                
                [self.dataArrayList addObjectsFromArray:loadArr];
                
                [self hiddenNoDataView];
                
                [self.tableView reloadData];
            }
            
            
        }else{
            
        }
    }];
}


#
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    self.tableView.mj_footer.hidden = self.is_last_page;
    return self.dataArrayList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RRCLeafueDelcell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRCLeafueDelcell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"RRCLeafueDelcell" owner:self options:nil] objectAtIndex:0];
    }
    [cell setLeResultModel:self.dataArrayList[indexPath.row]];
    
    kWeakSelf;
    cell.didActionUpdateScore = ^(RRCBetRecordModel * _Nonnull betM) {
        
        [[HUDHelper sharedInstance]syncLoading:@"更新比分"];
        
        [Service loadBmobObjectByParameters:@{@"ID_bet007":betM.match_id,@"objectId":betM.objectId} andByStoreName:@"updateBetOrder" constructingBodyWithBlock:^(CGDataResult *obj, BOOL b) {
            
            if (b) {
                
                [self.dataArrayList replaceObjectAtIndex:indexPath.row withObject:obj.data];
                
                [[HUDHelper sharedInstance]syncStopLoadingMessage:@"更新成功" delay:0.1 completion:^{
                    
                    [weakSelf.tableView reloadData];
                    
                }];
            }else{
                
                [[HUDHelper sharedInstance]syncStopLoadingMessage:obj.errorMsg];
                
            }
            
        }];
    };
    return cell;
}

@end

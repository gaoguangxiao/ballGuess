//
//  GGCBigSmallBallViewController.m
//  竞彩建模
//
//  Created by gaoguangxiao on 2020/6/9.
//  Copyright © 2020 renrencai. All rights reserved.
//

#import "GGCLeagueListViewController.h"
#import "GGCRiceListCell.h"
#import "ResultViewModel.h"
#import "ResultModel.h"
#import "RRCProgressHUD.h"
#import "MXSRefreshHeader.h"
#import "MBProgressHUD.h"
#import <MJRefresh.h>

#import "RRCLeagueConditionViewController.h"
#import "RRCLeaguesModel.h"
@interface GGCLeagueListViewController ()<UITableViewDelegate,UITableViewDataSource>
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

@implementation GGCLeagueListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _resultViewModel = [[ResultViewModel alloc]init];
    
    [self loadLeagueName];
        
}

-(void)loadLeagueName{
    [RRCProgressHUD showLoadView:self.view andHeight:self.view.frame.size.height];
    
    [_resultViewModel previewMatchListLeagueWithParameters:@{} Complete:^(NSArray * _Nonnull loadArr, NSInteger count) {
            
        NSMutableArray *leagueListArr = [NSMutableArray new];
        NSString *vcTitle = @"";
        for (NSInteger i = 0 ; i < loadArr.count; i++) {
            RRCLeaguesModel *temp_m = loadArr[i];
            if ([temp_m.name isEqualToString:self.leagueName]) {
                [leagueListArr addObjectsFromArray:temp_m.leagueList];
            }
            vcTitle = temp_m.name;
        }
        
        [_resultViewModel sortMatchLeagueWithParameters:leagueListArr Complete:^(NSArray * _Nonnull loadArr) {
            
            [RRCProgressHUD hideRRCForView:self.view animated:YES];
            
            if (leagueListArr.count == 0) {
                [self listZeroViewText:@"暂无数据" andImageName:@"" andView:self.tableView];
            }else{
                [self hiddenNoDataView];
            }
        
            [self updateRateText];
            
            [self.resultViewModel.listArray removeAllObjects];
            
            [self.resultViewModel.listArray addObjectsFromArray:leagueListArr];
            
            [self.tableView reloadData];
            
        }];

    }];
}

-(void)updateRateText{
    
    self.yzRate.text = _resultViewModel.yzRateText;
    
    self.dxqRate.text = _resultViewModel.dxqRateText;
    
    self.bdRate.text = _resultViewModel.yzdxqRRateText;
    
    self.jsRate.text = [NSString stringWithFormat:@"%@/%@",_resultViewModel.jcRateText,_resultViewModel.bdRateText];
    
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
        
        [self.tableView reloadData];
    
    };
    return cell;
}

@end

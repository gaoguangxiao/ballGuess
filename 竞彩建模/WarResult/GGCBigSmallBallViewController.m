//
//  GGCBigSmallBallViewController.m
//  竞彩建模
//
//  Created by gaoguangxiao on 2020/6/9.
//  Copyright © 2020 renrencai. All rights reserved.
//

#import "GGCBigSmallBallViewController.h"
#import "ResultTableViewCell.h"
#import "ResultViewModel.h"
#import "ResultModel.h"
#import "RRCProgressHUD.h"
@interface GGCBigSmallBallViewController ()
@property (nonatomic, strong) ResultViewModel *resultViewModel;
@end

@implementation GGCBigSmallBallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.baseTable.backgroundColor = RRCUnitViewColor;
    self.title = @"预测大小球";
    
    [self.view addSubview:self.baseTable];
    [self.baseTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_offset(0);
        make.bottom.mas_equalTo(0);
        make.top.mas_offset(0);
    }];
    self.baseTable.rowHeight = 90;
    
    _resultViewModel = [[ResultViewModel alloc]init];
    
    if (self.lastResultModel) {
        [_resultViewModel.listArray addObject:self.lastResultModel];
    }else{
        [self loadData];
    }
}

-(void)loadData{
    
    [RRCProgressHUD showLoadView:self.view andHeight:kScreenHeight];
    
    [_resultViewModel requestDataWithParameters:@{@"name":self.homeName} andComplete:^(NSArray * _Nonnull loadArr, BOOL isLoadsuc) {
        
        [RRCProgressHUD hideRRCForView:self.view animated:YES];
        
        [self.baseTable reloadData];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _resultViewModel.listArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ResultTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    [cell setupResultModel:_resultViewModel.listArray[indexPath.row]];
    return cell;
}

@end

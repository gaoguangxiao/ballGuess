//
//  HistorryOrderViewController.m
//  CPetro
//
//  Created by ggx on 2017/3/8.
//  Copyright © 2017年 高广校. All rights reserved.
//

#import "HistorryOrderViewController.h"
#import "HistorryOrderDetailViewController.h"

#import "RecordOrderCell.h"
#import "BSButtonView.h"
//#import "EFQuery.h"

@interface HistorryOrderViewController ()<BSButtonViewDelegate>
{
    __weak IBOutlet UITableView *_tableView;
    BOOL isFlow;
}
@property(nonatomic ,strong) NSMutableArray *baseData;
@end

@implementation HistorryOrderViewController
-(NSMutableArray *)baseData{
    if (!_baseData ) {
        _baseData = [NSMutableArray new];
    }
    return _baseData;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //将充值流量和账户充值合并在一起
    self.navigationItem.title = @"交易记录";

    BSButtonView *bsButtonView = [[BSButtonView alloc]initItemWithFram:CGRectMake(0, 0, SCREEN_WIDTH, 50) andData:@[@"预测记录",@"充值记录"]];
    bsButtonView.delegate = self;
    [self.view addSubview:bsButtonView];
    
    //
    [self afterRefreshView];
}
-(void)refreshView{
}
-(void)afterRefreshView{
    NSString *storeName;
    if (isFlow) {
        storeName = @"FlowStore";//预测记录
    }else{
        storeName = @"OrderListStore";//充值记录
    }
    [[HUDHelper sharedInstance]syncLoading];
    [Service loadBmobObjectByParameters:@{} andByStoreName:storeName constructingBodyWithBlock:^(CGDataResult *obj, BOOL b) {
        if (b) {
            [[HUDHelper sharedInstance]syncStopLoading];
            [self.baseData removeAllObjects];
            //主线程
            [self.baseData addObjectsFromArray:obj.data];
            
            if (self.baseData.count == 0) {
                [self listZeroViewText:@"暂无数据" andImageName:@"" andView:self->_tableView];
            }else{
                [self hiddenNoDataView];
            }
            
            [self->_tableView reloadData];
        }
    }];
//    [_tableView reloadData];
}
#pragma mark -切换
-(void)didActionBottomIndex:(NSInteger)index{

    isFlow = index == 1;
    
    [self afterRefreshView];

}
-(void)loadMore{
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.baseData count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellidenti = @"RecordOrderCell";
    RecordOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidenti];
    if (!cell) {
        cell = [[RecordOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidenti];
    }
    cell.objectBmob = self.baseData[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BmobObject *bmobObject = self.baseData[indexPath.row];
    HistorryOrderDetailViewController *Vc = CreateViewController(@"HistorryOrderDetailViewController");
    Vc.flowExChange = isFlow?@"2":@"1";
    Vc.homeOrderEntity = bmobObject;
    PushViewController(Vc);

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  HistorryOrderDetailViewController.m
//  CPetro
//
//  Created by ggx on 2017/3/8.
//  Copyright © 2017年 高广校. All rights reserved.
//

#import "HistorryOrderDetailViewController.h"

#import "UserCenterCell.h"
//#import "CGTableView+loadView2.h"
@interface HistorryOrderDetailViewController ()
{
    __weak IBOutlet UITableView *_tableView;
}
@property(nonatomic,strong)NSMutableArray *baseData;
@end

@implementation HistorryOrderDetailViewController

-(NSMutableArray *)baseData{
    if (!_baseData) {
        _baseData = [NSMutableArray new];
    }
    return _baseData;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"充值记录详情";
    //充值订单查询
    if ([self.flowExChange isEqualToString:@"2"]) {
        if ([[self.homeOrderEntity objectForKey:@"payType"] isEqualToString:@"Appleng"]) {
//            [self.baseData addObjectsFromArray:@[
//                                                 @{@"text":@"订单号",@"value":[self.homeOrderEntity objectForKey:@"orderId"]},
//                                                 @{@"text":@"充值时间",@"value":[self.homeOrderEntity objectForKey:@"createdAt"]},
//                                                 @{@"text":@"充值名称",@"value":[self.homeOrderEntity objectForKey:@"payType"]},
//                                                 @{@"text":@"充值名称",@"value":[self.homeOrderEntity objectForKey:@"money"]},
//                                                 @{@"text":@"充值状态",@"value":@"成功"}]];
        }else{
//            [BmobPay queryWithOrderNumber:[self.homeOrderEntity objectForKey:@"orderId"] result:^(NSDictionary *resultDic, NSError *error) {
//                if (resultDic[@"trade_state"]) {//订单状态
//                    [self.baseData addObjectsFromArray:@[
//                                                         @{@"text":@"订单号",@"value":[self.homeOrderEntity objectForKey:@"orderId"]},
//                                                         @{@"text":@"充值时间",@"value":[self.homeOrderEntity objectForKey:@"createdAt"]},
//                                                         @{@"text":@"充值名称",@"value":[self.homeOrderEntity objectForKey:@"payType"]},
//                                                         @{@"text":@"充值名称",@"value":[self.homeOrderEntity objectForKey:@"money"]},
//                                                         @{@"text":@"充值状态",@"value":resultDic[@"trade_state"]}]];
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        [_tableView reloadData];
//                    });
//                }else{
//
//                }
//            }];
        }
    }else if ([self.flowExChange isEqualToString:@"1"]){
        
//        [self showAnimated:YES title:@"" whileExecutingBlock:^CGDataResult *{
//            return [Service loadNetWorkingByParameters:@{@"orderid":[self.homeOrderEntity objectForKey:@"orderId"],@"key":API_EXCHANGE} andBymethodName:@"flow/ordersta"];
//        } completionBlock:^(BOOL b, CGDataResult *r) {
//            if(b){
//                HomeOrderEntity *homeOrder = (HomeOrderEntity *)[HomeOrderEntity getObjectFromDic:r.dataList];
//                
//                [self.baseData addObjectsFromArray:@[
//                                                     @{@"text":@"订单号",@"value":[self.homeOrderEntity objectForKey:@"orderId"]},
//                                                     @{@"text":@"充值金额",@"value":homeOrder.uordercash},
//                                                     @{@"text":@"充值手机",@"value":[self.homeOrderEntity objectForKey:@"phone"]},
//                                                     @{@"text":@"充值时间",@"value":[self.homeOrderEntity objectForKey:@"createdAt"]},
//                                                     @{@"text":@"充值状态",@"value":homeOrder.game_state}]];
//                
//                [_tableView reloadData];
//                
//            }
//        }];
    }
}
-(void)refreshView{
    //查询充值流量的借款
    
    
}
-(void)loadMore{
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.baseData count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellidenti = @"UserCenterCell";
    UserCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidenti];
    if (!cell) {
        cell = [[UserCenterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidenti];
    }
    cell.userDic = self.baseData[indexPath.row];
    return cell;
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

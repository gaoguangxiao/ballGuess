//
//  HistorryOrderDetailViewController.h
//  CPetro
//
//  Created by ggx on 2017/3/8.
//  Copyright © 2017年 高广校. All rights reserved.
//

#import "RRCRootViewController.h"

#import "HomeOrderEntity.h"
@interface HistorryOrderDetailViewController : RRCRootViewController
/**流量充值1、账户充值2*/
@property(nonatomic,strong)NSString *flowExChange;
@property(nonatomic,strong)BmobObject *homeOrderEntity;
@end

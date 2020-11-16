//
//  HomeCell.h
//  CPetro
//
//  Created by ggx on 2017/3/9.
//  Copyright © 2017年 高广校. All rights reserved.
//

#import "RRCTableViewCell.h"

#import "HomeOrderEntity.h"

@interface RecordOrderCell : RRCTableViewCell
@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)UILabel *orderId;
@property(nonatomic,strong)UILabel *orderTime;

@property (nonatomic , strong) UILabel *orderDetail;//订单详情 开赛时间 + 联赛

@property(nonatomic,strong)HomeOrderEntity *homeOrderEntity;

@property(nonatomic,strong)BmobObject *objectBmob;
@end

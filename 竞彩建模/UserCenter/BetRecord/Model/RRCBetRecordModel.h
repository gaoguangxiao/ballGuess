//
//  RRCBetRecordModel.h
//  竞彩建模
//
//  Created by gaoguangxiao on 2020/11/16.
//  Copyright © 2020 renrencai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RRCBetRecordModel : NSObject

@property (nonatomic , strong) NSString *objectId;//下注ID

@property (nonatomic , strong) NSString *match_id;

@property (nonatomic , strong) NSString *hmd;//月日时分
@property (nonatomic , strong) NSString *league;//联赛名字

@property (nonatomic , strong) NSString *status;//1 有赛果 0未出赛果

@property (nonatomic, strong) NSString *home;//主队名字
@property (nonatomic , strong) NSString *homeScore;//主队进球数
@property (nonatomic, strong) NSString *away;//客队名字
@property (nonatomic, strong) NSString *awayScore;//客队进球数

@property (nonatomic , strong) NSString *dxq_pk_water;//大小球水位
@property (nonatomic , strong) NSString *dxq_dxdif;//大小球差值
@property (nonatomic , strong) NSString *dxq_money;//大小球投注额
@property (nonatomic , strong) NSString *dxq_pk;//公司所开大小球盘口

@property (nonatomic , strong) NSString *yz_pk_water;//亚指水位
@property (nonatomic , strong) NSString *yz_dxdif;//亚指差值
@property (nonatomic , strong) NSString *yz_money;//亚指投注额
@property (nonatomic , assign) NSString *yz_pk;//公司所开亚指盘口

@property (nonatomic , strong) NSString *dxq_win;//-1未出赛果 0失败 1 成功 2走水
@property (nonatomic , strong) NSString *dxq_winMoney;

@property (nonatomic , strong) NSString *yz_win;
@property (nonatomic , strong) NSString *yz_winMoney;//亚指最终盈利

@property (nonatomic , strong) NSString *orderState;//订单状态 0未开始 1进行中 2已完成 3货物异常
@end

NS_ASSUME_NONNULL_END

//
//  GGXMatchInfo.h
//  竞彩建模
//
//  Created by gaoguangxiao on 2020/6/9.
//  Copyright © 2020 renrencai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GGXMatchInfo : NSObject

@property (nonatomic , strong) NSString *ID;
@property (nonatomic , strong) NSString *match_id;

@property (nonatomic , strong) NSString *mmdd;//月日
@property (nonatomic , strong) NSString *hhmm;//时分
@property (nonatomic , strong) NSString *league;//联赛名字

//已知参数
@property (nonatomic, strong) NSString *home;//主队名字
@property (nonatomic, strong) NSString *homeRange;//主队排名
@property (nonatomic, strong) NSString *homeLeagueScore;//主队联赛积分
@property (nonatomic, strong) NSString *homeHistoryScore;//主队近期胜率不分主客
@property (nonatomic, strong) NSString *homeHostHistoryScore;//主队近期胜率分主客
@property (nonatomic, strong) NSString *homeHostEncounterScore;//主队和客队交锋分主客

@property (nonatomic, strong) NSString *away;//客队名字
@property (nonatomic, strong) NSString *awayRange;//客队排名
@property (nonatomic , strong)NSString *home_score;//主队进球数
@property (nonatomic, strong) NSString *away_score;//客队进球数
@property (nonatomic, strong) NSString *awayLeagueScore;//客队联赛积分
@property (nonatomic, strong) NSString *awayHistoryScore;//客队近期胜率不分主客
@property (nonatomic, strong) NSString *awayHostHistoryScore;//客队近期胜率分主客
@property (nonatomic, strong) NSString *awayHostEncounterScore;//主队和客队交锋分主客

@property (nonatomic , strong) NSString *homeEnterCount;//主队近期平均得球数
@property (nonatomic , strong) NSString *awayEnterCount;//客队近期平均得球数
@property (nonatomic , strong) NSString *warEnterCount;//交锋近期平均得球数

//@property (nonatomic , strong) NSString *companyBigSmallNumber;//公司所开盘口
//@property (nonatomic , assign) float companyYazhiNumber;//公司所开亚指盘口

//预估数据
@property (nonatomic , strong) NSString *bd_home_score;
@property (nonatomic , strong) NSString *bd_away_score;
@property (nonatomic , strong) NSString *home_score_weight;
@property (nonatomic , strong) NSString *away_score_weight;
@property (nonatomic , strong) NSString *forecast_home_score;
@property (nonatomic , strong) NSString *forecast_away_score;
@property (nonatomic , strong) NSString *forecast_ball_num;

@property (nonatomic , strong) NSString *dxq_dpk;//大小球大球水位
@property (nonatomic , strong) NSString *dxq_xpk;//大小球大球小位
@property (nonatomic , strong) NSString *dxq_pk;
@property (nonatomic , strong) NSString *yp_pk;
@property (nonatomic , strong) NSString *yp_spk;//亚指上盘水位
@property (nonatomic , strong) NSString *yp_xpk;//亚指下盘水位
@end

NS_ASSUME_NONNULL_END

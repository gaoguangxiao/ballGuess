//
//  ResultModel.h
//  竞彩建模
//
//  Created by gaoguangxiao on 2020/6/8.
//  Copyright © 2020 renrencai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface ResultModel : NSObject

@property (nonatomic , strong) NSString *ID;
@property (nonatomic , strong) NSString *match_id;
     
@property (nonatomic , strong) NSString *mmdd;//月日
@property (nonatomic , strong) NSString *hhmm;//时分
@property (nonatomic , strong) NSString *league;//联赛名字

@property (nonatomic , strong) NSString *status;//1 有赛果 0未出赛果
//已知参数
@property (nonatomic, strong) NSString *home;//主队名字
@property (nonatomic, strong) NSString *homeRange;//主队排名
@property (nonatomic , strong) NSString *homeScore;//主队进球数
@property (nonatomic, assign) float homeLeagueScore_pro;//主队联赛积分占比
@property (nonatomic, assign) float homeHistoryScore_pro;//主队近期胜率不分主客占比
@property (nonatomic, assign) float homeHostHistoryScore_pro;//主队近期胜率分主客占比
@property (nonatomic, assign) float homeHostEncounterScore_pro;//主队和客队交锋分主客占比


@property (nonatomic, strong) NSString *away;//客队名字
@property (nonatomic, strong) NSString *awayRange;//客队排名
@property (nonatomic, strong) NSString *awayScore;//客队进球数
@property (nonatomic, assign) float awayLeagueScore_pro;//客队联赛积分占比
@property (nonatomic, assign) float awayHistoryScore_pro;//客队近期胜率不分主客占比
@property (nonatomic, assign) float awayHostHistoryScore_pro;//客队近期胜率分主客占比
@property (nonatomic, assign) float awayHostEncounterScore_pro;//主队和客队交锋分主客占比

//比如皇冠
@property (nonatomic , strong) NSString *dxq_dpk;//大小球大球水位
@property (nonatomic , strong) NSString *dxq_xpk;//大小球大球小位
@property (nonatomic , strong) NSString *companyBigSmallNumber;//公司所开大小球盘口

@property (nonatomic , strong) NSString *yp_spk;//亚指上盘水位
@property (nonatomic , strong) NSString *yp_xpk;//亚指下盘水位
@property (nonatomic , assign) float companyYazhiNumber;//公司所开亚指盘口

//计算所得参数
@property (nonatomic , assign) float allCompositeScore; //计算所得大小数 如 3.55

@property (nonatomic , assign) float homeProportion;//主队得分占比 51.52
@property (nonatomic , assign) float awayProportion;//客队得分占比 48.48

//结果参数
@property (nonatomic , assign) float homeCompositeScore;//主队计算所得球 如 1.83
@property (nonatomic , assign) float awayCompositeScore;//客队计算所得球 如 1.72
@property (nonatomic , strong) NSString *finishScoreSuc;
@property (nonatomic , strong) UIColor *finishScoreViewColor;//-1未出赛果 0失败 1 成功 2走水
@property (nonatomic , strong) UIImage *finishScoreImage;

@property (nonatomic , strong) NSString *bd_home_score;
@property (nonatomic , strong) NSString *bd_away_score;

//胜平负
@property (nonatomic , strong) NSString *finishWinText;//胜 平 负
@property (nonatomic , strong) NSString *finishWinSuc;//1主 3负
@property (nonatomic , strong) UIColor *finishWinViewColor;//推荐主客队灰色背景 失败黑色背景 成功红色背景

//胜平负第二选项
@property (nonatomic , strong) NSString *finishWinSText;//胜 平 负
@property (nonatomic , strong) NSString *finishWinSSuc;//1主 3负
@property (nonatomic , strong) UIColor *finishWinSViewColor;//推荐主客队灰色背景 失败黑色背景 成功红色背景

//大小球
@property (nonatomic , strong) NSString *finishBigMoney;//未出赛果比赛投注额
@property (nonatomic , strong) NSString *finishBigText;//最终大小推荐
@property (nonatomic , strong) NSString *finishBigSuc; //结果是否成功 -1未出赛果 0失败 1 成功 2走水
@property (nonatomic , strong) NSString *finishBigDif; //大小球预测水位 如果大球那么就为大球水位，小球为小球水位
@property (nonatomic , strong) NSString *finishScoreBigDif; //大小球预测差值
@property (nonatomic , strong) UIColor  *finishBigTextColor;//文本颜色 1正常 0警告
@property (nonatomic , strong) UIColor *finishBigViewColor;//未出赛果灰色背景 失败黑色背景 成功红色背景 走水绿色背景
@property (nonatomic , strong) UIImage *finishBigImage;

//亚指
@property (nonatomic , strong) NSString *finishYazhiMoney;//未出赛果比赛投注额
@property (nonatomic , strong) NSString *finishYazhiText;//最终胜平负
@property (nonatomic , strong) NSString *finishYazhiSuc;//结果是否成功 -1未出赛果 0失败 1 成功 2走水
@property (nonatomic , strong) NSString *finishYazhiDif; //亚指预测差值 预测赛果水位
@property (nonatomic , strong) NSString *finishScoreYazhiDif; //亚指预测差值 预测亚指差值
@property (nonatomic , strong) UIColor *finishYazhiViewColor;//视图背景
@property (nonatomic , strong) UIColor *finishYazhiTextColor;//文本颜色 1正常 0警告
@property (nonatomic , strong) UIImage *finishYazhiImage;

@property (nonatomic , strong) NSString *benjinMoney;//本金剩余
//某条赛事编辑状态
@property (nonatomic , assign) BOOL isEditDelete;
@end

NS_ASSUME_NONNULL_END

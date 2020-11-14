//
//  RRCMatchInfoModel.h
//  MXSFramework
//
//  Created by renrencai on 2019/4/17.
//  Copyright © 2019年 MXS. All rights reserved.
//

#import <Foundation/Foundation.h>

//#import "RRCMatchOddModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RRCMatchInfoModel : NSObject

//赛事信息
@property (nonatomic , strong) NSString *matchId;//
@property (nonatomic , assign) NSInteger MatchTimeStamp;//赛事时间
@property (nonatomic , strong) NSString *matchTime;//赛事时间
@property (nonatomic , strong) NSString *matchBallName;//让球
@property (nonatomic , strong) NSString *ID;
@property (nonatomic,copy) NSString *ID_bet007;//赛事唯一的ID
@property (nonatomic,copy) NSString *game_type;//赛事类型0竞彩，1北单，2串子 3篮球、4亚指
/** 比赛成员*/
@property (nonatomic , strong) NSString *matchMember;//

@property (nonatomic , strong) NSString *home;
@property (nonatomic , strong) NSString *homeScore;

@property (nonatomic , strong) NSString *away;
@property (nonatomic , strong) NSString *awayScore;

/** 比赛名字*/
@property (nonatomic , strong) NSString *matchName;//

@property (nonatomic , strong)NSArray *matchBallNum;//让球数目 【@"0"，@"+1"】| 几行（不算标题）

/** 赛事状态*/
@property (nonatomic , strong) NSString *state;

/** 0:待定 、 1：红 、2：黑 、3：走水 */
@property (nonatomic , assign) NSInteger matchStaus;//赛事状态

/** 赛事日期
 */
@property (nonatomic , strong) NSString *md;

/** 月日*/
@property (nonatomic , strong) NSString *match_time1;

/** 时分*/
@property (nonatomic , strong) NSString *match_time2;

/** 单场赛事结果*/
@property (nonatomic , strong) NSString *matchResultsImage;

/** 比赛的方法*/
@property (nonatomic , strong) NSArray *matchPlayMethod;

/** 比赛的方法 对应的选项 [@"胜2.5",@"平"]*/
@property (nonatomic , strong) NSArray <NSString *>*matchOdds;

/** 比赛状态 无赛果 黑 红 取消 走水 [无,取消]*/
@property (nonatomic , strong) NSArray <NSString *>*matchStateArr;

/** letball*/
@property(nonatomic , strong) NSString *letball;


#pragma mark - 竞彩
/** 不让球数*/
@property (nonatomic , strong) NSString *sf_goal;

@property (nonatomic , strong) NSString *sf_result;//不让球比赛结果 1：黑色 ，2红色，3走水
@property (nonatomic , strong) NSString *rq_sf_result;

@property (nonatomic , strong) NSString *sf_sf0;//不让球负赔率
@property (nonatomic , strong) NSString *sf_sf0_red;//不让球负 是否红
@property (nonatomic , assign) NSInteger sf_sf0_flag;
@property (nonatomic , strong) NSString *sf_sf0_checked;//是否选中不让球负
@property (nonatomic , strong) NSString *sf_sf0_checked_gui;//是否能选不让球负

@property (nonatomic , strong) NSString *sf_sf1;//不让球平赔率
@property (nonatomic , strong) NSString *sf_sf1_red;//不让球平 是否红
@property (nonatomic , assign) NSInteger sf_sf1_flag;
@property (nonatomic , strong) NSString *sf_sf1_checked;//是否选中不让球平
@property (nonatomic , strong) NSString *sf_sf1_checked_gui;//是否能选不让球平

@property (nonatomic , strong) NSString *sf_sf3;//不让球胜赔率
@property (nonatomic , strong) NSString *sf_sf3_red;//不让球胜 是否红
@property (nonatomic , strong) NSString *sf_sf3_checked;//是否选中不让球胜
@property (nonatomic , assign) NSInteger sf_sf3_flag;
@property (nonatomic , strong) NSString *sf_sf3_checked_gui;//是否能选不让球胜 1不能选中了

@property (nonatomic , strong) NSString *rq_goal;//让球数
@property (nonatomic , strong) NSString *rq_result;//让球比赛结果

@property (nonatomic , strong) NSString *rq_rq0;//让球负赔率
@property (nonatomic , strong) NSString *rq_rq0_red;//让球负 红
@property (nonatomic , strong) NSString *rq_rq0_checked;//是否选中让球负
@property (nonatomic , assign) NSInteger rq_rq0_flag;//让球赔率
@property (nonatomic , strong) NSString *rq_rq0_checked_gui;//是否能选让球负

@property (nonatomic , strong) NSString *rq_rq1;//让球平赔率
@property (nonatomic , strong) NSString *rq_rq1_red;//让球平 红
@property (nonatomic , strong) NSString *rq_rq1_checked;//是否选中让球平
@property (nonatomic , assign) NSInteger rq_rq1_flag;
@property (nonatomic , strong) NSString *rq_rq1_checked_gui;//是否能选让球平

@property (nonatomic , strong) NSString *rq_rq3;//让球胜赔率
@property (nonatomic , strong) NSString *rq_rq3_red;//让球胜 红
@property (nonatomic , strong) NSString *rq_rq3_checked;//是否选中让球胜
@property (nonatomic , assign) NSInteger rq_rq3_flag;
@property (nonatomic , strong) NSString *rq_rq3_checked_gui;//是否能选让球胜

@property (nonatomic,assign) NSInteger rq_goal_CheckNum;//让球
@property (nonatomic,assign) NSInteger sf_goal_CheckNum;//不让球
#pragma mark - 竞彩亚指
@property (nonatomic , strong) NSString *yz_desc;//亚指
@property (nonatomic , strong) NSString *jc_yz_result;//亚指结果
@property (nonatomic , strong) NSString *jc_yz_jspk;//亚指即时盘口

@property (nonatomic , strong) NSString *jc_yz_hjspl;//亚指主队赔率
@property (nonatomic , strong) NSString *jc_yz_hjspl_str;//亚指主队赔率描述
@property (nonatomic , strong) NSString *jc_yz_hjspl_red;//亚指主队 红
@property (nonatomic , strong) NSString *jc_yz_hjspl_checked;//是否选中亚盘主队赔率
@property (nonatomic , assign) NSInteger jc_yz_hjspl_flag;//亚指主队赔率是否过低
@property (nonatomic , strong) NSString *jc_yz_hjspl_checked_gui;//是否选中亚盘主队赔率

@property (nonatomic , strong) NSString *jc_yz_wjspl;//亚指客队赔率
@property (nonatomic , strong) NSString *jc_yz_wjspl_str;//亚指客队赔率描述
@property (nonatomic , strong) NSString *jc_yz_wjspl_red;//亚指客队 红
@property (nonatomic , strong) NSString *jc_yz_wjspl_checked;//是否选中亚盘客队赔率
@property (nonatomic , assign) NSInteger jc_yz_wjspl_flag;//亚指客队赔率是否过低
@property (nonatomic , strong) NSString *jc_yz_wjspl_checked_gui;//是否选中亚盘主队赔率



@property (nonatomic , assign) NSInteger order;

/*单场列表弹记录选中*/
///*不让球(0 1 2)  让球(3 4 5) 亚指(6 7) */
//@property (nonatomic , strong) NSString *gameType;
/** 是否选中不让球负*/
@property (nonatomic , assign) BOOL sf_sf0_local_checked;
//** 是否选中不让球平*/
@property (nonatomic , assign) BOOL sf_sf1_local_checked;
/** 是否选中不让球胜*/
@property (nonatomic , assign) BOOL sf_sf3_local_checked;
/** 是否选中让球负*/
@property (nonatomic , assign) BOOL rq_rq0_local_checked;
/** 是否选中让球平*/
@property (nonatomic , assign) BOOL rq_rq1_local_checked;
/** 是否选中让球胜*/
@property (nonatomic , assign) BOOL rq_rq3_local_checked;
/*是否选中亚盘客队赔率*/
@property (nonatomic , assign) BOOL jc_yz_wjspl_local_checked;
/*是否选中亚盘主队赔率*/
@property (nonatomic , assign) BOOL jc_yz_hjspl_local_checked;


//北单
@property (nonatomic , assign) BOOL spf_sf0_local_checked;//负
@property (nonatomic , assign) BOOL spf_sf1_local_checked;//平
@property (nonatomic , assign) BOOL spf_sf3_local_checked;//胜
@property (nonatomic , assign) BOOL bd_yz_hjspl_local_checked;//亚指 是否选中主队
@property (nonatomic , assign) BOOL bd_yz_wjspl_local_checked;//亚指 是否选中亚盘客胜

/** 赛事类型 0-竞彩 1-北单 2-篮球 3--亚指*/
@property (nonatomic , strong) NSString *match_type;

#pragma mark - 北单数据
@property (nonatomic , strong) NSString *match_id_str;
/** 让球数*/
@property (nonatomic , strong) NSString *spf_goal;
@property (nonatomic , strong) NSString *spf_result;

@property (nonatomic , strong) NSString *spf_sf3;
@property (nonatomic , strong) NSString *spf_sf3_red;
@property (nonatomic , strong) NSString *spf_sf3_checked;//胜
@property (nonatomic , assign) NSInteger spf_sf3_flag;

@property (nonatomic , strong) NSString *spf_sf1;
@property (nonatomic , strong) NSString *spf_sf1_red;
@property (nonatomic , strong) NSString *spf_sf1_checked;//平
@property (nonatomic , assign) NSInteger spf_sf1_flag;

@property (nonatomic , strong) NSString *spf_sf0;
@property (nonatomic , strong) NSString *spf_sf0_red;
@property (nonatomic , strong) NSString *spf_sf0_checked;//负
@property (nonatomic , assign) NSInteger spf_sf0_flag;

/** 亚指即时赔率*/
@property (nonatomic , strong) NSString *bd_yz_jspk;
@property (nonatomic , strong) NSString *bd_yz_result;

@property (nonatomic , strong) NSString *bd_yz_hjspl;
@property (nonatomic , strong) NSString *bd_yz_hjspl_red;
@property (nonatomic , strong) NSString *bd_yz_hjspl_str;
@property (nonatomic , strong) NSString *bd_yz_hjspl_checked;
@property (nonatomic , assign) NSInteger bd_yz_hjspl_flag;//亚指主是否赔率低

@property (nonatomic , strong) NSString *bd_yz_wjspl;
@property (nonatomic , strong) NSString *bd_yz_wjspl_red;
@property (nonatomic , strong) NSString *bd_yz_wjspl_str;//
@property (nonatomic , strong) NSString *bd_yz_wjspl_checked;
@property (nonatomic , assign) NSInteger bd_yz_wjspl_flag;//亚指客是否赔率低


#pragma mark - 篮球亚指
//篮球
@property (nonatomic , strong) NSString *league;

@property (nonatomic , strong) NSString *RFJSPK;
@property (nonatomic , strong) NSString *RF_result;

@property (nonatomic , strong) NSString *RFHJSPL;
@property (nonatomic , strong) NSString *RFHJSPL_str;
@property (nonatomic , strong) NSString *RFHJSPL_red;
@property (nonatomic , strong) NSString *RFHJSPL_checked;
@property (nonatomic , assign) NSInteger RFHJSPL_flag;

@property (nonatomic , strong) NSString *RFWJSPL;
@property (nonatomic , strong) NSString *RFWJSPL_str;
@property (nonatomic , strong) NSString *RFWJSPL_red;
@property (nonatomic , strong) NSString *RFWJSPL_checked;
@property (nonatomic , assign) NSInteger RFWJSPL_flag;

@property (nonatomic , strong) NSString *DXQJSPK;
@property (nonatomic , strong) NSString *dxf_desc;
@property (nonatomic , strong) NSString *DXQ_result;

@property (nonatomic , strong) NSString *DXQHJSPL;
@property (nonatomic , strong) NSString *DXQHJSPL_str;
@property (nonatomic , strong) NSString *DXQHJSPL_red;
@property (nonatomic , strong) NSString *DXQHJSPL_checked;
@property (nonatomic , assign) NSInteger DXQHJSPL_flag;

@property (nonatomic , strong) NSString *DXQWJSPL;
@property (nonatomic , strong) NSString *DXQWJSPL_str;
@property (nonatomic , strong) NSString *DXQWJSPL_red;
@property (nonatomic , strong) NSString *DXQWJSPL_checked;
@property (nonatomic , assign) NSInteger DXQWJSPL_flag;
#pragma mark - 篮球大小分
//亚指描述
@property (nonatomic , strong) NSString *yz_jspk;

@property (nonatomic , strong) NSString *dxq_desc;

@property (nonatomic , strong) NSString *dxq_jspk;
@property (nonatomic , strong) NSString *dxq_hjspl;
@property (nonatomic , strong) NSString *dxq_hjspl_str;
@property (nonatomic , strong) NSString *dxq_hjspl_red;
@property (nonatomic , assign) NSInteger dxq_hjspl_checked;
@property (nonatomic , assign) NSInteger dxq_hjspl_flag;//亚指大小 主赔率是否很低
@property (nonatomic , assign) BOOL dxq_hjspl_local_checked;

@property (nonatomic , strong) NSString *dxq_wjspl;
@property (nonatomic , strong) NSString *dxq_wjspl_str;
@property (nonatomic , strong) NSString *dxq_wjspl_red;
@property (nonatomic , assign) NSInteger dxq_wjspl_checked;
@property (nonatomic , assign) NSInteger dxq_wjspl_flag;//亚指大小 客赔率是否很低

@property (nonatomic , strong) NSString *dxq_result;


@property (nonatomic , assign) BOOL dxq_wjspl_local_checked;


/*亚指主队*/
@property (nonatomic , assign) BOOL RFHJSPL_local_checked;
/*亚指客队*/
@property (nonatomic , assign) BOOL RFWJSPL_local_checked;
/*大*/
@property (nonatomic , assign) BOOL DXQHJSPL_local_checked;
/*小*/
@property (nonatomic , assign) BOOL DXQWJSPL_local_checked;

/**是否展示推荐提示 */
@property (nonatomic , assign) BOOL isShowTipRecommend;

//擅长联赛展示 1显示 0不显示
@property (nonatomic , assign) NSInteger goodAt;
@end

NS_ASSUME_NONNULL_END

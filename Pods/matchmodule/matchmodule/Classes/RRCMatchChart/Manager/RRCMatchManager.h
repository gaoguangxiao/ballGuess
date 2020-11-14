//
//  RRCMatchManager.h
//  MXSFramework
//
//  Created by renrencai on 2019/4/16.
//  Copyright © 2019年 MXS. All rights reserved.
//

#import "RRCViewModel.h"
#import "Singleton.h"
#import "RRCMatchModel.h"
//#import "RRCMatchModelHeader.h"b

#import "RRCPostDraftModel.h" //可发帖赛事数量

@class RRCPostDraftModel;
NS_ASSUME_NONNULL_BEGIN

typedef void(^LoadMatchBlockGraftData)(RRCPostDraftModel *loadDraftResult);

@interface RRCMatchManager : RRCViewModel

DeclareSingleton(RRCMatchManager);

/**
 购物车模型
 */
@property (nonatomic , strong) RRCMatchModel *matchModel;

@property (nonatomic,copy) NSString *postID;//帖子Id


/**
 加载竞彩/北单日期数据

 @param matchType 0：竞彩 、1：北单
 @param complete 返回t日期数据
 */
-(void)loadMatchTodayRaceByType:(NSInteger)matchType andCompleteData:(LoadDataArrayBOOLIntegerBlockResult)complete;

/**
 加载条件数据筛选

 @param todayId <#todayId description#>
 @param senderTag <#senderTag description#>
 @param complete <#complete description#>
 */
-(void)loadMatchSortConditionsByTodayId:(NSString *)todayId andSortTypeByBtnTag:(NSInteger )senderTag andCompleteData:(LoadDataArrayBOOLIntegerBlockResult)complete;

/**
 加载赛事列表

 @param todayId 日期
 @param listArr 条件
 @param matchType 类型
 @param complete 返回数据
 */
-(void)loadTodayMatchByTodayId:(NSString *)todayId andLeagueListArr:(NSArray *)listArr andMatchType:(NSInteger )matchType andCompleteData:(LoadDataArrayBOOLIntegerBlockResult)complete;

#pragma mark - 赛事增删改查
/**
 保存赛事草稿
 
 @param matchList matchList description
 @param complete <#complete description#>
 */
-(void)saveOnceMatchInfoByMatchListModelArr:(NSArray *)matchList andComplete:(LoadDataArrayBOOLIntegerBlockResult)complete;

/**
 加载推荐赛事草稿

 @param paramter 请求参数
 @param complete 完成数据
 */
-(void)loadOnceRecommendedMatch:(NSDictionary *)paramter andComplete:(LoadDataArrayBOOLIntegerBlockResult)complete;


/// 加载赛事可推荐数量
/// @param paramter 传字段
/// @param complete <#complete description#>
-(void)loadOnceMatchRuleForSend:(NSDictionary *)paramter andComplete:(LoadMatchBlockGraftData)complete;

/**
 删除草稿

 @param matchtype 草稿类型
 @param RaftId 赛事类型
 @param complete 完成
 */
-(void)deleteMatchInfo:(NSString *)matchtype andByRaftId:(NSString *)RaftId andComplete:(loadDataBOOLBlock)complete;

/**
 处理串子数据

 @param arr 总场数
 @return 可串的数据
 */
-(NSArray *)handleTogetherStringDataByMatch:(NSArray *)arr;



#pragma mark - 赛事购物车
-(BOOL)boolInsertMatchInfoResult;


-(BOOL)boolInsertMatchInfoBy:(RRCMatchInfoModel *)matchInfoModel;

/**
 购物车插入数据

 @param matchInfoModel 场次
 */
-(void)handleInserMatchInfo:(RRCMatchInfoModel *)matchInfoModel;

/**
 删除购物车赛事数据

 @param matchInfoModel 要删除的赛事
 */
-(void)deleteShopCarMatchInfo:(RRCMatchInfoModel *)matchInfoModel andLoadDeleteResult:(loadDataBOOLBlock)complte;


/**
 更新赛事列表通过购物车数据

 @param matchArr 原始数据
 @return 返回处理之后的数据
 */
-(NSMutableArray *)updateMatchinfoListByShopCarArrWithOriMatchInfo:(NSMutableArray *)matchArr;

/**
 重置每场赛事状态

 @param ori_matchInfo <#ori_matchInfo description#>
 @return <#return value description#>
 */
-(RRCMatchInfoModel *)resetMatchInfoData:(RRCMatchInfoModel *)ori_matchInfo;


/**
 更新每场赛事用购物车数据

 @param ori_matchInfo <#ori_matchInfo description#>
 @param newMatchInfo <#newMatchInfo description#>
 @return <#return value description#>
 */
-(RRCMatchInfoModel *)updateMatchInfoData:(RRCMatchInfoModel *)ori_matchInfo andNewMatchInfo:(RRCMatchInfoModel *)newMatchInfo;
#pragma mark - 序列化赛事数据
/**
 赛事数据，web传递的数据 序列号 单场数据/串子数据 RRCMatchModel

 @param data_arr 单场数据/串子数据
 @return <#return value description#>
 */
-(NSMutableArray *)handMatchInfo:(NSArray *)data_arr;

/**
 序列化 串子数据

 @param originalDataArr <#originalDataArr description#>
 @return <#return value description#>
 */
-(NSArray *)loadMatchTogetherRaftData:(NSArray *)originalDataArr;

/**
 序列化 单场数据

 @param originalDataArr <#originalDataArr description#>
 @return <#return value description#>
 */
-(NSArray *)loadMatchRaftData:(NSArray *)originalDataArr;

/**
 处理以单场为单元
 
 @param originalDataArr 单场赛事
 @return 包装之后的 RRCMatchModel
 */
-(NSMutableArray *)loadMatchData:(NSArray *)originalDataArr;

//计算每个单场的高度
-(CGFloat)chartHeight:(RRCMatchInfoModel *)matchInfo;

-(NSDictionary *)getSubmit:(RRCMatchInfoModel *)infoModel;
@end

NS_ASSUME_NONNULL_END

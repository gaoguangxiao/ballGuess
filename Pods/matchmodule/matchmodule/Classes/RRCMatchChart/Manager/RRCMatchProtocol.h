//
//  RRCMatchProtocol.h
//  MXSFramework
//
//  Created by renrencai on 2019/4/18.
//  Copyright © 2019年 MXS. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RRCMatchInfoModel;
@class RRCMatchModel;
@protocol RRCMatchHandleProtocol <NSObject>

@optional;
/**
 删除某场比赛

 @param matchId 比赛的ID
 */
- (void)deleteMatchInfoBymatchId:(NSString *)matchId;

/**
 删除某场赛事

 @param matchModel <#matchModel description#>
 */
- (void)deleteMatchByMatchModel:(RRCMatchModel *)matchModel;

/**
 编辑某场赛事

 @param matchModel <#matchModel description#>
 */
- (void)editMatchByMatchModel:(RRCMatchModel *)matchModel;

/**
 * 删除赛事成功
 */
- (void)deleteMatchInfoSuccessful;

/**
 删除赛事时，当列表数据为0时
 */
- (void)deleteMatchWhileListCountZero;

/**
 更新赛事成功
 */
- (void)updateMatchInfoSuccessful;

/**
 插入某一场比赛

 @param macthId 比赛的ID
 @param matchInfo 比赛信息
 */
- (void)insertMatchInfoBymatchId:(NSString *)macthId andMatchInfo:(RRCMatchInfoModel *)matchInfo;

/**
 刷新当前比赛列表
 */
-(void)reloadAllMatchInfo;
@end

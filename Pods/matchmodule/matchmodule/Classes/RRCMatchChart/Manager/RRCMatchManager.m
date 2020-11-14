//
//  RRCMatchManager.m
//  MXSFramework
//
//  Created by renrencai on 2019/4/16.
//  Copyright © 2019年 MXS. All rights reserved.
//

#import "RRCMatchManager.h"
#import "RRCBallStateEdit.h"
#import "RRCBallModel.h"

#import "RRCTodayModel.h"
#import <MJExtension/MJExtension.h>

#import "RRCMatchLeagueModel.h"
#import "RRCMatchInfoModel.h"
#import "RRCPostDraftModel.h"

#import "RRCNetWorkManager.h"
#import "RRCAlertManager.h"
//工具
#import "RRCDeviceConfigure.h"
#import "RRCServiceApiConfig.h"
@implementation RRCMatchManager

ImplementSingleton(RRCMatchManager);

#pragma mark - 赛事日期
-(void)loadMatchTodayRaceByType:(NSInteger)matchType andCompleteData:(LoadDataArrayBOOLIntegerBlockResult)complete{
    NSString *requestUrl = RRCPostJcDatelist;
    if (matchType == 0) {
        requestUrl = RRCPostJcDatelist;
    }else if (matchType == 1) {
        requestUrl = RRCPostYpDatelist;
    }else if (matchType == 2){
        requestUrl = RRCPostLqDatelist;
    }
    [[RRCNetWorkManager sharedTool]loadRequestWithURLString:requestUrl parameters:@{} success:^(CGDataResult * _Nonnull result) {
        if (result.status.boolValue) {
            NSDictionary *dic = result.data;
            NSArray *arr = [RRCTodayModel mj_objectArrayWithKeyValuesArray:dic];
            complete(arr,YES,result.code);
        }else{
            [[RRCAlertManager sharedRRCAlertManager] showPostingWithtitle:result.errorMsg];
            if (result.code == 404) {
                complete(@[],NO,result.code);
            }
        }
    }];
}

#pragma mark - 赛事筛选
-(void)loadMatchSortConditionsByTodayId:(NSString *)todayId andSortTypeByBtnTag:(NSInteger )senderTag andCompleteData:(LoadDataArrayBOOLIntegerBlockResult)complete{
    NSString *requestUrl = RRCPostJcleaguelist;
    if (senderTag == 0) {
        requestUrl = RRCPostJcleaguelist;
    }else if (senderTag == 1) {
        requestUrl = RRCPostYzleaguelist;
    }else if (senderTag == 2){
        requestUrl = RRCPostLqleaguelist;
    }
    [[RRCNetWorkManager sharedTool] loadRequestWithURLString:requestUrl parameters:@{@"date_str":todayId,@"is_important":@"1"} success:^(CGDataResult * _Nonnull result) {
        if (result.status.boolValue) {
            NSDictionary *dic = result.data;
            NSArray *arr = [RRCMatchLeagueModel mj_objectArrayWithKeyValuesArray:dic];
            complete(arr,YES,result.code);
        }else{
            complete(@[],NO,result.code);
            [[RRCAlertManager sharedRRCAlertManager] showPostingWithtitle:result.errorMsg];
        }
    }];
}

#pragma mark -加载赛事列表
-(void)loadTodayMatchByTodayId:(NSString *)todayId andLeagueListArr:(NSArray *)listArr andMatchType:(NSInteger )matchType andCompleteData:(LoadDataArrayBOOLIntegerBlockResult)complete{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (todayId && todayId.length) {
        dic[@"date_str"] = todayId;
    }
    NSMutableArray *sortArr = [NSMutableArray new];
    if (listArr.count > 0) {
        if ([listArr.firstObject isKindOfClass:[NSString class]]) {
            [sortArr addObjectsFromArray:listArr];
        }else if ([listArr.firstObject isKindOfClass:[RRCMatchLeagueModel class]]){
            for (NSInteger i = 0; i < listArr.count; i++) {
                RRCMatchLeagueModel *legueModel = listArr[i];
                if ([legueModel.isSelect intValue] == 1) {
                    [sortArr addObject:kSafeString(legueModel.league)];
                }
            }
        }else{
            
        }
    }
    dic[@"leaguelist"] = sortArr;
    NSString *requestUrl = RRCJcMatchList;
    if (matchType == 0) {
        requestUrl = RRCJcMatchList;
    }else if (matchType == 1) {
        requestUrl = RRCPostRecommendYP;
    }else if (matchType == 2){
        requestUrl = RRCPostRecommendLQ;
    }
    [[RRCNetWorkManager sharedTool] loadRequestWithURLString:requestUrl parameters:dic success:^(CGDataResult * _Nonnull result) {
        if (result.status.boolValue) {
            NSDictionary *dic = result.data;
            NSArray *ori_arr = [RRCMatchInfoModel mj_objectArrayWithKeyValuesArray:dic];
            NSArray *arr = [self loadMatchData:ori_arr];
            complete(arr,YES,result.code);
        }else{
            complete(@[],NO,result.code);
            [[RRCAlertManager sharedRRCAlertManager] showPostingWithtitle:result.errorMsg];
        }
    }];
}

#pragma mark - 赛事增删改查
-(void)saveOnceMatchInfoByMatchListModelArr:(NSArray *)matchList andComplete:(LoadDataArrayBOOLIntegerBlockResult)complete{
    
    NSMutableDictionary *mutabDict = [NSMutableDictionary dictionaryWithDictionary:@{@"datalist":matchList}];
    [[RRCNetWorkManager sharedTool]loadRequestWithURLString:RRCSaveGameDraft parameters:mutabDict success:^(CGDataResult * _Nonnull result) {
        if (result.status.boolValue) {
            NSArray *arr = [RRCTodayModel mj_objectArrayWithKeyValuesArray:result.data];
            complete(arr,YES,result.code);
        }else{
            [[RRCAlertManager sharedRRCAlertManager] showPostingWithtitle:result.errorMsg];
            complete(@[],NO,result.code);
        }
    }];
}

-(void)loadOnceRecommendedMatch:(NSDictionary *)paramter andComplete:(LoadDataArrayBOOLIntegerBlockResult)complete{
    [[RRCNetWorkManager sharedTool] loadRequestWithURLString:RRCGetGameDraft parameters:paramter success:^(CGDataResult * _Nonnull result) {
        NSMutableArray *data_draft_arr = [NSMutableArray new];
        if (result.status.boolValue) {//成功
            NSArray *new_draft_arr = [self handMatchInfo:result.data];
            [data_draft_arr addObjectsFromArray:new_draft_arr];
            complete(data_draft_arr,result.status.boolValue,result.code);
        }else{
            complete(data_draft_arr,result.status.boolValue,result.code);
            [[RRCAlertManager sharedRRCAlertManager] showPostingWithtitle:result.errorMsg];
        }
    }];
}

-(void)loadOnceMatchRuleForSend:(NSDictionary *)paramter andComplete:(LoadMatchBlockGraftData)complete{
    [[RRCNetWorkManager sharedTool]loadRequestWithURLString:RRCMatchRuleForSend parameters:paramter success:^(CGDataResult * _Nonnull result) {
        if (result.status.boolValue) {
            RRCPostDraftModel *draftModel = [RRCPostDraftModel mj_objectWithKeyValues:result.data];
            complete(draftModel);
        }
    }];
}

-(void)deleteMatchInfo:(NSString *)matchtype andByRaftId:(NSString *)RaftId andComplete:(loadDataBOOLBlock)complete{
    if (!matchtype) {
        return;
    }
    if (!RaftId) {
        return;
    }
    NSMutableDictionary *mutabDict = [[NSMutableDictionary alloc] initWithDictionary:@{@"game_type":matchtype,@"id":RaftId}];
    [[RRCNetWorkManager sharedTool]loadRequestWithURLString:RRCDeleteGame parameters:mutabDict success:^(CGDataResult * _Nonnull result) {
        if (result.status.boolValue) {
             complete(YES);
        }else{
            complete(NO);
            [[RRCAlertManager sharedRRCAlertManager] showPostingWithtitle:result.errorMsg];
        }
    }];

}

-(NSArray *)handleTogetherStringDataByMatch:(NSArray *)arr{
    NSMutableArray *mutabArr = [NSMutableArray array];
    for (RRCMatchInfoModel *model in arr) {
        if ([model.jc_yz_wjspl_checked intValue] == 0 && [model.jc_yz_hjspl_checked intValue] == 0 && [model.game_type intValue] == 0 && [model.jc_yz_hjspl_checked intValue] == 0 && [model.jc_yz_wjspl_checked intValue] == 0) {
            [mutabArr addObject:[self getSubmit:model]];
        }
    }
    return mutabArr.copy;
}

-(NSDictionary *)getSubmit:(RRCMatchInfoModel *)infoModel{
    NSDictionary *uploadDicts = nil;
    if ([infoModel.game_type intValue] == 0) {
        uploadDicts = @{@"game_type":@"0",@"ID_bet007":kSafeString(infoModel.ID_bet007),@"sf_sf0":kSafeString(infoModel.sf_sf0),@"sf_sf0_checked":kSafeString(infoModel.sf_sf0_checked),@"sf_sf1":kSafeString(infoModel.sf_sf1),@"sf_sf1_checked":kSafeString(infoModel.sf_sf1_checked),@"sf_sf3":kSafeString(infoModel.sf_sf3),@"sf_sf3_checked":kSafeString(infoModel.sf_sf3_checked),@"rq_rq0":kSafeString(infoModel.rq_rq0),@"rq_rq0_checked":kSafeString(infoModel.rq_rq0_checked),@"rq_rq1":kSafeString(infoModel.rq_rq1),@"rq_rq1_checked":kSafeString(infoModel.rq_rq1_checked),@"rq_rq3":kSafeString(infoModel.rq_rq3),@"rq_rq3_checked":kSafeString(infoModel.rq_rq3_checked),@"jc_yz_hjspl_checked":kSafeString(infoModel.jc_yz_hjspl_checked),@"jc_yz_hjspl":kSafeString(infoModel.jc_yz_hjspl),@"jc_yz_wjspl":kSafeString(infoModel.jc_yz_wjspl),@"jc_yz_wjspl_checked":kSafeString(infoModel.jc_yz_wjspl_checked),@"jc_yz_jspk":kSafeString(infoModel.jc_yz_jspk)};
    }else if ([infoModel.game_type intValue] == 1){
        uploadDicts = @{@"game_type":@"1",@"ID_bet007":kSafeString(infoModel.ID_bet007),@"spf_sf0":kSafeString(infoModel.spf_sf0),@"spf_sf0_checked":kSafeString(infoModel.spf_sf0_checked),@"spf_sf1":kSafeString(infoModel.spf_sf1),@"spf_sf1_checked":kSafeString(infoModel.spf_sf1_checked),@"spf_sf3":kSafeString(infoModel.spf_sf3),@"spf_sf3_checked":kSafeString(infoModel.spf_sf3_checked),@"bd_yz_jspk":kSafeString(infoModel.bd_yz_jspk),@"bd_yz_hjspl_checked":kSafeString(infoModel.bd_yz_hjspl_checked),@"bd_yz_hjspl":kSafeString(infoModel.bd_yz_hjspl),@"bd_yz_wjspl":kSafeString(infoModel.bd_yz_wjspl),@"bd_yz_wjspl_checked":kSafeString(infoModel.bd_yz_wjspl_checked)};
    }else if ([infoModel.game_type intValue] == 3){
        uploadDicts = @{@"game_type":@"3",@"ID_bet007":kSafeString(infoModel.ID_bet007),
                        @"RFHJSPL_checked":kSafeString(infoModel.RFHJSPL_checked),
                        @"RFWJSPL_checked":kSafeString(infoModel.RFWJSPL_checked),
                        @"DXQHJSPL_checked":kSafeString(infoModel.DXQHJSPL_checked),
                        @"DXQWJSPL_checked":kSafeString(infoModel.DXQWJSPL_checked),
                        @"RFJSPK":kSafeString(infoModel.RFJSPK),
                        @"RFHJSPL":kSafeString(infoModel.RFHJSPL),
                        @"DXQJSPK":kSafeString(infoModel.DXQJSPK),
                        @"DXQHJSPL":kSafeString(infoModel.DXQHJSPL),
                        @"DXQWJSPL":kSafeString(infoModel.DXQWJSPL),
                        @"RFWJSPL":kSafeString(infoModel.RFWJSPL)
                        };
        
    }else if ([infoModel.game_type integerValue] == 4){
        uploadDicts = @{@"game_type":@"4",@"ID_bet007":kSafeString(infoModel.ID_bet007),
                        @"bd_yz_hjspl_checked":kSafeString(infoModel.bd_yz_hjspl_checked),
                        @"bd_yz_wjspl_checked":kSafeString(infoModel.bd_yz_wjspl_checked),
                        @"dxq_hjspl_checked":@(infoModel.dxq_hjspl_checked),
                        @"dxq_wjspl_checked":@(infoModel.dxq_wjspl_checked),
                        @"bd_yz_hjspl":kSafeString(infoModel.bd_yz_hjspl),
                        @"bd_yz_wjspl":kSafeString(infoModel.bd_yz_wjspl),
                        @"dxq_hjspl":kSafeString(infoModel.dxq_hjspl),
                        @"dxq_wjspl":kSafeString(infoModel.dxq_wjspl),
                        @"bd_yz_jspk":kSafeString(infoModel.bd_yz_jspk),
                        @"dxq_jspk":kSafeString(infoModel.dxq_jspk),
                        };
    }
    return uploadDicts;
}


#pragma mark - 赛事购物车
//是否能插入赛事
-(BOOL)boolInsertMatchInfoResult{
    
    return [self.matchModel.matchsShopNum integerValue] < self.matchModel.matchsShopMaxNum;
}
-(BOOL)boolInsertMatchInfoBy:(RRCMatchInfoModel *)matchInfoModel{
    __block BOOL isAddCar = NO;//是否添加进购物车
    [self.matchModel.matchsShopCarArr enumerateObjectsUsingBlock:^(RRCMatchInfoModel  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.ID_bet007 isEqualToString:matchInfoModel.ID_bet007] && [obj.game_type isEqualToString:matchInfoModel.game_type]) {
            isAddCar = YES;
        }
    }];
    return [self.matchModel.matchsShopNum integerValue] < self.matchModel.matchsShopMaxNum || isAddCar;
}
-(void)handleInserMatchInfo:(RRCMatchInfoModel *)matchInfoModel{
    NSInteger sf_rq_allNum = matchInfoModel.sf_goal_CheckNum + matchInfoModel.rq_goal_CheckNum;
    
    //竞彩也需要这些数据
    if ([matchInfoModel.jc_yz_wjspl_checked integerValue] || [matchInfoModel.jc_yz_hjspl_checked integerValue]) {
        sf_rq_allNum ++;
    }
    
    if ([matchInfoModel.bd_yz_hjspl_checked integerValue] || [matchInfoModel.bd_yz_wjspl_checked integerValue]) {
        sf_rq_allNum ++;
    }
    
    if ([matchInfoModel.match_type integerValue] == 1) {
    }else  if ([matchInfoModel.match_type integerValue] == 2) {
        //检测篮球
        if ([matchInfoModel.RFHJSPL_checked integerValue] || [matchInfoModel.RFWJSPL_checked integerValue]) {
            sf_rq_allNum ++;
        }
        if ([matchInfoModel.DXQHJSPL_checked integerValue] || [matchInfoModel.DXQWJSPL_checked integerValue]) {
            sf_rq_allNum ++;
        }
    }else if ([matchInfoModel.match_type integerValue] == 3){
        if ([matchInfoModel.bd_yz_hjspl_checked integerValue] || [matchInfoModel.bd_yz_wjspl_checked integerValue]) {
            sf_rq_allNum ++;
        }
        if (matchInfoModel.dxq_hjspl_checked || matchInfoModel.dxq_wjspl_checked) {
            sf_rq_allNum ++;
        }
    }
    
    __block BOOL isAddCar = NO;//是否添加进购物车
    __block NSInteger carIndex = 0;//购物车位置
    [self.matchModel.matchsShopCarArr enumerateObjectsUsingBlock:^(RRCMatchInfoModel  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.ID_bet007 isEqualToString:matchInfoModel.ID_bet007] && [obj.match_type isEqualToString:matchInfoModel.match_type]) {
            isAddCar = YES;
            carIndex = idx;
        }
    }];
    
    if (sf_rq_allNum == 0) {
        if (isAddCar) {
            NSLog(@"已经添加了，应该移除");
            [self.matchModel.matchsShopCarArr removeObjectAtIndex:carIndex];
        }
        //        [self.matchModel.matchsShopCarArr removeObject:matchInfoModel];
    }else if (sf_rq_allNum > 0){
        //不含的情况+1
        if (!isAddCar) {
            NSLog(@"添加成功");
            [self.matchModel.matchsShopCarArr addObject:matchInfoModel];
        }else{
            [self.matchModel.matchsShopCarArr replaceObjectAtIndex:carIndex withObject:matchInfoModel];
            NSLog(@"赛事购物车已经有了此次比赛");
        }
    }else{
        
    }
    
    //将赛事按照时间 排序
    //将赛事按照比赛ID排序
    
    NSSortDescriptor *sort1 = [NSSortDescriptor sortDescriptorWithKey:@"MatchTimeStamp" ascending:YES];
    
    NSSortDescriptor *sort2 = [NSSortDescriptor sortDescriptorWithKey:@"matchId" ascending:YES];
    [self.matchModel.matchsShopCarArr sortUsingDescriptors:[NSArray arrayWithObjects:sort1,sort2, nil]];
    
    self.matchModel.matchsShopNum = [NSString stringWithFormat:@"%ld",self.matchModel.matchsShopCarArr.count];
    
    //购物车数据改变
    self.matchModel.shopCarArrIsUpdate = YES;
    self.matchModel.showCarIsConfirm   = NO;
}
-(void)deleteShopCarMatchInfo:(RRCMatchInfoModel *)matchInfoModel andLoadDeleteResult:(loadDataBOOLBlock)complte{
    if ([self.matchModel.matchsShopCarArr containsObject:matchInfoModel]) {
        //1、因为引用关系，删除之后先把数据重置
        [self resetMatchInfoData:matchInfoModel];
        //2、移除数据
        [self.matchModel.matchsShopCarArr removeObject:matchInfoModel];
        
        self.matchModel.matchsShopNum = [NSString stringWithFormat:@"%ld",self.matchModel.matchsShopCarArr.count];
        self.matchModel.shopCarArrIsUpdate = YES;
        self.matchModel.showCarIsConfirm   = NO;
        complte(YES);
    }else{
        complte(NO);
    }
}
-(NSMutableArray *)updateMatchinfoListByShopCarArrWithOriMatchInfo:(NSMutableArray *)matchArr{
    
    //1、当购物车存在
    [matchArr enumerateObjectsUsingBlock:^(RRCMatchModel *  _Nonnull matchModel, NSUInteger idx, BOOL * _Nonnull stop) {
        
        RRCMatchInfoModel *obj = matchModel.matchArr.firstObject;
        
        [self.matchModel.matchsShopCarArr enumerateObjectsUsingBlock:^(RRCMatchInfoModel * _Nonnull matchInfoModel, NSUInteger idx, BOOL * _Nonnull stop) {
            
            //2、更新列表
            if ([obj.ID_bet007 isEqualToString:matchInfoModel.ID_bet007] && [obj.game_type isEqualToString:matchInfoModel.game_type]) {
                [self updateMatchInfoData:obj andNewMatchInfo:matchInfoModel];
            }
        }];
        
    }];
    
    
    return matchArr;
}
#pragma mark - 处理赛事数据
-(NSMutableArray *)loadMatchData:(NSArray *)originalDataArr{
    NSMutableArray *handleArr = [NSMutableArray new];
    for (NSInteger i = 0; i < originalDataArr.count; i++) {
        RRCMatchInfoModel *ori_matchInfo = originalDataArr[i];
        //更新状态
        RRCMatchModel *matchModel = [[RRCMatchModel alloc]init];
        CGFloat allHeightChart = 0;
        if ([ori_matchInfo.match_type integerValue] == 3) {
            allHeightChart = 96 * Device_Ccale + 48 * Device_Ccale;
        }else if ([ori_matchInfo.match_type integerValue] == 2) {
            allHeightChart = 96 * Device_Ccale + 48 * Device_Ccale;
        }else if ([ori_matchInfo.match_type integerValue] == 1) {
            allHeightChart = 96 * Device_Ccale + 32 * Device_Ccale;
        }else{
            allHeightChart = 144 * Device_Ccale + 32 * Device_Ccale;
        }
        matchModel.heightChart = allHeightChart;
        matchModel.heightTitleChart = allHeightChart + 16 * Device_Ccale;
        matchModel.matchArr = @[ori_matchInfo];//单场
        [handleArr addObject:matchModel];
    }
    return handleArr;
}
-(NSMutableArray *)handMatchInfo:(NSArray *)data_arr{
    NSMutableArray *data_draft_arr = [NSMutableArray new];
    for (NSInteger i = 0; i < data_arr.count; i++) {
        NSDictionary *data_dic = data_arr[i];
        if ([data_dic valueForKey:@"remark"]) {
            //串子数据
            RRCMatchModel *match_Model = [RRCMatchModel mj_objectWithKeyValues:data_dic];
            NSArray *updateArr = [self loadMatchTogetherRaftData:@[match_Model]];
            [data_draft_arr addObjectsFromArray:updateArr];
        }else{
            RRCMatchInfoModel *matchInfo_Model = [RRCMatchInfoModel mj_objectWithKeyValues:data_dic];
            NSArray *updateArr = [self loadMatchRaftData:@[matchInfo_Model]];
            [data_draft_arr addObjectsFromArray:updateArr];
        }
    }
    return data_draft_arr;
}

-(CGFloat)chartHeight:(RRCMatchInfoModel *)matchInfo{
    CGFloat allHeightChart = 0;
    if (matchInfo.matchPlayMethod.count == 1) {
        allHeightChart = 64 * Device_Ccale;
    }else if (matchInfo.matchPlayMethod.count == 2){
        //两种类别，判断是否包含胜平负
        if (matchInfo.matchOdds.count == 2) {
            if ([matchInfo.matchPlayMethod containsObject:matchInfo.yz_desc]) {
                allHeightChart = 88 * Device_Ccale;
            }else{
                allHeightChart = 76 * Device_Ccale;
            }
        }else if(matchInfo.matchOdds.count == 3){
            allHeightChart = 109 * Device_Ccale;
        }
    }else if (matchInfo.matchPlayMethod.count == 3){
        allHeightChart = 120 * Device_Ccale;
    }
    return allHeightChart;
}

//获取每块单元的高度
//#pragma mark -表格高度
//-(CGFloat)chartViewItemHeightWithMatchInfo:(RRCMatchInfoModel *)matchInfoModel andByRow:(NSInteger)row andByColum:(NSInteger)column andTitleTag:(NSString *)titleTag andItemHeight:(CGFloat)itemHeight{
//    //传入当前比赛 以及所用字段
//    NSInteger matchPlayMethodCount = matchInfoModel.matchPlayMethod.count;//类别数量
//    NSInteger matchOddsCount       = matchInfoModel.matchOdds.count;//类别选项
//    
//    CGFloat itemPerHeight = 0;//单元表格高度
//    if (column == 2) {
//        if ([matchInfoModel.matchPlayMethod containsObject:matchInfoModel.yz_desc]) {
//            if (matchOddsCount == 2) {
//                itemPerHeight = itemHeight/2;
//            }else{
//                //3个类别
//                if (matchPlayMethodCount == 2 && ![titleTag isEqualToString:matchInfoModel.yz_desc]) {
//                    itemPerHeight = 64 * Device_Ccale;
//                }else{
//                    if ([titleTag isEqualToString:@"胜平负"]) {
//                        itemPerHeight = 32 * Device_Ccale;
//                    }else{
//                        itemPerHeight = 44 * Device_Ccale;
//                    }
//                }
//            }
//        }else{
//            if ([titleTag isEqualToString:@"胜平负"]) {
//                itemPerHeight = 32 * Device_Ccale;
//            }else{
//                itemPerHeight = 44 * Device_Ccale;
//            }
//            
//        }
//    }
//    else if (column == 3){
//        //高度类型 32 44 64
//        if (matchOddsCount == 1) {
//            itemPerHeight = itemHeight;
//        }else if (matchOddsCount == 2){
//            if ([matchInfoModel.matchPlayMethod containsObject:matchInfoModel.yz_desc]) {
//                itemPerHeight = itemHeight/2;
//            }else{
//                //观察胜所在的位置，类别两 不包含亚指
//                if (matchPlayMethodCount == 1) {
//                    itemPerHeight = 32 * Device_Ccale;
//                }else if (matchPlayMethodCount == 2) {
//                    if (row == 0) {//胜
//                        itemPerHeight = 32 * Device_Ccale;
//                    }else{
//                        itemPerHeight = 44 * Device_Ccale;
//                    }
//                }else{
//                    if (matchPlayMethodCount == 1) {
//                        if (row == 0) {//胜
//                             itemPerHeight = 32 * Device_Ccale;
//                        }else{
//                             itemPerHeight = 44 * Device_Ccale;
//                        }
//                       
//                    }else{
//                        itemPerHeight = itemHeight - 32 * Device_Ccale;
//                        if (itemPerHeight >= 44) {
//                            itemPerHeight = 44 * Device_Ccale;
//                        }
//                    }
//                }
//            }
//        }else{
//            if (matchPlayMethodCount == 2) {
//                if ([titleTag containsString:kSafeString(matchInfoModel.jc_yz_hjspl_str)] || [titleTag containsString:kSafeString(matchInfoModel.jc_yz_wjspl_str)] || [titleTag containsString:kSafeString(matchInfoModel.bd_yz_hjspl_str)] || [titleTag containsString:kSafeString(matchInfoModel.bd_yz_wjspl_str)]) {
//                    itemPerHeight = 44 * Device_Ccale;
//                }else{
//                    itemPerHeight = 32 * Device_Ccale;
//                }
//            }else{
//                //类别三种
//                if (row == 0) {
//                    itemPerHeight = 32 * Device_Ccale;
//                }else{
//                    itemPerHeight = 44 * Device_Ccale;
//                }
//            }
//        }
//    }
//    else if(column == 4){
//        if (matchOddsCount == 1) {
//            itemPerHeight = itemHeight;
//        }else if (matchOddsCount == 2){
//            if ([matchInfoModel.matchPlayMethod containsObject:matchInfoModel.yz_desc]) {
//                itemPerHeight = itemHeight/2;
//            }else{
//                //观察胜所在的位置，类别两 不包含亚指
//                if (matchOddsCount == matchPlayMethodCount && row == 0) {
//                    itemPerHeight = 32 * Device_Ccale;
//                }else{
//                    if (matchPlayMethodCount == 1) {
//                        itemPerHeight = itemHeight;
//                    }else{
//                        itemPerHeight = itemHeight - 32 * Device_Ccale;
//                        if (itemPerHeight >= 44) {
//                            itemPerHeight = 44 * Device_Ccale;
//                        }
//                    }
//                }
//            }
//        }else{
//            //                类别三种
//            if (row == 0) {
//                if (matchPlayMethodCount == 3) {
//                    itemPerHeight = 76 * Device_Ccale;
//                }else{
//                    itemPerHeight = 64 * Device_Ccale;
//                }
//            }else{
//                itemPerHeight = 44 * Device_Ccale;
//            }
//        }
//    }
//    
//    return itemPerHeight;
//    
//}

#pragma mark - 私有方法
-(NSArray *)loadMatchTogetherRaftData:(NSArray *)originalDataArr{
    NSMutableArray *handleArr = [NSMutableArray new];
    //    strandList 串子数据
    for (NSInteger i = 0; i < originalDataArr.count; i++) {
        RRCMatchModel *matchModel = originalDataArr[i];
        NSMutableArray *matchToArr = [NSMutableArray new];
        NSMutableArray *matchHeightArr = [NSMutableArray new];
        NSMutableArray *matchTopArr = [NSMutableArray new];
        CGFloat allHeightChart = 0;
        for (NSInteger j = 0; j < matchModel.matchArr.count; j++) {
            RRCMatchInfoModel *match_info_model = [self handlMatchInfoData:matchModel.matchArr[j]];
            [matchToArr addObject:match_info_model];
            CGFloat heightChart = [self chartHeight:match_info_model];
            allHeightChart += heightChart;
            [matchHeightArr addObject:@(heightChart)];
            if (match_info_model.matchPlayMethod.count == 1) {
                [matchTopArr addObject:@(8 * Device_Ccale)];
            }else{
                [matchTopArr addObject:@(14 * Device_Ccale)];
            }
            
        }
        //计算高度
        //        NSLog(@"------%f",allHeightChart);
        matchModel.heightChart = allHeightChart;//串子
        matchModel.matchHeightArr = matchHeightArr;
        matchModel.matchTopArr = matchTopArr;
        if (allHeightChart != 0) {
            matchModel.heightTitleChart = allHeightChart + 32 * Device_Ccale + 44 * Device_Ccale;
        }
        matchModel.isTogetherMatch = YES;
        //        NSLog(@"------%f",matchModel.heightTitleChart);
        matchModel.matchArr = matchToArr;
        [handleArr addObject:matchModel];
    }
    return handleArr;
}
//处理单场数据
-(NSArray *)loadMatchRaftData:(NSArray *)originalDataArr{
    NSMutableArray *handleArr = [NSMutableArray new];
    //    strandList 串子数据
    for (NSInteger i = 0; i < originalDataArr.count; i++) {
        //        RRCMatchInfoModel *ori_matchInfo = originalDataArr[i];
        RRCMatchInfoModel *matchInfo = [self handlMatchInfoData:originalDataArr[i]];
        
        RRCMatchModel *matchModel = [[RRCMatchModel alloc]init];
        //        //计算所需要的高度
        CGFloat allHeightChart = [self chartHeight:matchInfo];
        matchModel.heightChart = allHeightChart;//
        matchModel.heightTitleChart = 44 * Device_Ccale + 32 * Device_Ccale + matchModel.heightChart;//单场所需要展示高度 |
        matchModel.matchArr = @[matchInfo];//单场
        matchModel.game_type = matchInfo.game_type;
        matchModel.ID        = matchInfo.ID;
        [handleArr addObject:matchModel];
    }
    return handleArr;
}
#pragma mark -赛事结果序列化
-(RRCMatchInfoModel *)resetMatchInfoData:(RRCMatchInfoModel *)ori_matchInfo{
    ori_matchInfo.rq_rq0_checked = @"0";
    ori_matchInfo.rq_rq1_checked = @"0";
    ori_matchInfo.rq_rq3_checked = @"0";
    
    ori_matchInfo.sf_sf0_checked = @"0";
    ori_matchInfo.sf_sf1_checked = @"0";
    ori_matchInfo.sf_sf3_checked = @"0";
    
    ori_matchInfo.jc_yz_hjspl_checked = @"0";
    ori_matchInfo.jc_yz_wjspl_checked = @"0";
    
    //北单数据
    ori_matchInfo.spf_sf0_checked  = @"0";
    ori_matchInfo.spf_sf1_checked  = @"0";
    ori_matchInfo.spf_sf3_checked  = @"0";
    
    ori_matchInfo.bd_yz_hjspl_checked  = @"0";
    ori_matchInfo.bd_yz_wjspl_checked  = @"0";
    
    ori_matchInfo.rq_rq0_checked_gui = @"0";
    ori_matchInfo.rq_rq1_checked_gui = @"0";
    ori_matchInfo.rq_rq3_checked_gui = @"0";
    //
    ori_matchInfo.sf_sf0_checked_gui = @"0";
    ori_matchInfo.sf_sf1_checked_gui = @"0";
    ori_matchInfo.sf_sf3_checked_gui = @"0";
    
    
    ori_matchInfo.rq_goal_CheckNum = 0;
    ori_matchInfo.sf_goal_CheckNum = 0;
    
    //篮球
    ori_matchInfo.RFHJSPL_checked = @"0";
    ori_matchInfo.RFWJSPL_checked = @"0";
    
    ori_matchInfo.DXQHJSPL_checked = @"0";
    ori_matchInfo.DXQHJSPL_checked = @"0";
    //足球亚指
    ori_matchInfo.dxq_hjspl_checked = 0;
    ori_matchInfo.dxq_wjspl_checked = 0;
    
    return ori_matchInfo;
}
-(RRCMatchInfoModel *)updateMatchInfoData:(RRCMatchInfoModel *)ori_matchInfo andNewMatchInfo:(RRCMatchInfoModel *)newMatchInfo{
    //仅仅修改状态
    ori_matchInfo.rq_rq0_checked = newMatchInfo.rq_rq0_checked;
    ori_matchInfo.rq_rq1_checked = newMatchInfo.rq_rq1_checked;
    ori_matchInfo.rq_rq3_checked = newMatchInfo.rq_rq3_checked;
    
    ori_matchInfo.sf_sf0_checked = newMatchInfo.sf_sf0_checked;
    ori_matchInfo.sf_sf1_checked = newMatchInfo.sf_sf1_checked;
    ori_matchInfo.sf_sf3_checked = newMatchInfo.sf_sf3_checked;
    
    ori_matchInfo.jc_yz_hjspl_checked = newMatchInfo.jc_yz_hjspl_checked;
    ori_matchInfo.jc_yz_wjspl_checked = newMatchInfo.jc_yz_wjspl_checked;
    
    //北单数据
    ori_matchInfo.spf_sf0_checked  = newMatchInfo.spf_sf0_checked;
    ori_matchInfo.spf_sf1_checked  = newMatchInfo.spf_sf1_checked;
    ori_matchInfo.spf_sf3_checked  = newMatchInfo.spf_sf3_checked;
    
    ori_matchInfo.bd_yz_hjspl_checked  = newMatchInfo.bd_yz_hjspl_checked;
    ori_matchInfo.bd_yz_wjspl_checked  = newMatchInfo.bd_yz_wjspl_checked;
    
    ori_matchInfo.rq_rq0_checked_gui = newMatchInfo.rq_rq0_checked_gui;
    ori_matchInfo.rq_rq1_checked_gui = newMatchInfo.rq_rq1_checked_gui;
    ori_matchInfo.rq_rq3_checked_gui = newMatchInfo.rq_rq3_checked_gui;

    ori_matchInfo.sf_sf0_checked_gui = newMatchInfo.sf_sf0_checked_gui;
    ori_matchInfo.sf_sf1_checked_gui = newMatchInfo.sf_sf1_checked_gui;
    ori_matchInfo.sf_sf3_checked_gui = newMatchInfo.sf_sf3_checked_gui;
    
    
    ori_matchInfo.sf_sf0_flag = newMatchInfo.sf_sf0_flag;
    ori_matchInfo.sf_sf1_flag = newMatchInfo.sf_sf1_flag;
    ori_matchInfo.sf_sf3_flag = newMatchInfo.sf_sf3_flag;
    
    ori_matchInfo.rq_rq0_checked = newMatchInfo.rq_rq0_checked;
    ori_matchInfo.rq_rq1_checked = newMatchInfo.rq_rq1_checked;
    ori_matchInfo.rq_rq3_checked = newMatchInfo.rq_rq3_checked;
    
    ori_matchInfo.jc_yz_hjspl_flag = newMatchInfo.jc_yz_hjspl_flag;
    ori_matchInfo.jc_yz_wjspl_flag = newMatchInfo.jc_yz_wjspl_flag;
    
    ori_matchInfo.bd_yz_hjspl_flag = newMatchInfo.bd_yz_hjspl_flag;
    ori_matchInfo.bd_yz_wjspl_flag = newMatchInfo.bd_yz_wjspl_flag;
    
    ori_matchInfo.rq_goal_CheckNum = newMatchInfo.rq_goal_CheckNum;
    ori_matchInfo.sf_goal_CheckNum = newMatchInfo.sf_goal_CheckNum;
    return ori_matchInfo;
}
#pragma mark -序列号网络端的赛事数据
-(RRCMatchInfoModel *)handlMatchInfoData:(RRCMatchInfoModel *)ori_matchInfo{
    //处理之后的数据
    ori_matchInfo.matchId = ori_matchInfo.matchId;
    ori_matchInfo.matchTime = [NSString stringWithFormat:@"%@|%@",ori_matchInfo.match_time1,ori_matchInfo.match_time2];

    //、有赛果
    NSMutableArray *playMethod = [NSMutableArray new];//类别
    NSMutableArray *oddArr = [NSMutableArray new];//比赛选项筛选
    NSMutableArray *matchStateArr = [NSMutableArray new];

    ori_matchInfo.matchBallName = ori_matchInfo.letball;
    
    //测试擅长展示
//    ori_matchInfo.goodAt = 1;
    
    if ([ori_matchInfo.state isEqualToString:@"-1"]) {
        ori_matchInfo.matchMember = [NSString stringWithFormat:@"%@|%@:%@|%@|%ld",ori_matchInfo.home,ori_matchInfo.homeScore,ori_matchInfo.awayScore,ori_matchInfo.away,ori_matchInfo.goodAt];
    }else{
        ori_matchInfo.matchMember = [NSString stringWithFormat:@"%@|%@|%@|%ld",ori_matchInfo.home,@"VS",ori_matchInfo.away,ori_matchInfo.goodAt];
    }
    
    ori_matchInfo.matchName = ori_matchInfo.matchName;
    
    //改写开发数据
    //    state 赛事 夭折，
    
    if ([ori_matchInfo.sf_sf0_checked integerValue] || [ori_matchInfo.sf_sf1_checked integerValue] || [ori_matchInfo.sf_sf3_checked integerValue]) {
        [playMethod addObject:@"胜平负"];
        ori_matchInfo.matchResultsImage = [self imageNameByResult:ori_matchInfo.rq_sf_result];
        [matchStateArr addObject:ori_matchInfo.matchResultsImage];
        
        
        if ([ori_matchInfo.sf_sf3_checked integerValue]) {
            [oddArr addObject:[NSString stringWithFormat:@"胜%@|%@",ori_matchInfo.sf_sf3,ori_matchInfo.sf_sf3_red]];
        }
        if ([ori_matchInfo.sf_sf1_checked integerValue]) {
            [oddArr addObject:[NSString stringWithFormat:@"平%@|%@",ori_matchInfo.sf_sf1,ori_matchInfo.sf_sf1_red]];
        }
        
        if ([ori_matchInfo.sf_sf0_checked integerValue]) {
            [oddArr addObject:[NSString stringWithFormat:@"负%@|%@",ori_matchInfo.sf_sf0,ori_matchInfo.sf_sf0_red]];
        }
    }
    
    if ([ori_matchInfo.rq_rq0_checked integerValue] || [ori_matchInfo.rq_rq1_checked integerValue] || [ori_matchInfo.rq_rq3_checked integerValue]) {
        [playMethod addObject:[NSString stringWithFormat:@"让球（%@）胜平负",ori_matchInfo.rq_goal]];
        ori_matchInfo.matchResultsImage = [self imageNameByResult:ori_matchInfo.rq_sf_result];
        
        //如果胜平负的赛事结果已经加进，但是结果为 黑（判断此次结果） 红（过滤不加） 取消（过滤不加），走水（过滤不加）
        if (matchStateArr.count == 0) {
            [matchStateArr addObject:ori_matchInfo.matchResultsImage];
//            [matchStateArr addObject:@"取消"];
        }else if (matchStateArr.count == 1) {
            if ([matchStateArr[0] isEqualToString:@"黑"]) {
                [matchStateArr replaceObjectAtIndex:0 withObject:ori_matchInfo.matchResultsImage];
            }else{
                //已经有红，就不做处理
            }

        }
        
        if ([ori_matchInfo.rq_rq3_checked integerValue]) {
            [oddArr addObject:[NSString stringWithFormat:@"胜%@|%@",ori_matchInfo.rq_rq3,ori_matchInfo.rq_rq3_red]];
        }
        if ([ori_matchInfo.rq_rq1_checked integerValue]) {
            [oddArr addObject:[NSString stringWithFormat:@"平%@|%@",ori_matchInfo.rq_rq1,ori_matchInfo.rq_rq1_red]];
        }
        if ([ori_matchInfo.rq_rq0_checked integerValue]) {
            [oddArr addObject:[NSString stringWithFormat:@"负%@|%@",ori_matchInfo.rq_rq0,ori_matchInfo.rq_rq0_red]];
        }
    }
    
    if ([ori_matchInfo.jc_yz_hjspl_checked integerValue] || [ori_matchInfo.jc_yz_wjspl_checked integerValue]) {
        if (ori_matchInfo.yz_desc) {
            [playMethod addObject:ori_matchInfo.yz_desc];
        }else{
            [playMethod addObject:@"亚指"];
        }
        ori_matchInfo.matchResultsImage = [self imageNameByResult:ori_matchInfo.jc_yz_result];
        [matchStateArr addObject:ori_matchInfo.matchResultsImage];
        if ([ori_matchInfo.jc_yz_hjspl_checked integerValue]) {
            [oddArr addObject:[NSString stringWithFormat:@"%@\n@%@|%@",ori_matchInfo.jc_yz_hjspl_str,ori_matchInfo.jc_yz_hjspl,ori_matchInfo.jc_yz_hjspl_red]];
        }
        if ([ori_matchInfo.jc_yz_wjspl_checked integerValue]) {
            [oddArr addObject:[NSString stringWithFormat:@"%@\n@%@|%@",ori_matchInfo.jc_yz_wjspl_str,ori_matchInfo.jc_yz_wjspl,ori_matchInfo.jc_yz_wjspl_red]];
        }
    }
    
    //处理北单
    if ([ori_matchInfo.spf_sf0_checked integerValue] || [ori_matchInfo.spf_sf1_checked integerValue] || [ori_matchInfo.spf_sf3_checked integerValue]) {
        if ([ori_matchInfo.spf_goal integerValue]) {
            [playMethod addObject:[NSString stringWithFormat:@"让球（%@）胜平负",ori_matchInfo.spf_goal]];
        }else{
            [playMethod addObject:@"胜平负"];
        }
        ori_matchInfo.matchResultsImage = [self imageNameByResult:ori_matchInfo.spf_result];
        [matchStateArr addObject:ori_matchInfo.matchResultsImage];
        if ([ori_matchInfo.spf_sf3_checked integerValue]) {
            [oddArr addObject:[NSString stringWithFormat:@"胜%@|%@",ori_matchInfo.spf_sf3,ori_matchInfo.spf_sf3_red]];
        }
        if ([ori_matchInfo.spf_sf1_checked integerValue]) {
            [oddArr addObject:[NSString stringWithFormat:@"平%@|%@",ori_matchInfo.spf_sf1,ori_matchInfo.spf_sf1_red]];
        }
        if ([ori_matchInfo.spf_sf0_checked integerValue]) {
            [oddArr addObject:[NSString stringWithFormat:@"负%@|%@",ori_matchInfo.spf_sf0,ori_matchInfo.spf_sf0_red]];
        }
    }
    
    if ([ori_matchInfo.bd_yz_hjspl_checked integerValue] || [ori_matchInfo.bd_yz_wjspl_checked integerValue]) {
        if (ori_matchInfo.yz_desc) {
            [playMethod addObject:ori_matchInfo.yz_desc];
        }else{
            [playMethod addObject:@"亚指"];
        }
        ori_matchInfo.matchResultsImage = [self imageNameByResult:ori_matchInfo.bd_yz_result];
        [matchStateArr addObject:ori_matchInfo.matchResultsImage];
        if ([ori_matchInfo.bd_yz_hjspl_checked integerValue]) {
            [oddArr addObject:[NSString stringWithFormat:@"%@\n@%@|%@",ori_matchInfo.bd_yz_hjspl_str,ori_matchInfo.bd_yz_hjspl,ori_matchInfo.bd_yz_hjspl_red]];
        }
        if ([ori_matchInfo.bd_yz_wjspl_checked integerValue]) {
            [oddArr addObject:[NSString stringWithFormat:@"%@\n@%@|%@",ori_matchInfo.bd_yz_wjspl_str,ori_matchInfo.bd_yz_wjspl,ori_matchInfo.bd_yz_wjspl_red]];
        }
    }
    
    //篮球亚指
    if ([ori_matchInfo.RFHJSPL_checked integerValue] || [ori_matchInfo.RFWJSPL_checked integerValue]) {
        if (ori_matchInfo.yz_desc) {
            [playMethod addObject:ori_matchInfo.yz_desc];
        }else{
            [playMethod addObject:@"亚指"];
        }
        ori_matchInfo.matchResultsImage = [self imageNameByResult:ori_matchInfo.RF_result];
        [matchStateArr addObject:ori_matchInfo.matchResultsImage];
        if ([ori_matchInfo.RFHJSPL_checked integerValue]) {
            [oddArr addObject:[NSString stringWithFormat:@"%@\n@%@|%@",ori_matchInfo.RFHJSPL_str,ori_matchInfo.RFHJSPL,ori_matchInfo.RFHJSPL_red]];
        }
        if ([ori_matchInfo.RFWJSPL_checked integerValue]) {
            [oddArr addObject:[NSString stringWithFormat:@"%@\n@%@|%@",ori_matchInfo.RFWJSPL_str,ori_matchInfo.RFWJSPL,ori_matchInfo.RFWJSPL_red]];
        }
    }
    //篮球大小分
    if ([ori_matchInfo.DXQHJSPL_checked integerValue] || [ori_matchInfo.DXQWJSPL_checked integerValue]) {
        if (ori_matchInfo.yz_desc) {
            [playMethod addObject:ori_matchInfo.dxf_desc];
        }else{
            [playMethod addObject:@"亚指"];
        }
        ori_matchInfo.matchResultsImage = [self imageNameByResult:ori_matchInfo.DXQ_result];
        [matchStateArr addObject:ori_matchInfo.matchResultsImage];
        if ([ori_matchInfo.DXQHJSPL_checked integerValue]) {
            [oddArr addObject:[NSString stringWithFormat:@"%@\n@%@|%@",ori_matchInfo.DXQHJSPL_str,ori_matchInfo.DXQHJSPL,ori_matchInfo.DXQHJSPL_red]];
        }
        if ([ori_matchInfo.DXQWJSPL_checked integerValue]) {
            [oddArr addObject:[NSString stringWithFormat:@"%@\n@%@|%@",ori_matchInfo.DXQWJSPL_str,ori_matchInfo.DXQWJSPL,ori_matchInfo.DXQWJSPL_red]];
        }
    }
    
    ori_matchInfo.matchPlayMethod = playMethod;
    ori_matchInfo.matchOdds = oddArr;
    ori_matchInfo.matchStateArr = matchStateArr;
    if ([ori_matchInfo.game_type integerValue] == 1) {
        
    }else if ([ori_matchInfo.game_type integerValue] == 2){
        
    }else if ([ori_matchInfo.game_type integerValue] == 3){
        
    }else if ([ori_matchInfo.game_type integerValue] == 4) {//这是亚指的类别
        RRCBallStateEdit *balEdit = [[RRCBallStateEdit alloc]initWithType:RRCBallType_YaPanBall];
        //2、处理亚指的赛事
        [balEdit sortBallPlayMathodMatchInfo:ori_matchInfo];
    }
    
    
    return ori_matchInfo;
}
-(NSString *)imageNameByResult:(NSString *)result{
    RRCBallModel *ballResult = [[RRCBallModel alloc]init];
    return [ballResult imageNameByResult:result];
}
@end

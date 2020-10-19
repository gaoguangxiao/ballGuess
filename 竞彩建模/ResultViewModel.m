//
//  ResultViewModel.m
//  竞彩建模
//
//  Created by gaoguangxiao on 2020/6/8.
//  Copyright © 2020 renrencai. All rights reserved.
//

#import "ResultViewModel.h"
#import "ResultModel.h"
#import "RRCLeaguesModel.h"
#import "RRCMatchRateModel.h"
#import "GGXMatchInfo.h"
#import <MJExtension.h>
#import "RRCNetWorkManager.h"
#import "YBColorConfigure.h"
#import "RRCDeviceConfigure.h"
@interface ResultViewModel ()

//@property (nonatomic,assign)float dxqRedCount;//大小球红的个数
//@property (nonatomic,assign)float yzRedCount; //盘口红的个数
//@property (nonatomic,assign)float jcRedCount; //竞彩红的个数
//@property (nonatomic,assign)float allCount;//总个数
@end

@implementation ResultViewModel

-(void)requestDataWithParameters:(NSDictionary *)parameters andComplete:(void (^)(NSArray * _Nonnull, BOOL))blockList{
    
    //
    //    http://120.27.24.112:9118/getMatchData
    [[RRCNetWorkManager sharedTool]loadRequestWithURLString:@"getMatchData" parameters:parameters success:^(CGDataResult * _Nonnull result) {
        
        if (result.status.boolValue) {
            [self.listArray removeAllObjects];
            
            GGXMatchInfo *m = [GGXMatchInfo mj_objectWithKeyValues:result.data];
            [self handleScoreWithData:m];
            
            //            NSString *path = [[NSBundle mainBundle]pathForResource:@"matchInfo" ofType:@"json"];
            //            NSData *data = [[NSData alloc] initWithContentsOfFile:path];
            //            //    对数据进行JSON格式化并返回字典形式
            //            NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            //
            //            for (NSInteger i = 0; i < array.count; i++) {
            //                GGXMatchInfo *m = [GGXMatchInfo mj_objectWithKeyValues:array[i]];
            //                [self handleScoreWithData:m];
            //            }
            
        }
        blockList(self.listArray,YES);
    }];
    
}

#pragma mark - 查询多个赛事
-(void)requestMultipleDataWithParameters:(NSDictionary *)parameters andLocalArr:(NSArray *)locaArray andComplete:(loadDataBOOLBlock)blockList{
    
    //返回多个请求的结果
    [[RRCNetWorkManager sharedTool]loadRequestWithURLString:@"getMatchDataArr" parameters:parameters success:^(CGDataResult * _Nonnull result) {
        
        if (result.status.boolValue) {
            
            NSArray *array = [GGXMatchInfo mj_objectArrayWithKeyValuesArray:result.data];
            
            NSMutableArray *queryList = [[NSMutableArray alloc]init];
            
            NSArray *queryWaterArray = locaArray;
            
            for (NSInteger i = 0; i < array.count; i++) {
                GGXMatchInfo *m = [GGXMatchInfo mj_objectWithKeyValues:array[i]];
                
                ResultModel *resultModel = [self onlyHandleScoreWithData:m];
                
                if (queryWaterArray.count == locaArray.count) {
                    ResultModel *waterModel = queryWaterArray[i];
                    resultModel.yp_spk = waterModel.yp_spk;
                    resultModel.yp_xpk = waterModel.yp_xpk;
                    resultModel.dxq_dpk = waterModel.dxq_dpk;
                    resultModel.dxq_xpk = waterModel.dxq_xpk;
                    
                    [queryList addObject:resultModel];
                }
                
            }
            
            //查询失败
            if (queryList.count == 0) {
                
                blockList(NO);
            }
            
            //进行赛事记录保存
            for (NSInteger i = 0;i < queryList.count;i++) {
                
                ResultModel *re = queryList[i];
                
                //计算完成保存此次赛事
                NSMutableDictionary *dict = [NSMutableDictionary new];
                dict[@"home"] = re.home;
                dict[@"away"] = re.away;
                dict[@"hhmm"] = re.hhmm;
                dict[@"mmdd"] = re.mmdd;
                dict[@"league"] = re.league;
                dict[@"home_score_weight"] = [NSString stringWithFormat:@"%.2f",re.homeProportion];
                dict[@"away_score_weight"] = [NSString stringWithFormat:@"%.2f",re.awayProportion];
                
                dict[@"forecast_home_score"] = [NSString stringWithFormat:@"%.2f",re.homeCompositeScore];
                dict[@"forecast_away_score"] = [NSString stringWithFormat:@"%.2f",re.awayCompositeScore];
                
                dict[@"forecast_ball_num"] = [NSString stringWithFormat:@"%.2f",re.allCompositeScore];
                dict[@"dxq_pk"] = re.companyBigSmallNumber;
                dict[@"dxq_dpk"] = re.dxq_dpk;
                dict[@"dxq_xpk"] = re.dxq_xpk;
                dict[@"yp_spk"] = re.yp_spk;
                dict[@"yp_xpk"] = re.yp_xpk;
                dict[@"yp_pk"] = @(re.companyYazhiNumber);
                dict[@"match_id"] = re.match_id;
                
                [self saveMatchListWithParameters:dict Complete:^(BOOL isEnd) {
                    
                    if (i == queryList.count - 1) {
                        
                        blockList(YES);
                        
                    }
                    
                }];
            }
            
        }
        
    }];
    
}
-(void)testModelComplete:(nonnull LoadDataArrayIntegerBlock)blockList{
    //测试脚本
    NSString *path = [[NSBundle mainBundle]pathForResource:@"matchInfo" ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    //    对数据进行JSON格式化并返回字典形式
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    for (NSInteger i = 0; i < array.count; i++) {
        GGXMatchInfo *m = [GGXMatchInfo mj_objectWithKeyValues:array[i]];
        [self handleScoreWithData:m];
    }
    
    //    NSString *dxqRedRate = [NSString stringWithFormat:@"%.2f%%",self.dxqRedCount/self.allCount * 100];
    //    NSString *yzRedRate = [NSString stringWithFormat:@"%.2f%%",self.yzRedCount/self.allCount * 100];
    
    //    self.dxqRateText = [NSString stringWithFormat:@"%@",dxqRedRate];
    //    self.yzRateText  = [NSString stringWithFormat:@"%@",yzRedRate];
    
    blockList(self.listArray,YES);
}

#pragma mark - 联赛筛选
-(void)previewMatchListLeagueWithParameters:(NSDictionary *)parameters Complete:(nonnull LoadDataArrayIntegerBlock)blockList{
    [[RRCNetWorkManager sharedTool]loadRequestWithURLString:@"getAllMatch" parameters:parameters success:^(CGDataResult * _Nonnull result) {
        
        //整合相同联赛
        NSMutableArray *leagueArray = [NSMutableArray new];
        if (result.status.boolValue) {
            
            NSArray *array = result.data;
            //10场
            NSInteger count = array.count;
            
            for (NSInteger i = 0; i < count; i++) {
                
                GGXMatchInfo *m = [GGXMatchInfo mj_objectWithKeyValues:array[i]];
                
                ResultModel *m_r = [self handleOnlyEndScoreWithData:m];
                
                BOOL isconstain = NO;
                RRCLeaguesModel *lastLeagueModel;
                for (RRCLeaguesModel *league_M in leagueArray) {
                    //相等说明，包含
                    if ([league_M.name isEqualToString:m_r.league]) {
                        isconstain = YES;
                        lastLeagueModel = league_M;
                    }
                    
                }
                
                if (isconstain) {
                    [lastLeagueModel.leagueList addObject:m_r];
                    lastLeagueModel.counts ++;
                }else{
                    RRCLeaguesModel *leagueModel = [RRCLeaguesModel new];
                    leagueModel.name = m_r.league;
                    leagueModel.counts = 1;
                    leagueModel.leagueList = [NSMutableArray new];
                    
                    [leagueModel.leagueList addObject:m_r];
                    
                    [leagueArray addObject:leagueModel];
                }
                
            }
            
        }
        
        
        //处理联赛命中率
        for (NSInteger i = 0; i < leagueArray.count; i++) {
            
            RRCLeaguesModel *leModel = leagueArray[i];
            
            //某联赛数量
            float dxqSortRedCount = 0;
            float yzSortRedCount  = 0;
            float scoreSortRedCount = 0;
            float jcSortRedCount = 0;
            
            float sortAllCount = 0;
            //循环处理某联赛
            for (NSInteger i = 0; i < leModel.leagueList.count; i++) {
                
                ResultModel *m = leModel.leagueList[i];
                if ([m.status integerValue] == 1) {
                    if ([m.finishBigSuc integerValue] == 1) {
                        dxqSortRedCount ++;
                    }
                    if ([m.finishYazhiSuc integerValue] == 1) {
                        yzSortRedCount ++;
                    }
                    if ([m.finishScoreSuc integerValue] == 1) {
                        scoreSortRedCount ++;
                    }
                    if ([m.finishWinSuc integerValue] == 1 || m.finishWinSSuc.integerValue == 1) {
                        jcSortRedCount ++;
                    }
                    sortAllCount ++;
                }
            }
            
            float tempDxqRate =  dxqSortRedCount/sortAllCount * 100;
            float tempYzRate =  yzSortRedCount/sortAllCount * 100;
            float tempJcRate =  jcSortRedCount/sortAllCount * 100;
            
            leModel.dxqRate = [NSString stringWithFormat:@"%.2f%%",dxqSortRedCount/sortAllCount * 100];
            leModel.yzRate  = [NSString stringWithFormat:@"%.2f%%",yzSortRedCount/sortAllCount * 100];
            leModel.bdRate  = [NSString stringWithFormat:@"%.2f%%",scoreSortRedCount/sortAllCount* 100];
            leModel.jcRate  = [NSString stringWithFormat:@"%.2f%%",jcSortRedCount/sortAllCount * 100];
            // 联赛超过五次，其中某项胜率大于70%
            //【4次以上】 1、某项80%以上 2、双70% 3、单项65% 4、双60%
            if (sortAllCount >= 4) {
                leModel.isRecommend = 1;
                
                //很低了
                leModel.recommendViewColor = @"#FFFFFFF";
                leModel.recommendWeight = 1;
                
                //最低的
                if (tempDxqRate >= 60 && tempYzRate >= 60){
                    leModel.recommendWeight = 2;
                    leModel.recommendViewColor = @"#FDD7DF";
                }
                
                if (tempDxqRate >= 65 || tempYzRate > 65) {
                    leModel.recommendWeight = 3;
                    leModel.recommendViewColor = @"#FD98AF";
                }
                
                if (tempDxqRate >= 70 && tempYzRate >= 70) {
                    leModel.recommendWeight = 4;
                    leModel.recommendViewColor = @"#FD4C74";
                }
                
                if (tempDxqRate >= 80 || tempYzRate >= 80 || tempJcRate >= 80) {
                    leModel.recommendWeight = 5;
                    leModel.recommendViewColor = @"#FD053D";
                }
                
            }else{
                //场次不够
                leModel.isRecommend = 0;
                leModel.recommendWeight = 0;
                leModel.recommendViewColor = @"#4B0082";
                
            }
            
            //倒序
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"recommendWeight" ascending:NO];//
            // 设置排序优先级，并组成数组。这里优先级最高为commentI
            [leagueArray sortUsingDescriptors:@[sortDescriptor]];
        }
        blockList(leagueArray,YES);
    }];
    
}

#pragma mark - 日期筛选
-(void)previewDateListLeagueWithParameters:(NSDictionary *)parameters Complete:(nonnull LoadDataArrayIntegerBlock)blockList{
    [[RRCNetWorkManager sharedTool]loadRequestWithURLString:@"getAllMatch" parameters:parameters success:^(CGDataResult * _Nonnull result) {
        
        //整合同一天
        NSMutableArray *dateMatchArray = [NSMutableArray new];
        
        __block float finishMoney = 0;
        
        if (result.status.boolValue) {
            
            NSArray *array = result.data;
            //10场
            NSInteger count = array.count;
            
            for (NSInteger i = 0; i < count; i++) {
                
                GGXMatchInfo *m = [GGXMatchInfo mj_objectWithKeyValues:array[i]];
                
                ResultModel *m_r = [self handleOnlyEndScoreWithData:m];
                
                BOOL isconstain = NO;
                RRCMatchRateModel *lastMatchRateModel;
                for (RRCMatchRateModel *date_M in dateMatchArray) {
                    //相等说明，包含
                    if ([date_M.mmdd isEqualToString:m_r.mmdd]) {
                        isconstain = YES;
                        lastMatchRateModel = date_M;
                    }
                    
                }
                
                if (isconstain) {
                    [lastMatchRateModel.dateMartchList addObject:m_r];
                    lastMatchRateModel.counts ++;
                }else{
                    RRCMatchRateModel *dateMatchModel = [RRCMatchRateModel new];
                    dateMatchModel.mmdd = m_r.mmdd;
                    dateMatchModel.counts = 1;
                    dateMatchModel.dateMartchList = [NSMutableArray new];
                    
                    [dateMatchModel.dateMartchList addObject:m_r];
                    
                    [dateMatchArray addObject:dateMatchModel];
                }
                
            }
            
            
            for (NSInteger i = 0; i < dateMatchArray.count; i++) {
                
                RRCMatchRateModel *leModel = dateMatchArray[dateMatchArray.count - i - 1];
                //循环处理某联赛
                    NSArray *m = leModel.dateMartchList;
                    
                    [self sortMatchLeagueWithParameters:m Complete:^(NSArray * _Nonnull loadArr) {
                        
                        NSString *dxqRateText = loadArr[1];
                        NSString *yzRateText  = loadArr[2];
                        NSString *bdRateText  = loadArr[3];
                        NSString *jcRateText  = loadArr[4];
                        NSString *moneyRateText  = loadArr[5];
                        leModel.dxqRate = dxqRateText;
                        leModel.yzRate = yzRateText;
                        leModel.bdRate = bdRateText;
                        leModel.jcRate = jcRateText;
                        leModel.dxqYzRate = moneyRateText;
                        
                        finishMoney += moneyRateText.floatValue;
                        NSLog(@"盈利笔%f、%@",finishMoney,moneyRateText);
//                        blockList(self.listArray,YES);
                    }];
            }
            
        }
    
     blockList(dateMatchArray,finishMoney);
}];

}

#pragma mark -列表预览
-(void)previewMatchListWithParameters:(NSDictionary *)parameters Complete:(nonnull LoadDataArrayIntegerBlock)blockList{
    
    [[RRCNetWorkManager sharedTool]loadRequestWithURLString:@"getAllMatch" parameters:parameters success:^(CGDataResult * _Nonnull result) {
        
        if (result.status.boolValue) {
            
            [self.listArray removeAllObjects];
            
            NSArray *array = result.data;
            //10场
            NSInteger count = array.count;
            
            for (NSInteger i = 0; i < count; i++) {
                GGXMatchInfo *matchInfo= [GGXMatchInfo mj_objectWithKeyValues:array[i]];
                
                ResultModel *m = [self handleOnlyEndScoreWithData:matchInfo];
                
                [self.listArray addObject:m];
            }
            
            
            //整理赛事胜率
            [self sortMatchLeagueWithParameters:self.listArray Complete:^(NSArray * _Nonnull loadArr) {
                blockList(self.listArray,YES);
            }];
        }
        
    }];
    
}

#pragma mark - 查询赛事胜率
-(void)sortMatchLeagueWithParameters:(NSArray *)parameters Complete:(nonnull LoadDataArrayBlock)blockList{
    
    float dxqSortRedCount = 0;
    float yzSortRedCount  = 0;
    float scoreSortRedCount = 0;
    float jcSortRedCount = 0;
    
    float sortAllCount = 0;
    //原始数据，赛前下注，如果进行了，没下注就需要删除。每天最多12场。一场接一场
//    NSArray *submitMoneyArr = @[@"10",@"20",@"60",@"180",@"540",@"1620",@"4860",@"14580",@"43740"];//最大支持八连黑 总资金65600元
//    NSArray *submitMoneyArr = @[@"100",@"200",@"300",@"600",@"900",@"1500",@"2500",@"4000",@"6500"];//最大支持八连黑 总资金16600。
//    NSArray *submitMoneyArr = @[@"150",@"250",@"500",@"600",@"1000",@"1500",@"2000",@"2000",@"2000"];//最大支持八连黑 总资金10000。
    NSArray *submitMoneyArr = @[@"100",@"100",@"100",@"100",@"100",@"100",@"100",@"100",@"100"];//最大支持八连黑 总资金1000。
    
    //设置注量模式
    NSInteger rateMoneyIndex = [KUserDefault(@"RateMoneyArr") integerValue];
    if (rateMoneyIndex == 0) {
        submitMoneyArr = @[@"100",@"100",@"100",@"100",@"100",@"100",@"100",@"100",@"100"];//均注 本金：1000
    }else if(rateMoneyIndex == 1){//总金额十分之一投注 700一个档次
//        本金200 均注200/4 = 50 * 10 = 500。
//        本金700 均注700/10 = 70 * 10 = 700
//        本金1400 均注1400/10 = 140 * 10 = 1400
//        本金2800 均注2800/10 = 280 * 10 = 2800
//        NSInteger winMoney = 0;
//        if (winMoney%700 == 0) {
//            NSInteger submitMoney = winMoney/700;//900
//        }
        submitMoneyArr = @[@"100",@"200",@"600",@"1800",@"5400",@"16200",@"48600",@"145800",@"437400"];//最大支持八连黑 总资金65600元
    }else if(rateMoneyIndex == 2){
        submitMoneyArr = @[@"25",@"50",@"150",@"450",@"1350",@"4050",@"12150",@"36450",@"109350"];//最大支持八连黑 总资金10000。
    }else if(rateMoneyIndex == 3){
        submitMoneyArr = @[@"10",@"20",@"60",@"180",@"540",@"1620",@"4860",@"14580",@"43740"];//最大支持八连黑 总资金65600元
    }
    
    ResultModel *lastResultModel;//
    
    NSInteger dxqRedCount = 0;//负数为黑 0为次数抵消 正数1为连红
    NSInteger yzRedCount = 0;//负数为黑 0为次数抵消 正数1为连红
    
    //大小球盈利每场盈利
    float dxqRemainPoint  = 0;//盈利点数 单位1
    float yzRemainPoint  = 0;
    
    float benjinMoney = 2000;//2000
    
    for (NSInteger i = 0; i < parameters.count; i++) {
        
        ResultModel *m = parameters[parameters.count - i - 1];
        
        if ([m.status integerValue] == 1) {
            //1、上场比赛是否黑。如果黑了，那么本场翻倍。而本场下注倍数根据黑的场数计算。把本场 黑红次数保存下来，下场用于计算
            //2、上场比赛是否红。如果红了，那么本场均注。值为1
            //3、没有上场比赛，本场均注
            
            //初始赔率
            NSString *firstMoney = submitMoneyArr.firstObject;
            //新场次大小球
            NSString *firstDxqRedMoney = [NSString stringWithFormat:@"%.2f",[firstMoney integerValue] * m.finishBigDif.floatValue];
            //新场次亚指
            NSString *firstYzRedMoney = [NSString stringWithFormat:@"%.2f",[firstMoney integerValue] * m.finishYazhiDif.floatValue];
            
            if (lastResultModel) {
                
                //大小球倍投统计
                if (dxqRedCount >= 0) {//上场比赛红了
                    m.finishBigMoney = firstMoney;
                    if (m.finishBigSuc.integerValue == 1) {//本场红了
                        dxqSortRedCount ++;
                        dxqRedCount = 1;
                        dxqRemainPoint += firstDxqRedMoney.floatValue;//
//                        NSLog(@"大小球本次盈利指数：%@",firstDxqRedMoney);
                    }else if (m.finishBigSuc.integerValue == 0){//本场黑了
                        dxqRedCount = -1;
                        dxqRemainPoint -= firstMoney.floatValue;
//                        NSLog(@"大小球本次盈利指数：-%@",firstMoney);
                    }
                    
                }
                else{//上场黑了
                    NSInteger submitMoneyIndex = labs(dxqRedCount);
                    NSString *dxqRedNextMoney = [NSString stringWithFormat:@"%.2f",[submitMoneyArr[submitMoneyIndex] integerValue] * m.finishBigDif.floatValue];
                    NSString *dxqBlackNextMoney = submitMoneyArr[submitMoneyIndex];
                    m.finishBigMoney = [NSString stringWithFormat:@"%@",submitMoneyArr[submitMoneyIndex]];
                    
                    //-1：投注额为，索引第二位置
                    //-2为连黑两场，那么投注额为索引第三位置
                    if (m.finishBigSuc.integerValue == 1) {//本场红了
                        dxqSortRedCount ++;
                        dxqRedCount = 1;
                        dxqRemainPoint += dxqRedNextMoney.floatValue;
//                        NSLog(@"大小球本次盈利指数：%@",dxqRedNextMoney);
                    }else if (m.finishBigSuc.integerValue == 0){//本场黑了
                        dxqRedCount -= 1;
                        dxqRemainPoint -= dxqBlackNextMoney.floatValue;
//                        NSLog(@"大小球本次盈利指数：-%@",dxqBlackNextMoney);
                    }
                    
                }
                
                //亚指倍投统计
                if (yzRedCount >= 0) {//上场比赛红了
                    if (m.finishYazhiSuc.integerValue == 1) {//本场红了
                        yzSortRedCount ++;
                        yzRedCount = 1;
                        yzRemainPoint += firstYzRedMoney.floatValue;
//                        NSLog(@"亚指本次盈利指数：%@,总盈利：%f.2",firstYzRedMoney,yzRemainPoint);
                    }else if (m.finishYazhiSuc.integerValue == 0){//本场黑了
                        yzRedCount = -1;
                        yzRemainPoint -= firstMoney.floatValue;
//                        NSLog(@"亚指本次盈利指数：-%@,总盈利：%f.2",firstMoney,yzRemainPoint);
                    }
                    m.finishYazhiMoney = firstMoney;
                }
                else{//上场黑了
                    NSInteger submitMoneyIndex = labs(yzRedCount);
                    
                    NSString *yzRedNextMoney = [NSString stringWithFormat:@"%.2f",[submitMoneyArr[submitMoneyIndex] integerValue] * m.finishYazhiDif.floatValue];
                    NSString *yzBlackNextMoney = submitMoneyArr[submitMoneyIndex];
                    m.finishYazhiMoney = yzBlackNextMoney;
                    //-1：投注额为，索引第二位置
                    //-2为连黑两场，那么投注额为索引第三位置
                    if (m.finishYazhiSuc.integerValue == 1) {//本场红了
                        yzSortRedCount ++;
                        yzRedCount = 1;
                        yzRemainPoint += yzRedNextMoney.floatValue;
//                        NSLog(@"亚指本次盈利指数：%@,总盈利：%f.2",yzRedNextMoney,yzRemainPoint);
                    }else if (m.finishYazhiSuc.integerValue == 0){//本场黑了
                        yzRedCount -= 1;
                        yzRemainPoint -= yzBlackNextMoney.floatValue;
//                        NSLog(@"亚指本次盈利指数：-%@,总盈利：%f.2",yzBlackNextMoney,yzRemainPoint);
                    }
                    
                }
                
                
            }
            else{
                //没有上场比赛
                if (m.finishBigSuc.integerValue == 1) {//本场红了
                    dxqSortRedCount ++;
                    dxqRedCount = 1;
                    dxqRemainPoint += firstDxqRedMoney.floatValue;
//                    NSLog(@"大小球本次盈利指数：%@",firstDxqRedMoney);
                }else if (m.finishBigSuc.integerValue == 0){//本场黑了
                    dxqRedCount = -1;
                    dxqRemainPoint -= firstMoney.floatValue;
//                    NSLog(@"大小球本次盈利指数：-%@",firstMoney);
                }
                m.finishBigMoney = firstMoney;
                
                //亚指倍投统计
                if (m.finishYazhiSuc.integerValue == 1) {//本场红了
                    yzSortRedCount ++;
                    yzRedCount = 1;
                    yzRemainPoint += firstYzRedMoney.floatValue;
//                    NSLog(@"亚指本次盈利指数：%@,总盈利：%f.2",firstYzRedMoney,yzRemainPoint);
                }else if (m.finishYazhiSuc.integerValue == 0){//本场黑了
                    yzRedCount = -1;
                    yzRemainPoint -= firstMoney.floatValue;
//                    NSLog(@"亚指本次盈利指数：-%@,总盈利：%f.2",firstMoney,yzRemainPoint);
                }
                m.finishYazhiMoney = firstMoney;
            }
            
            if ([m.finishScoreSuc integerValue] == 1) {
                scoreSortRedCount ++;
            }
            
            if ([m.finishWinSuc integerValue] == 1 || m.finishWinSSuc.integerValue == 1) {
                jcSortRedCount ++;
            }
            sortAllCount ++;
            
            
            lastResultModel = m;//保存下次
            
            float remainM = benjinMoney + dxqRemainPoint + yzRemainPoint;
            m.benjinMoney = [NSString stringWithFormat:@"%.2f",remainM];
        }
        else{
            //建议倍投额
            if (dxqRedCount >= 0) {//上场比赛红了
                m.finishBigMoney = [NSString stringWithFormat:@"%@",submitMoneyArr.firstObject];
            }else{//上场黑了
                NSInteger submitMoneyIndex = labs(dxqRedCount);
                m.finishBigMoney = [NSString stringWithFormat:@"%@",submitMoneyArr[submitMoneyIndex]];
            }
            
            //建议亚指倍投额
            if (yzRedCount >= 0) {//上场比赛红了
                m.finishYazhiMoney = [NSString stringWithFormat:@"%@",submitMoneyArr.firstObject];
            }else{//上场黑了
                NSInteger submitMoneyIndex = labs(yzRedCount);
                m.finishYazhiMoney = [NSString stringWithFormat:@"%@",submitMoneyArr[submitMoneyIndex]];
            }
        }
        
    }
    //100注 60%胜率 200 * 100 * (60% * 0.85 - 1 + 60%) = 盈利百分比 60 * 200 * 0.85 - 40 * 200
    
    self.dxqRateText = [NSString stringWithFormat:@"%.0f场%.2f%%【%.f】",sortAllCount,dxqSortRedCount/sortAllCount * 100,dxqRemainPoint];
    self.yzRateText  = [NSString stringWithFormat:@"%.0f场%.2f%%【%.f】",sortAllCount,yzSortRedCount/sortAllCount * 100,yzRemainPoint];
    self.bdRateText  = [NSString stringWithFormat:@"%.2f%%",scoreSortRedCount/sortAllCount* 100];
    self.yzdxqRRateText = [NSString stringWithFormat:@"%@",@(dxqRemainPoint + yzRemainPoint)];
    self.jcRateText  = [NSString stringWithFormat:@"%.2f%%",jcSortRedCount/sortAllCount * 100];
    self.matchRateCount = [NSString stringWithFormat:@"%.0f",sortAllCount];
    blockList(@[parameters,self.dxqRateText,self.yzRateText,self.bdRateText,self.jcRateText,@(dxqRemainPoint + yzRemainPoint),@(sortAllCount)]);//6
    
}


-(void)previewLoadMoreMatchListWithParameters:(NSDictionary *)parameters Complete:(nonnull LoadDataArrayIntegerBlock)blockList{
    
    [[RRCNetWorkManager sharedTool]loadRequestWithURLString:@"getMatch" parameters:parameters success:^(CGDataResult * _Nonnull result) {
        
        if (result.status.boolValue) {
            
            NSArray *array = result.data;
            
            for (NSInteger i = 0; i < array.count; i++) {
                GGXMatchInfo *m = [GGXMatchInfo mj_objectWithKeyValues:array[i]];
                [self handleEndScoreWithData:m];
            }
            
            NSString *dxqForecast = [NSString stringWithFormat:@"%@",kSafeString(result.originalData[@"dxq_forecast_rate"])];
            NSString *ypForecast = [NSString stringWithFormat:@"%@",kSafeString(result.originalData[@"yp_forecast_rate"])];
            NSString *scoreForecast = [NSString stringWithFormat:@"%@",kSafeString(result.originalData[@"score_forecast_rate"])];
            
            self.dxqRateText = [NSString stringWithFormat:@"%.2f%%",[dxqForecast floatValue] * 100];
            self.yzRateText  = [NSString stringWithFormat:@"%.2f%%",[ypForecast floatValue] * 100];
            self.bdRateText  = [NSString stringWithFormat:@"%.2f%%",[scoreForecast floatValue] * 100];
            
            //            NSString *dxqRedRate = [NSString stringWithFormat:@"%.2f%%",self.dxqRedCount/self.allCount * 100];
            //            NSString *yzRedRate = [NSString stringWithFormat:@"%.2f%%",self.yzRedCount/self.allCount * 100];
            //            float yzRedRate  = self.yzRedCount/self.allCount;
            //            self.dxqRateText = [NSString stringWithFormat:@"%@ ：%@",self.dxqRateText,dxqRedRate];
            //            self.dxqRateText = [NSString stringWithFormat:@"%@:%@",self.dxqRateText,dxqRedRate];
            //            self.yzRateText  = [NSString stringWithFormat:@"%@:%@",self.yzRateText,yzRedRate];
            
            //            NSLog(@"当前大小球胜率：%@、亚指胜率：%@、总个数：%f",dxqRedRate,yzRedRate,self.allCount);
        }
        blockList(self.listArray,result.extraInfo.is_last_page);
    }];
    
}

-(void)saveMatchListWithParameters:(NSDictionary *)parameters Complete:(nonnull loadDataBOOLBlock)blockList{
    
    [[RRCNetWorkManager sharedTool]loadRequestWithURLString:@"saveMatch" parameters:parameters success:^(CGDataResult * _Nonnull result) {
        
        if (result.status.boolValue) {
            
            GGXMatchInfo *m = [GGXMatchInfo mj_objectWithKeyValues:result.data];
            
            [self handleScoreWithData:m];
            
        }
        blockList(YES);
    }];
    
}

-(void)deleteMatchListWithParameters:(NSDictionary *)parameters Complete:(nonnull loadDataBOOLBlock)blockList{
    
    [[RRCNetWorkManager sharedTool]loadRequestWithURLString:@"delMatch" parameters:parameters success:^(CGDataResult * _Nonnull result) {
        
        blockList(result.status.boolValue);
        
    }];
    
}

#pragma mark - 预测参数计算
//处理所要查询的
-(ResultModel *)onlyHandleScoreWithData:(GGXMatchInfo *)matchInfo{
    
    ResultModel *scoreModel = [[ResultModel alloc]init];
    scoreModel.match_id = matchInfo.matchId;
    scoreModel.home = matchInfo.home;
    scoreModel.away = matchInfo.away;
    scoreModel.league = matchInfo.league;
    scoreModel.hhmm   = matchInfo.hhmm;
    scoreModel.mmdd   = matchInfo.mmdd;
    scoreModel.homeScore = matchInfo.home_score;
    scoreModel.awayScore = matchInfo.away_score;
    scoreModel.companyBigSmallNumber = matchInfo.companyBigSmallNumber;
    scoreModel.companyYazhiNumber    = matchInfo.companyYazhiNumber;
    //解决赛果问题
    if (scoreModel.homeScore != nil && scoreModel.awayScore != nil) {
        scoreModel.status = @"1";
    }else{
        scoreModel.status = @"0";
        scoreModel.homeScore = @"-";
        scoreModel.awayScore = @"-";
    }
    //一、计算主客队联赛得分
    float allLeagueScore = matchInfo.homeLeagueScore.floatValue + matchInfo.awayLeagueScore.floatValue;
    if (allLeagueScore != 0) {
        scoreModel.homeLeagueScore_pro = matchInfo.homeLeagueScore.floatValue/allLeagueScore;
        scoreModel.awayLeagueScore_pro = 1 - scoreModel.homeLeagueScore_pro;
    }
    
    //二、计算历史战绩得分
    float historyAllScore = matchInfo.homeHistoryScore.floatValue + matchInfo.awayHistoryScore.floatValue;
    scoreModel.homeHistoryScore_pro = matchInfo.homeHistoryScore.floatValue/historyAllScore;
    scoreModel.awayHistoryScore_pro = matchInfo.awayHistoryScore.floatValue/historyAllScore;
    
    //三、计算主客队历史战绩得分
    float allHostHistoryScore = matchInfo.homeHostHistoryScore.floatValue + matchInfo.awayHostHistoryScore.floatValue;
    if (allHostHistoryScore != 0) {
        scoreModel.homeHostHistoryScore_pro = matchInfo.homeHostHistoryScore.floatValue;
        scoreModel.awayHostHistoryScore_pro = matchInfo.awayHostHistoryScore.floatValue/allHostHistoryScore;
    }
    
    //四、计算主客队交锋历史得分【同主客】
    scoreModel.homeHostEncounterScore_pro = matchInfo.homeHostEncounterScore.floatValue;
    scoreModel.homeHostEncounterScore_pro = 1 - scoreModel.homeHostEncounterScore_pro;
    
    //五、计算主客队排名得分
    //    float rangeAllScore = matchInfo.homeRange.floatValue + matchInfo.awayRange.floatValue;
    float homeRangeScore = 0;
    float awayRangeScore = 0;
    
    //得出主客队总得分比例
    float tempHomeProportion = homeRangeScore + scoreModel.homeLeagueScore_pro + scoreModel.homeHistoryScore_pro + scoreModel.homeHostHistoryScore_pro + scoreModel.homeHostEncounterScore_pro;
    
    float tempAwayProportion = awayRangeScore + scoreModel.awayLeagueScore_pro + scoreModel.awayHistoryScore_pro + scoreModel.awayHostHistoryScore_pro + scoreModel.homeHostEncounterScore_pro;
    
    //额外信息增加
    //1、主场优势，百分比增加2%
    //    tempHomeProportion += tempHomeProportion * (1 + 0.02);
    
    float pro = tempHomeProportion + tempAwayProportion;
    
    scoreModel.homeProportion = tempHomeProportion / pro * 100;
    scoreModel.awayProportion = 100 - scoreModel.homeProportion;
    
    float recordEnterBall = (matchInfo.homeEnterCount.floatValue + matchInfo.awayEnterCount.floatValue)/2;
    scoreModel.allCompositeScore = (recordEnterBall + matchInfo.warEnterCount.floatValue)/2;//欠缺计算
    
    //计算主客队所进球数
    scoreModel.homeCompositeScore = scoreModel.homeProportion/100 * scoreModel.allCompositeScore;
    scoreModel.awayCompositeScore = scoreModel.awayProportion/100 * scoreModel.allCompositeScore;
    
    
    scoreModel.bd_home_score = [NSString stringWithFormat:@"%d",(int)scoreModel.homeCompositeScore];;
    scoreModel.bd_away_score = [NSString stringWithFormat:@"%d",(int)scoreModel.awayCompositeScore];
    
    [self handleHomeScoreText:scoreModel];
    
    [self handleScoreText:scoreModel];
    
    [self handleBigSmallText:scoreModel];
    
    [self handleyzJK:scoreModel];
    
    return scoreModel;
}
//处理所要查询的
-(void)handleScoreWithData:(GGXMatchInfo *)matchInfo{
    
    ResultModel *scoreModel = [self onlyHandleScoreWithData:matchInfo];
    
    [self.listArray addObject:scoreModel];
}

#pragma mark - 服务器数据处理
-(void)handleEndScoreWithData:(GGXMatchInfo *)matchInfo{
    
    ResultModel *scoreModel = [self handleOnlyEndScoreWithData:matchInfo];
    
    [self.listArray addObject:scoreModel];
    
}

-(ResultModel *)handleOnlyEndScoreWithData:(GGXMatchInfo *)matchInfo{
    
    ResultModel *scoreModel = [[ResultModel alloc]init];
    scoreModel.match_id = matchInfo.matchId;
    scoreModel.ID       = matchInfo.ID;
    scoreModel.home = matchInfo.home;
    scoreModel.league = matchInfo.league;
    scoreModel.hhmm   = matchInfo.hhmm;
    scoreModel.mmdd   = matchInfo.mmdd;
    scoreModel.dxq_dpk= matchInfo.dxq_dpk;
    scoreModel.dxq_xpk= matchInfo.dxq_xpk;
    scoreModel.yp_spk= matchInfo.yp_spk;
    scoreModel.yp_xpk= matchInfo.yp_xpk;
    scoreModel.homeRange = matchInfo.homeRange;
    scoreModel.awayRange = matchInfo.awayRange;
    scoreModel.bd_home_score = matchInfo.bd_home_score;
    scoreModel.bd_away_score = matchInfo.bd_away_score;
    scoreModel.away = [NSString stringWithFormat:@"%@",matchInfo.away];
    
    scoreModel.homeScore = matchInfo.home_score;
    scoreModel.awayScore = matchInfo.away_score;
    
    //解决赛果问题
    if (scoreModel.homeScore != nil && scoreModel.awayScore != nil) {
        scoreModel.status = @"1";
    }else{
        scoreModel.status = @"0";
        scoreModel.homeScore = @"-";
        scoreModel.awayScore = @"-";
    }
    
    scoreModel.companyBigSmallNumber = matchInfo.dxq_pk;
    scoreModel.companyYazhiNumber    = [matchInfo.yp_pk floatValue];
    
    scoreModel.homeProportion = matchInfo.home_score_weight.floatValue;
    scoreModel.awayProportion = matchInfo.away_score_weight.floatValue;
    
    scoreModel.allCompositeScore = matchInfo.forecast_ball_num.floatValue;
    
    scoreModel.homeCompositeScore = matchInfo.forecast_home_score.floatValue;
    scoreModel.awayCompositeScore = matchInfo.forecast_away_score.floatValue;
    
    //计算胜平负
    [self handleHomeScoreText:scoreModel];
    //计算第二选项胜平负
    [self handleHomeSScoreText:scoreModel];
    
    //计算波胆
    [self handleScoreText:scoreModel];
    //计算大小球
    [self handleBigSmallText:scoreModel];
    //亚指
    [self handleyzJK:scoreModel];
    
    return scoreModel;
}

#pragma mark - 处理文本显示

#pragma mark -计算胜平负
-(void)handleHomeScoreText:(ResultModel *)scoreModel{
    
    float home_wheight = scoreModel.homeCompositeScore - scoreModel.awayCompositeScore;
    if (home_wheight > 0) {
        scoreModel.finishWinText = @"胜";
    }else if (home_wheight == 0){
        scoreModel.finishWinText = @"平";
    }else{
        scoreModel.finishWinText = @"负";
    }
    
    if ([scoreModel.status integerValue]) {
        
        NSInteger home_score_height = scoreModel.homeScore.integerValue - scoreModel.awayScore.integerValue;
        
        if (home_wheight > 0) {
            //胜
            if (home_score_height > 0) {
                scoreModel.finishWinSuc = @"1";
            }else{
                scoreModel.finishWinSuc = @"3";
            }
        }else if (home_wheight == 0){
            //平局
            if (home_score_height == 0) {
                scoreModel.finishWinSuc = @"1";
            }else{
                scoreModel.finishWinSuc = @"3";
            }
        }else{
            if (home_score_height < 0) {
                scoreModel.finishWinSuc = @"1";
            }else{
                scoreModel.finishWinSuc = @"3";
            }
        }
        
    }else{
        
        scoreModel.finishWinSuc = @"-1";
    }
    
    //背景颜色
    if (scoreModel.finishWinSuc.integerValue == 1) {
        
        scoreModel.finishWinViewColor = RRCHighLightTitleColor;
        
    }else if (scoreModel.finishWinSuc.integerValue == 3){
        
        scoreModel.finishWinViewColor = RRCThemeTextColor;
        
    }else{
        scoreModel.finishWinViewColor = RRCGrayTextColor;
        
    }
}

-(void)handleHomeSScoreText:(ResultModel *)scoreModel{
    
    //小数判断
    float home_wheight = scoreModel.homeCompositeScore - scoreModel.awayCompositeScore;
    
    //保持第二选项和第一不一样
    float absFCom = fabsf(scoreModel.companyYazhiNumber);
    if ([scoreModel.finishWinText isEqualToString:@"胜"]) {
        if (home_wheight > 0) {
            //胜平负基础，如果盘口小于0.5，那么为平局
            if (absFCom < 0.5) {
                //平局概率
                home_wheight = 0;
            }else if (absFCom == 0.5){
                //半球生死盘
                home_wheight = -1;//
            }else{
                //0.75以上 默认生死盘
                home_wheight = -1;//
            }
        }
    }else if ([scoreModel.finishWinText isEqualToString:@"平"]){//
        //第二选项也为平局。根据盘口调整，上盘独赢
        if (home_wheight == 0) {
            if (scoreModel.companyYazhiNumber < 0) {//上盘，主队让球，主独赢
                home_wheight = 1;
            }else if(scoreModel.companyYazhiNumber > 0){//客队让球，客独赢
                home_wheight = -1;
            }else{//平手盘 1.23：1.23 1：1。暂时平局优先
                home_wheight = 0;
            }
        }
    }else{
        //负
        if (home_wheight < 0) {
            //胜平负基础，如果盘口小于0.5，那么为平局
            if (absFCom < 0.5) {
                //平局概率
                home_wheight = 0;
            }else if (absFCom == 0.5){
                //半球生死盘
                home_wheight = 1;//
            }else{
                //0.75以上 默认生死盘
                home_wheight = 1;//
            }
        }
    }
    
    if (home_wheight > 0) {
        scoreModel.finishWinSText = @"胜";
    }else if (home_wheight == 0){
        scoreModel.finishWinSText = @"平";
    }else{
        scoreModel.finishWinSText = @"负";
    }
    
    if ([scoreModel.status integerValue]) {
        
        NSInteger home_score_height = scoreModel.homeScore.integerValue - scoreModel.awayScore.integerValue;
        
        if (home_wheight > 0) {
            //胜
            if (home_score_height > 0) {
                scoreModel.finishWinSSuc = @"1";
            }else{
                scoreModel.finishWinSSuc = @"3";
            }
        }else if (home_wheight == 0){
            //平局
            if (home_score_height == 0) {
                scoreModel.finishWinSSuc = @"1";
            }else{
                scoreModel.finishWinSSuc = @"3";
            }
        }else{
            if (home_score_height < 0) {
                scoreModel.finishWinSSuc = @"1";
            }else{
                scoreModel.finishWinSSuc = @"3";
            }
        }
        
    }else{
        
        scoreModel.finishWinSSuc = @"-1";
    }
    
    //背景颜色
    if (scoreModel.finishWinSSuc.integerValue == 1) {
        
        scoreModel.finishWinSViewColor = RRCHighLightTitleColor;
        
    }else if (scoreModel.finishWinSSuc.integerValue == 3){
        
        scoreModel.finishWinSViewColor = RRCThemeTextColor;
        
    }else{
        scoreModel.finishWinSViewColor = RRCGrayTextColor;
        
    }
}
#pragma mark -计算波胆
-(void)handleScoreText:(ResultModel *)scoreModel{
    
    if ([scoreModel.status integerValue]) {
        
        NSInteger home_r = scoreModel.bd_home_score.integerValue - scoreModel.homeScore.integerValue;
        
        NSInteger away_r = scoreModel.bd_away_score.integerValue - [scoreModel.awayScore integerValue];
        
        if (home_r == 0 && away_r == 0) {
            scoreModel.finishScoreSuc = @"1";
        }else{
            scoreModel.finishScoreSuc = @"0";
        }
        
    }else{
        scoreModel.finishScoreSuc = @"-1";
    }
    
    //背景颜色
    if (scoreModel.finishScoreSuc.integerValue == 1) {
        
        scoreModel.finishScoreViewColor = RRCHighLightTitleColor;
        scoreModel.finishScoreImage = [UIImage imageNamed:@"红备份 2"];
    }else if (scoreModel.finishScoreSuc.integerValue == 0){
        
        scoreModel.finishScoreViewColor = RRCThemeTextColor;
        scoreModel.finishScoreImage = [UIImage imageNamed:@"黑备份 2"];
    }else if (scoreModel.finishScoreSuc.integerValue == 2){
        
        scoreModel.finishScoreViewColor = RRC0F9958Color;
        scoreModel.finishScoreImage = [UIImage imageNamed:@"走备份 2"];
    }else{
        scoreModel.finishScoreViewColor = RRCGrayTextColor;
        scoreModel.finishScoreImage = [UIImage imageNamed:@""];
    }
}

#pragma mark -计算大小球
//大小球计算方式
-(void)handleBigSmallText:(ResultModel *)scoreModel{
    
    //大小球结果计算
    float allScoreDif = scoreModel.allCompositeScore - scoreModel.companyBigSmallNumber.floatValue;
    
    scoreModel.finishScoreBigDif = [NSString stringWithFormat:@"%.2f",allScoreDif];
    
    if (allScoreDif > 0) {
        scoreModel.finishBigDif  = [NSString stringWithFormat:@"%.2f",scoreModel.dxq_dpk.floatValue];
        scoreModel.finishBigText = [NSString stringWithFormat:@"%@\n大%.2f\n%@",kSafeString(scoreModel.dxq_dpk),scoreModel.companyBigSmallNumber.floatValue,kSafeString(scoreModel.dxq_xpk)];
        
        if (scoreModel.dxq_dpk.floatValue < scoreModel.dxq_xpk.floatValue) {
            scoreModel.finishBigTextColor = RRCWhiteDarkColor;
        }else{
            scoreModel.finishBigTextColor = RRCFFC60AColor;
        }
        
    }else{
        scoreModel.finishBigDif  = [NSString stringWithFormat:@"%.2f",scoreModel.dxq_xpk.floatValue];
        scoreModel.finishBigText = [NSString stringWithFormat:@" %@\n小%.2f\n%@",kSafeString(scoreModel.dxq_dpk),scoreModel.companyBigSmallNumber.floatValue,kSafeString(scoreModel.dxq_xpk)];
        
        if (scoreModel.dxq_dpk.floatValue > scoreModel.dxq_xpk.floatValue) {
            scoreModel.finishBigTextColor = RRCWhiteDarkColor;
        }else{
            scoreModel.finishBigTextColor = RRCFFC60AColor;
        }
    }
    
    //命中大小球计算
    if ([scoreModel.status integerValue]) {
        float realresults = scoreModel.homeScore.floatValue + scoreModel.awayScore.floatValue - scoreModel.companyBigSmallNumber.floatValue;
        //最终结果相等走水
        if (realresults == 0) {
            scoreModel.finishBigSuc = @"2";
        }else{
            if ((realresults > 0 && allScoreDif > 0)||( realresults < 0 && allScoreDif <= 0)) {
                scoreModel.finishBigSuc = @"1";
                //计算盈利水位，进球为3 盘口开出2.75，赢一半的水位。进球为5盘口5.25
                if (fabsf(realresults) == 0.25) {
                    if (allScoreDif > 0) {
                        scoreModel.finishBigDif  = [NSString stringWithFormat:@"%.2f",scoreModel.dxq_dpk.floatValue * 0.5];
                    }else{
                        scoreModel.finishBigDif  = [NSString stringWithFormat:@"%.2f",scoreModel.dxq_xpk.floatValue * 0.5];
                    }
                }
            }else{
                scoreModel.finishBigSuc = @"0";
            }
        }
    }else{
        scoreModel.finishBigSuc = @"-1";
    }
    //大小球背景颜色
    if (scoreModel.finishBigSuc.integerValue == 1) {
        
        scoreModel.finishBigViewColor = RRCHighLightTitleColor;
        
        scoreModel.finishBigImage = [UIImage imageNamed:@"红备份 2"];
        
    }else if (scoreModel.finishBigSuc.integerValue == 0){
        
        scoreModel.finishBigViewColor = RRCThemeTextColor;
        
        scoreModel.finishBigImage = [UIImage imageNamed:@"黑备份 2"];
        
    }else if (scoreModel.finishBigSuc.integerValue == 2){
        
        scoreModel.finishBigViewColor = RRC04BD2CColor;
        
        scoreModel.finishBigImage = [UIImage imageNamed:@"走备份 2"];
    }else{
        
        scoreModel.finishBigViewColor = RRCGrayTextColor;
        
        scoreModel.finishBigImage = [UIImage imageNamed:@""];
    }
    
}
#pragma mark -计算亚指
-(void)handleyzJK:(ResultModel *)scoreModel{
    //计算亚指结果
    float allScoreYazhiDif = scoreModel.homeCompositeScore - scoreModel.awayCompositeScore + scoreModel.companyYazhiNumber;
    
    scoreModel.finishScoreYazhiDif = [NSString stringWithFormat:@"%.2f",allScoreYazhiDif];
    
    float absFCom = fabsf(scoreModel.companyYazhiNumber);
    //如果盘口大于零 得分差 + 盘口指数
//   如果盘口小于0，得分差 -
    if (allScoreYazhiDif > 0) {
        scoreModel.finishYazhiDif  = scoreModel.yp_spk;
        
        if (scoreModel.companyYazhiNumber < 0) {
            scoreModel.finishYazhiText = [NSString stringWithFormat:@"%@\n主让%.2f\n%@",kSafeString(scoreModel.yp_spk),absFCom,kSafeString(scoreModel.yp_xpk)];
        }else if (scoreModel.companyYazhiNumber > 0){
            scoreModel.finishYazhiText = [NSString stringWithFormat:@"%@\n主受让%.2f\n%@",kSafeString(scoreModel.yp_spk),absFCom,kSafeString(scoreModel.yp_xpk)];
        }else{
            scoreModel.finishYazhiText = [NSString stringWithFormat:@"%@\n主平手\n%@",kSafeString(scoreModel.yp_spk),kSafeString(scoreModel.yp_xpk)];
        }
        
        //如果上盘水位比下盘低，推荐上盘正常。字体绿色通过。否则黄色警告
        if (scoreModel.yp_spk.floatValue < scoreModel.yp_xpk.floatValue) {
            scoreModel.finishYazhiTextColor = RRCWhiteDarkColor;
        }else{
            scoreModel.finishYazhiTextColor = RRCFFC60AColor;
        }
        
    }else{
        scoreModel.finishYazhiDif  = scoreModel.yp_xpk;
        
        if (scoreModel.companyYazhiNumber > 0) {
            scoreModel.finishYazhiText = [NSString stringWithFormat:@"%@\n客让%.2f\n%@",kSafeString( scoreModel.yp_spk),absFCom,kSafeString(scoreModel.yp_xpk)];
        }else if(scoreModel.companyYazhiNumber < 0){
            scoreModel.finishYazhiText = [NSString stringWithFormat:@"%@\n客受让%.2f\n%@",kSafeString( scoreModel.yp_spk),absFCom,kSafeString(scoreModel.yp_xpk)];
        }else{
            scoreModel.finishYazhiText = [NSString stringWithFormat:@"%@\n客平手\n%@",kSafeString( scoreModel.yp_spk),kSafeString(scoreModel.yp_xpk)];
        }
        
        if (scoreModel.yp_spk.floatValue > scoreModel.yp_xpk.floatValue) {
            scoreModel.finishYazhiTextColor = RRCWhiteDarkColor;
        }else{
            scoreModel.finishYazhiTextColor = RRCFFC60AColor;
        }
    }
    
    //计算亚指猜测结果
    if ([scoreModel.status integerValue]) {
        float realYaResults = scoreModel.homeScore.floatValue - scoreModel.awayScore.floatValue + scoreModel.companyYazhiNumber;
        if (realYaResults == 0) {
            scoreModel.finishYazhiSuc = @"2";
        }else{
            if ((realYaResults > 0 && allScoreYazhiDif > 0)||( realYaResults < 0 && allScoreYazhiDif < 0)) {
                scoreModel.finishYazhiSuc = @"1";
                if (fabsf(realYaResults) == 0.25) {
                    if (allScoreYazhiDif > 0) {//主队水位
                        scoreModel.finishYazhiDif  = [NSString stringWithFormat:@"%.2f",scoreModel.yp_spk.floatValue * 0.5];
                    }else{
                        scoreModel.finishYazhiDif  = [NSString stringWithFormat:@"%.2f",scoreModel.yp_xpk.floatValue * 0.5];
                    }
                }
            }else{
                scoreModel.finishYazhiSuc = @"0";
            }
        }
    }else{
        
        scoreModel.finishYazhiSuc = @"-1";
    }
    if (scoreModel.finishYazhiSuc.integerValue == 1) {
        
        scoreModel.finishYazhiViewColor = RRCHighLightTitleColor;
        
        scoreModel.finishYazhiImage = [UIImage imageNamed:@"红备份 2"];
        
    }else if (scoreModel.finishYazhiSuc.integerValue == 0){
        
        scoreModel.finishYazhiViewColor = RRCThemeTextColor;
        
        scoreModel.finishYazhiImage = [UIImage imageNamed:@"黑备份 2"];
        
    }else if (scoreModel.finishYazhiSuc.integerValue == 2){
        
        scoreModel.finishYazhiViewColor = RRC04BD2CColor;
        
        scoreModel.finishYazhiImage = [UIImage imageNamed:@"走备份 2"];
    }else{
        
        scoreModel.finishYazhiViewColor = RRCGrayTextColor;
        
        scoreModel.finishYazhiImage = [UIImage imageNamed:@"-"];
    }
    
}
@end

//
//  RRCMatchEditManager.m
//  MXSFramework
//
//  Created by renrencai on 2019/4/30.
//  Copyright © 2019 MXS. All rights reserved.
//

#import "RRCMatchEditManager.h"
#import "RRCMatchManager.h"
#import "RRCMatchInfoModel.h"
#import "RRCBallStateEdit.h"
@implementation RRCMatchEditManager

ImplementSingleton(RRCMatchEditManager);


-(void)enableUpdateMatchInfo:(RRCMatchInfoModel *)matchInfoModel AtRow:(NSInteger)row column:(NSInteger)column andhandleMatchinfo:(HandleMatchBlockBOOL)block{
    
    if ([matchInfoModel.match_type integerValue] == 0) {
        RRCBallStateEdit *bballEdit = [[RRCBallStateEdit alloc]initWithType:RRCBallType_Race];
        [bballEdit updateBallStateMatchInfo:matchInfoModel AtRow:row Atcolumn:column];
    }else if ([matchInfoModel.match_type integerValue]== 2){
        RRCBallStateEdit *bballEdit = [[RRCBallStateEdit alloc]initWithType:RRCBallType_Basket];
        [bballEdit updateBallStateMatchInfo:matchInfoModel AtRow:row Atcolumn:column];
    }else if ([matchInfoModel.match_type integerValue] == 3){
        RRCBallStateEdit *bballEdit = [[RRCBallStateEdit alloc]initWithType:RRCBallType_YaPanBall];
        [bballEdit updateBallStateMatchInfo:matchInfoModel AtRow:row Atcolumn:column];
    }else{
        RRCBallStateEdit *bballEdit = [[RRCBallStateEdit alloc]initWithType:RRCBallType_NorthS];
        [bballEdit updateBallStateMatchInfo:matchInfoModel AtRow:row Atcolumn:column];
    }
    
    //插入一条数据
    [[RRCMatchManager sharedRRCMatchManager]handleInserMatchInfo:matchInfoModel];
    
    //1、判断选择的数量 统计所有
    NSInteger sf_rq_allNum = matchInfoModel.sf_goal_CheckNum + matchInfoModel.rq_goal_CheckNum;
    //    NSLog(@"比赛选择个数：%ld:",sf_rq_allNum);
    if (sf_rq_allNum >= 2) {
        if ([matchInfoModel.match_type integerValue] == 0) {
            //将所有的状态置位不可点击
            if (![matchInfoModel.sf_sf3_checked integerValue]) {
                matchInfoModel.sf_sf3_checked_gui = @"1";
            }
            
            if (![matchInfoModel.sf_sf1_checked integerValue]) {
                matchInfoModel.sf_sf1_checked_gui = @"1";
            }
            
            if (![matchInfoModel.sf_sf0_checked integerValue]) {
                matchInfoModel.sf_sf0_checked_gui = @"1";
            }
            
            if (![matchInfoModel.rq_rq3_checked integerValue]) {
                matchInfoModel.rq_rq3_checked_gui = @"1";
            }
            
            if (![matchInfoModel.rq_rq1_checked integerValue]) {
                matchInfoModel.rq_rq1_checked_gui = @"1";
            }
            
            if (![matchInfoModel.rq_rq0_checked integerValue]) {
                matchInfoModel.rq_rq0_checked_gui = @"1";
            }
        }else{
            //将所有的状态置位不可点击
            if (![matchInfoModel.spf_sf3_checked integerValue]) {
                matchInfoModel.sf_sf3_checked_gui = @"1";
            }
            
            if (![matchInfoModel.spf_sf1_checked integerValue]) {
                matchInfoModel.sf_sf1_checked_gui = @"1";
            }
            
            if (![matchInfoModel.spf_sf0_checked integerValue]) {
                matchInfoModel.sf_sf0_checked_gui = @"1";
            }
            
        }
        
    }else{
        matchInfoModel.sf_sf3_checked_gui = @"0";
        matchInfoModel.sf_sf1_checked_gui = @"0";
        matchInfoModel.sf_sf0_checked_gui = @"0";
        matchInfoModel.rq_rq3_checked_gui = @"0";
        matchInfoModel.rq_rq1_checked_gui = @"0";
        matchInfoModel.rq_rq0_checked_gui = @"0";
        
    }
    
    block(YES);
}

@end

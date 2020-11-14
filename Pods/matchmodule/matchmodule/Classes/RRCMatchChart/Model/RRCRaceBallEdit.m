//
//  RRCRaceBallEdit.m
//  MXSFramework
//
//  Created by gaoguangxiao on 2019/6/6.
//  Copyright © 2019 MXS. All rights reserved.
//

#import "RRCRaceBallEdit.h"
#import "RRCMatchInfoModel.h"
@implementation RRCRaceBallEdit

-(void)updateBallMatchInfo:(RRCMatchInfoModel *)matchInfoModel AtRow:(NSInteger)row Atcolumn:(NSInteger)column{
    if (row == 2) {
        //不让球
        if (column == 0) {
            matchInfoModel.sf_sf3_checked = [matchInfoModel.sf_sf3_checked isEqualToString:@"1"] ? @"0":@"1";
            if (matchInfoModel.sf_sf3_flag) {
                [self handlesf_num:matchInfoModel.sf_sf3_checked andMatchInfo:matchInfoModel];
            }else{
                matchInfoModel.isShowTipRecommend = YES;
            }
        }else if (column == 1){
            matchInfoModel.sf_sf1_checked = [matchInfoModel.sf_sf1_checked isEqualToString:@"1"] ? @"0":@"1";
            if (matchInfoModel.sf_sf1_flag) {
                [self handlesf_num:matchInfoModel.sf_sf1_checked andMatchInfo:matchInfoModel];
            }else{
                matchInfoModel.isShowTipRecommend = YES;
            }
        }else{
            matchInfoModel.sf_sf0_checked = [matchInfoModel.sf_sf0_checked isEqualToString:@"1"] ? @"0":@"1";
            if (matchInfoModel.sf_sf0_flag) {
                [self handlesf_num:matchInfoModel.sf_sf0_checked andMatchInfo:matchInfoModel];
            }else{
                matchInfoModel.isShowTipRecommend = YES;
            }
        }
    }
    else if (row == 3){
        if (column == 0) {
            matchInfoModel.rq_rq3_checked = [matchInfoModel.rq_rq3_checked isEqualToString:@"1"] ? @"0":@"1";
            if (matchInfoModel.rq_rq3_flag) {
                [self handlerq_num:matchInfoModel.rq_rq3_checked andMatchInfo:matchInfoModel];
            }else{
                matchInfoModel.isShowTipRecommend = YES;
            }
        }else if (column == 1){
            matchInfoModel.rq_rq1_checked = [matchInfoModel.rq_rq1_checked isEqualToString:@"1"] ? @"0":@"1";
            if (matchInfoModel.rq_rq1_flag) {
                [self handlerq_num:matchInfoModel.rq_rq1_checked andMatchInfo:matchInfoModel];
            }else{
                matchInfoModel.isShowTipRecommend = YES;
            }
        }else{
            matchInfoModel.rq_rq0_checked = [matchInfoModel.rq_rq0_checked isEqualToString:@"1"] ? @"0":@"1";
            if (matchInfoModel.rq_rq0_flag) {
                [self handlerq_num:matchInfoModel.rq_rq0_checked andMatchInfo:matchInfoModel];
            }else{
                matchInfoModel.isShowTipRecommend = YES;
            }
        }
    }
    else if (row == 4){
        if (column == 0) {
            matchInfoModel.jc_yz_hjspl_checked = [matchInfoModel.jc_yz_hjspl_checked isEqualToString:@"1"] ? @"0":@"1";
            if (matchInfoModel.jc_yz_hjspl_flag) {
                if (matchInfoModel.jc_yz_hjspl_checked) {
                    matchInfoModel.jc_yz_wjspl_checked = @"0";
                }
                matchInfoModel.isShowTipRecommend = NO;
            }else{
                matchInfoModel.isShowTipRecommend = YES;
            }
        }else if (column == 1){
            matchInfoModel.jc_yz_wjspl_checked = [matchInfoModel.jc_yz_wjspl_checked isEqualToString:@"1"] ? @"0":@"1";
            if (matchInfoModel.jc_yz_wjspl_flag) {
                if (matchInfoModel.jc_yz_wjspl_checked) {
                    matchInfoModel.jc_yz_hjspl_checked = @"0";
                }
                matchInfoModel.isShowTipRecommend = NO;
            }else{
                matchInfoModel.isShowTipRecommend = YES;
            }
        }else{
            
        }
    }
}

-(void)handlesf_num:(NSString *)checked andMatchInfo:(RRCMatchInfoModel *)matchInfoModel{
    if ([checked integerValue]) {
        matchInfoModel.sf_goal_CheckNum ++;
    }else{
        matchInfoModel.sf_goal_CheckNum --;
    }
    matchInfoModel.isShowTipRecommend = NO;
}

-(void)handlerq_num:(NSString *)checked andMatchInfo:(RRCMatchInfoModel *)matchInfoModel{
    if ([checked integerValue]) {
        matchInfoModel.rq_goal_CheckNum ++;
    }else{
        matchInfoModel.rq_goal_CheckNum --;
    }
    matchInfoModel.isShowTipRecommend = NO;
}
@end

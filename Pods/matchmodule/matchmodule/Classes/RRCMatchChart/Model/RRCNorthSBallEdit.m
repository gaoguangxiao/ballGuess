//
//  RRCNorthSEdit.m
//  MXSFramework
//
//  Created by gaoguangxiao on 2019/6/6.
//  Copyright © 2019 MXS. All rights reserved.
//

#import "RRCNorthSBallEdit.h"
#import "RRCMatchInfoModel.h"
@implementation RRCNorthSBallEdit

-(void)updateBallMatchInfo:(RRCMatchInfoModel *)matchInfoModel AtRow:(NSInteger)row Atcolumn:(NSInteger)column{
    
    if (row == 2) {
        //不让球
        if (column == 0) {
            matchInfoModel.spf_sf3_checked = [matchInfoModel.spf_sf3_checked isEqualToString:@"1"] ? @"0":@"1";
            
            [self handlesf_num:matchInfoModel.spf_sf3_checked andMatchInfo:matchInfoModel];
        }else if (column == 1){
            matchInfoModel.spf_sf1_checked = [matchInfoModel.spf_sf1_checked isEqualToString:@"1"] ? @"0":@"1";
            
            [self handlesf_num:matchInfoModel.spf_sf1_checked andMatchInfo:matchInfoModel];
        }else{
            matchInfoModel.spf_sf0_checked = [matchInfoModel.spf_sf0_checked isEqualToString:@"1"] ? @"0":@"1";
            
            [self handlesf_num:matchInfoModel.spf_sf0_checked andMatchInfo:matchInfoModel];
        }
    }
    else{
        if (column == 0) {
            matchInfoModel.bd_yz_hjspl_checked = [matchInfoModel.bd_yz_hjspl_checked isEqualToString:@"1"] ? @"0":@"1";
            if ([matchInfoModel.bd_yz_hjspl_checked integerValue]) {
                matchInfoModel.bd_yz_wjspl_checked = @"0";
                matchInfoModel.isShowTipRecommend = YES;
            }else{
                matchInfoModel.isShowTipRecommend = NO;
            }
        }else if (column == 1){
            matchInfoModel.bd_yz_wjspl_checked = [matchInfoModel.bd_yz_wjspl_checked isEqualToString:@"1"] ? @"0":@"1";
            if ([matchInfoModel.bd_yz_wjspl_checked integerValue]) {
                matchInfoModel.bd_yz_hjspl_checked = @"0";
                matchInfoModel.isShowTipRecommend = YES;
            }else{
                matchInfoModel.isShowTipRecommend = NO;
            }
        }else{
            matchInfoModel.sf_sf3_checked = [matchInfoModel.sf_sf3_checked isEqualToString:@"1"] ? @"0":@"1";
        }
    }
}

-(void)handlesf_num:(NSString *)checked andMatchInfo:(RRCMatchInfoModel *)matchInfoModel{
    if ([checked integerValue]) {
        matchInfoModel.sf_goal_CheckNum ++;
        matchInfoModel.isShowTipRecommend = YES;
    }else{
        matchInfoModel.sf_goal_CheckNum --;
        matchInfoModel.isShowTipRecommend = NO;
    }
}
@end

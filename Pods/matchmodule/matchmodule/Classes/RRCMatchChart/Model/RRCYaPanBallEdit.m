//
//  RRCYaPanBallEdit.m
//  MXSFramework
//
//  Created by gaoguangxiao on 2019/6/18.
//  Copyright © 2019 MXS. All rights reserved.
//

#import "RRCYaPanBallEdit.h"
#import "RRCMatchInfoModel.h"
@implementation RRCYaPanBallEdit

-(void)updateBallMatchInfo:(RRCMatchInfoModel *)matchInfoModel AtRow:(NSInteger)row Atcolumn:(NSInteger)column{
    if (row == 2) {
        if (column == 0) {
            matchInfoModel.bd_yz_hjspl_checked = [matchInfoModel.bd_yz_hjspl_checked isEqualToString:@"1"] ? @"0":@"1";
            if (matchInfoModel.bd_yz_hjspl_flag) {
                if (matchInfoModel.bd_yz_hjspl_checked) {
                    matchInfoModel.bd_yz_wjspl_checked = @"0";
                }
                matchInfoModel.isShowTipRecommend = NO;
            }else{
                matchInfoModel.bd_yz_hjspl_checked = @"0";
                matchInfoModel.isShowTipRecommend = YES;
            }
        }else if (column == 1){
            matchInfoModel.bd_yz_wjspl_checked = [matchInfoModel.bd_yz_wjspl_checked isEqualToString:@"1"] ? @"0":@"1";
            if (matchInfoModel.bd_yz_wjspl_flag) {
                if (matchInfoModel.bd_yz_wjspl_checked) {
                    matchInfoModel.bd_yz_hjspl_checked = @"0";
                }
                matchInfoModel.isShowTipRecommend = NO;
            }else{
                matchInfoModel.bd_yz_wjspl_checked = @"0";
                matchInfoModel.isShowTipRecommend = YES;
            }
        }else{

        }
    } else{
        if (column == 0) {
            matchInfoModel.dxq_hjspl_checked = matchInfoModel.dxq_hjspl_checked ? 0:1;
            if (matchInfoModel.dxq_hjspl_flag) {
                if (matchInfoModel.dxq_hjspl_checked) {
                    matchInfoModel.dxq_wjspl_checked = 0;
                }
                matchInfoModel.isShowTipRecommend = NO;
            }else{
                matchInfoModel.dxq_hjspl_checked  = 0;
                matchInfoModel.isShowTipRecommend = YES;
            }
        }else if (column == 1){
            matchInfoModel.dxq_wjspl_checked = matchInfoModel.dxq_wjspl_checked? 0 : 1;
            if (matchInfoModel.dxq_wjspl_flag) {
                if (matchInfoModel.dxq_wjspl_checked) {
                    matchInfoModel.dxq_hjspl_checked = 0;
                }
                matchInfoModel.isShowTipRecommend = NO;
            }else{
                matchInfoModel.dxq_wjspl_checked = 0;
                matchInfoModel.isShowTipRecommend = YES;
            }
        }else{
           
        }
    }
}

-(void)sortBallPlayMethodByMatchInfo:(RRCMatchInfoModel *)matchInfoModel{

    //足球亚指场次
    self.match_name = [NSString stringWithFormat:@"%@|%@ |%@",kSafeString(matchInfoModel.league),kSafeString(matchInfoModel.match_time1),kSafeString(matchInfoModel.match_time2)];
    
    //足球专属 亚指类别
    if ([matchInfoModel.bd_yz_hjspl_checked integerValue] || [matchInfoModel.bd_yz_wjspl_checked integerValue]) {
        if (matchInfoModel.yz_desc) {
            [self.play_Method addObject:matchInfoModel.yz_desc];
        }else{
            [self.play_Method addObject:@"亚指"];
        }
        matchInfoModel.matchResultsImage = [self imageNameByResult:matchInfoModel.bd_yz_result];
        [self.match_tateArr addObject:matchInfoModel.matchResultsImage];
        
        if ([matchInfoModel.bd_yz_hjspl_checked integerValue]) {
            [self.odd_Arr addObject:[NSString stringWithFormat:@"%@\n@%@|%@",matchInfoModel.bd_yz_hjspl_str,matchInfoModel.bd_yz_hjspl,matchInfoModel.bd_yz_hjspl_red]];
        }
        if ([matchInfoModel.bd_yz_wjspl_checked integerValue]) {
            [self.odd_Arr addObject:[NSString stringWithFormat:@"%@\n@%@|%@",matchInfoModel.bd_yz_wjspl_str,matchInfoModel.bd_yz_wjspl,matchInfoModel.bd_yz_wjspl_red]];
        }
    }
    //足球大小
    if (matchInfoModel.dxq_hjspl_checked || matchInfoModel.dxq_wjspl_checked) {
        if (matchInfoModel.dxq_desc) {
            [self.play_Method addObject:matchInfoModel.dxq_desc];
        }else{
            [self.play_Method addObject:@"大小"];
        }
        matchInfoModel.matchResultsImage = [self imageNameByResult:matchInfoModel.dxq_result];
        [self.match_tateArr addObject:matchInfoModel.matchResultsImage];
        if (matchInfoModel.dxq_hjspl_checked) {
            [self.odd_Arr addObject:[NSString stringWithFormat:@"%@\n@%@|%@",matchInfoModel.dxq_hjspl_str,matchInfoModel.dxq_hjspl,matchInfoModel.dxq_hjspl_red]];
        }
        if (matchInfoModel.dxq_wjspl_checked) {
            [self.odd_Arr addObject:[NSString stringWithFormat:@"%@\n@%@|%@",matchInfoModel.dxq_wjspl_str,matchInfoModel.dxq_wjspl,matchInfoModel.dxq_wjspl_red]];
        }
    }
    
    matchInfoModel.matchName = self.match_name;
    matchInfoModel.matchPlayMethod = self.play_Method;
    matchInfoModel.matchOdds = self.odd_Arr;
    matchInfoModel.matchStateArr = self.match_tateArr;
}
@end

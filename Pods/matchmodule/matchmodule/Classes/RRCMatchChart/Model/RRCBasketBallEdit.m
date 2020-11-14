//
//  RRCBBallStateEdit.m
//  MXSFramework
//
//  Created by gaoguangxiao on 2019/6/6.
//  Copyright © 2019 MXS. All rights reserved.
//

#import "RRCBasketBallEdit.h"
#import "RRCMatchInfoModel.h"

@implementation RRCBasketBallEdit


-(void)updateBallMatchInfo:(RRCMatchInfoModel *)matchInfoModel AtRow:(NSInteger)row Atcolumn:(NSInteger)column{
    if (row == 2) {
        if (column == 0) {
            matchInfoModel.RFHJSPL_checked = [matchInfoModel.RFHJSPL_checked isEqualToString:@"1"] ? @"0":@"1";
            if (matchInfoModel.RFHJSPL_flag) {
                if (matchInfoModel.RFHJSPL_checked) {
                    matchInfoModel.RFWJSPL_checked = @"0";
                }
                matchInfoModel.isShowTipRecommend = NO;
            }else{
                matchInfoModel.RFHJSPL_checked = @"0";
                matchInfoModel.isShowTipRecommend = YES;
            }
        }else if (column == 1){
            matchInfoModel.RFWJSPL_checked = [matchInfoModel.RFWJSPL_checked isEqualToString:@"1"] ? @"0":@"1";
            if (matchInfoModel.RFWJSPL_flag) {
                if (matchInfoModel.RFWJSPL_checked) {
                    matchInfoModel.RFHJSPL_checked = @"0";
                }
                matchInfoModel.isShowTipRecommend = NO;
            }else{
                matchInfoModel.RFWJSPL_checked =  @"0";
                matchInfoModel.isShowTipRecommend = YES;
            }
        }else{

        }
    } else{
        if (column == 0) {
            matchInfoModel.DXQHJSPL_checked = [matchInfoModel.DXQHJSPL_checked isEqualToString:@"1"] ? @"0":@"1";
           if (matchInfoModel.DXQHJSPL_flag) {
                if (matchInfoModel.DXQHJSPL_checked) {
                    matchInfoModel.DXQWJSPL_checked = @"0";
                }
                matchInfoModel.isShowTipRecommend = NO;
            }else{
                matchInfoModel.DXQHJSPL_checked = @"0";
                matchInfoModel.isShowTipRecommend = YES;
            }
        }else if (column == 1){
            matchInfoModel.DXQWJSPL_checked = [matchInfoModel.DXQWJSPL_checked isEqualToString:@"1"] ? @"0":@"1";
            if (matchInfoModel.DXQWJSPL_flag) {
                if (matchInfoModel.DXQWJSPL_checked) {
                    matchInfoModel.DXQHJSPL_checked = @"0";
                }
                matchInfoModel.isShowTipRecommend = NO;
            }else{
                matchInfoModel.DXQWJSPL_checked = @"0";
                matchInfoModel.isShowTipRecommend = YES;
            }
        }else{

        }
    }
}
@end

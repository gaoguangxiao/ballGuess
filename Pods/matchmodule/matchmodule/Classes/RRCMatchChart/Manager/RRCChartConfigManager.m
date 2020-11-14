//
//  RRCChartConfigManager.m
//  MXSFramework
//
//  Created by renrencai on 2019/4/30.
//  Copyright © 2019 MXS. All rights reserved.
//

#import "RRCChartConfigManager.h"
#import "RRCMatchInfoModel.h"
#import "JHTableRowModel.h"
#import "RRCDeviceConfigure.h"
@implementation RRCChartConfigManager

ImplementSingleton(RRCChartConfigManager);

#pragma mark -表格属性
-(CGFloat)chartViewItemHeightWithMatchInfo:(RRCMatchInfoModel *)matchInfoModel andByRow:(NSInteger)row andByColum:(NSInteger)column andTitleTag:(NSString *)titleTag andItemHeight:(CGFloat)itemHeight{
    //传入当前比赛 以及所用字段
    NSInteger matchPlayMethodCount = matchInfoModel.matchPlayMethod.count;//类别数量
    NSInteger matchOddsCount       = matchInfoModel.matchOdds.count;//类别选项
    
    CGFloat itemPerHeight = 0;//单元表格高度
    if (column == 2) {
        if ([matchInfoModel.matchPlayMethod containsObject:matchInfoModel.yz_desc]) {
            if (matchOddsCount == 2) {
                itemPerHeight = itemHeight/2;
            }else{
                //3个类别
                if (matchPlayMethodCount == 2 && ![titleTag isEqualToString:matchInfoModel.yz_desc]) {
                    itemPerHeight = 64 * Device_Ccale;
                }else{
                    if ([titleTag isEqualToString:@"胜平负"]) {
                        itemPerHeight = 32 * Device_Ccale;
                    }else{
                        itemPerHeight = 44 * Device_Ccale;
                    }
                }
            }
        }else{
            if ([titleTag isEqualToString:@"胜平负"]) {
                itemPerHeight = 32 * Device_Ccale;
            }else{
                itemPerHeight = 44 * Device_Ccale;
            }
            
        }
    }
    else if (column == 3){
        //高度类型 32 44 64
        if (matchOddsCount == 1) {
            itemPerHeight = itemHeight;
        }else if (matchOddsCount == 2){
            if ([matchInfoModel.matchPlayMethod containsObject:matchInfoModel.yz_desc]) {
                itemPerHeight = itemHeight/2;
            }else{
                //观察胜所在的位置，类别两 不包含亚指
                if (matchPlayMethodCount == 1) {
                    itemPerHeight = 32 * Device_Ccale;
                }else if (matchPlayMethodCount == 2) {
                    if (row == 0) {//胜
                        itemPerHeight = 32 * Device_Ccale;
                    }else{
                        itemPerHeight = 44 * Device_Ccale;
                    }
                }else{
                    if (matchPlayMethodCount == 1) {
                        if (row == 0) {//胜
                            itemPerHeight = 32 * Device_Ccale;
                        }else{
                            itemPerHeight = 44 * Device_Ccale;
                        }
                        
                    }else{
                        itemPerHeight = itemHeight - 32 * Device_Ccale;
                        if (itemPerHeight >= 44) {
                            itemPerHeight = 44 * Device_Ccale;
                        }
                    }
                }
            }
        }else{
            if (matchPlayMethodCount == 2) {
                if ([titleTag containsString:kSafeString(matchInfoModel.jc_yz_hjspl_str)] || [titleTag containsString:kSafeString(matchInfoModel.jc_yz_wjspl_str)] || [titleTag containsString:kSafeString(matchInfoModel.bd_yz_hjspl_str)] || [titleTag containsString:kSafeString(matchInfoModel.bd_yz_wjspl_str)]) {
                    itemPerHeight = 44 * Device_Ccale;
                }else{
                    itemPerHeight = 32 * Device_Ccale;
                }
            }else{
                //类别三种
                if (row == 0) {
                    itemPerHeight = 32 * Device_Ccale;
                }else{
                    itemPerHeight = 44 * Device_Ccale;
                }
            }
        }
    }
    else if(column == 4){
        if (matchOddsCount == 1) {
            itemPerHeight = itemHeight;
        }else if (matchOddsCount == 2){
            if ([matchInfoModel.matchPlayMethod containsObject:matchInfoModel.yz_desc]) {
                itemPerHeight = itemHeight/2;
            }else{
                //观察胜所在的位置，类别两 不包含亚指
                if (matchOddsCount == matchPlayMethodCount && row == 0) {
                    itemPerHeight = 32 * Device_Ccale;
                }else{
                    if (matchPlayMethodCount == 1) {
                        itemPerHeight = itemHeight;
                    }else{
                        itemPerHeight = itemHeight - 32 * Device_Ccale;
                        if (itemPerHeight >= 44) {
                            itemPerHeight = 44 * Device_Ccale;
                        }
                    }
                }
            }
        }else{
            //                类别三种
            if (row == 0) {
                if (matchPlayMethodCount == 3) {
                    itemPerHeight = 76 * Device_Ccale;
                }else{
                    itemPerHeight = 64 * Device_Ccale;
                }
            }else{
                itemPerHeight = 44 * Device_Ccale;
            }
        }
    }
    
    return itemPerHeight;
    
}

#pragma mark - 配置颜色大小
-(UIFont *)chartViewItemByrow:(NSInteger)row andAtcolumn:(NSInteger)column{
    if (row == 0) {
        if (column == 0) {
            return [UIFont boldSystemFontOfSize:11 * Device_Ccale];
        }else{
            return [UIFont boldSystemFontOfSize:10 * Device_Ccale];
        }
    }else if (row == 1){
        return [UIFont boldSystemFontOfSize:12 * Device_Ccale];
    }else if (row == 2){
        return [UIFont boldSystemFontOfSize:11 * Device_Ccale];
    }else{
        return [UIFont systemFontOfSize:12 * Device_Ccale];
    }
}

-(NSArray *)chartDataRowWithAtRow:(NSInteger )row andMatchInfo:(RRCMatchInfoModel *)r{
    if (row == 0) {
        if ([r.match_type integerValue] == 2) {
            return [self chartyzRowDataWithMatchInfo:r andRow:row];
        }else if ([r.match_type integerValue] == 3){
            return [self chartyzRowDataWithMatchInfo:r andRow:row];
        }else{
            return [self chartOddsRowDataWithAtRow:row andMatchInfo:r];
        }
        
    }else if (row == 1){
        if ([r.match_type integerValue] == 0) {
            return [self chartOddsRowDataWithAtRow:row andMatchInfo:r];
        }else{
            return [self chartyzRowDataWithMatchInfo:r andRow:row];
        }
    }else{
        return [self chartyzRowDataWithMatchInfo:r andRow:row];
    }
}
//需要处理不让球下的数据 row == 0 game_type == 1
-(NSArray *)chartOddsRowDataWithAtRow:(NSInteger )row andMatchInfo:(RRCMatchInfoModel *)r{
    
    //胜平负组装
    NSArray *sf_str    = @[@"胜",@"平",@"负"];
    
    //不让球
    NSArray *sf_sf_arr = @[@"sf_sf3",@"sf_sf1",@"sf_sf0"];
    NSArray *sf_check_arr = @[@"sf_sf3_checked",@"sf_sf1_checked",@"sf_sf0_checked"];
    NSArray *sf_checked_gui_arr = @[@"sf_sf3_checked_gui",@"sf_sf1_checked_gui",@"sf_sf0_checked_gui"];
    NSArray *sf_checked_flag_arr = @[@"sf_sf3_flag",@"sf_sf1_flag",@"sf_sf0_flag"];
    
    //让球
    NSArray *rq_rq_arr = @[@"rq_rq3",@"rq_rq1",@"rq_rq0"];
    NSArray *rq_check_arr = @[@"rq_rq3_checked",@"rq_rq1_checked",@"rq_rq0_checked"];
    NSArray *rq_checked_gui_arr = @[@"rq_rq3_checked_gui",@"rq_rq1_checked_gui",@"rq_rq0_checked_gui"];
    NSArray *rq_checked_flag_arr = @[@"rq_rq3_flag",@"rq_rq1_flag",@"rq_rq0_flag"];
    
    //北单让球
    NSArray *spf_sf_arr = @[@"spf_sf3",@"spf_sf1",@"spf_sf0"];
    NSArray *spf_check_arr = @[@"spf_sf3_checked",@"spf_sf1_checked",@"spf_sf0_checked"];
    NSArray *spf_checked_gui_arr = @[@"spf_sf3_checked_gui",@"spf_sf1_checked_gui",@"spf_sf0_checked_gui"];
    NSArray *spf_checked_flag_arr = @[@"sf_sf3_flag",@"sf_sf1_flag",@"sf_sf0_flag"];

    NSMutableArray *list_arr = [NSMutableArray new];
    for (NSInteger i = 0; i < sf_str.count; i++) {
//        NSString *str_chart = @"";
        JHTableRowModel *rowt_0_h = [JHTableRowModel new];
        if (row == 0) {
            if ([r.match_type integerValue]) {
                rowt_0_h.ball_str  = sf_str[i];
                rowt_0_h.ball_num  = [r valueForKey:spf_sf_arr[i]];
                rowt_0_h.unitSelect = [[r valueForKey:spf_check_arr[i]] integerValue];
                rowt_0_h.unitDisTouch = [[r valueForKey:spf_checked_gui_arr[i]] integerValue];
                rowt_0_h.unitbackImageisHidden = [[r valueForKey:spf_checked_flag_arr[i]] integerValue];
  
            }else{
                rowt_0_h.ball_str  = sf_str[i];
                rowt_0_h.ball_num  = [r valueForKey:sf_sf_arr[i]];
                rowt_0_h.unitSelect = [[r valueForKey:sf_check_arr[i]] integerValue];
                rowt_0_h.unitDisTouch = [[r valueForKey:sf_checked_gui_arr[i]] integerValue];
                rowt_0_h.unitbackImageisHidden = [[r valueForKey:kSafeString(sf_checked_flag_arr[i])]integerValue];
            }
        }else if (row == 1){
            rowt_0_h.ball_str  = sf_str[i];
            rowt_0_h.ball_num  = [r valueForKey:rq_rq_arr[i]];
            rowt_0_h.unitSelect = [[r valueForKey:rq_check_arr[i]] integerValue];
            rowt_0_h.unitDisTouch = [[r valueForKey:rq_checked_gui_arr[i]] integerValue];
            rowt_0_h.unitbackImageisHidden = [[r valueForKey:rq_checked_flag_arr[i]]integerValue];
        }
        [list_arr addObject:rowt_0_h];
    }
//    NSLog(@"%@",list_arr);
    return list_arr.copy;
}
-(NSArray *)chartyzRowDataWithMatchInfo:(RRCMatchInfoModel *)r andRow:(NSInteger)row{
    NSArray *thirdRowArr = @[];
    if ([r.match_type integerValue] == 1) {
        JHTableRowModel *row1_0_h = [JHTableRowModel new];
        row1_0_h.ball_str  = r.bd_yz_hjspl_str;
        row1_0_h.ball_num  = r.bd_yz_hjspl;
        row1_0_h.unitSelect = [r.bd_yz_hjspl_checked integerValue];
        row1_0_h.unitbackImageisHidden = r.bd_yz_hjspl_flag;
        
        JHTableRowModel *row1_0_w = [JHTableRowModel new];
        row1_0_w.ball_str  = r.bd_yz_wjspl_str;
        row1_0_w.ball_num  = r.bd_yz_wjspl;
        row1_0_w.unitSelect = [r.bd_yz_wjspl_checked integerValue];
        row1_0_w.unitbackImageisHidden = r.bd_yz_wjspl_flag;
        thirdRowArr = @[row1_0_h,row1_0_w];
    }else if ([r.match_type integerValue] == 2){
        if (row == 0) {
            JHTableRowModel *row2_0_h = [JHTableRowModel new];
            row2_0_h.ball_str  = r.RFHJSPL_str;
            row2_0_h.ball_num  = [NSString stringWithFormat:@"@%@",r.RFHJSPL];
            row2_0_h.unitSelect = [r.RFHJSPL_checked integerValue];
            row2_0_h.unitbackImageisHidden = r.RFHJSPL_flag;
            
            JHTableRowModel *row2_0_w = [JHTableRowModel new];
            row2_0_w.ball_str  = r.RFWJSPL_str;
            row2_0_w.ball_num  = [NSString stringWithFormat:@"@%@",r.RFWJSPL];
            row2_0_w.unitSelect = [r.RFWJSPL_checked integerValue];
            row2_0_w.unitbackImageisHidden = r.RFWJSPL_flag;
            thirdRowArr = @[row2_0_h,row2_0_w];
        }else{
            JHTableRowModel *row2_1_h = [JHTableRowModel new];
            row2_1_h.ball_str  = r.DXQHJSPL_str;
            row2_1_h.ball_num  = [NSString stringWithFormat:@"@%@",r.DXQHJSPL];
            row2_1_h.unitSelect = [r.DXQHJSPL_checked integerValue];
            row2_1_h.unitbackImageisHidden = r.DXQHJSPL_flag;
            
            JHTableRowModel *row2_1_w = [JHTableRowModel new];
            row2_1_w.ball_str  = r.DXQWJSPL_str;
            row2_1_w.ball_num  = [NSString stringWithFormat:@"@%@",r.DXQWJSPL];
            row2_1_w.unitSelect = [r.DXQWJSPL_checked integerValue];
            row2_1_w.unitbackImageisHidden = r.DXQWJSPL_flag;
            thirdRowArr = @[row2_1_h,row2_1_w];
        }
        
    }else if ([r.match_type intValue] == 3){
        if (row == 0) {
            JHTableRowModel *row3_0_h = [JHTableRowModel new];
            row3_0_h.ball_str  = r.bd_yz_hjspl_str;
            row3_0_h.ball_num  = [NSString stringWithFormat:@"@%@",r.bd_yz_hjspl];
            row3_0_h.unitSelect = [r.bd_yz_hjspl_checked integerValue];
            row3_0_h.unitbackImageisHidden = r.bd_yz_hjspl_flag;
            
            JHTableRowModel *row3_0_w = [JHTableRowModel new];
            row3_0_w.ball_str  = r.bd_yz_wjspl_str;
            row3_0_w.ball_num  = [NSString stringWithFormat:@"@%@",r.bd_yz_wjspl];
            row3_0_w.unitSelect = [r.bd_yz_wjspl_checked integerValue];
            row3_0_w.unitbackImageisHidden = r.bd_yz_wjspl_flag;
            thirdRowArr = @[row3_0_h,row3_0_w];
        }else{
            JHTableRowModel *row3_1_h = [JHTableRowModel new];
            row3_1_h.ball_str  = r.dxq_hjspl_str;
            row3_1_h.ball_num  = [NSString stringWithFormat:@"@%@",r.dxq_hjspl];
            row3_1_h.unitSelect = r.dxq_hjspl_checked;
            row3_1_h.unitbackImageisHidden = r.dxq_hjspl_flag;
            
            JHTableRowModel *row3_2_h = [JHTableRowModel new];
            row3_2_h.ball_str  = r.dxq_wjspl_str;
            row3_2_h.ball_num  = [NSString stringWithFormat:@"@%@",r.dxq_wjspl];
            row3_2_h.unitSelect = r.dxq_wjspl_checked;
            row3_2_h.unitbackImageisHidden = r.dxq_wjspl_flag;
            
            thirdRowArr = @[row3_1_h,row3_2_h];
        }
    } else{
        JHTableRowModel *row0_h = [JHTableRowModel new];
        row0_h.ball_str  = r.jc_yz_hjspl_str;
        row0_h.ball_num  = [NSString stringWithFormat:@"@%@",r.jc_yz_hjspl];
        row0_h.unitSelect = [r.jc_yz_hjspl_checked integerValue];
        row0_h.unitbackImageisHidden = r.jc_yz_hjspl_flag;
        
        JHTableRowModel *row0_w = [JHTableRowModel new];
        row0_w.ball_str  = r.jc_yz_wjspl_str;
        row0_w.ball_num  = [NSString stringWithFormat:@"@%@",r.jc_yz_wjspl];
        row0_w.unitSelect = [r.jc_yz_wjspl_checked integerValue];
        row0_w.unitbackImageisHidden = r.jc_yz_wjspl_flag;
        
        thirdRowArr = @[row0_h,row0_w];
    }
    
    return thirdRowArr;
}
-(NSString *)valueForByKey:(NSString *)key andMatchInfo:(RRCMatchInfoModel *)m{
    NSString *result = @"";
    if ([m valueForKey:key]) {
        result = [m valueForKey:key];
    }
    return result;
}
@end

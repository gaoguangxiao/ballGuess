//
//  RRCMatchInfoView.m
//  JHChartDemo
//
//  Created by renrencai on 2019/4/17.
//  Copyright © 2019年 JH. All rights reserved.
//

#import "RRCMatchInfoView.h"
#import "JHTableChart.h"

#import "RRCMatchChartHeadView.h"

#import "RRCMatchManager.h"
#import "RRCMatchEditManager.h"
#import "RRCChartConfigManager.h"
#import "RRCAlertManager.h"

#import "RRCMatchInfoModel.h"
#import "RRCMatchModel.h"

#import "DYUIViewExt.h"
#import "RRCDeviceConfigure.h"
#import "YBImageConfigure.h"
#import "YBColorConfigure.h"
#import <MJExtension/MJExtension.h>
//路由
#import "FFRouter.h"
//#import "RRCLiveOnlineController.h" //直播详情
//#import "RRCStatisticalController.h"
@interface RRCMatchInfoView ()<JHTableChartDelegate,RRCMatchHandleProtocol>

@property (nonatomic , strong) RRCMatchChartHeadView *matchHeadView;
@property (nonatomic , strong) JHTableChart *tableChart;//第一视图

@property (nonatomic , strong) JHTableChart *tableChart1;
@property (nonatomic , strong) JHTableChart *tableChart2;
@property (nonatomic , strong) JHTableChart *tableChart3;//

@property (nonatomic , strong) RRCMatchInfoModel *matchInfoModel;
//@property (nonatomic , strong) JHTableChart *oddsFirstChart;
@end

@implementation RRCMatchInfoView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
-(RRCMatchChartHeadView *)matchHeadView{
    if (!_matchHeadView) {
        _matchHeadView = [[RRCMatchChartHeadView alloc]initWithFrame:CGRectMake(0, 0, self.width, 44*Device_Ccale)];
    }
    return _matchHeadView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //                [self setUpView];
    }
    return self;
}

-(void)setUpView{
    [self addSubview:self.tableChart];
    [self congigChoseTable:self.tableChart];
    
    if (self.matchInfoState == RRCMatchInfoListStateEdit || self.matchInfoState == RRCMatchInfoListStateAdd) {
        self.tableChart.minHeightItems = 48 * Device_Ccale;
        self.tableChart.colTitleSelectBackImage = RRCF21646Image;
        RRCMatchInfoModel *matchInfo_model = self.matchModel.matchArr.firstObject;
        self.matchInfoModel = matchInfo_model;
        NSMutableArray *chartArr = [NSMutableArray new];
        NSMutableArray *colTitleArr = [NSMutableArray new];
        if ([matchInfo_model.match_type isEqualToString:@"0"]) {
            [colTitleArr addObject:kSafeString(matchInfo_model.matchId)];
            [colTitleArr addObject:kSafeString(matchInfo_model.letball)];
            [colTitleArr addObject:kSafeString(matchInfo_model.matchMember)];
            [chartArr addObject:@[matchInfo_model.matchName,matchInfo_model.sf_goal,@"胜"]];
            [chartArr addObject:@[[NSString stringWithFormat:@"%@ |%@",matchInfo_model.match_time1,matchInfo_model.match_time2],matchInfo_model.rq_goal,@"胜"]];
            
            if (matchInfo_model.jc_yz_jspk) {
                [chartArr addObject:@[matchInfo_model.yz_desc,matchInfo_model.jc_yz_jspk,@"胜"]];
            }else{
                [chartArr addObject:@[matchInfo_model.yz_desc,@"0",@"胜"]];
            }
            self.tableChart.colTitleHeight = 32 * Device_Ccale;
        }else if ([matchInfo_model.match_type isEqualToString:@"1"]){
            NSString *match_Str = [NSString stringWithFormat:@"%@|%@",kSafeString(matchInfo_model.match_id_str),kSafeString(matchInfo_model.match_time2)];
            [colTitleArr addObject:kSafeString(match_Str)];
            [colTitleArr addObject:kSafeString(matchInfo_model.letball)];
            [colTitleArr addObject:kSafeString(matchInfo_model.matchMember)];
            //不让球
            [chartArr addObject:@[matchInfo_model.matchName,matchInfo_model.spf_goal,@""]];
            //亚指
            if (matchInfo_model.bd_yz_jspk) {
                [chartArr addObject:@[matchInfo_model.yz_desc,matchInfo_model.bd_yz_jspk,@""]];
            }else{
                [chartArr addObject:@[matchInfo_model.yz_desc,@"0",@"胜"]];
            }
            self.tableChart.colTitleHeight = 32 * Device_Ccale;
        }else if([matchInfo_model.match_type integerValue] == 2 || [matchInfo_model.match_type integerValue] == 3){
            NSString *match_Str = [NSString stringWithFormat:@"%@ |%@ %@",kSafeString(matchInfo_model.league),kSafeString(matchInfo_model.match_time1),matchInfo_model.match_time2];
            NSString *matchMember_str = [NSString stringWithFormat:@"%@|VS|%@",kSafeString(matchInfo_model.home),matchInfo_model.away];
            [colTitleArr addObject:kSafeString(match_Str)];
            [colTitleArr addObject:kSafeString(matchInfo_model.letball)];
            [colTitleArr addObject:kSafeString(matchMember_str)];
            //不让球
            
            if ([matchInfo_model.match_type integerValue] == 3) {
                [chartArr addObject:@[kSafeString(matchInfo_model.yz_desc),kSafeString(matchInfo_model.bd_yz_jspk),@""]];
                [chartArr addObject:@[kSafeString(matchInfo_model.dxq_desc),kSafeString(matchInfo_model.dxq_jspk),@""]];
            }else{
                [chartArr addObject:@[kSafeString(matchInfo_model.yz_desc),kSafeString(matchInfo_model.RFJSPK),@""]];
                [chartArr addObject:@[kSafeString(matchInfo_model.dxf_desc),kSafeString(matchInfo_model.DXQJSPK),@""]];
                self.tableChart.colTitleSelectBackImage = RRC4A74FFImage;
            }
            
            self.tableChart.colTitleHeight = 48 * Device_Ccale;
            self.tableChart.colTitleFont = [UIFont boldSystemFontOfSize:12 * Device_Ccale];
            self.tableChart.beginTopMagrin = 4 * Device_Ccale;
            
        }else{
            
        }
        self.tableChart.colTitleArr = colTitleArr;
        self.tableChart.dataArr = chartArr;
        
        CGFloat topMagrin = 16 * Device_Ccale;
        self.tableChart.frame = CGRectMake(0, topMagrin,ceil(self.width), ceil(self.matchModel.heightChart));
    }else{
        
        //赛事推荐
        self.tableChart.colTitleArr = @[@"场次",@"主VS客",@"类别",@"选项",@"赛果"];
        
        //需要加表头
        [self addSubview:self.matchHeadView];
        self.matchHeadView.matchInfoState = self.matchInfoState;
        
        __weak RRCMatchInfoView *weakSelf = self;
        _matchHeadView.deleteMatchInfoBlock = ^(NSString * _Nonnull matchId) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(deleteMatchByMatchModel:)]) {
                [weakSelf.delegate deleteMatchByMatchModel:weakSelf.matchModel];
            }
        };
        //分场次
        //        CGFloat allHeightChart = 0;
        if (self.matchModel.isTogetherMatch) {
            self.matchHeadView.titleLab.text = [NSString stringWithFormat:@"%@",self.matchModel.remark];
            
            NSMutableArray *chartArr = [NSMutableArray new];
            NSInteger isKeepOddsCount = 0;
            for (NSInteger i = 0; i < self.matchModel.matchArr.count; i++) {
                RRCMatchInfoModel *matchInfo_model = self.matchModel.matchArr[i];
                [chartArr addObject:@[matchInfo_model.matchId,
                                      matchInfo_model.matchMember,
                                      matchInfo_model.matchPlayMethod,
                                      matchInfo_model.matchOdds,
                                      matchInfo_model.matchStateArr]];
                isKeepOddsCount += matchInfo_model.matchOdds.count;
            }
            self.tableChart.minHeightItems = 64 * Device_Ccale;
            self.tableChart.dataArr = chartArr;
            self.tableChart.frame = CGRectMake(0, self.matchHeadView.height,ceil(self.width),ceil(self.matchModel.heightChart + self.tableChart.colTitleHeight));
        }else{
            //默认不包含亚指 单场比赛
            
            RRCMatchInfoModel *matchInfo_model = self.matchModel.matchArr.firstObject;
            NSString *match_Str = @"";
            if ([matchInfo_model.game_type integerValue] == 3) {
                self.matchHeadView.titleLab.text = [NSString stringWithFormat:@"篮球"];
                self.matchHeadView.baseImg.backgroundColor = RRC4A74FFColor;
                match_Str = [NSString stringWithFormat:@"%@|%@ |%@",kSafeString(matchInfo_model.league),kSafeString(matchInfo_model.match_time1),kSafeString(matchInfo_model.match_time2)];
            }else if ([matchInfo_model.game_type integerValue] == 4){
                self.matchHeadView.baseImg.backgroundColor = RRCThemeViewColor;
                self.matchHeadView.titleLab.text = [NSString stringWithFormat:@"足球"];
                match_Str = matchInfo_model.matchName;
            }else{
                self.matchHeadView.baseImg.backgroundColor = RRCThemeViewColor;
                self.matchHeadView.titleLab.text = [NSString stringWithFormat:@"足球"];
                match_Str = kSafeString(matchInfo_model.matchId);
            }
            
            self.matchHeadView.matchId = [NSString stringWithFormat:@"%ld",matchInfo_model.order];
            
            NSMutableArray *chartArr = [NSMutableArray new];
            
            [chartArr addObject:@[match_Str,
                                  kSafeString(matchInfo_model.matchMember),
                                  matchInfo_model.matchPlayMethod,
                                  matchInfo_model.matchOdds,
                                  matchInfo_model.matchStateArr]];
            if (matchInfo_model.matchPlayMethod.count == 1) {
                self.tableChart.beginTopMagrin = 8 * Device_Ccale;
            }else if (matchInfo_model.matchPlayMethod.count == 2){
                //两种类别，判断是否包含胜平负
                if (matchInfo_model.matchOdds.count == 2) {
                    self.tableChart.beginTopMagrin = 14 * Device_Ccale;
                }else if(matchInfo_model.matchOdds.count == 3){
                    self.tableChart.beginTopMagrin = 36 * Device_Ccale;
                }
            }else if (matchInfo_model.matchPlayMethod.count == 3){
                self.tableChart.beginTopMagrin = 36 * Device_Ccale;
            }
            
            self.tableChart.minHeightItems = self.matchModel.heightChart;
            self.tableChart.dataArr = chartArr;
            self.tableChart.frame = CGRectMake(0, self.matchHeadView.height,ceil(self.width),ceil([self.tableChart heightFromThisDataSource]));
        }
        
        //        self.height = self.tableChart.height + self.matchHeadView.height;
    }
    
    [self.tableChart showAnimation];
    
}

-(void)showChartAnimation{
    [self setUpView];
}
#pragma mark - tableChartDelegate
-(void)tableChartDelete:(JHTableChart *)chart{
    if ([RRCMatchManager sharedRRCMatchManager].matchModel.showCarIsConfirm) {
        [[RRCAlertManager sharedRRCAlertManager]showChoseWithtitle:@"修改会影响提交数据" array:@[@"取消",@"确定"] DoneBlock:^(NSInteger index) {
            
            if (index == 1) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(deleteMatchByMatchModel:)]) {
                    [self.delegate deleteMatchByMatchModel:self.matchModel];
                }
            }
        }];
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(deleteMatchByMatchModel:)]) {
            [self.delegate deleteMatchByMatchModel:self.matchModel];
        }
    }
}
-(void)tablewChart:(JHTableChart *)chart ViewForTapRow:(NSInteger)row{
//    NSLog(@"点击的位置：%ld",row);
    //只有预览的时候才能跳转
    if (self.matchInfoState == RRCMatchInfoListStatePreview) {
        RRCMatchInfoModel *currentMatchInfo = self.matchModel.matchArr.firstObject;
        if (row <= self.matchModel.matchArr.count - 1) {
            currentMatchInfo = self.matchModel.matchArr[row];
        }
        
        if ([currentMatchInfo.game_type integerValue] != 3) {
            [FFRouter routeURL:@"protocol://RRCLiveOnlineController" withParameters:@{@"ID_bet007":currentMatchInfo.ID_bet007}];
        }

    }
   
}
-(void)tablewChart:(JHTableChart *)chart ViewForButtonRow:(NSInteger)row{
    if (self.matchInfoState == RRCMatchInfoListStateAdd) {
        [FFRouter routeURL:@"protocol://RRCStatisticalController" withParameters:self.matchInfoModel.mj_JSONObject];
    }
}
-(CGFloat)tableChart:(JHTableChart *)chart widthForTableRowAtcolumn:(NSInteger)column{
    if (self.matchInfoState == RRCMatchInfoListStateAdd || self.matchInfoState == RRCMatchInfoListStateEdit) {
        if (column == 0) {
            return 70 *Device_Ccale;
        }else{
            return 0;
        }
    }else{
        return 0;
    }
}
-(CGFloat)tableChart:(JHTableChart *)chart heightAtRow:(NSInteger)row{
    if (self.matchModel.isTogetherMatch) {
        return  [self.matchModel.matchHeightArr[row] floatValue];
    }else{
        return  chart.minHeightItems;
    }
}

-(CGFloat)tableChart:(JHTableChart *)chart topMarginAtRow:(NSInteger)row{
    if (self.matchModel.isTogetherMatch) {
        return  [self.matchModel.matchTopArr[row] floatValue];
    }else{
        return  chart.beginTopMagrin;
    }
}


-(UIFont *)fontTableChart:(JHTableChart *)chart colorAtRow:(NSInteger)row andAtcolumn:(NSInteger)column{
    UIFont *font = chart.colTitleFont;
    if (self.matchInfoState == RRCMatchInfoListStateAdd || self.matchInfoState == RRCMatchInfoListStateEdit) {
        RRCMatchInfoModel *currentMatchInfo = self.matchModel.matchArr.firstObject;
        if (chart == self.tableChart && ([currentMatchInfo.match_type integerValue] == 2 || [currentMatchInfo.match_type integerValue] == 3)) {
            //主表才绘制样式,篮球绘制样式
            font = [[RRCChartConfigManager sharedRRCChartConfigManager]chartViewItemByrow:row andAtcolumn:column];
        }
        
    }
    return font;
}

-(CGFloat)tableChart:(JHTableChart *)chart heightForTableRowAtRow:(NSInteger)row column:(NSInteger)column andMatchIndex:(NSInteger)matchIndex andTagTitle:(NSString *)titleTag{
    CGFloat rowHeight = 0;
    if (self.matchInfoState == RRCMatchInfoListStateAdd || self.matchInfoState == RRCMatchInfoListStateEdit) {
        RRCMatchInfoModel *currentMatchInfo = self.matchModel.matchArr.firstObject;
        rowHeight =  [currentMatchInfo.match_type integerValue] == 2 ? 0 : 48 * Device_Ccale;
    }else  if (self.matchInfoState == RRCMatchInfoListStatePreview || self.matchInfoState == RRCMatchInfoListStateDelete) {
        RRCMatchInfoModel *currentMatchInfo = self.matchModel.matchArr.firstObject;
        if (matchIndex <= self.matchModel.matchArr.count - 1) {
            currentMatchInfo = self.matchModel.matchArr[matchIndex];
        }
        rowHeight = [[RRCChartConfigManager sharedRRCChartConfigManager]chartViewItemHeightWithMatchInfo:currentMatchInfo andByRow:row andByColum:column andTitleTag:titleTag andItemHeight:self.matchModel.heightChart];
    }
    else{
        rowHeight = 0;
    }
    return rowHeight;
}
-(UIView *)tableChart:(JHTableChart*)chart viewForContentAtRow:(NSInteger)row column:(NSInteger)column subRow:(NSInteger)subRow contentSize:(CGSize)contentSize{
    if (self.matchInfoState == RRCMatchInfoListStateAdd || self.matchInfoState == RRCMatchInfoListStateEdit) {
        return [self chartviewByColum:column andRow:row andSize:contentSize];
    }else{
        return nil;
    }
    return nil;
}

-(UIView *)chartviewByColum:(NSInteger)column andRow:(NSInteger)row andSize:(CGSize)contentSize{
    if (column == 2) {
        NSArray *chartData = [[RRCChartConfigManager sharedRRCChartConfigManager]chartDataRowWithAtRow:row andMatchInfo:self.matchInfoModel];
        return [self addSuFile:contentSize andArr:chartData andChartTag:row + 2];
    }else{
        return nil;
    }
}

-(void)tableSelectChart:(JHTableChart *)chart viewForContentAtRow:(NSInteger)row column:(NSInteger)column{
    //统计所选择数据
    RRCMatchManager *matchManeger = [RRCMatchManager sharedRRCMatchManager];
    if (matchManeger.matchModel.showCarIsConfirm) {
        
        [[RRCAlertManager sharedRRCAlertManager]showChoseWithtitle:@"修改会重置已确定的数据" array:@[@"取消",@"确定"] DoneBlock:^(NSInteger index) {
        
            if (index == 1) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(editMatchByMatchModel:)]) {
                    [self.delegate editMatchByMatchModel:self.matchModel];
                }
                
                [[RRCMatchEditManager sharedRRCMatchEditManager]enableUpdateMatchInfo:self.matchInfoModel AtRow:row column:column andhandleMatchinfo:^(BOOL result) {
                    [self showChartAnimation];
                }];
            }
        }];
    }else{
        if ([matchManeger boolInsertMatchInfoBy:self.matchInfoModel]) {
            
            UIWindow *window = [[UIApplication sharedApplication].delegate window];
            
            //获取表视图
            JHTableChart *tableChart = [self viewWithTag:row];
            UIView *view = [tableChart viewWithTag:column];
            
            //获取的OK
            CGRect frame = [tableChart convertRect:tableChart.bounds toView:window];
            frame.size = view.size;

            
            //修正X /Y 的位置
            [[RRCMatchEditManager sharedRRCMatchEditManager]enableUpdateMatchInfo:self.matchInfoModel AtRow:row column:column andhandleMatchinfo:^(BOOL result) {
                
                if (self.matchInfoModel.isShowTipRecommend) {
                    //控制箭头朝向
//                    NSInteger dropDirection = column;
//                    if (tableChart.colTitleArr.count == 2 && column == 1) {
//                        dropDirection = 2;
//                    }
                    [[RRCAlertManager sharedRRCAlertManager]showPostingWithtitle:@"赔率过低，无法选择!"];
//                    [[MGAlertHelper alert]showTipText:@"温馨提示：已有80%专家推荐该选项，请谨慎选择" andRect:frame alignmentDrop:dropDirection doneBlock:^(NSInteger index) {
//
//                    }];
                }
                [self showChartAnimation];
            }];
        }else{
            [[RRCAlertManager sharedRRCAlertManager]showPostingWithtitle:[NSString stringWithFormat:@"限制最大数量%ld",matchManeger.matchModel.matchsShopMaxNum]];
        }
    }
}

#pragma mark - private method
-(JHTableChart *)addSuFile:(CGSize)contentSize andArr:(NSArray *)arr andChartTag:(NSInteger)tag{
    //判断视图是否具有此表 如果有立即返回
    BOOL ishaveTableView = NO;
    for (UIView *s_v in self.tableChart.subviews) {
        if ([s_v isKindOfClass:[JHTableChart class]]) {
            if (s_v.tag == tag) {

                [s_v removeFromSuperview];
                
            }
        }
    }
    if (ishaveTableView) {
//        lastView =
        return nil;
    }
    JHTableChart *table = [[JHTableChart alloc] initWithFrame:CGRectMake(0, 0, contentSize.width, contentSize.height)];
    table.tag = tag;
    table.colTitleArr = arr;
    table.colTitleFont = [UIFont fontWithName:@"PingFangSC-Regular" size:12 * Device_Ccale];//
    table.delegate = self;
    table.isAllowUserInteraction = YES;
    table.colTitleHeight = 48 * Device_Ccale;//调节子类表格高度 48
    [self congigChoseTable:table];
    [table showAnimation];
    return table;
}
-(void)congigChoseTable:(JHTableChart *)table{
    
    table.beginSpace = 0;
    
    table.lineColor = RRCLineViewColor;//RRCLineViewColor
    if (self.matchInfoState == RRCMatchInfoListStateAdd || self.matchInfoState == RRCMatchInfoListStateEdit) {
        table.backgroundColor = RRCUnitViewColor;
    }else{
        table.backgroundColor = RRCInputViewColor;
    }
    table.colTitleSelectBackImage = self.tableChart.colTitleSelectBackImage;
    
}
#pragma mark - Getter/Setter
-(JHTableChart *)tableChart{
    if (!_tableChart) {
        _tableChart = [[JHTableChart alloc]init];

        _tableChart.layer.cornerRadius = 3 * Device_Ccale;
        _tableChart.colWidthArr = @[@(70.0 * Device_Ccale),@(70.0 * Device_Ccale),@(kScreenWidth - 140 * Device_Ccale)];
        _tableChart.colTitleHeight = 32 * Device_Ccale;
        
        _tableChart.colTitleFont = [UIFont fontWithName:@"PingFangSC-Semibold" size:12 * Device_Ccale];
        _tableChart.colTitleColor = RRCThemeTextColor;
        
        _tableChart.bodyTextColor = RRCThemeTextColor;
        _tableChart.bodyTextFont  = [UIFont fontWithName:@"PingFangSC-Regular" size:12*Device_Ccale];
        
        _tableChart.delegate = self;
        _tableChart.tag = 1;
        _tableChart.isAllowDeleteChart = self.matchInfoState == RRCMatchInfoListStateEdit;
        _tableChart.isAllowStatisticalChart = self.matchInfoState == RRCMatchInfoListStateAdd;
    }
    return _tableChart;
}
@end

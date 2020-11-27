//
//  ResultViewModel.h
//  竞彩建模
//
//  Created by gaoguangxiao on 2020/6/8.
//  Copyright © 2020 renrencai. All rights reserved.
//

#import "RRCViewModel.h"
#import "ResultModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^ResultDataIndexPathBlock)(NSIndexPath *indexPath);

@interface ResultViewModel : RRCViewModel

//亚指胜率
@property (strong, nonatomic) NSString *yzRateText;
//大小球胜率
@property (strong, nonatomic) NSString *dxqRateText;
//亚指以及大小球胜率
@property (strong, nonatomic) NSString *yzdxqRRateText;
//波胆胜率
@property (strong, nonatomic) NSString *bdRateText;
//竞彩胜率
@property (nonatomic , strong) NSString *jcRateText;
//出赛果场次
@property (nonatomic , strong) NSString *matchRateCount;

//查询多个赛事
-(void)requestMultipleDataWithParameters:(NSDictionary *)parameters andLocalArr:(NSArray *)locaArray andComplete:(LoadDataArrayBlock)blockList;

//保存赛事以及订单
-(void)saveMatchListWithParameters:(NSDictionary *)parameters Complete:(loadDataBOOLBlock)blockList;

/// 获取列表
/// @param blockList <#blockList description#>
-(void)previewMatchListWithParameters:(NSDictionary *)parameters Complete:(LoadDataArrayIntegerBlock)blockList;


/// 获取更多列表
/// @param parameters <#parameters description#>
/// @param blockList <#blockList description#>
-(void)previewLoadMoreMatchListWithParameters:(NSDictionary *)parameters Complete:(nonnull LoadDataArrayIntegerBlock)blockList;


/// 删除某条赛事
/// @param parameters <#parameters description#>
/// @param blockList <#blockList description#>
-(void)deleteMatchListWithParameters:(NSDictionary *)parameters Complete:(nonnull loadDataBOOLBlock)blockList;


/// 删除许多条赛事
/// @param parameters <#parameters description#>
/// @param blockList <#blockList description#>
-(void)deleteMatchArrListWithParameters:(NSDictionary *)parameters Complete:(nonnull loadDataBOOLBlock)blockList;

/// 获取联赛列表
/// @param parameters <#parameters description#>
/// @param blockList <#blockList description#>
-(void)previewMatchListLeagueWithParameters:(NSDictionary *)parameters Complete:(nonnull LoadDataArrayIntegerBlock)blockList;


/// 获取日期列表
/// @param parameters <#parameters description#>
/// @param blockList <#blockList description#>
-(void)previewDateListLeagueWithParameters:(NSDictionary *)parameters Complete:(nonnull LoadDataArrayIntegerBlock)blockList;

/// 获取指定联赛
/// @param parameters <#parameters description#>
/// @param blockList <#blockList description#>
-(void)sortMatchLeagueWithParameters:(NSArray *)parameters Complete:(nonnull LoadDataArrayBlock)blockList;


/// 下注某项联赛
/// @param re 联赛模型
/// @param blockList <#blockList description#>
-(void)betAmountResultModel:(ResultModel *)re Complete:(nonnull loadDataBOOLBlock)blockList;

-(void)scrollMatchOpenComplete:(nonnull ResultDataIndexPathBlock)blockList;

//测试脚本
-(void)testModelComplete:(nonnull LoadDataArrayIntegerBlock)blockList;
@end

NS_ASSUME_NONNULL_END

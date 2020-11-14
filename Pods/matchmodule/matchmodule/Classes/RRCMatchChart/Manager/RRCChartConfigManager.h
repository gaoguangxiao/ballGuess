//
//  RRCChartConfigManager.h
//  MXSFramework
//
//  Created by renrencai on 2019/4/30.
//  Copyright © 2019 MXS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
@class RRCMatchInfoModel;
NS_ASSUME_NONNULL_BEGIN

@interface RRCChartConfigManager : NSObject

DeclareSingleton(RRCChartConfigManager);

-(CGFloat)chartViewItemHeightWithMatchInfo:(RRCMatchInfoModel *)matchInfoModel andByRow:(NSInteger)row andByColum:(NSInteger)column andTitleTag:(NSString *)titleTag andItemHeight:(CGFloat)itemHeight;

//配置每一行的字体大小
-(UIFont *)chartViewItemByrow:(NSInteger)row andAtcolumn:(NSInteger)column;

-(NSArray *)chartDataRowWithAtRow:(NSInteger )row andMatchInfo:(RRCMatchInfoModel *)r;

/**
 胜平负率
 
 @param row <#row description#>
 @param r <#r description#>
 @return <#return value description#>
 */
-(NSMutableArray *)chartOddsRowDataWithAtRow:(NSInteger )row andMatchInfo:(RRCMatchInfoModel *)r;

/**
 亚指
 
 @param r <#r description#>
 @return <#return value description#>
 */
//-(NSArray *)chartyzRowDataWithMatchInfo:(RRCMatchInfoModel *)r;
@end

NS_ASSUME_NONNULL_END

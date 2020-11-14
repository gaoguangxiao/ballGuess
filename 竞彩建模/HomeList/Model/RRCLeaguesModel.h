//
//  RRCLeaguesModel.h
//  MXSFramework
//
//  Created by gaoguangxiao on 2019/7/16.
//  Copyright © 2019 MXS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResultModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RRCLeaguesModel : NSObject

@property (nonatomic , strong) NSString *name;

@property (nonatomic , strong) NSString *dxqRate;//联赛大小球命中率
@property (nonatomic , strong) NSString *yzRate;//联赛亚指命中率
@property (nonatomic , strong) NSString *bdRate;//联赛波胆命中率
@property (nonatomic , strong) NSString *jcRate;//联赛竞彩命中率

@property (nonatomic , assign) NSInteger isRecommend;//1 可推荐 0不可推荐

@property (nonatomic , assign) NSInteger recommendWeight;//推荐权重【5次以上】 1、某项80%以上 2、双70% 3、单项65% 4、双60%
@property (nonatomic , strong) NSString *recommendViewColor;//推荐权重【5次以上】 1、某项80%以上 2、双70% 3、单项65% 4、双60%

@property (nonatomic , assign) NSInteger counts;//联赛数量

@property (nonatomic , strong) NSString *isSelect;

/**0全部 1精简 3亚指 4大小*/
@property (nonatomic , strong) NSString *gameType;

@property (nonatomic , strong) NSMutableArray *leagueList;
@end

NS_ASSUME_NONNULL_END

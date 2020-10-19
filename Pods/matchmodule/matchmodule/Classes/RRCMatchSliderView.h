//
//  RRCMatchSliderView.h
//  MXSFramework
//
//  Created by 人人彩 on 2020/4/13.
//  Copyright © 2020 MXS. All rights reserved.
//

#import "RRCView.h"
#import "RRCMatchLiveDataStatisModel.h"
typedef enum : NSUInteger {
    LiveDataStatistics = 0,   //数据统计
    LiveMatchEvent,           //比赛事件
    MatchEventList,           //赛事列表
} RRCMatchSliderSyle;
NS_ASSUME_NONNULL_BEGIN

@interface RRCMatchSliderView : RRCView
@property (nonatomic,assign) RRCMatchSliderSyle sliderStyle;
@property (nonatomic,copy) NSString *nameStr;

@property (nonatomic,strong) RRCMatchLiveDataStatisModel *statisModel;
@end

NS_ASSUME_NONNULL_END

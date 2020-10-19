//
//  RRCNetLoopTools.h
//  NetLoopTime
//
//  Created by gaoguangxiao on 2020/4/15.
//  Copyright © 2020 gaoguangxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RRCLoopTimeModel.h"
@class CGDataResult;
NS_ASSUME_NONNULL_BEGIN

@interface RRCNetLoopTools : NSObject

//时间模型
@property (nonatomic,strong) RRCLoopTimeModel *loopTimeModel;

@property (nonatomic, strong) NSMutableArray *timerFlagArray;

@property (nonatomic, strong)void(^NetDataBlock)(CGDataResult *result);

/// 时间自加计数
@property (nonatomic, strong)void(^timeAddBlock)(float timeCount);

-(void)loadLoopRequestWithURLString:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(CGDataResult *result))success;

//注册事件循环key
-(void)registerTimerKey:(NSString *)timerKey;

//销毁
-(void)registerTimerModel:(RRCLoopTimeModel *)timerModel;
//销毁对应
-(void)unregisterTimerFlag:(NSString *)timeFlag;

-(void)updateLoopCycleTime:(NSInteger)secondTime;
@end

NS_ASSUME_NONNULL_END

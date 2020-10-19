//
//  RRCNetLoopTools.m
//  NetLoopTime
//
//  Created by gaoguangxiao on 2020/4/15.
//  Copyright © 2020 gaoguangxiao. All rights reserved.
//

#import "RRCNetLoopTools.h"

#import "RRCNetWorkManager.h"

@interface RRCNetLoopTools ()

@end

@implementation RRCNetLoopTools

-(void)loadLoopRequestWithURLString:(NSString *)URLString parameters:(NSDictionary *)parameters success:(void (^)(CGDataResult *result))success{
    
    [[RRCNetWorkManager sharedTool] loadRequestWithURLString:URLString parameters:parameters success:^(CGDataResult * _Nonnull result) {
        //如果需要循环调用 就需要注册
        if (result.status.boolValue) {
            if ([self.timerFlagArray containsObject:URLString]) {
                if ([result.data isKindOfClass:[NSDictionary class]]) {
                    if ([result.data valueForKey:@"secondTime"]) {
                        [self updateLoopCycleTime:[result.data[@"secondTime"] integerValue]];
                    }
                }
                self.loopTimeModel.parameters = parameters;
                
                [self initLoopTime:URLString];
            }
        }
        success(result);
    }];
    
}

-(void)initLoopTime:(NSString *)timeFlag{
    //    NSLog(@"%@",[NSThread currentThread]);
    self.loopTimeModel.timeKey = timeFlag;//会变化
    
    [self.loopTimeModel startFireTimer];
    
    __weak typeof(self) weakLoopSelf = self;
    self.loopTimeModel.timtCycleTargetEnd = ^(NSString * _Nonnull timeFlag) {
        
        [weakLoopSelf loopNetWorking:timeFlag];
    };
    
    self.loopTimeModel.timeAddChage = ^(float currentCount) {
        if (weakLoopSelf.timeAddBlock) {
            weakLoopSelf.timeAddBlock(currentCount);
        }
    };
    
}

-(void)loopNetWorking:(NSString *)timeFlag{
    
    if ([self.timerFlagArray containsObject:timeFlag]) {
        if (self.loopTimeModel.loopWebUrl) {
            [[RRCNetWorkManager sharedTool] loadRequestWithURLString:self.loopTimeModel.loopWebUrl parameters:self.loopTimeModel.parameters success:^(CGDataResult * _Nonnull result) {
                
                if ([result.data isKindOfClass:[NSDictionary class]]) {
                    if ([result.data valueForKey:@"secondTime"]) {
                        [self updateLoopCycleTime:[result.data[@"secondTime"] integerValue]];
                    }
                }
                
                if (self.NetDataBlock) {
                    self.NetDataBlock(result);
                }
            }];
        }else{
            if (self.NetDataBlock) {
                self.NetDataBlock([CGDataResult new]);
            }
        }
        
    }
}

-(void)registerTimerKey:(NSString *)timerKey{
    
    [self.timerFlagArray addObject:timerKey];
    
}

-(void)registerTimerModel:(RRCLoopTimeModel *)timerModel{
    //注册
    [self.timerFlagArray addObject:timerModel.timeKey];
    
    self.loopTimeModel = timerModel;
    
}

-(void)unregisterTimerFlag:(NSString *)timeFlag{
    //销毁对应
    [self.timerFlagArray removeObject:timeFlag];
    
    if (self.timerFlagArray.count == 0) {
        [self.loopTimeModel endTimer];
    }
}

-(void)updateLoopCycleTime:(NSInteger)secondWebTime{
    NSInteger secondTime = 6;//默认下次请求6秒
    if (secondWebTime >= 6 && secondWebTime <= 20) {
        secondTime = secondWebTime;
    }
    //更新下次请求时间
    self.loopTimeModel.timeCycle  = secondTime;
}

-(void)dealloc{
    NSLog(@"%@--dealloc--",self.class);
    
    [self unregisterTimerFlag:self.loopTimeModel.timeKey];
}

-(NSMutableArray *)timerFlagArray{
    if (!_timerFlagArray) {
        _timerFlagArray = [NSMutableArray new];
    }
    return _timerFlagArray;
}

-(RRCLoopTimeModel *)loopTimeModel{
    if (!_loopTimeModel) {
        _loopTimeModel = [RRCLoopTimeModel new];
    }
    return _loopTimeModel;
}
@end

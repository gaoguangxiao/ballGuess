//
//  RRCLoopTimeTools.m
//  NetLoopTime
//
//  Created by gaoguangxiao on 2020/4/15.
//  Copyright © 2020 gaoguangxiao. All rights reserved.
//

#import "RRCLoopTimeModel.h"

@interface RRCLoopTimeModel ()

@property (nonatomic, strong) NSTimer *loopTimer;
@end

@implementation RRCLoopTimeModel

-(instancetype)init{
    if (self) {
        self.timeKey = @"com.timer.app";
        self.timeSize = 1;
        self.timeCount = 0;
        self.timeBegin = [NSDate date];
        self.timeCycle = 6;
        
    }
    return self;
}

-(void)startFireTimer{
    [[NSRunLoop currentRunLoop]addTimer:self.loopTimer forMode:NSRunLoopCommonModes];
    //延迟一秒计数
    self.timeCount = -1;
    
    //立即开始计时
    [self.loopTimer fire];
}

/// 开始
-(void)startTimer{
    [self.loopTimer setFireDate:[NSDate date]];
}

-(void)pauseTimer{
    [self.loopTimer setFireDate:[NSDate distantFuture]];
}

-(void)endTimer{
    
    if (_loopTimer) {
        [_loopTimer invalidate];
        _loopTimer = nil;
    }
}

-(void)timerStartAdd:(NSTimer *)timer{
    
    self.timeCount = self.timeCount + self.timeSize;
//    NSLog(@"%f--计时--",self.timeCount);
    
    //回调时间自加
    if (self.timeAddChage) {
        self.timeAddChage(self.timeCount);
    }
    
    if (self.timeCount - self.timeCycle == 0) {
        
        self.timeCountCycle ++;//循环次数++
        
        self.requestFlag = [NSString stringWithFormat:@"%@_%ld",self.timeKey,(long)self.timeCountCycle];//由注册标志 + 循环次数 + 当前计数组成
        
//        NSLog(@"周期--标志%@",self.requestFlag);
        
        self.timeCount = 0;
        
        if (self.timtCycleTargetEnd) {
            self.timtCycleTargetEnd(self.timeKey);
        }
    }
}

-(void)setRequestFlag:(NSString *)requestFlag{
    _requestFlag = requestFlag;
    
    //设置参数
    NSMutableDictionary *loopTimeDict = [NSMutableDictionary dictionaryWithDictionary:self.parameters];//修正参数的标志
    [loopTimeDict setValue:_requestFlag forKey:@"randomNumber"];
    self.parameters = loopTimeDict;
}

-(NSTimer *)loopTimer{
    if (!_loopTimer) {
        _loopTimer = [NSTimer timerWithTimeInterval:self.timeSize target:self selector:@selector(timerStartAdd:) userInfo:nil repeats:YES];
    }
    return _loopTimer;
}
@end

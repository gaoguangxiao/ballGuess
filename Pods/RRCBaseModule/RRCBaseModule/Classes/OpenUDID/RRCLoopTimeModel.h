//
//  RRCLoopTimeTools.h
//  NetLoopTime
//
//  Created by gaoguangxiao on 2020/4/15.
//  Copyright © 2020 gaoguangxiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface RRCLoopTimeModel : NSObject

@property (nonatomic, strong) NSString *timeKey;//时间标志 首次URL
@property (nonatomic, strong) NSDictionary *parameters;//请求参数
@property (nonatomic , strong) NSString *loopWebUrl;//循环接口地址
@property (nonatomic , strong) NSString *requestFlag;//每次请求的标志，用于循环定时调用时的匹配
@property (nonatomic, strong) NSDate *timeBegin;//创建此队列时间
@property (nonatomic, assign) float timeSize;//计时器调用间隔 默认1秒
@property (nonatomic, assign) CGFloat timeCycle;//时间周期 默认6秒
@property (nonatomic, assign) float timeCount;//时间计数 自增 +timeSize
@property (nonatomic, assign) NSInteger timeCountCycle;//时间周期运行


//周期性时间达到
@property (nonatomic, strong)void(^timtCycleTargetEnd)(NSString *timeFlag);

//当前自加计数
@property (nonatomic , strong) void (^timeAddChage)(float currentCount);

/// 启动
-(void)startFireTimer;

//结束
-(void)endTimer;

/// 开始
-(void)startTimer;

///暂停
-(void)pauseTimer;
@end

NS_ASSUME_NONNULL_END

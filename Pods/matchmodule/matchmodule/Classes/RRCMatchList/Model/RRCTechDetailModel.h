//
//  RRCTechDetailModel.h
//  matchscoremodule_Example
//
//  Created by gaoguangxiao on 2020/8/4.
//  Copyright © 2020 高广校. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RRCMatchEventModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RRCTechDetailModel : NSObject

//以下为服务器原始数据
@property (nonatomic , strong) NSString *matchId;//赛事ID
@property (nonatomic , strong) NSDictionary *comepetitionEvents;//比赛进程
@property (nonatomic , strong) RRCMatchEventModel *technicalDetails;

//数据整理之后的
@property (nonatomic , strong) NSArray *shotsStatisModelArr;//比赛事件
@end

NS_ASSUME_NONNULL_END

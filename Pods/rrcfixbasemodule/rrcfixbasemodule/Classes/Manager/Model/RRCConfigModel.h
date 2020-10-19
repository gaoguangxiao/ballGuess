//
//  RRCConfigModel.h
//  MXSFramework
//
//  Created by gaoguangxiao on 2019/10/24.
//  Copyright © 2019 MXS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RRCConfigModel : NSObject

/**赛事筛选条件 */
@property (nonatomic, assign) NSInteger matchSortType;

///默认选中公司
@property (nonatomic , strong) NSString *lotteryId;

/**是否知道已完场的赛果 0未知 1已知，用于战绩列表的弹框*/
@property (nonatomic, strong) NSString *isKnowMatchRules;

/** 极光注册的register_id，每次启动都更新获取*/
@property (nonatomic, strong) NSString *registerId;

@end

NS_ASSUME_NONNULL_END

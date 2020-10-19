//
//  RRCMatchConditionViewController.h
//  MXSFramework
//
//  Created by gaoguangxiao on 2019/7/12.
//  Copyright © 2019 MXS. All rights reserved.
//

#import "RRCRootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface RRCLeagueConditionViewController : RRCRootViewController

/**
 赛事筛选确定按钮
 */
@property (nonatomic, strong) void(^submitChoseCondition)(NSArray *arr,NSString *title);
@end

NS_ASSUME_NONNULL_END

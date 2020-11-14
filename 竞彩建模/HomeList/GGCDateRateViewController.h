//
//  GGCDateRateViewController.h
//  竞彩建模
//
//  Created by gaoguangxiao on 2020/9/29.
//  Copyright © 2020 renrencai. All rights reserved.
//

#import "RRCRootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GGCDateRateViewController : RRCRootViewController

/**
 日期筛选确定按钮
 */
@property (nonatomic, strong) void(^submitChoseCondition)(NSArray *arr,NSString *title);
@end

NS_ASSUME_NONNULL_END

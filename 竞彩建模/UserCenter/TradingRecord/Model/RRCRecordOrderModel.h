//
//  RRCRecordOrderModel.h
//  竞彩建模
//
//  Created by gaoguangxiao on 2020/11/17.
//  Copyright © 2020 renrencai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RRCRecordOrderModel : NSObject

@property (nonatomic, strong) NSString *home;//主队名字
@property (nonatomic, strong) NSString *away;//客队名字
@property (nonatomic , strong) NSString *league;//联赛名字
@property (nonatomic , strong) NSString *match_id;
@property (nonatomic , strong) NSString *hmd;//比赛时间
@property (nonatomic , strong) NSString *create_time;

@property (nonatomic , strong) NSString *userForecastCount;
@property (nonatomic , strong) NSString *order_no;
@end

NS_ASSUME_NONNULL_END

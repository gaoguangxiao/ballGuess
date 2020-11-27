//
//  RRCMatchRateModel.h
//  竞彩建模
//
//  Created by gaoguangxiao on 2020/9/29.
//  Copyright © 2020 renrencai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RRCMatchRateModel : NSObject

@property (nonatomic , strong) NSString *mmdd;//月日
@property (nonatomic , strong) NSString *hhmm;//时分

@property (nonatomic , assign) NSInteger counts;//每天数量 0 ~ 24 天

@property (nonatomic , strong) NSString *isSelect;

@property (nonatomic , strong) NSMutableArray *dateMartchList;


@property (nonatomic , strong) NSString *dxqRate;//联赛大小球命中率
@property (nonatomic , strong) NSString *yzRate;//联赛亚指命中率
@property (nonatomic , strong) NSString *bdRate;//联赛波胆命中率
@property (nonatomic , strong) NSString *jcRate;//联赛竞彩命中率
@property (nonatomic , strong) NSString *dxqYzRate;//联赛大小球亚指盈利和
@end

NS_ASSUME_NONNULL_END

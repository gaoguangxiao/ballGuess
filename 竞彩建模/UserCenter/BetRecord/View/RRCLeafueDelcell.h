//
//  RRCLeafueDelcell.h
//  竞彩建模
//
//  Created by gaoguangxiao on 2020/11/6.
//  Copyright © 2020 renrencai. All rights reserved.
//

#import "RRCTableViewCell.h"

#import "RRCBetRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RRCLeafueDelcell : RRCTableViewCell


@property (nonatomic , strong) void(^didActionUpdateScore)(RRCBetRecordModel *betM);

@property (nonatomic , strong) RRCBetRecordModel *leResultModel;

@end

NS_ASSUME_NONNULL_END

//
//  ResultTableViewCell.h
//  竞彩建模
//
//  Created by gaoguangxiao on 2020/6/8.
//  Copyright © 2020 renrencai. All rights reserved.
//

#import "RRCTableViewCell.h"
#import "ResultModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface GGXWarResultCell : RRCTableViewCell

//@property (nonatomic , strong) ResultModel ;

-(void)setupResultModel:(ResultModel *)resultModel;

@end

NS_ASSUME_NONNULL_END

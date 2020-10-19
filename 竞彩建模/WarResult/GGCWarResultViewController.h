//
//  GGCWarResultViewController.h
//  竞彩建模
//
//  Created by gaoguangxiao on 2020/6/9.
//  Copyright © 2020 renrencai. All rights reserved.
//

#import "RRCRootViewController.h"
@class ResultModel;
NS_ASSUME_NONNULL_BEGIN

@interface GGCWarResultViewController : RRCRootViewController

@property (nonatomic , strong) NSString *homeName;

@property (nonatomic , strong) ResultModel *lastResultModel;

@end

NS_ASSUME_NONNULL_END

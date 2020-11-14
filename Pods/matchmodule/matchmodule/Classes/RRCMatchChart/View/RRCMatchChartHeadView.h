//
//  RRCMatchHeadView.h
//  MXSFramework
//
//  Created by renrencai on 2019/4/18.
//  Copyright © 2019年 MXS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RRCMatchInfoView.h"
NS_ASSUME_NONNULL_BEGIN

@interface RRCMatchChartHeadView : UIView

@property (nonatomic , strong) void(^deleteMatchInfoBlock)(NSString *matchId);

@property (nonatomic , assign) RRCMatchInfoListState matchInfoState;

/** 赛事ID*/
@property (nonatomic , strong) NSString *matchId;

@property (nonatomic , strong) UILabel *titleLab;

@property (nonatomic , strong) UIImageView *baseImg;
//-(void)set
@end

NS_ASSUME_NONNULL_END

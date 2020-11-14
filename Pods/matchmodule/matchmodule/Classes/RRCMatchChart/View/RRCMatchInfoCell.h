//
//  RRCMatchInfoCell.h
//  JHChartDemo
//
//  Created by renrencai on 2019/4/17.
//  Copyright © 2019年 JH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RRCMatchInfoView.h"
NS_ASSUME_NONNULL_BEGIN

@interface RRCMatchInfoCell : UITableViewCell

@property (nonatomic , strong) RRCMatchInfoModel *matchInfoModel;

@property (nonatomic , assign) CGFloat chartHeight;

@property (nonatomic , weak)id<RRCMatchHandleProtocol>delegate;

/**
 列表展示状态
 */
@property (nonatomic , assign) RRCMatchInfoListState matchInfoState;

-(void)setUpMatchInfoList:(RRCMatchModel *)matchModel;
@end

NS_ASSUME_NONNULL_END

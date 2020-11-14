//
//  RRCMatchListView.h
//  MXSFramework
//
//  Created by renrencai on 2019/4/18.
//  Copyright © 2019年 MXS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RRCMatchInfoView.h"

@class RRCMatchChartConfig;
NS_ASSUME_NONNULL_BEGIN

@interface RRCMatchListView : UIView


@property (nonatomic , weak)id<RRCMatchHandleProtocol>delegate;
/**
 列表展示状态
 */
@property (nonatomic , assign) RRCMatchInfoListState matchInfoState;

@property (nonatomic , strong) RRCMatchChartConfig *matchConfig;

@property (nonatomic , strong) NSMutableArray *matchListArr;

//加载数据
-(void)beginRefreshing;

-(void)reloadMatchList;

-(void)endRefreshing;

@property (nonatomic , assign) CGFloat tableViewheight;


-(void)reloadDataAndOffyToTop;
@end

NS_ASSUME_NONNULL_END

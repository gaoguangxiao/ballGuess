//
//  RecommendListView.h
//  MXSFramework
//
//  Created by 人人彩 on 2019/4/18.
//  Copyright © 2019 MXS. All rights reserved.
//

#import "RRCView.h"
#import "RRCMatchInfoView.h"
NS_ASSUME_NONNULL_BEGIN

@interface RecommendListView : RRCView

/// 隐藏视图回调
@property (nonatomic , strong) void(^hiddnRecommendViewScreen) (void);

-(void)showGameScreen;

@property (nonatomic , weak)id<RRCMatchHandleProtocol>delegate;

/** 推荐草稿数据*/
@property (nonatomic , strong)NSArray *draftArr;

@property (nonatomic , strong) NSMutableArray *matchListShowArr;

-(void)reloadList;
@end

NS_ASSUME_NONNULL_END

//
//  RRCMatchInfoView.h
//  JHChartDemo
//
//  Created by renrencai on 2019/4/17.
//  Copyright © 2019年 JH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RRCMatchProtocol.h"
//#import "RRCMatchModelHeader.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, RRCMatchInfoListState) {
    RRCMatchInfoListStateAdd = 0,
    RRCMatchInfoListStateEdit,
    RRCMatchInfoListStateDelete,      //帖子删除
    RRCMatchInfoListStatePreview,
    RRCMatchInfoListStateCommentDelete //评论删除
};

@interface RRCMatchInfoView : UIView

@property (nonatomic , weak)id<RRCMatchHandleProtocol>delegate;

/**
 列表展示状态
 */
@property (nonatomic , assign) RRCMatchInfoListState matchInfoState;

/** 赛事模型*/
@property (nonatomic , strong) RRCMatchModel *matchModel;

-(void)showChartAnimation;
@end

NS_ASSUME_NONNULL_END

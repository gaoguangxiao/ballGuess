//
//  RRCMatchModel.h
//  MXSFramework
//
//  Created by renrencai on 2019/4/18.
//  Copyright © 2019年 MXS. All rights reserved.
//  赛事模型：控制视图如何显示以及单场数据

#import <Foundation/Foundation.h>


@class RRCMatchInfoModel;
NS_ASSUME_NONNULL_BEGIN

@interface RRCMatchModel : NSObject

/** 赛事推荐添加 默认NO 赛事添加 YES*/
//@property (nonatomic , assign) BOOL isMatchAdd;
//@property (nonatomic , assign) CGFloat topMargin;//距离顶部距离
#pragma mark - 赛事属性
@property (nonatomic , strong) NSString *ID;

@property (nonatomic , strong) NSString *user_id;

/** 几串几*/
@property (nonatomic , strong) NSString *remark;

@property (nonatomic , strong) NSString *game_type;

/** 是否是串子*/
@property (nonatomic , assign) BOOL isTogetherMatch;

/** 存储每场比赛*/
@property (nonatomic , strong) NSArray <RRCMatchInfoModel *>*matchArr;

@property (nonatomic , strong) NSArray *matchHeightArr;//每场比赛的高度

@property (nonatomic , strong) NSArray *matchTopArr;//每场比赛顶部间距

@property (nonatomic , assign) CGFloat heightChart;//表格总高度

@property (nonatomic , assign) CGFloat heightTitleChart;//加入标题高度

#pragma mark - 赛事购物车属性
//------------APP内使用----------
/** 赛事购物车 购物车最大数量*/
@property (nonatomic , assign) NSInteger matchsShopMaxNum;

/** 赛事购物车 当前购物车数量*/
@property (nonatomic , strong) NSString *matchsShopNum;

/** 购物车数据*/
@property (nonatomic , strong) NSMutableArray *matchsShopCarArr;

/** 购物车数据是否更新：默认NO，每次加减都会为YES，预览购物车处理之后为NO*/
@property (nonatomic , assign) BOOL shopCarArrIsUpdate;

/** 赛事是否确认过 默认：NO，每次确认购物车为YES，购物车更新，用户确认之后为NO*/
@property (nonatomic , assign) BOOL showCarIsConfirm;

/*单场Model数据缓存*/
@property (nonatomic , strong) NSArray *matchsListModelsArr;

//单场提交的数量
@property (nonatomic , strong) NSString *matchSubmitNum;
//是否有串子
@property (nonatomic , assign) BOOL isSeries;
//串子提交的数量
@property (nonatomic , strong) NSString *seriesSubmitNum;
@end

NS_ASSUME_NONNULL_END

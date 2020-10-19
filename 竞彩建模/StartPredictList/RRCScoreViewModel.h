//
//  RRCScoreViewModel.h
//  MXSFramework
//
//  Created by gaoguangxiao on 2020/4/14.
//  Copyright © 2020 MXS. All rights reserved.
//

#import "RRCViewModel.h"
#import <UIKit/UIKit.h>
@class RRCTScoreModel;
NS_ASSUME_NONNULL_BEGIN

@protocol RRRCScoreViewModelDelegate <NSObject>

/// 数据加载完毕代理方法、用户操作行为，不得使用此数据
/// @param matchCondition 执行的列表
/// @param array 列表数据
-(void)dataFinishload:(NSInteger)matchCondition andlistArray:(NSArray *)array;

@end

@interface RRCScoreViewModel : RRCViewModel

//赛事列表车
@property (nonatomic , strong) NSMutableArray *matchListCar;

@property (nonatomic, weak) id<RRRCScoreViewModelDelegate> delegate;

/// 展开的动画直播位置 默认 -1、
@property (nonatomic , assign) NSInteger eventViewTag;
@property (nonatomic , assign) BOOL teamEventOpenTag;
@property (nonatomic , assign) BOOL teamStadiumOpenTag;

-(NSInteger)getNumberOfRow;//获取列表数目

//预先的高度
-(CGFloat)getCellRowHeightAtIndexPath:(NSIndexPath *)indexPath;

//获取某一行的model
-(RRCTScoreModel *)getCurrentScoreModelAtIndexPath:(NSIndexPath *)indexPath;

- (void)requestWithMatchCondition: (NSInteger )matchCondition
                       parameters: (NSDictionary *)parameters
                          success:(void(^)(NSArray *loadArr,BOOL isLoadsuc))blockScoreList;

- (void)requestReloadWithMatchCondition: (NSInteger )matchCondition
parameters: (NSDictionary *)parameters
                                success:(nonnull void (^)(NSArray * _Nonnull, BOOL))blockScoreList;

/// 更新比分置顶状态
/// @param indexPath 位置
/// @param complete 状态block
-(void)updateScoreListTopStatus:(NSIndexPath *)indexPath
            andLoadDeleteResult:(loadDataBOOLBlock)complete;

/// 重新排序列表数据
-(void)resetSortListForTopStatus;

/// 是否能否本地排序
-(BOOL)sortEnableWithCondition:(NSInteger)matchCondition;

/// 比赛事件展开
/// @param openEvent <#openEvent description#>
/// @param indexPath <#indexPath description#>
/// @param complete <#complete description#>
-(void)changeMatchEventStatus:(BOOL)openEvent andIndexPath:(NSIndexPath *)indexPath andomplete:(loadDataBOOLBlock)complete;


/// 球场事件展开
/// @param openStadium <#openStadium description#>
/// @param indexPath <#indexPath description#>
/// @param complete <#complete description#>
-(void)changeStadiumSizeEventStatus:(BOOL)openStadium andIndexPath:(NSIndexPath *)indexPath andomplete:(loadDataBOOLBlock)complete;
@end

NS_ASSUME_NONNULL_END

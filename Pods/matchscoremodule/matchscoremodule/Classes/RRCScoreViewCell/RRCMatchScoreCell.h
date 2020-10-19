//
//  RRCMatchScoreCell.h
//  matchscoremodule
//
//  Created by gaoguangxiao on 2020/5/16.
//

#import "RRCTableViewCell.h"
@class RRCTScoreModel;
NS_ASSUME_NONNULL_BEGIN
@protocol RRCMatchScoreCellDelegate <NSObject>

@optional;
/**
 收藏状态

 @param indexPath 是否收藏
 @param matchID 赛事ID
 @param isResult 收藏结果，网络成功
 */
-(void)UpdatecollectStatusWithIndexPath:(NSIndexPath *)indexPath andMatchID:(NSString *)matchID andCompleteStatus:(nonnull void (^)(BOOL))isResult;


/// 置顶状态
/// @param indexPath 当前位置
/// @param matchID <#matchID description#>
/// @param isResult <#isResult description#>
-(void)UpdateTopStatusWithisTop:(NSIndexPath *)indexPath andMatchID:(NSString *)matchID andCompleteStatus:(nonnull void (^)(BOOL))isResult;


/// 赛事事件展开
/// @param openEvent 是否打开赛事事件
/// @param indexPath <#indexPath description#>
-(void)UpdateMatchEventStatus:(BOOL)openEvent andIndexPath:(NSIndexPath *)indexPath;

@end
@interface RRCMatchScoreCell : RRCTableViewCell

//球场替代视图
@property (nonatomic , strong)UIButton *eventPlaceholderView;

@property(nonatomic, weak)id<RRCMatchScoreCellDelegate>delegate;

-(void)setupScoreModel:(RRCTScoreModel *)scoreModel;

@end

NS_ASSUME_NONNULL_END

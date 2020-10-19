//
//  RRCTeamVSEventView.h
//  matchscoremodule
//
//  Created by gaoguangxiao on 2020/5/19.
//

#import "RRCView.h"
@class RRCTScoreModel;
NS_ASSUME_NONNULL_BEGIN

@interface RRCTeamVSEventView : RRCView

@property (nonatomic , strong) void(^StadiumSizeChangeBlock) (BOOL isOpenStadium);

@property (nonatomic , strong) void(^viewActionBlock) (NSString *eventID);

@property (nonatomic , strong) void(^EventChangeBlock) (BOOL isOpenEvent);

-(void)setupTeamVsEventData:(RRCTScoreModel *)scoreModel;


/// 更新动画直播关联的事件 不更新动画网址，当没有动画直播时
/// @param scoreModel <#scoreModel description#>
-(void)updateTeamVsEventData:(RRCTScoreModel *)scoreModel;
@end

NS_ASSUME_NONNULL_END

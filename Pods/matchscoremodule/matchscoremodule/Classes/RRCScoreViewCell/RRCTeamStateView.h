//
//  RRCTeamStateView.h
//  matchscoremodule
//
//  Created by gaoguangxiao on 2020/5/19.
//

#import "RRCView.h"
@class RRCTScoreModel;
NS_ASSUME_NONNULL_BEGIN

@interface RRCTeamStateView : RRCView

-(void)setupTeamStateData:(RRCTScoreModel *)scoreModel;

@end

NS_ASSUME_NONNULL_END

//
//  RRCTeamVSScoreView.h
//  matchscoremodule
//
//  Created by gaoguangxiao on 2020/5/16.
//

#import "RRCView.h"
@class RRCTScoreModel;
NS_ASSUME_NONNULL_BEGIN

@interface RRCTeamVSScoreView : RRCView

/// 收藏按钮
@property (nonatomic , strong) UIButton *collectStatusBtn;

-(void)setupTeamData:(RRCTScoreModel *)scoreModel;
@end

NS_ASSUME_NONNULL_END

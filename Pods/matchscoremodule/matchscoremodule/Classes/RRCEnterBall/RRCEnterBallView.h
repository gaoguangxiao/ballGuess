//
//  RRCEnterBallCell.h
//  MXSFramework
//
//  Created by gaoguangxiao on 2019/7/10.
//  Copyright © 2019 MXS. All rights reserved.
//

#import "RRCView.h"
@class RRCTScoreModel;
NS_ASSUME_NONNULL_BEGIN

@interface RRCEnterBallView : RRCView

-(void)setupBrandscoreMode:(RRCTScoreModel *)scoreModel;

-(void)playUrl:(NSString *)playUrl;

@end

NS_ASSUME_NONNULL_END

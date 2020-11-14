//
//  RRCBallProtocol.h
//  MXSFramework
//
//  Created by gaoguangxiao on 2019/6/6.
//  Copyright © 2019 MXS. All rights reserved.
//

#ifndef RRTCBallProtocol_h
#define RRTCBallProtocol_h

@class RRCMatchInfoModel;
@protocol RRCBallProtocol <NSObject>


/**
 改变球类选中状态

 @param matchInfoModel 赛事模型
 */
-(void)updateBallMatchInfo:(RRCMatchInfoModel *)matchInfoModel AtRow:(NSInteger)row Atcolumn:(NSInteger)column;

@optional;
-(void)sortBallPlayMethodByMatchInfo:(RRCMatchInfoModel *)matchInfoModel;

@end

#endif /* RRTCBallProtocol_h */

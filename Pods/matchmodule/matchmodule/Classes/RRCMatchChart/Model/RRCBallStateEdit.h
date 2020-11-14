//
//  RRCBallStateEdit.h
//  MXSFramework
//
//  Created by gaoguangxiao on 2019/6/6.
//  Copyright © 2019 MXS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
// 球的类型
typedef enum : NSUInteger {
    RRCBallType_Race, //竞彩球
    RRCBallType_NorthS, //北单球
    RRCBallType_Basket,  //篮球
    RRCBallType_YaPanBall//亚指球
} RRCBallType;

@class RRCMatchInfoModel;
@interface RRCBallStateEdit : NSObject

- (instancetype)initWithType:(RRCBallType)type;


/**
 更新球状态

 @param matchInfoModel <#matchInfoModel description#>
 @param row <#row description#>
 @param column <#column description#>
 */
-(void)updateBallStateMatchInfo:(RRCMatchInfoModel *)matchInfoModel AtRow:(NSInteger)row Atcolumn:(NSInteger)column;


-(void)sortBallPlayMathodMatchInfo:(RRCMatchInfoModel *)matchInfo;
@end

NS_ASSUME_NONNULL_END

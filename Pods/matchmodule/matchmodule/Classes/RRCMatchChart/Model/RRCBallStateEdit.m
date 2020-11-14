//
//  RRCBallStateEdit.m
//  MXSFramework
//
//  Created by gaoguangxiao on 2019/6/6.
//  Copyright © 2019 MXS. All rights reserved.
//

#import "RRCBallStateEdit.h"
#import "RRCBallProtocol.h"
#import "RRCRaceBallEdit.h"
#import "RRCNorthSBallEdit.h"
#import "RRCBasketBallEdit.h"
#import "RRCYaPanBallEdit.h"
@interface RRCBallStateEdit ()
{
    id<RRCBallProtocol>  ballEdit;
}
@end

@implementation RRCBallStateEdit

- (instancetype)initWithType:(RRCBallType)type{
    self = [super init];
    if (self) {
        [self initPlayerWithType:type];
    }
    return self;
}

// 初始化赛事类型
- (void)initPlayerWithType:(RRCBallType)type{
    switch (type) {
        case RRCBallType_Race:{
            ballEdit = [[RRCRaceBallEdit alloc] init];
            break;
        }
        case RRCBallType_NorthS:{
            ballEdit = [[RRCNorthSBallEdit alloc] init];
            break;
        }
        case RRCBallType_Basket:{
            ballEdit = [[RRCBasketBallEdit alloc] init];
            break;
        }
        case RRCBallType_YaPanBall:{
            ballEdit = [[RRCYaPanBallEdit alloc] init];
            break;
        }
    }
}

-(void)updateBallStateMatchInfo:(RRCMatchInfoModel *)matchInfoModel AtRow:(NSInteger)row Atcolumn:(NSInteger)column{
    [ballEdit updateBallMatchInfo:matchInfoModel AtRow:row Atcolumn:column];
}

-(void)sortBallPlayMathodMatchInfo:(RRCMatchInfoModel *)matchInfo{
    [ballEdit sortBallPlayMethodByMatchInfo:matchInfo];
}
@end

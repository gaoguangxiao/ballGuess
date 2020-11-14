//
//  RRCTechDetailModel.m
//  matchscoremodule_Example
//
//  Created by gaoguangxiao on 2020/8/4.
//  Copyright © 2020 高广校. All rights reserved.
//

#import "RRCTechDetailModel.h"
#import "MJExtension.h"
#import "RRCMatchLiveDataStatisModel.h"


@implementation RRCTechDetailModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"shotsStatisModelArr" : @"RRCMatchLiveDataStatisModel",@"technicalDetails":@"RRCMatchEventModel"};
}

-(id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    if ([property.name isEqualToString:@"technicalDetails"]) {
        self.technicalDetails = [RRCMatchEventModel mj_objectWithKeyValues:oldValue];
        
        if (self.technicalDetails) {
            NSMutableArray *techArr = [NSMutableArray new];
                 RRCMatchLiveDataStatisModel *dataStatisModel1 = [RRCMatchLiveDataStatisModel mj_objectWithKeyValues:@{@"home":self.technicalDetails.homeBallControlRate,@"away":self.technicalDetails.visitingTeamBallControlRate,@"type":@"控球率"}];
                 
                 RRCMatchLiveDataStatisModel *dataStatisModel2 = [RRCMatchLiveDataStatisModel mj_objectWithKeyValues:@{@"home":self.technicalDetails.homeDangerousAttack,@"away":self.technicalDetails.visitingTeamDangerousAttack,@"type":@"危险进攻次数"}];
            
                 RRCMatchLiveDataStatisModel *dataStatisModel3 = [RRCMatchLiveDataStatisModel mj_objectWithKeyValues:@{@"home":self.technicalDetails.homeAttack,@"away":self.technicalDetails.visitingTeamAttack,@"type":@"进攻次数"}];
               
                 RRCMatchLiveDataStatisModel *dataStatisModel4 = [RRCMatchLiveDataStatisModel mj_objectWithKeyValues:@{@"home":self.technicalDetails.homeShootPositive,@"away":self.technicalDetails.visitingTeamShootPositive,@"type":@"射正次数"}];
                 
                 RRCMatchLiveDataStatisModel *dataStatisModel5 = [RRCMatchLiveDataStatisModel mj_objectWithKeyValues:@{@"home":self.technicalDetails.homeShootNumber,@"away":self.technicalDetails.visitingTeamShootNumber,@"type":@"射门次数"}];

                 [techArr addObject:dataStatisModel1];
                 [techArr addObject:dataStatisModel2];
                 [techArr addObject:dataStatisModel3];
                 [techArr addObject:dataStatisModel4];
                 [techArr addObject:dataStatisModel5];
                 
                 self.shotsStatisModelArr = techArr.copy;
        }
        
    }
    return oldValue;
}

@end

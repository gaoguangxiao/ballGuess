//
//  RRCTScoreModel.m
//  MXSFramework
//
//  Created by gaoguangxiao on 2019/7/9.
//  Copyright © 2019 MXS. All rights reserved.
//

#import "RRCTScoreModel.h"
#import "MJExtension.h"
#import "RRCMatchLiveDataStatisModel.h"
#import "RRCDeviceConfigure.h"
@implementation RRCTScoreModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"shotsStatisModelArr" : @"RRCMatchLiveDataStatisModel",@"technicalDetails":@"RRCMatchEventModel"};
}

-(id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    if ([property.name isEqualToString:@"technicalDetails"]) {
//        self.technicalDetails = [RRCMatchEventModel mj_objectWithKeyValues:oldValue];
//
        NSMutableArray *techArr = [NSMutableArray new];
//        RRCMatchLiveDataStatisModel *dataStatisModel1 = [RRCMatchLiveDataStatisModel mj_objectWithKeyValues:@{@"home":self.technicalDetails.homeBallControlRate,@"away":self.technicalDetails.visitingTeamBallControlRate,@"type":@"控球率"}];
//
//        RRCMatchLiveDataStatisModel *dataStatisModel2 = [RRCMatchLiveDataStatisModel mj_objectWithKeyValues:@{@"home":self.technicalDetails.homeDangerousAttack,@"away":self.technicalDetails.visitingTeamDangerousAttack,@"type":@"危险进攻次数"}];
//
//        RRCMatchLiveDataStatisModel *dataStatisModel3 = [RRCMatchLiveDataStatisModel mj_objectWithKeyValues:@{@"home":self.technicalDetails.homeAttack,@"away":self.technicalDetails.visitingTeamAttack,@"type":@"进攻次数"}];
//
//        RRCMatchLiveDataStatisModel *dataStatisModel4 = [RRCMatchLiveDataStatisModel mj_objectWithKeyValues:@{@"home":self.technicalDetails.homeShootPositive,@"away":self.technicalDetails.visitingTeamShootPositive,@"type":@"射正次数"}];
//
//        RRCMatchLiveDataStatisModel *dataStatisModel5 = [RRCMatchLiveDataStatisModel mj_objectWithKeyValues:@{@"home":self.technicalDetails.homeShootNumber,@"away":self.technicalDetails.visitingTeamShootNumber,@"type":@"射门次数"}];
//
//        [techArr addObject:dataStatisModel1];
//        [techArr addObject:dataStatisModel2];
//        [techArr addObject:dataStatisModel3];
//        [techArr addObject:dataStatisModel4];
//        [techArr addObject:dataStatisModel5];
//
        self.shotsStatisModelArr = techArr.copy;
    }
    return oldValue;
}
-(RRCTScoreModel *)replaceMJDataByNewModel:(RRCTScoreModel *)m{
    
    self.hmd       = m.hmd != nil ? m.hmd : self.hmd;
    self.color     = m.color != nil ? m.color : self.color;
    
    self.homeTeamRanking = m.homeTeamRanking != nil ? m.homeTeamRanking : self.homeTeamRanking;
    self.awayTeamRanking = m.awayTeamRanking != nil ? m.awayTeamRanking : self.awayTeamRanking;
    
    self.homeScore = m.homeScore != nil ? m.homeScore : self.homeScore;
    self.awayScore = m.awayScore != nil ? m.awayScore : self.awayScore;
    
    self.bc1       = m.bc1     != nil ? m.bc1     : self.bc1;
    self.bc2       = m.bc2     != nil ? m.bc2     : self.bc2;
    self.corner1   = m.corner1 != nil ? m.corner1 : self.corner1;
    self.corner2   = m.corner2 != nil ? m.corner2 : self.corner2;
    
    self.live      = m.live    != nil ? m.live    : self.live;
    
    self.yellow1   = m.yellow1 != nil ? m.yellow1 : self.yellow1;
    self.yellow2   = m.yellow2 != nil ? m.yellow2 : self.yellow2;
    self.red1      = m.red1    != nil ? m.red1    : self.red1;
    self.red2      = m.red2    != nil ? m.red2    : self.red2;
    
    self.stateDesc = m.stateDesc != nil ? m.stateDesc : self.stateDesc;
    self.state     = m.state     != nil ? m.state     : self.state;
    
    //    self.JSPK      = m.JSPK  != nil ? m.JSPK  : self.JSPK;
    self.HJSPL     = m.HJSPL != nil ? m.HJSPL : self.HJSPL;
    self.JSPKDesc  = m.JSPKDesc  != nil ? m.JSPKDesc  : self.JSPKDesc;
    self.WJSPL     = m.WJSPL != nil ? m.WJSPL : self.WJSPL;
    
    //XX比分变化：升降状态不为空、闲置状态、赔率初始状态和新状态不相等
    //如果异常
    if ([self.HJSPL isEqualToString:@"-"] || [self.HJSPL isEqualToString:@"封"]) {
        self.HJSPLFlag      = @"0";
    }else{
        if (m.HJSPLFlag  != nil) {
            if ([m.HJSPLFlag integerValue] != 0) {//升降状态为激活
                self.HJSPLFlag = m.HJSPLFlag;
                self.HJSPLFlagTimer = 10;//开始倒计时10S高亮
            }else{
                if (self.HJSPLFlagTimer == 0) {
                    self.HJSPLFlag = m.HJSPLFlag;
                }
            }
        }
    }
    
    if ([self.JSPKDesc isEqualToString:@"-"] || [self.JSPKDesc isEqualToString:@"封"]) {
        self.JSPKFlag = @"0";
    }else{
        if (m.JSPKFlag != nil) {
            if ([m.JSPKFlag integerValue] != 0) {
                self.JSPKFlag = m.JSPKFlag;
                self.JSPKFlagTimer = 30;
            }else{
                if (self.JSPKFlagTimer == 0) {
                    self.JSPKFlag = m.JSPKFlag;
                }
            }
        }
    }
    
    if ([self.WJSPL isEqualToString:@"-"] || [self.WJSPL isEqualToString:@"封"]) {
        self.WJSPLFlag = @"0";
    }else{
        if (m.WJSPLFlag != nil) {
            if ([m.WJSPLFlag integerValue] != 0) {
                self.WJSPLFlag = m.WJSPLFlag;
                self.WJSPLFlagTimer = 10;
            }else{
                if (self.WJSPLFlagTimer == 0) {
                    self.WJSPLFlag = m.WJSPLFlag;
                }
            }
        }
    }
    
    //    self.JSPKFlag  = (m.JSPKFlag  != nil && self.JSPKFlagTimer == 0)? m.JSPKFlag  : self.JSPKFlag;
    //    self.HJSPLFlag = m.HJSPLFlag != nil ? m.HJSPLFlag : self.HJSPLFlag;
    //    self.WJSPLFlag = m.WJSPLFlag != nil ? m.WJSPLFlag : self.WJSPLFlag;
    
    self.DXQ_HJSPL = m.DXQ_HJSPL != nil ? m.DXQ_HJSPL : self.DXQ_HJSPL;
    self.DXQDesc   = m.DXQDesc   != nil ? m.DXQDesc   : self.DXQDesc;
    self.DXQ_WJSPL = m.DXQ_WJSPL != nil ? m.DXQ_WJSPL : self.DXQ_WJSPL;
    
    if ([self.DXQ_HJSPL isEqualToString:@"-"] || [self.DXQ_HJSPL isEqualToString:@"封"]) {
        self.DXQ_HJSPLFlag = @"0";
    }else{
        if ([m.DXQ_HJSPLFlag integerValue] != 0) {
            self.DXQ_HJSPLFlag = m.DXQ_HJSPLFlag;
            self.DXQ_HJSPLFlagTimer = 10;
        }else{
            //1变色期间
            if (self.DXQ_HJSPLFlagTimer == 0) {
                self.DXQ_HJSPLFlag = m.DXQ_HJSPLFlag;
            }
        }
    }
    
    if ([self.DXQDesc isEqualToString:@"-"] || [self.DXQDesc isEqualToString:@"封"]) {
        self.DXQ_JSPKFlag = @"0";
    }else{
        if (m.DXQ_JSPKFlag  != nil ) {
            if ([m.DXQ_JSPKFlag integerValue] != 0) {
                self.DXQ_JSPKFlag = m.DXQ_JSPKFlag;
                self.DXQ_JSPKFlagTimer = 30;
            }else{
                if (self.DXQ_JSPKFlagTimer == 0) {
                    self.DXQ_JSPKFlag = m.DXQ_JSPKFlag;
                }
            }
        }
        
    }
    
    if ([self.DXQ_WJSPL isEqualToString:@"-"] || [self.DXQ_WJSPL isEqualToString:@"封"]) {
        self.DXQ_WJSPLFlag = @"0";
    }else{
        if (m.DXQ_WJSPLFlag  != nil) {
            if ([m.DXQ_WJSPLFlag integerValue] != 0) {
                self.DXQ_WJSPLFlag = m.DXQ_WJSPLFlag;
                self.DXQ_WJSPLFlagTimer = 10;
            }else{
                if (self.DXQ_WJSPLFlagTimer == 0) {
                    self.DXQ_WJSPLFlag = m.DXQ_WJSPLFlag;
                }
            }
        }
        
    }
    

    self.recommendNum  = m.recommendNum  != nil ? m.recommendNum  : self.recommendNum;
    
    self.overTimeContent    = m.overTimeContent != nil ? m.overTimeContent : self.overTimeContent;
    
    //    self.overTimeShowStatus = 1;
    self.shotsStatisModelArr = m.shotsStatisModelArr != nil ? m.shotsStatisModelArr : self.shotsStatisModelArr;
    self.comepetitionEvents  = m.comepetitionEvents != nil ? m.comepetitionEvents : self.comepetitionEvents;
    self.dhUrl1 = m.dhUrl1 != nil ? m.dhUrl1 : self.dhUrl1;
    self.dhUrl2 = m.dhUrl2 != nil ? m.dhUrl2 : self.dhUrl2;
    self.dhlive = m.dhlive;
    
    if (self.dhlive) {
        self.isContainsMatchEvent = YES;
    }
    return self;
}
@end

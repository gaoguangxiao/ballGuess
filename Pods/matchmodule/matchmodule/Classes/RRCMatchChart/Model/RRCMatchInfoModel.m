//
//  RRCMatchInfoModel.m
//  MXSFramework
//
//  Created by renrencai on 2019/4/17.
//  Copyright © 2019年 MXS. All rights reserved.
//

#import "RRCMatchInfoModel.h"

@implementation RRCMatchInfoModel


+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"matchId":@"match_id",
             @"matchMember":@"match_str",
             @"matchName":@"league",
             @"ID":@"id"
             
             };
}

@end

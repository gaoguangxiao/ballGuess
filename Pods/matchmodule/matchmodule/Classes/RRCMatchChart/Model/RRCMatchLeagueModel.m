//
//  RRCMatchLeagueModel.m
//  MXSFramework
//
//  Created by renrencai on 2019/4/19.
//  Copyright © 2019年 MXS. All rights reserved.
//

#import "RRCMatchLeagueModel.h"
#import <MJExtension/MJExtension.h>
@implementation RRCMatchLeagueModel

-(id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    if ([property.name isEqualToString:@"isSelect"]) {
        return @"1";
    }
    return oldValue;
}

@end

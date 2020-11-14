//
//  RRCMatchLiveDataStatisModel.m
//  MXSFramework
//
//  Created by gaoguangxiao on 2020/5/25.
//  Copyright © 2020 MXS. All rights reserved.
//

#import "RRCMatchLiveDataStatisModel.h"
#import <MJExtension/MJExtension.h>

@implementation RRCMatchLiveDataStatisModel


-(id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    if ([property.name isEqualToString:@"home"] || [property.name isEqualToString:@"away"]) {
        if ([self isStatisEmpty:oldValue]) {
            return @"0";
        }
    }
    return oldValue;
}

-(BOOL)isStatisEmpty:(id)objc{
    if ([objc isEqual:[NSNull null]] || objc == nil) {
        return YES;
    }
    return NO;
}
@end

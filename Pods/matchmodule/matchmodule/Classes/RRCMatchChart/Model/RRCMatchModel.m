//
//  RRCMatchModel.m
//  MXSFramework
//
//  Created by renrencai on 2019/4/18.
//  Copyright © 2019年 MXS. All rights reserved.
//

#import "RRCMatchModel.h"
#import "RRCMatchInfoModel.h"
#import <MJExtension/MJExtension.h>
@implementation RRCMatchModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"matchArr":@"strandList",
             @"ID":@"id"
             };
}

-(id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    if ([property.name isEqualToString:@"matchArr"]) {
        NSArray *model = [RRCMatchInfoModel mj_objectArrayWithKeyValuesArray:oldValue];
        return model;
    }else if ([property.name isEqualToString:@"remark"]){
        if ([oldValue containsString:@"串"]) {
            self.isTogetherMatch = YES;
        }
    }
    return oldValue;
}
@end

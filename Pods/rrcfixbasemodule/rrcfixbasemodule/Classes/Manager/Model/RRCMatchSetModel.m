//
//  RRCMatchSetModel.m
//  MXSFramework
//
//  Created by gaoguangxiao on 2019/7/12.
//  Copyright © 2019 MXS. All rights reserved.
//

#import "RRCMatchSetModel.h"

@implementation RRCMatchSetModel

-(NSMutableDictionary *)matchTopLisDict{
    if (!_matchTopLisDict) {
        _matchTopLisDict = [NSMutableDictionary new];
    }
    return _matchTopLisDict;
}
@end

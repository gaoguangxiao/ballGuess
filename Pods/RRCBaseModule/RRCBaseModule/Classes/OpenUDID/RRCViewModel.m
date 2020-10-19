//
//  RRCViewModel.m
//  MXSFramework
//
//  Created by gaoguangxiao on 2020/4/16.
//  Copyright © 2020 MXS. All rights reserved.
//

#import "RRCViewModel.h"

@implementation RRCViewModel

-(void)requestDataWithParameters:(NSDictionary *)parameters andComplete:(nonnull void (^)(NSArray * _Nonnull, BOOL))blockList{
    
}

#pragma mark - Getter
-(NSMutableArray *)listArray{
    if (!_listArray) {
        _listArray = [NSMutableArray new];
    }
    return _listArray;
}

#pragma mark - Getter
-(NSMutableArray *)itemChoseArrayID{
    if (!_itemChoseArrayID) {
        _itemChoseArrayID = [NSMutableArray new];
    }
    return _itemChoseArrayID;
}
@end

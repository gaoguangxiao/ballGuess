//
//  RRCBallModel.m
//  MXSFramework
//
//  Created by gaoguangxiao on 2019/6/18.
//  Copyright © 2019 MXS. All rights reserved.
//

#import "RRCBallModel.h"

@interface RRCBallModel ()

@end

@implementation RRCBallModel

-(NSString *)imageNameByResult:(NSString *)result{
    NSString *imageName = @"";
    if ([result integerValue] == 1){
        imageName = @"红";
    }else if ([result integerValue] == 2){
        imageName = @"黑";
    }else if ([result integerValue] == 3){
        imageName = @"走";
    }else if ([result integerValue] == 4){
        imageName = @"取消";
    }else if ([result integerValue] == 5){
        imageName = @"推迟";
    }else if ([result integerValue] == 6){
        imageName = @"待定";
    }else if ([result integerValue] == 7){
        imageName = @"腰斩";
    }else if ([result integerValue] == 8){
        imageName = @"中断";
    }else{
        imageName = @"无";
    }
    return imageName;
}

-(NSMutableArray *)play_Method{
    if (!_play_Method) {
        _play_Method = [NSMutableArray new];
    }
    return _play_Method;
}

-(NSMutableArray *)odd_Arr{
    if (!_odd_Arr) {
        _odd_Arr = [NSMutableArray new];
    }
    return _odd_Arr;
}

-(NSMutableArray *)match_tateArr{
    if (!_match_tateArr) {
        _match_tateArr = [NSMutableArray new];
    }
    return _match_tateArr;
}
@end

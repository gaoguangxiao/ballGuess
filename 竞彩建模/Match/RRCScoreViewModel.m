//
//  RRCScoreViewModel.m
//  MXSFramework
//
//  Created by gaoguangxiao on 2020/4/14.
//  Copyright © 2020 MXS. All rights reserved.
//

#import "RRCScoreViewModel.h"
#import "RRCNetWorkManager.h"
#import <MJExtension/MJExtension.h>
#import "RRCTScoreModel.h" //引入要处理的model
#import "RRCConfigManager.h"
#import "RRCDeviceConfigure.h"
#import "ResultModel.h"
@implementation RRCScoreViewModel

- (void)requestWithMatchCondition: (NSInteger )matchCondition
                       parameters: (NSDictionary *)parameters
                          success:(nonnull void (^)(NSArray * _Nonnull, BOOL))blockScoreList{
    NSString *postUrl = @"";
    switch (matchCondition) {
        case 0:
            postUrl = @"v11/game/todayGame";
            break;
        case 1:
            postUrl = @"v11/game/openGame";
            break;
        case 2:
            postUrl = @"v11/game/scheduleGame";
            break;
        case 3:
            postUrl = @"v11/game/amidithionGame";
            break;
        case 4:
            postUrl = @"v11/user/attentionGameList";
            break;
        default:
            postUrl = @"";
            break;
    }
    [[RRCNetWorkManager sharedTool] loadRequestWithURLString:[NSString stringWithFormat:@"https://appbalance2.zqcf718.com/%@",postUrl] isfull:YES parameters:parameters success:^(CGDataResult * _Nonnull result) {
        
        [self.listArray removeAllObjects];
        if (result.status.boolValue) {
            

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSArray *arr1 = [RRCTScoreModel mj_objectArrayWithKeyValuesArray:result.data];
                [self.listArray removeAllObjects];
                [self.matchListCar removeAllObjects];
                
                [self handleScoreArray:arr1 andMatchContion:matchCondition];
                //赛事排序 是否自定义
                for (NSInteger i = 0;i < arr1.count;i++) {
                    RRCTScoreModel *re = arr1[i];
                    if (![re.DXQDesc isEqualToString:@"-"] && ![re.JSPKDesc isEqualToString:@"-"]) {
                        [self.listArray addObject:re];
                    }
                }
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(dataFinishload:andlistArray:)]) {
                    [self.delegate dataFinishload:matchCondition andlistArray:self.listArray];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    blockScoreList(self.listArray,result.status.boolValue);
                });
                
            });
            
        }else{
            if (result.code == 404) {
                blockScoreList(self.listArray,NO);
            }else{
                blockScoreList(self.listArray,YES);
            }
        }
        
    }];
}

- (void)requestReloadWithMatchCondition: (NSInteger )matchCondition
                             parameters: (NSDictionary *)parameters
                                success:(nonnull void (^)(NSArray * _Nonnull, BOOL))blockScoreList{
    NSString *postUrl = @"";
    switch (matchCondition) {
        case 0:
            postUrl = @"v11/game/todayGame";
            break;
        case 1:
            postUrl = @"v11/game/openGame";
            break;
        case 2:
            postUrl = @"v11/game/scheduleGame";
            break;
        case 3:
            postUrl = @"v11/game/amidithionGame";
            break;
        case 4:
            postUrl = @"v11/user/attentionGameList";
            break;
        default:
            postUrl = @"";
            break;
    }
    [[RRCNetWorkManager sharedTool] loadRequestWithURLString:[NSString stringWithFormat:@"https://appbalance2.zqcf718.com/%@",postUrl] isfull:YES parameters:parameters success:^(CGDataResult * _Nonnull result) {
        [self.listArray removeAllObjects];
        if (result.status.boolValue) {
            
//            NSLog(@"%@",result.originalData);
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSArray *arr1 = [RRCTScoreModel mj_objectArrayWithKeyValuesArray:result.data];
                //赛事排序 是否自定义
                [self.listArray removeAllObjects];
                [self.matchListCar removeAllObjects];
                
                [self handleScoreArray:arr1 andMatchContion:matchCondition];
                
                if ([self sortEnableWithCondition:matchCondition]) {
                    NSArray *defineArray = [self sortDescriptorOrign:arr1];
                    [self.listArray addObjectsFromArray:defineArray];
                }else{
                    [self.listArray addObjectsFromArray:arr1];
                }
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(dataFinishload:andlistArray:)]) {
                    [self.delegate dataFinishload:matchCondition andlistArray:self.listArray];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    blockScoreList(self.listArray,result.status.boolValue);
                });
                
            });
            
        }else{
            if (result.code == 404) {
                blockScoreList(self.listArray,NO);
            }else{
                blockScoreList(self.listArray,YES);
            }
        }
        
    }];
}
//每个model：处理一下问题：1、model高度；2、model指数变化；3、model比分变化；4、model进球事件；5、置顶状态循环
-(void)handleScoreArray:(NSArray *)orignArray andMatchContion:(NSInteger)matchCondition{

    for (NSInteger i = 0; i < orignArray.count; i++) {
        RRCTScoreModel *_tempScore = orignArray[i];
        
        _tempScore.cellIndex = i;
        
        if ([_tempScore.home containsString:@"(中)"]) {
            _tempScore.home = [_tempScore.home substringToIndex:_tempScore.home.length - 3];
        }
        
        _tempScore.cellScoreHeight = 98 * Device_Ccale;
        
        if ([_tempScore.state integerValue] == -1 || ([_tempScore.state integerValue] <= 5 && [_tempScore.state integerValue] >= 1)) {
            _tempScore.isShowHalf = YES;
        }else{
            _tempScore.isShowHalf = NO;
        }
        
        _tempScore.dhlive = 0;
        _tempScore.recommendNum = @"0";
        _tempScore.live = @"0";
        if (_tempScore.dhlive) {
            
            _tempScore.isContainsMatchEvent = YES;
            
            if (matchCondition == 2 || matchCondition == 3) {
                
            }else{
                _tempScore.isShowOpenEvent = YES;
            }
        }
        _tempScore.isShowCollectStatusBtn = YES;
        
        if (matchCondition == 3) {
            _tempScore.isShowCollectStatusBtn = NO;
        }else{
            _tempScore.isShowCollectStatusBtn = YES;
        }
        //更新row高度
        [self updateDhHeightScoreModel:_tempScore];
        
        //是否能够置顶
        _tempScore.enableTop = [self enableLongPressTop:matchCondition];
        
        [self updatescoreModel:_tempScore];
        
    }
    
}

#pragma mark - 更新预测状态
-(void)updateScoreListTopStatus:(NSIndexPath *)indexPath andLoadDeleteResult:(loadDataBOOLBlock)complete{
    //    NSLog(@"当前线程：%@",[NSThread currentThread]);
    RRCTScoreModel *tempScore = [self getCurrentScoreModelAtIndexPath:indexPath];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        for (RRCTScoreModel *_tempScore in self.listArray) {
            if ([_tempScore.ID integerValue] == [tempScore.ID integerValue]) {
                
                //改变置顶状态
                tempScore.collectStatus = tempScore.collectStatus.integerValue == 1 ? @"0" : @"1";
                
                //2、置顶状态处理
                RRCMatchSetModel *matchSet = [[RRCConfigManager sharedRRCConfigManager] loadPushLocalSet];
                NSLog(@"收藏数据：%@",matchSet.matchTopLisDict);
                NSString *timeStampKey = [NSString stringWithFormat:@"%@",tempScore.ID];
                if (tempScore.collectStatus.integerValue) {
                    NSDictionary *timeStampDic = @{@"time_stamp":@(tempScore.time_stamp),@"ID":tempScore.ID};
                    [matchSet.matchTopLisDict setValue:timeStampDic forKey:timeStampKey];
                    [self.matchListCar addObject:tempScore];
                }else{
                    [self.matchListCar removeObject:tempScore];
                    [matchSet.matchTopLisDict removeObjectForKey:timeStampKey];
                }
                [[RRCConfigManager sharedRRCConfigManager]updatePushLocalSetBySetModel:matchSet];
                break;
            }
        }
        //改变某个cell所在的位置
        //        [self.listArray exchangeObjectAtIndex:indexPath.row withObjectAtIndex:0];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(YES);
        });
        
    });
    
}

-(void)reloadScoreListTopStatus:(NSArray *)newFinishArr andLoadDeleteResult:(loadDataBOOLBlock)complete{

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        for (RRCTScoreModel *_tempScore in self.listArray) {
            
            for (ResultModel *resultModel in newFinishArr) {
                //大小球赛果以及比分赛果合入比分列表
                if ([_tempScore.time containsString:resultModel.mmdd] && [_tempScore.home containsString:resultModel.home] && [_tempScore.away containsString:resultModel.away]) {
                    
                    NSArray *yzArr = [resultModel.finishYazhiText componentsSeparatedByString:@"\n"];
                    
                    _tempScore.YZ_FINISHTYEXTR = [NSString stringWithFormat:@"%@ %@ %@",yzArr[0],yzArr[1],yzArr[2]];
                    
                    NSArray *dxqArr = [resultModel.finishBigText componentsSeparatedByString:@"\n"];
                    
                    _tempScore.DXQ_FINISHTYEXTR = [NSString stringWithFormat:@"%@ %@ %@",dxqArr[0],dxqArr[1],dxqArr[2]];
                    
                    continue;
                }
            
            }
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            complete(YES);
        });
        
    });
    
}


#pragma mark - puplic
//是否能长按置顶
-(BOOL)enableLongPressTop:(NSInteger)matchCondition{
    BOOL enableLongPress = NO;
    if (matchCondition == 0 || matchCondition == 1 || matchCondition == 4) {
        enableLongPress = YES;
    }
    return enableLongPress;
}

-(void)updateDhHeightScoreModel:(RRCTScoreModel *)scoreModel{
    
    scoreModel.isOpenStadium  = YES;
    
    if (self.eventViewTag == [scoreModel.ID integerValue]) {
        
        scoreModel.isOpenEvent = self.teamEventOpenTag;
        scoreModel.isOpenStadium = self.teamStadiumOpenTag;
        
        [self updateCellHeightModel:scoreModel andomplete:^(BOOL isEnd) {
            
        }];
    }else{
        [self updateCellHeightModel:scoreModel andomplete:^(BOOL isEnd) {
            
        }];
    }
}

//是否自定义排序
-(BOOL)sortEnableWithCondition:(NSInteger)matchCondition{
    BOOL enableSort = NO;
    if (matchCondition == 0 || matchCondition == 1 || matchCondition == 4) {
        enableSort = YES;
    }
    return enableSort;
}

-(NSInteger)getNumberOfRow{
    return self.listArray.count;
}

-(RRCTScoreModel *)getCurrentScoreModelAtIndexPath:(NSIndexPath *)indexPath{
    if (self.listArray.count > 0 ) {
        return self.listArray[indexPath.row];
    }else{
        return [RRCTScoreModel new];
    }
}

-(CGFloat)getCellRowHeightAtIndexPath:(NSIndexPath *)indexPath{
    RRCTScoreModel *tempScore = [self getCurrentScoreModelAtIndexPath:indexPath];
    return tempScore.cellScoreHeight;
}

-(void)resetSortListForTopStatus{
    //    NSLog(@"当前线程：%@",[NSThread currentThread]);
    [self updateListTopStatus];
    
    [self updateSortList];
}

//更新排序列表
-(void)updateSortList{
    NSArray *orignList = [self sortDescriptorOrign:self.listArray];
    
    [self.listArray removeAllObjects];
    [self.listArray addObjectsFromArray:orignList];
    
}

//更新列表置顶状态、排序所有字段
-(void)updateListTopStatus{
    for (RRCTScoreModel *_tempScore in self.listArray) {
        [self updatescoreModel:_tempScore];
    }
}

#pragma mark - 展开闭合方法
-(void)changeMatchEventStatus:(BOOL)openEvent andIndexPath:(NSIndexPath *)indexPath andomplete:(nonnull loadDataBOOLBlock)complete{
    //    NSLog(@"应该具备的事件：%d",openEvent);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (RRCTScoreModel *t in self.listArray) {
            t.isOpenEvent = NO;
            t.isOpenStadium = YES;
            t.cellScoreHeight = 98 * Device_Ccale;
            if (t.overTimeShowStatus) {
                t.cellScoreHeight = t.cellScoreHeight + 27 * Device_Ccale;
            }
        }
        //修改model数据
        RRCTScoreModel *obj = [self getCurrentScoreModelAtIndexPath:indexPath];
        obj.isOpenEvent = openEvent;
        self.eventViewTag = [obj.ID integerValue];
        self.teamEventOpenTag = obj.isOpenEvent;
        self.teamStadiumOpenTag = obj.isOpenStadium;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateCellHeightModel:obj andomplete:^(BOOL isEnd) {
                complete(isEnd);
            }];
        });
    });
    
}

-(void)changeStadiumSizeEventStatus:(BOOL)openStadium andIndexPath:(NSIndexPath *)indexPath andomplete:(nonnull loadDataBOOLBlock)complete{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (RRCTScoreModel *t in self.listArray) {
            t.isOpenStadium = NO;
        }
        
        RRCTScoreModel *obj = self.listArray[indexPath.row];
        obj.isOpenStadium = openStadium;
        self.eventViewTag = [obj.ID integerValue];
        self.teamEventOpenTag = obj.isOpenEvent;
        self.teamStadiumOpenTag = obj.isOpenStadium;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateCellHeightModel:obj andomplete:^(BOOL isEnd) {
                complete(isEnd);
            }];
        });
        
    });
    
}
-(void)updateCellHeightModel:(RRCTScoreModel *)obj andomplete:(nonnull loadDataBOOLBlock)complete{
    
    if (obj.isOpenEvent) {
        if (obj.isOpenStadium) {
            //球场展示全部459
            obj.cellScoreHeight = 459 * Device_Ccale;
        }else{
            //球场展示一半259
            obj.cellScoreHeight = 259 * Device_Ccale;
        }
        
    }else{
        
        obj.cellScoreHeight = 106 * Device_Ccale;
        
    }
    
    if (obj.overTimeShowStatus) {
        obj.cellScoreHeight = obj.cellScoreHeight + 27 * Device_Ccale;
    }
    
    obj.isUpdateStadiumHeight = YES;
    
    complete(YES);
    
}
#pragma mark - private
//更新某条比分模型 比分模型从缓存判断数据
-(void)updatescoreModel:(RRCTScoreModel *)scoreModel{

    //将原始模型置顶状态为0、用本地状态修正
    scoreModel.collectStatus = @"0";
   
    RRCMatchSetModel *matchSet = [[RRCConfigManager sharedRRCConfigManager] loadPushLocalSet];
    
    for (NSDictionary *resultModel in matchSet.matchScoreListArr) {
        //大小球赛果以及比分赛果合入比分列表
        if ([scoreModel.time containsString:resultModel[@"mmdd"]] && [scoreModel.home containsString:resultModel[@"home"]] && [scoreModel.away containsString:resultModel[@"away"]]) {
            
            NSArray *yzArr = [resultModel[@"finishYazhiText"] componentsSeparatedByString:@"\n"];
            
            scoreModel.YZ_FINISHTYEXTR = [NSString stringWithFormat:@"%@ %@ %@",yzArr[0],yzArr[1],yzArr[2]];
            
            NSArray *dxqArr = [resultModel[@"finishBigText"] componentsSeparatedByString:@"\n"];
            
            scoreModel.DXQ_FINISHTYEXTR = [NSString stringWithFormat:@"%@ %@ %@",dxqArr[0],dxqArr[1],dxqArr[2]];
        }
    
    }
}

/*0：未开、1：上半场、2：中场、3：下半场、4：加时、5：点球、
 -1：完场
 -14:推迟 【有问题】
 -10:取消、【有问题】
 -13:中断、
 -12:腰斩、
 -11:待定*/
-(NSArray *)sortDescriptorOrign:(NSArray *)orignArray{
    
    NSMutableArray *topMatchListAray = [NSMutableArray new];
    NSMutableArray *contentListArray = [NSMutableArray new];
    
    for (RRCTScoreModel *_tempScore in orignArray) {
        if (_tempScore.topStatus) {
            [topMatchListAray addObject:_tempScore];
        }else{
            [contentListArray addObject:_tempScore];
        }
    }
    NSMutableArray *newMatchListArray = [NSMutableArray new];
    
    
    //topMatchListAray 排序
    NSSortDescriptor *topStatusDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"cellIndex" ascending:YES];
    NSArray *topArr = [topMatchListAray sortedArrayUsingDescriptors:@[topStatusDescriptor]];
    
    NSArray *contentArr = [contentListArray sortedArrayUsingDescriptors:@[topStatusDescriptor]];
    
    [newMatchListArray addObjectsFromArray:topArr];
    [newMatchListArray addObjectsFromArray:contentArr];
    //YES升序 NO降序
    //    NSSortDescriptor *stateDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"sortState" ascending:NO comparator:^NSComparisonResult(NSString  *_Nonnull obj1, NSString * _Nonnull obj2) {
    //        if ([obj1 integerValue] < 0 && [obj2 integerValue] < 0) {
    //            return [self sortValue:obj2 andValue1:obj1];//[sortKey(obj2, obj1)];//都小于0，采用升序
    //        }else{
    //            return [self sortValue:obj1 andValue1:obj2];
    //        }
    //
    //    }];
    
    //    NSSortDescriptor *timeDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES];
    //    NSArray *newMatchListArray = [orignArray sortedArrayUsingDescriptors:@[topStatusDescriptor]];
    
    return newMatchListArray;
}
-(NSComparisonResult)sortValue:(NSString *)obj1 andValue1:(NSString *)obj2{
    if (obj1 == obj2) {
        return NSOrderedSame;
    }else if ([obj1 floatValue] > [obj2 floatValue] ){
        return NSOrderedDescending;
    }else {
        return NSOrderedAscending;//降序
    }
}

#pragma mark - Getter
-(NSMutableArray *)matchListCar{
    if (!_matchListCar) {
        _matchListCar = [NSMutableArray new];
    }
    return _matchListCar;
}
@end

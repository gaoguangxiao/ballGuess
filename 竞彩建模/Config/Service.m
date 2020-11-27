//
//  Service.m
//  CPetro
//
//  Created by ggx on 2017/3/10.
//  Copyright © 2017年 高广校. All rights reserved.
//

#import "Service.h"

//#import "NSDictionary+Json.h"

#import "HUDHelper.h"
#import "EFUser.h"

#import "RRCBetRecordModel.h"
#import "EntityGoods.h"

#import "RRCTScoreModel.h"
static AFHTTPSessionManager *manager;

@implementation Service
//
+(AFHTTPSessionManager *)shareSessionManger{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        
    });
    return manager;
    
}
#pragma mark - AFN网络请求
+(CGDataResult *)loadNetWorkingByParameters:(NSDictionary *)parameters andBymethodName:(NSString *)methodName{
    return [CGDataResult getResultFromDic:[Service backDataResults_webService:methodName AndDic:parameters]];
}
+(CGDataResult *)postImageByUrlByParameters:(NSDictionary *)parameters andBymethodName:(NSString *)methodName andByImageData:(NSData *)imageData andImageKey:(NSString *)imageKey{
    return [CGDataResult getResultFromDic:[Service postImagebyResultsWebService:methodName withParameters:parameters andImageData:imageData imageKey:imageKey]];
}
+(CGDataResult *)postMany:(NSDictionary *)argvs andUrl:(NSString *)url{
    NSString *urlNew = [NSString stringWithFormat:@"%@%@",WEBSEARVICE,url];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSMutableArray *images = [[NSMutableArray alloc] initWithCapacity:0];
    
    for(NSString *key in [argvs allKeys]){
        id obj = [argvs objectForKey:key];
        if(![obj isKindOfClass:[NSArray class]]){
            [parameters setObject:[NSString stringWithFormat:@"%@",obj] forKey:key];
        }else{
            NSArray *arr = obj;
            for (int i = 0; i < arr.count; i ++) {
                if ([arr[i] isKindOfClass:[UIImage class]]) {
                    [images addObject:UIImageJPEGRepresentation(arr[i], 0.8)];
                    //                     [images setObject: forKey:key];
                }else{
                    //                     [images setObject:arr[i] forKey:key];
                }
                
            }
        }
        
    }
    
    
    [self deletebugDic:parameters andBugUrl:urlNew];
    AFHTTPRequestSerializer *requestOperation = [[AFHTTPRequestSerializer alloc] init];
    
    NSMutableURLRequest *urlrequest =  [requestOperation multipartFormRequestWithMethod:@"POST" URLString:urlNew parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        int theidnexx = 0;
        
        
        for(id key in images){
            NSData* obj = key;
            
            
            NSString *timeStr = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
            
            NSString *name = [NSString stringWithFormat:@"%@-%@-%d.png",@"",timeStr,theidnexx];
            [formData appendPartWithFileData:obj name:[NSString stringWithFormat:@"file%d",theidnexx] fileName:name mimeType:@"image/png"];//picurl
            
            
            theidnexx++;
            
        }
    } error:nil];
    //    requestOperation.ht
    return [CGDataResult getResultFromDic:[self handleNetData:urlrequest]];
}
/**同步图片请求事列*/
+(NSDictionary *)postImagebyResultsWebService:(NSString*)url withParameters:(NSDictionary*)parameters andImageData:(NSData*)imageData imageKey:(NSString *)imageKey{
    
    NSString *urlNew = [NSString stringWithFormat:@"%@%@",WEBSEARVICE,url];
    [self deletebugDic:parameters andBugUrl:urlNew];
    AFHTTPRequestSerializer *requestOperation = [[AFHTTPRequestSerializer alloc] init];
    
    NSMutableURLRequest *urlrequest =  [requestOperation multipartFormRequestWithMethod:@"POST" URLString:urlNew parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSString *timeStr = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
        //
        NSString *name = [NSString stringWithFormat:@"%@-%@-%d.png",@"",timeStr,1];
        [formData appendPartWithFileData:imageData name:imageKey fileName:name mimeType:@"image/png"];//picurl
        //                theidnexx++;
    } error:nil];
    //    requestOperation.ht
    return [self handleNetData:urlrequest];
    
}
#pragma mark - bmob加载数据
+(void)loadBmobanimation:(BOOL)animated andTitle:(NSString *)title andObjectByParameters:(NSDictionary *)parameters andByStoreName:(NSString *)storeName constructingBodyWithBlock:(returnObject)block{
    MBProgressHUD *hud;
    if (animated) {
        hud = [[HUDHelper sharedInstance]loading:title];
    }
    [self loadBmobObjectByParameters:parameters andByStoreName:storeName constructingBodyWithBlock:^(CGDataResult *obj, BOOL b) {
        [hud hideAnimated:YES];
        block(obj,b);
    }];
}
+(void)loadBmobObjectByParameters:(NSDictionary *)parameters andByStoreName:(NSString *)storeName constructingBodyWithBlock:(returnObject)block{
    //执行网络请求，给提示说明
    
    CGDataResult *result = [[CGDataResult alloc]init];
    if ([storeName isEqualToString:@"PictureStore"]) {
        [self queryHomePostObject:^(NSArray *array, NSError *error) {
            if (error) {
                result.status   = @(NO);
                result.errorMsg = [error description];
            }else{
                result.status   = @(YES);
                result.data = array;
                result.errorMsg = @"执行成功";
            }
            block(result,result.status.boolValue);
        }];
    }
    //发帖子
    if ([storeName isEqualToString:@"SubmitPostStore"]) {
        [self submitPostByparameters:parameters andComplete:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                result.status   = @(YES);
                result.data = @[];
                result.errorMsg = @"执行成功";
            }else{
                result.status   = @(NO);
                result.errorMsg = [error description];
            }
            block(result,result.status.boolValue);
        }];
    }
    //查询帖子详情
    if ([storeName isEqualToString:@"PictureDetailStore"]) {
        [self queryPostDetailByObject:parameters andComplete:^(BmobObject *object, NSError *error) {
            if (object) {
                result.status   = @(YES);
                result.data = object;
                result.errorMsg = @"执行成功";
            }else{
                result.status   = @(NO);
                result.errorMsg = [error description];
            }
            block(result,result.status.boolValue);
        }];
    }
    
    //查询充流量记录
    if ([storeName isEqualToString:@"FlowStore"]) {
        [self queryUserExchangeFlowRecord:parameters andComplete:^(NSArray *array, NSError *error) {
            if (error) {
                result.status   = @(NO);
                result.errorMsg = [error description];
            }else{
                result.status   = @(YES);
                result.data = array;
                result.errorMsg = @"执行成功";
            }
            block(result,result.status.boolValue);
        }];
        
    }
    //账户充值记录
    if ([storeName isEqualToString:@"AmountStore"]) {
        [self queryUserExchangeAmountRecord:parameters andComplete:^(NSArray *array, NSError *error) {
            if (error) {
                result.status   = @(NO);
                result.errorMsg = [error description];
            }else{
                result.status   = @(YES);
                result.data = array;
                result.errorMsg = @"执行成功";
            }
            block(result,result.status.boolValue);
        }];
        
    }
    //账户充值 v1.1
    if ([storeName isEqualToString:@"AmountAddMoney"]) {
        [self userAddAmount:parameters andComplete:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                result.status   = @(YES);
                result.data = @[];
                result.errorMsg = @"执行成功";
            }else{
                result.status   = @(NO);
                result.errorMsg = [error description];
            }
            block(result,result.status.boolValue);
        }];
    }
    
    //账户重置方式
    if ([storeName isEqualToString:@"AppConfigStore"]) {
        [self userCheckFlowPayMehod:parameters andComplete:^(BmobObject *object, NSError *error) {
            if (!error) {
                result.status = @(YES);
                result.data = [[object mj_keyValues] objectForKey:@"dataDic"];
                result.errorMsg = @"执行成功";
            }else{
                result.status   = @(NO);
                result.errorMsg = [error description];
            }
            block(result,result.status.boolValue);
        }];
    }
    
    if ([storeName isEqualToString:@"AddMoneyConfigStore"]) {
        [self userAddMoneyConfigCount:parameters andComplete:^(NSArray *array, NSError *error) {
            if (error) {
                result.status   = @(NO);
                result.errorMsg = [error description];
            }else{
                result.status   = @(YES);
                result.data = array;
                NSMutableArray *re = [NSMutableArray new];
                for (NSInteger i = 0; i < array.count; i++) {
                    
                    BmobObject * o = array[i];
                    
                    EntityGoods *r = [EntityGoods mj_objectWithKeyValues:[o valueForKey:@"dataDic"]];
                    [re addObject:r];
                }
                result.status   = @(YES);
                result.data = re;
                result.errorMsg = @"执行成功";
            }
            block(result,result.status.boolValue);
        }];
        
    }
    
    //预测扣款账户
    if ([storeName isEqualToString:@"OrderForecastStore"]) {
        [self userAddOrderFlow:parameters andComplete:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                result.status   = @(YES);
                result.data = @[];
                result.errorMsg = @"执行成功";
            }else{
                result.status   = @(NO);
                result.errorMsg = error.userInfo[@"NSLocalizedDescriptionKey"];
            }
            block(result,result.status.boolValue);
        }];
    }
    
    //订单查询
    if ([storeName isEqualToString:@"OrderListStore"]) {
        [self userOrderListLoad:parameters andComplete:^(NSArray *array, NSError *error) {
            if (!error) {
                result.status   = @(YES);
                result.data = array;
                result.errorMsg = @"执行成功";
            }else{
                result.status   = @(NO);
                result.errorMsg = error.userInfo[@"NSLocalizedDescriptionKey"];
            }
            block(result,result.status.boolValue);
        }];
    }
    
    //下注
    if ([storeName isEqualToString:@"BetOrderStore"]) {
        [self userBetOrderFlow:parameters andComplete:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                result.status   = @(YES);
                result.data = @[];
                result.errorMsg = @"下注完成";
            }else{
                result.status   = @(NO);
                result.errorMsg = error.userInfo[@"NSLocalizedDescriptionKey"];
            }
            block(result,result.status.boolValue);
        }];
    }
    //    查询下注列表
    if ([storeName isEqualToString:@"BetListOrderStore"]) {
        [self userBetOrderListLoad:parameters andComplete:^(NSArray *array, NSError *error) {
            if (!error) {
                //数组遍历 RRCBetRecordModel
                NSMutableArray *re = [NSMutableArray new];
                for (NSInteger i = 0; i < array.count; i++) {
                    
                    BmobObject * o = array[i];
                    
                    RRCBetRecordModel *r = [RRCBetRecordModel mj_objectWithKeyValues:[o valueForKey:@"dataDic"]];
                    if ([r.homeScore isEqualToString:@"-"] && [r.awayScore isEqualToString:@"-"]) {
                        r.status = @"0";
                    }else{
                        r.status = @"1";
                    }
                    [self handleDxqSmallText:r];
                    [self handleyzpK:r];
                    
                    [re addObject:r];
                }
                result.status   = @(YES);
                result.data = re;
                result.errorMsg = @"执行成功";
            }else{
                result.status   = @(NO);
                result.errorMsg = error.userInfo[@"NSLocalizedDescriptionKey"];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                block(result,result.status.boolValue);
            });
        }];
    }
    
    //更新某条数据,只有此接口才能增加
    if ([storeName isEqualToString:@"updateBetOrder"]) {
        [self updateBetOrderListLoad:parameters andComplete:^(BmobObject *object, NSError *error) {
//            if (!error) {
                //返回处理完成的数据模型
                NSDictionary *nDict = [object valueForKey:@"dataDic"];
                RRCBetRecordModel *r = [RRCBetRecordModel mj_objectWithKeyValues:nDict];
                
                NSInteger stateCode = error.code;//-1才是完结
                if (stateCode == -1) {
                    r.status = @"1";
                }else{
                    if (stateCode == 14) {
                        r.status = @"2";
                    }else{
                        r.status = @"0";
                    }
                    
                }
            
                //根据订单
                if (r.status.integerValue == 1 && r.orderState.integerValue == 0) {
                    [self handleDxqSmallText:r];
                    [self handleyzpK:r];
                    //修改用户金额
                    float allMoney = r.dxq_winMoney.floatValue + r.yz_winMoney.floatValue;//最终盈利
                    float benMoney = r.dxq_money.floatValue + r.yz_money.floatValue;//此局投入的本金
                    
                    //最终金额
                    allMoney = benMoney + allMoney;
                    
//                  +191
                    r.money = [NSString stringWithFormat:@"%.2f",r.money.floatValue + allMoney];
                    
                    [EFUser updateUserMoneyAmount:allMoney andStateAdd:YES andBackResult:^(BOOL isSuccessful, NSError *error) {
                        if (isSuccessful) {
                            r.orderState = @"2";
                            BmobQuery  *bquery = [BmobQuery queryWithClassName:@"BetOrderStore"];
                            [bquery getObjectInBackgroundWithId:parameters[@"objectId"] block:^(BmobObject *object, NSError *error) {
                                //更新订单状态
                                [object setObject:r.orderState forKey:@"orderState"];
                                //更新订单中用户钱
                                [object setObject:r.money forKey:@"money"];
                                [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                                    if (isSuccessful) {
                                        result.status   = @(YES);
                                        result.data = r;
                                        result.errorMsg = @"执行成功";
                                    }
                                    block(result,result.status.boolValue);
                                }];
                            }];
                            
                            //增加金额记录
                            //可以查询
                            BmobObject *flowScore = [BmobObject objectWithClassName:@"orderMoneyStore"];
                            //订单列表应该插入用户的信息
                            [flowScore setObject:[CustomUtil getUserInfo].username forKey:@"userName"];
                            [flowScore setObject:[BmobUser currentUser] forKey:@"author"];
                            [flowScore setObject:[NSString stringWithFormat:@"%.2f",allMoney] forKey:@"money"];
                            NSDate *currentDate = [NSDate date];//获取当前时间，日期
                            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
                            [dateFormatter setDateFormat:@"YYYYMMDDHHMM"];//设定时间格式,这里可以设置成自己需要的格式
                            NSString *dateString = [dateFormatter stringFromDate:currentDate];
                            
                            NSInteger userForecastNum = [[parameters valueForKey:@"userForecastCount"] integerValue];
                            NSString *oID = [NSString stringWithFormat:@"%@%ldB5",dateString,(long)userForecastNum];
                            [flowScore setObject:oID forKey:@"orderId"];
                            [flowScore setObject:r.home forKey:@"home"];
                            [flowScore setObject:r.away forKey:@"away"];
                            
                            [flowScore saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                                
                            }];
                        }else{
                            
                        }
                    }];
                    
                }
                else if (r.status.integerValue == 2 && r.orderState.integerValue == 0) {
                  
                    r.dxq_winMoney = @"0";
                    r.yz_winMoney  = @"0";
                    //修改用户金额
                    float allMoney = r.dxq_winMoney.floatValue + r.yz_winMoney.floatValue;//最终盈利
                    float benMoney = r.dxq_money.floatValue + r.yz_money.floatValue;//此局投入的本金
                    
                    allMoney = benMoney + allMoney;
                  
                    r.money = [NSString stringWithFormat:@"%.2f",r.money.floatValue + allMoney];
                    
                    [EFUser updateUserMoneyAmount:allMoney andStateAdd:YES andBackResult:^(BOOL isSuccessful, NSError *error) {
                        if (isSuccessful) {
                            r.orderState = @"3";
                            BmobQuery  *bquery = [BmobQuery queryWithClassName:@"BetOrderStore"];
                            [bquery getObjectInBackgroundWithId:parameters[@"objectId"] block:^(BmobObject *object, NSError *error) {
                                //更新订单状态
                                [object setObject:r.orderState forKey:@"orderState"];
                                //更新订单中用户钱
                                [object setObject:r.money forKey:@"money"];
                                [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                                    if (isSuccessful) {
                                        result.status   = @(YES);
                                        result.data = r;
                                        result.errorMsg = @"执行成功";
                                    }
                                    block(result,result.status.boolValue);
                                }];
                            }];
                            
                            //增加金额记录
                            //可以查询
                            BmobObject *flowScore = [BmobObject objectWithClassName:@"orderMoneyStore"];
                            //订单列表应该插入用户的信息
                            [flowScore setObject:[CustomUtil getUserInfo].username forKey:@"userName"];
                            [flowScore setObject:[BmobUser currentUser] forKey:@"author"];
                            [flowScore setObject:[NSString stringWithFormat:@"%.2f",allMoney] forKey:@"money"];
                            NSDate *currentDate = [NSDate date];//获取当前时间，日期
                            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
                            [dateFormatter setDateFormat:@"YYYYMMDDHHMM"];//设定时间格式,这里可以设置成自己需要的格式
                            NSString *dateString = [dateFormatter stringFromDate:currentDate];
                            
                            NSInteger userForecastNum = [[parameters valueForKey:@"userForecastCount"] integerValue];
                            NSString *oID = [NSString stringWithFormat:@"%@%ldB5",dateString,(long)userForecastNum];
                            [flowScore setObject:oID forKey:@"orderId"];
                            [flowScore setObject:r.home forKey:@"home"];
                            [flowScore setObject:r.away forKey:@"away"];
                            
                            [flowScore saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                                
                            }];
                        }else{
                            
                        }
                    }];
                
                    
                }else{
                    result.status   = @(YES);
                    result.data = r;
                    result.errorMsg = error.userInfo[@"NSLocalizedDescriptionKey"];;
                    block(result,result.status.boolValue);
                }
                
//            }
//            else{
//                result.code = error.code;
//                result.status   = @(NO);
//                result.errorMsg = error.userInfo[@"NSLocalizedDescriptionKey"];
//
//                if (result.code == 100) {
//
//
//                }
//
//                block(result,result.status.boolValue);
//            }
            
        }];
    }
    
    //
    if ([storeName isEqualToString:@"GameStatus"]) {
        [self queryGameSatus:parameters andComplete:^(BmobObject *object, NSError *error) {
            if (object) {
                result.status   = @(YES);
                result.data = object;
                result.errorMsg = @"执行成功";
            }else{
                result.status   = @(NO);
                result.errorMsg = [error description];
            }
            block(result,result.status.boolValue);
        }];
    }
}

/**
 查询首页的数据
 */
#pragma mark - API接口数据库表操作
#pragma mark -发帖子
+(void)submitPostByparameters:(NSDictionary *)parameters andComplete:(BmobBooleanResultBlock)block{
    //移除空字符串，打印数据
    BmobObject *obj = [[BmobObject alloc] initWithClassName:@"PictureStore"];
    //保存以上数据、
    //    标题，内容，图片，发帖人，(帖子聚合币 对这个用户来说 领取状态，单价，数量，总价)
    [obj saveAllWithDictionary:parameters];
    [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        URLLog(@"发帖子信息：%@",error);
        //1、用户发布帖子、不扣除聚合币
        //        [EFUser updateUserAmount:parameters[@"totalMoney"] andStateAdd:NO andBackResult:^(BOOL isSuccessful, NSError *error) {
        //            URLLog(@"更新用户信息：%@",error);
        //如果出现金额更新失败，这个帖子就需要删除，不能保存
        //            if (error) {
        //                [obj deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
        //                    URLLog(@"尚未进行保存");
        //                }];
        //            }
        block(isSuccessful,error);
        //        }];
        //在建立一个，关联这个帖子的用户状态、方便登陆用户进行查询
    }];
}

#pragma mark -获取首页数据
+(void)queryHomePostObject:(BmobObjectArrayResultBlock)block{
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"PictureStore"];
    [bquery orderByDescending:@"createdAt"];//将序排列
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        block(array,error);
    }];
}
#pragma mark -获取帖子具体内容

/**
 查询帖子详情
 
 @param dicPost 帖子列表数据
 @param block <#block description#>
 */
+(void)queryPostDetailByObject:(NSDictionary *)dicPost andComplete:(BmobObjectResultBlock)block{
    //查找帖子信息
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"PictureStore"];
    //    声明该次查询需要将author关联对象信息一并查询出来
    [bquery includeKey:@"author"];
    [bquery orderByDescending:@"createdAt"];//将序排列
    [bquery getObjectInBackgroundWithId:dicPost[@"objectId"] block:^(BmobObject *post, NSError *error) {
        //作者
        BmobUser *author = [post objectForKey:@"author"];
        //帖子信息、帖子作者信息、好友关系查询
        NSMutableDictionary *detailMutableDic = [[NSMutableDictionary alloc]initWithDictionary:@{@"title":[post objectForKey:@"title"]?[post objectForKey:@"title"]:@"",
                                                                                                 @"content":[post objectForKey:@"content"],
                                                                                                 @"author":author,
                                                                                                 @"userName":[post objectForKey:@"userName"]?[post objectForKey:@"userName"]:@"",
                                                                                                 @"userFile":[post objectForKey:@"userFile"],
                                                                                                 @"userPictures":[post objectForKey:@"userPictures"],
                                                                                                 @"state":[post objectForKey:@"state"],
                                                                                                 @"price":[post objectForKey:@"price"],
                                                                                                 @"remaining":[post objectForKey:@"remaining"],
                                                                                                 @"totalMoney":[post objectForKey:@"totalMoney"],
                                                                                                 @"createdAt":[post objectForKey:@"createdAt"],
                                                                                                 @"userLevel":[author objectForKey:@"userLevel"]}];
        
        
        //查找与此用户的关系
        BmobQuery   *bqueryFriend = [BmobQuery queryWithClassName:@"FriendsListStore"];
        //            [bqueryFriend selectKeys:@[@"author"]];//返回指定的列、
        //匹配查询、构造查询条件 返回好友列表，
        //查询帖子用户的好友列表，
        BmobQuery *inQuery = [BmobQuery queryForUser];
        [inQuery whereKey:@"objectId" equalTo:author.objectId];//构造查询条件
        [bqueryFriend whereKey:@"author" matchesQuery:inQuery];
        
        __block BOOL iscontainFriend = [author.objectId isEqualToString:[BmobUser currentUser].objectId];
        [bqueryFriend findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            [array enumerateObjectsUsingBlock:^(BmobObject *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([[obj objectForKey:@"applyId"] isEqualToString:[BmobUser currentUser].objectId]||[[obj objectForKey:@"receiveId"] isEqualToString:[BmobUser currentUser].objectId]) {
                    iscontainFriend = YES;
                }
            }];
            
            NSNumber *boolValue = [NSNumber numberWithBool:iscontainFriend];
            BOOL b = [boolValue boolValue];
            NSLog(@"iscontainFriend = %d  村之前的= %d",iscontainFriend,b);
            //                [detailMutableDic setValue:boolValue forKey:@"isFriend"];
            [detailMutableDic setObject:boolValue forKey:@"isFriend"];
            //取出
            //新建帖子详情数据
            BmobObject *newObject = [[BmobObject alloc]initWithDictionary:detailMutableDic];
            block(newObject,error);
        }];
    }];
    
}
#pragma mark -申请加为好友
+(void)applyAddFriendByObject:(NSDictionary *)dicPost andComplete:(BmobBooleanResultBlock)block{
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"PictureStore"];
    //    声明该次查询需要将author关联对象信息一并查询出来
    [bquery includeKey:@"author"];
    [bquery orderByDescending:@"createdAt"];//将序排列、获取作者信息
    [bquery getObjectInBackgroundWithId:dicPost[@"objectId"] block:^(BmobObject *post, NSError *error) {
        if (!error) {
            //加好友、创建一个好友的列表，单方向的加
            BmobObject *friendApplyStore = [BmobObject objectWithClassName:@"FriendsListStore"];
            BmobObject *friendReceiveStore = [BmobObject objectWithClassName:@"FriendsListStore"];
            
            BmobUser *author = [post objectForKey:@"author"];
            //向表中添加作者
            [friendApplyStore setObject:[BmobUser currentUser] forKey:@"author"];
            [friendReceiveStore setObject:author forKey:@"author"];
            
            //设置关系
            BmobRelation *relation = [[BmobRelation alloc] init];
            //添加自己用户关联关系到likes列中
            [relation addObject:[BmobUser currentUser]];
            //再创建对方的关联中。
            
            [relation addObject:author];
            //添加关系
            [friendApplyStore addRelation:relation forKey:@"likes"];
            
            
            [friendReceiveStore addRelation:relation forKey:@"likes"];
            
            //设置关系状态
            [friendApplyStore setObject:@"1" forKey:@"state"];
            [friendReceiveStore setObject:@"0" forKey:@"state"];
            //解决社交卡顿问题，保存目标id
            [friendApplyStore setObject:[BmobUser currentUser].objectId forKey:@"applyId"];//设置申请的tagitId
            [friendReceiveStore setObject:[BmobUser currentUser].objectId forKey:@"applyId"];
            //接收
            [friendApplyStore setObject:author.objectId forKey:@"receiveId"];//设置沟通的接收Id
            [friendReceiveStore setObject:author.objectId forKey:@"receiveId"];
            //申请保存下来
            [friendApplyStore saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                [friendReceiveStore saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    block(isSuccessful,error);
                }];
                
            }];
            
        }else{
            
        }
    }];
}
#pragma mark -获取好友列表
+(void)getFriendListPostObject:(BmobObjectArrayResultBlock)block{
    //查找与此用户的关系
    BmobQuery   *bqueryFriend = [BmobQuery queryWithClassName:@"FriendsListStore"];
    BmobQuery *inQuery = [BmobQuery queryForUser];
    [inQuery whereKey:@"objectId" equalTo:[BmobUser currentUser].objectId];//构造查询条件
    [bqueryFriend whereKey:@"author" matchesQuery:inQuery];
    [bqueryFriend findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        //取出好友列表，需要知道对方对好友列表的同意状态，查询对方的表
        block(array,error);
    }];
    
}
#pragma mark -同意加好友
+(void)agressFriendBy:(NSDictionary *)dicPost andComplete:(BmobBooleanResultBlock)block{
    //查询申请用户的关系表
    BmobQuery *friendApplyStore = [BmobQuery queryWithClassName:@"FriendsListStore"];
    [friendApplyStore orderByDescending:@"createdAt"];//将序排列
    [friendApplyStore getObjectInBackgroundWithId:dicPost[@"friendStoreObjectId"] block:^(BmobObject *object, NSError *error) {
        [object setObject:@"1" forKey:@"state"];//更新状态
        [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            block(isSuccessful,error);
        }];
    }];
}
#pragma mark -删除好友
+(void)deleteFriendBy:(NSDictionary *)dicPost andComplete:(BmobBooleanResultBlock)block{
    BmobQuery *friendApplyStore = [BmobQuery queryWithClassName:@"FriendsListStore"];//
    [friendApplyStore getObjectInBackgroundWithId:dicPost[@"friendStoreObjectId"] block:^(BmobObject *object, NSError *error) {
        [object deleteInBackground];
        [friendApplyStore getObjectInBackgroundWithId:dicPost[@"MyStoreObjectId"] block:^(BmobObject *object, NSError *error) {
            [object deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                block(isSuccessful,error);
            }];
        }];
        
        
    }];
}
#pragma mark - 用户信息类

#pragma mark -充值方式查询
+(void)userCheckFlowPayMehod:(NSDictionary *)parameters andComplete:(BmobObjectResultBlock)block{
    BmobQuery   *bqueryRate = [BmobQuery queryWithClassName:@"AppConfigStore"];
    [bqueryRate getObjectInBackgroundWithId:@"Ow4i6667" block:^(BmobObject *object, NSError *error) {
        block(object,error);
    }];
    
}

#pragma mark -充值配置查询
+(void)userAddMoneyConfigCount:(NSDictionary *)parameters andComplete:(BmobObjectArrayResultBlock)block{
    BmobQuery   *bqueryRate = [BmobQuery queryWithClassName:@"AddMoneyConfigStore"];
    [bqueryRate orderByDescending:@"createdAt"];//将序排列
    [bqueryRate findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        block(array,error);
    }];
}

#pragma mark -用户预测订单查询
+(void)userOrderListLoad:(NSDictionary *)parameters andComplete:(BmobObjectArrayResultBlock)block{
    
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"OrderForecastStore"];
    [bquery orderByDescending:@"createdAt"];//将序排列
    //构造约束条件
    BmobQuery *inQuery = [BmobQuery queryForUser];
    [inQuery whereKey:@"objectId" equalTo:[BmobUser currentUser].objectId];//构造查询条件
    //匹配查询
    [bquery whereKey:@"author" matchesQuery:inQuery];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        block(array,error);
        
    }];
    
}
#pragma mark -用户预测
+(void)userAddOrderFlow:(NSDictionary *)parameters andComplete:(BmobBooleanResultBlock)block{
    [EFUser updateUserAmount:parameters andStateAdd:NO andBackResult:^(BOOL isSuccessful, NSError *error) {
        URLLog(@"更新用户信息：%@",error);
        block(isSuccessful,error);
        
    }];
}
#pragma mark -用户下注
+(void)userBetOrderFlow:(NSDictionary *)parameters andComplete:(BmobBooleanResultBlock)block{
    //判断用户余额是否支持下注
    EntityUser *login_M = [CustomUtil getUserInfo];
    //取得当前用户金额
    float cureentAmount = [login_M.amount floatValue];
    float needMoney = [parameters[@"yz_money"] floatValue] + [parameters[@"dxq_money"] floatValue];
    if (needMoney > cureentAmount) {
        NSError *error = [NSError errorWithDomain:@"账户余额不足" code:NSFileWriteInapplicableStringEncodingError userInfo: @{@"NSLocalizedDescriptionKey":@"账户余额不足"}];
        block(NO,error);
        return;
    }
    BmobObject *flowScore = [BmobObject objectWithClassName:@"BetOrderStore"];
    //订单列表应该插入用户的信息
    [flowScore setObject:[CustomUtil getUserInfo].username forKey:@"userName"];
    [flowScore setObject:[BmobUser currentUser] forKey:@"author"];
    [flowScore saveAllWithDictionary:parameters];
    [flowScore setObject:[NSString stringWithFormat:@"%.2f",cureentAmount - needMoney] forKey:@"money"];
    [flowScore saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        block(isSuccessful,error);
    }];
    
    //减
    [EFUser updateUserMoneyAmount:needMoney andStateAdd:NO andBackResult:^(BOOL isSuccessful, NSError *error) {
        
    }];
}

//更新某项下注，只能针对未出赛果
#pragma mark -更新赛果
+(void)updateBetOrderListLoad:(NSDictionary *)parameters andComplete:(BmobObjectResultBlock)block{
    
    [[RRCNetWorkManager sharedTool] loadRequestWithURLString:[NSString stringWithFormat:@"https://appbalance2.zqcf718.com/v11/real/time/getOneGameInfo"] isfull:YES parameters:parameters success:^(CGDataResult * _Nonnull result) {
        
        if (result.status.boolValue) {
            
            BmobQuery  *bquery = [BmobQuery queryWithClassName:@"BetOrderStore"];
            
            //查找
            [bquery getObjectInBackgroundWithId:parameters[@"objectId"] block:^(BmobObject *object, NSError *error) {
                
                RRCTScoreModel *scModel = [RRCTScoreModel mj_objectWithKeyValues:result.data];
                
                if ([scModel.state isEqualToString:@"0"]) {
                    NSError *error = [NSError errorWithDomain:@"比赛尚未开始" code:scModel.state.integerValue userInfo: @{@"NSLocalizedDescriptionKey":@"比赛尚未开始"}];
                    block(object,error);
                }else if ([scModel.state isEqualToString:@"1"] || [scModel.state isEqualToString:@"2"] ||[scModel.state isEqualToString:@"3"]  ){
                    NSError *error = [NSError errorWithDomain:@"比赛进行中" code:scModel.state.integerValue userInfo: @{@"NSLocalizedDescriptionKey":@"比赛进行中"}];
                    block(object,error);
                }else if([scModel.state isEqualToString:@"-1"]){
                    //更新两个
                    [object setObject:scModel.homeScore forKey:@"homeScore"];
                    [object setObject:scModel.awayScore forKey:@"awayScore"];
                    [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                        
                        if (isSuccessful) {
                            NSError *error = [NSError errorWithDomain:@"比赛完结" code:scModel.state.integerValue userInfo: @{@"NSLocalizedDescriptionKey":@"比赛进行中"}];
                            block(object,error);
                        }else{
                            block(object,error);
                        }
                    }];
                }else{
                    NSError *error = [NSError errorWithDomain:@"比赛异常" code:labs(scModel.state.integerValue) userInfo: @{@"NSLocalizedDescriptionKey":@"比赛异常"}];
                    block(object,error);
                }
                
            }];
        }else{
            
        }
        
        
    }];
    
}

#pragma mark -用户下注订单查询
+(void)userBetOrderListLoad:(NSDictionary *)parameters andComplete:(BmobObjectArrayResultBlock)block{
    
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"BetOrderStore"];
    [bquery orderByDescending:@"hmd"];//将序排列
    //构造约束条件
    BmobQuery *inQuery = [BmobQuery queryForUser];
    [inQuery whereKey:@"objectId" equalTo:[BmobUser currentUser].objectId];//构造查询条件
    //匹配查询
    [bquery whereKey:@"author" matchesQuery:inQuery];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        block(array,error);
        
    }];
    
}

#pragma mark -用户充值
+(void)userAddAmount:(NSDictionary *)parameters andComplete:(BmobBooleanResultBlock)block{
    BmobObject *obj = [[BmobObject alloc] initWithClassName:@"AmountAddMoney"];
    //    充值方式、订单ID、用户名，充值数目
    [obj saveAllWithDictionary:parameters];
    [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        //        URLLog(@"添加账户信息：%@",error);
        //1、添加聚合币，更新用户信息
        [EFUser updateUserMoneyAmount:[parameters[@"totalMoney"] floatValue] andStateAdd:YES andBackResult:^(BOOL isSuccessful, NSError *error) {
            URLLog(@"更新用户信息：%@",error);
            //如果出现金额更新失败，这个添加记录就需要删除，不能保存
            if (error) {
                [obj deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                    URLLog(@"尚未进行保存");
                }];
            }
            block(isSuccessful,error);
        }];
    }];
}

#pragma mark -查询用户充值流量记录
+(void)queryUserExchangeFlowRecord:(NSDictionary *)paramaters andComplete:(BmobObjectArrayResultBlock)block{
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"OrderIdStore"];
    [bquery orderByDescending:@"createdAt"];//将序排列
    //构造约束条件
    BmobQuery *inQuery = [BmobQuery queryForUser];
    [inQuery whereKey:@"objectId" equalTo:[BmobUser currentUser].objectId];//构造查询条件
    //匹配查询
    [bquery whereKey:@"author" matchesQuery:inQuery];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        block(array,error);
        
    }];
}
#pragma mark -查询用户充账户记录
+(void)queryUserExchangeAmountRecord:(NSDictionary *)paramaters andComplete:(BmobObjectArrayResultBlock)block{
    
    BmobQuery   *bqueryFriend = [BmobQuery queryWithClassName:@"ExChangeStore"];
    BmobQuery *inQuery = [BmobQuery queryForUser];
    [inQuery whereKey:@"objectId" equalTo:[BmobUser currentUser].objectId];//构造查询条件
    [bqueryFriend whereKey:@"author" matchesQuery:inQuery];
    [bqueryFriend findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        //取出好友列表，需要知道对方对好友列表的同意状态，查询对方的表
        block(array,error);
    }];
}
#pragma mark - 游戏红包类
#pragma mark -查询游戏状态
+(void)queryGameSatus:(NSDictionary *)paramaters andComplete:(BmobObjectResultBlock)block{
    BmobQuery *bQuery = [BmobQuery queryWithClassName:@"GameInitStore"];
    [bQuery orderByDescending:@"createdAt"];//将序排列
    [bQuery getObjectInBackgroundWithId:paramaters[@"ObjectId"] block:^(BmobObject *object, NSError *error) {
        
        block(object,error);
        
    }];
    
}
#pragma mark - 私有方法
+(NSDictionary *)backDataResults_webService:(NSString *)webService AndDic:(NSDictionary *)dicTionary{
    NSString *urlNew = [NSString stringWithFormat:@"%@%@",WEBSEARVICE,webService];
    [self deletebugDic:dicTionary andBugUrl:urlNew];
    AFHTTPRequestSerializer *requestOperation = [[AFHTTPRequestSerializer alloc] init];
    NSMutableURLRequest *urlrequest =  [requestOperation requestWithMethod:@"POST" URLString:[self getURLByString:urlNew] parameters:dicTionary error:nil];
    return [self handleNetData:urlrequest];
    
}
/**调试输出网址*/
+(void)deletebugDic:(NSDictionary *)dicTionary andBugUrl:(NSString *)url{
    NSMutableDictionary *tempMutable = [NSMutableDictionary dictionaryWithDictionary:dicTionary];
    //调试
    NSMutableString *mutableString = [[NSMutableString alloc]initWithString:[NSString stringWithFormat:@"%@",url]];
    for (NSString *key in tempMutable.allKeys) {
        if ([tempMutable[key] isKindOfClass:[NSString class]]) {
            NSString *value = tempMutable[key];
            if (value.length<1) {
                [tempMutable removeObjectForKey:key];
            }
            [mutableString appendFormat:@"%@", [NSString stringWithFormat:@"&%@=%@",key,tempMutable[key]]];
        }
    }
    URLLog(@"%@",mutableString);
}
+(NSDictionary *)handleNetData:(NSMutableURLRequest *)request{
    NSURLResponse *reponse;
    NSError *error = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&reponse error:&error];
    //集合
    NSDictionary *dic = [NSDictionary new];
    
    if (error) {
        return @{};
    }else {
        if (responseData) {
            dic = [self getDicFromData:responseData];
            if (dic) {
                NSString *jstrParam = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dic options:0 error:nil] encoding:NSUTF8StringEncoding];
                URLLog(@"%@",jstrParam);
            }
        }
        return dic;
    }
}
//处理回车单引号引起的错误
+(NSDictionary *)getDicFromData:(NSData *)d1{
    //处理掉回车、单引号引起的格式出错
    NSString *str = [[NSString alloc]initWithData:d1 encoding:NSUTF8StringEncoding];
    NSString *str1 = [[[str stringByReplacingOccurrencesOfString:@"\n" withString:@"%0A"]stringByReplacingOccurrencesOfString:@"\r" withString:@"%0D"] stringByReplacingOccurrencesOfString:@"\t" withString:@"%09"];
    NSData *d = [str1 dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSDictionary *dic = [[NSJSONSerialization JSONObjectWithData:d options:NSJSONReadingMutableContainers error:nil] mutableCopy];
    
    dic = [self dealObjectWithObj:dic];
    return dic;
}
/**
 *  递归调用
 *
 *  @param obj 要处理的对象
 *
 *  @return 处理过后的值
 */
+(id)dealObjectWithObj:(id)obj{
    if ([obj isKindOfClass:[NSArray class]]) {
        NSMutableArray *arr = [NSMutableArray new];
        for (id d in (NSArray *)obj) {
            [arr addObject:[self dealObjectWithObj:d]];
        }
        return arr;
    }else if ([obj isKindOfClass:[NSDictionary class]]){
        NSMutableDictionary *dic = [NSMutableDictionary new];
        for (NSString *s in ((NSDictionary *)obj).allKeys) {
            dic[s] = [self dealObjectWithObj:obj[s]];
        }
        return dic;
    }else{
        NSString *str = obj;
        if ([str isKindOfClass:[NSString class]]) {
            str = [[[str stringByReplacingOccurrencesOfString:@"%0A" withString:@"\n"]stringByReplacingOccurrencesOfString:@"%0D" withString:@"\r"] stringByReplacingOccurrencesOfString:@"%09" withString:@"\t"] ;
        }
        return str;
    }
}
+(NSString *)getURLByString:(NSString *)str{
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return str;
}

#pragma mark - 其他方法
//大小球计算方式
+(void)handleDxqSmallText:(RRCBetRecordModel *)scoreModel{
    //获取大小球结果
    float allScoreDif = scoreModel.dxq_dxdif.floatValue;
    float realresults = 0;
    //命中大小球计算
    if ([scoreModel.status integerValue]) {
        realresults = scoreModel.homeScore.floatValue + scoreModel.awayScore.floatValue - scoreModel.dxq_pk.floatValue;
        //最终结果相等走水
        if (realresults == 0) {
            scoreModel.dxq_win = @"2";
        }else{
            if ((realresults > 0 && allScoreDif > 0)||( realresults < 0 && allScoreDif <= 0)) {
                scoreModel.dxq_win = @"1";
            }else{
                scoreModel.dxq_win = @"0";
            }
        }
    }else{
        scoreModel.dxq_win = @"-1";
    }
    
    //更新最终盈利
    if (scoreModel.dxq_win.integerValue == 1) {
        if (fabsf(realresults) == 0.25) {
            scoreModel.dxq_winMoney = [NSString stringWithFormat:@"%.2f",scoreModel.dxq_pk_water.floatValue * scoreModel.dxq_money.floatValue * 0.5];
        }else{
            scoreModel.dxq_winMoney = [NSString stringWithFormat:@"%.2f",scoreModel.dxq_pk_water.floatValue * scoreModel.dxq_money.floatValue];
        }
    }else if (scoreModel.dxq_win.integerValue == 0){
        if (fabsf(realresults) == 0.25) {
            scoreModel.dxq_winMoney = [NSString stringWithFormat:@"-%.2f",scoreModel.dxq_money.floatValue * 0.5];
        }else{
            scoreModel.dxq_winMoney = [NSString stringWithFormat:@"-%.2f",scoreModel.dxq_money.floatValue];
        }
        
    }else if(scoreModel.dxq_win.integerValue == 2){
        //走水
        scoreModel.dxq_winMoney = [NSString stringWithFormat:@"0"];
    }else{
        scoreModel.dxq_winMoney = [NSString stringWithFormat:@"-"];
    }
}

+(void)handleyzpK:(RRCBetRecordModel *)scoreModel{
    //获取亚指猜测结果
    float allScoreYazhiDif = scoreModel.yz_dxdif.floatValue;//
    float realYaResults    = 0;
    if ([scoreModel.status integerValue]) {
        //计算亚指结果
        realYaResults = scoreModel.homeScore.floatValue - scoreModel.awayScore.floatValue + scoreModel.yz_pk.floatValue;
        if (realYaResults == 0) {
            scoreModel.yz_win = @"2";
        }else{
            if ((realYaResults > 0 && allScoreYazhiDif > 0)||( realYaResults < 0 && allScoreYazhiDif < 0)) {
                scoreModel.yz_win = @"1";
            }else{
                scoreModel.yz_win = @"0";
            }
        }
    }else{
        scoreModel.yz_win = @"-1";
    }
    
    if (scoreModel.yz_win.integerValue == 1) {
        //判断是否赢一半
        if (fabsf(realYaResults) == 0.25) {
            scoreModel.yz_winMoney = [NSString stringWithFormat:@"%.2f",scoreModel.yz_pk_water.floatValue * scoreModel.yz_money.floatValue * 0.5];
        }else{
            scoreModel.yz_winMoney = [NSString stringWithFormat:@"%.2f",scoreModel.yz_pk_water.floatValue * scoreModel.yz_money.floatValue];
        }
    }else if (scoreModel.yz_win.integerValue == 0){
        //判断是否输一半
        if (fabsf(realYaResults) == 0.25) {
            scoreModel.yz_winMoney = [NSString stringWithFormat:@"-%.2f",scoreModel.yz_money.floatValue * 0.5];
        }else{
            scoreModel.yz_winMoney = [NSString stringWithFormat:@"-%.2f",scoreModel.yz_money.floatValue];
        }
    }else if(scoreModel.yz_win.integerValue == 2){
        //走水
        scoreModel.yz_winMoney = [NSString stringWithFormat:@"0"];
    }else{
        scoreModel.yz_winMoney = [NSString stringWithFormat:@"-"];
    }
}

@end

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
    //账户充值
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

//#pragma mark -预测次数查询
//+(void)userCheckForecastCount:(NSDictionary *)parameters andComplete:(BmobObjectResultBlock)block{
//    BmobQuery   *bqueryRate = [BmobQuery queryWithClassName:@"AppConfigStore"];
//    [bqueryRate getObjectInBackgroundWithId:@"Ow4i6667" block:^(BmobObject *object, NSError *error) {
//        block(object,error);
//    }];
//    
//}

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
        //如果出现金额更新失败，这个添加记录就需要删除，不能保存
        if (error) {
            block(isSuccessful,error);
        }else{
            //可以查询
            BmobObject *flowScore = [BmobObject objectWithClassName:@"OrderForecastStore"];
            //订单列表应该插入用户的信息
            [flowScore setObject:[CustomUtil getToken] forKey:@"token"];
            [flowScore setObject:[CustomUtil getToken] forKey:@"userName"];
            [flowScore setObject:[BmobUser currentUser] forKey:@"author"];
            
            [flowScore saveAllWithDictionary:parameters];
            
            [flowScore saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                block(isSuccessful,error);
            }];
        }
    }];
}

#pragma mark -用户充值
+(void)userAddAmount:(NSDictionary *)parameters andComplete:(BmobBooleanResultBlock)block{
    BmobObject *obj = [[BmobObject alloc] initWithClassName:@"ExChangeStore"];
    //    充值方式、订单ID、用户名，充值数目
    [obj saveAllWithDictionary:parameters];
    [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        //        URLLog(@"添加账户信息：%@",error);
        //1、添加聚合币，更新用户信息
        [EFUser updateUserAmount:parameters[@"totalMoney"] andStateAdd:YES andBackResult:^(BOOL isSuccessful, NSError *error) {
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
@end

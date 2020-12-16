//
//  EFUser.m
//  EagleFast
//
//  Created by ggx on 2017/7/5.
//  Copyright © 2017年 高广校. All rights reserved.
//

#import "EFUser.h"
#import "NSString+Common.h"
#import "OpenUDID.h"
#import "RRCNetWorkManager.h"
@implementation EFUser
+(void)registerUserUserName:(NSString *)userName andPassWord:(NSString *)psw andTelepnone:(NSString *)tele andBackResult:(void(^)(EntityUser *user,BOOL isSuccessful, NSError *error))block{
    BmobUser *user = [[BmobUser alloc]init];
    user.username  = userName;
    user.password  = psw;
    user.mobilePhoneNumber = tele;
    [user setObject:tele forKey:@"phone"];
    [user setObject:@"1000" forKey:@"amount"];//注册用户赠送1000聚合币
    [user setObject:@"1" forKey:@"userLevel"];
    [user setObject:@"true" forKey:@"isExchange"];
    [user setObject:@"100" forKey:@"userForecast"];//注册用户默认5次预测
    //设置唯一token,id+用户名+设备
    NSString *tokenString = [NSString md5String:[NSString stringWithFormat:@"%@%@%@",API_OPENID,userName,[OpenUDID value]]];
    [user setObject:tokenString forKey:@"token"];
    
    [user signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
        
        EntityUser *userEntity = [EntityUser new];
        if (isSuccessful) {
            userEntity = [self updateLocalUser:user andLoginUserPsw:psw];
        }else{
            
        }
        block(userEntity,isSuccessful,error);
    }];
}

+(void)loginYQUserName:(NSString *)userName andPassWord:(NSString *)psw andBackResult:(void(^)(EntityUser *user,BOOL isSuccessful, NSError *error))block{
    
    [self loginInbackgroundWithAccount:userName andPassword:psw block:^(BmobUser *user, NSError *error) {
        if (user) {
            
            EntityUser *userEntity = [self updateLocalUser:user andLoginUserPsw:psw];
            
            block(userEntity,YES,error);

        } else {
            
            block([EntityUser new],NO,error);
            
//            NSLog(@"%@",[error description]);
        }
    }];
}

+(void)updateUserMoneyAmount:(float )changeAmount andStateAdd:(BOOL)isAdd andBackResult:(void(^)(BOOL isSuccessful, NSError *error))block{

    EntityUser *login_M = [CustomUtil getUserInfo];
    
    //取得当前用户金额
    float cureentAmount = [login_M.amount floatValue];
    
    NSString *updateAmount  = [NSString stringWithFormat:@"%.1f",isAdd? changeAmount + cureentAmount : cureentAmount - changeAmount];
    
    //3、账户余额不足
    if ([updateAmount floatValue] < 0) {
        NSError *error = [NSError errorWithDomain:@"账户余额不足" code:NSFileWriteInapplicableStringEncodingError userInfo: @{@"NSLocalizedDescriptionKey":@"账户余额不足"}];
        block(NO,error);
        return;
    }else{

        BmobUser *loginUser = [BmobUser currentUser];
//        更新余额
        [loginUser setObject:updateAmount forKey:@"amount"];
      
        //是否更新账户的余额、由用户状态决定
        //更新等级0~500/500~2000/2000~5000、5000~10000
        //十个等级
//        @[@"100",@"200",
//        @"600",@"1800",
//        @"5400",@"16200",
//        @"48600",@"145800",
//        @"437400",@"437400"];
        if ([updateAmount intValue]<300) {//
            [loginUser setObject:@"1" forKey:@"userLevel"];
        }else if ([updateAmount intValue]<2400){
            [loginUser setObject:@"2" forKey:@"userLevel"];
        }else if ([updateAmount intValue]<21600){
            [loginUser setObject:@"3" forKey:@"userLevel"];
        }else if ([updateAmount intValue]<194400){
            [loginUser setObject:@"4" forKey:@"userLevel"];
        }else{
            [loginUser setObject:@"5" forKey:@"userLevel"];
        }
        
        //异步更新数据
        [loginUser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            block(isSuccessful,error);
            [[NSNotificationCenter defaultCenter]postNotificationName:K_APNNOTIFICATIONAmountUpdate object:@(YES)];
            
        }];
    }
}

+(void)updateUserAmount:(NSDictionary *)changeDict andStateAdd:(BOOL)isAdd andBackResult:(void(^)(BOOL isSuccessful, NSError *error))block{
//

    EntityUser *login_M = [CustomUtil getUserInfo];
    //1、账户没有预测权限
    if (!login_M.isExchange) {
        NSError *error = [NSError errorWithDomain:@"账户没有预测权限" code:NSFileWriteInapplicableStringEncodingError userInfo: @{@"NSLocalizedDescriptionKey":@"账户没有预测权限"}];
        block(NO,error);
        return;
    }
    
    //取得当前用户预测次数
    NSInteger cureentForeNum = [login_M.userForecast integerValue];
    //要预测的赛事数量
    NSInteger userForecastNum = [[changeDict valueForKey:@"userForecastCount"] integerValue];
    
    //2、账户预测次数为0
    if (userForecastNum > cureentForeNum) {
        NSString *erM = [NSString stringWithFormat:@"单次预测数量限制%@场",login_M.userForecast];
        NSError *error = [NSError errorWithDomain:erM code:NSFileWriteInapplicableStringEncodingError userInfo: @{@"NSLocalizedDescriptionKey":erM}];
        block(NO,error);
        return;
    }
    
    float changeAmount = userForecastNum * 0;//
    [self updateUserMoneyAmount:changeAmount andStateAdd:isAdd andBackResult:^(BOOL isSuccessful, NSError *error) {
        block(isSuccessful,error);
    }];
     
}
+(void)updatePostUserRationState:(NSString *)state andPostId:(BmobObject *)post andBackResult:(void (^)(BOOL, NSError *))block{
    //获取要添加关联关系的post
    
    //判断是否可以处理这种添加关系，也就是取出发帖数量，做更新处理
    NSString *finalNum = [EFUser queryStoreName:post andChangeNumber:state];
    if ([finalNum floatValue]>=0) {
        //设置最新的数量
        [post setObject:finalNum forKey:@"remaining"];//
        //设置状态
        [post setObject:[finalNum floatValue]==0?@"1":@"0" forKey:@"state"];
        //设置关系
        BmobRelation *relation = [[BmobRelation alloc] init];
        [relation addObject:[BmobUser currentUser]];
        //添加关联关系到likes列中
        [post addRelation:relation forKey:@"likes"];
        //异步更新obj的数据
        [post updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                block(isSuccessful,error);
                //            NSLog(@"successful");
            }else{
                NSLog(@"error %@",[error description]);
            }
            
            
        }];
    }else{
        NSError *error = [NSError errorWithDomain:@"com.company.framework_or_app.ErrorDomain" code:NSFileWriteInapplicableStringEncodingError userInfo: @{@"NSLocalizedDescriptionKey":@"被领完"}];
        block(NO,error);
    }
}
+(NSString *)queryStoreName:(BmobObject *)objectStore andChangeNumber:(NSString *)number{
    float cureentAmount = [[objectStore objectForKey:@"remaining"] floatValue];
    return [NSString stringWithFormat:@"%.1f",cureentAmount - [number floatValue]];
}
#pragma mark - 更新用户头像
+(void)updateUserUserLoad:(UIImage *)userLogo andBackResult:(void (^)(BOOL, NSError *))block{
    
    BmobUser *user = [BmobUser currentUser];
    
    NSData *imageData = UIImageJPEGRepresentation(userLogo, 0.8);
    NSString *fileString = [NSString stringWithFormat:@"%@Picture%d.png" ,user.username,arc4random()%100];
    BmobFile *file1 = [[BmobFile alloc] initWithFileName:fileString withFileData:imageData];
    
    [file1 saveInBackground:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            BmobUser *loginUser = [BmobUser currentUser];
            [loginUser setObject:file1.url forKey:@"portraitUri"];
            //异步更新数据
            [loginUser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                URLLog("%@",error);
                block(isSuccessful,error);
            }];
            
        }else{
            block(isSuccessful,error);
            NSLog(@"%@",error);
        }
    } withProgressBlock:^(CGFloat progress) {
        NSLog(@"上传进度：%f",progress);
    }];
    
}
#pragma mark - 获取用户信息
+(void)getUserInfo:(BmobUserResultBlock)block{
    BmobUser *user1 = [BmobUser currentUser];
    [self loginInbackgroundWithAccount:user1.username andPassword:[CustomUtil getUserInfo].password block:^(BmobUser *user, NSError *error) {
    
        EntityUser *userEntity = [self updateLocalUser:user andLoginUserPsw:[CustomUtil getUserInfo].password];
        
        [CustomUtil saveUserInfo:userEntity];

//        URLLog(@"更新结果%@",error);
        block(user,nil);
    }];
}

+(EntityUser *)updateLocalUser:(BmobUser *)user andLoginUserPsw:(NSString *)psw{
 
    EntityUser *userEntity = [EntityUser new];
    if (psw) {
        userEntity.password = psw;
    }else{
        userEntity.password = [CustomUtil getUserInfo].password;
    }
    
    userEntity.username = user.username;
    userEntity.phone    = [user objectForKey:@"phone"];
    userEntity.amount   = [user objectForKey:@"amount"];
    userEntity.userLevel = [user objectForKey:@"userLevel"];
    userEntity.portraitUri = [user objectForKey:@"portraitUri"];
    userEntity.token       = [user objectForKey:@"token"];
    
    //设置全局通用参数
    [[RRCNetWorkManager sharedTool].baseParameters setValue:userEntity.token forKey:@"device_id"];
    
    userEntity.userForecast = [user objectForKey:@"userForecast"];
    userEntity.isExchange  = [[user objectForKey:@"isExchange"] boolValue];
    return userEntity;
}
@end

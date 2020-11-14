//
//  EntityUser.h
//  SimpleSrore
//
//  Created by ggx on 2017/3/16.
//  Copyright © 2017年 高广校. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>
@interface EntityUser : NSObject
@property (copy, nonatomic) NSString *username;//用户名
@property (copy, nonatomic) NSString *password;//密码
@property (copy, nonatomic) NSString *mobilePhoneNumber;//手机号

@property (copy, nonatomic) NSString *amount;//账户余额
@property (nonatomic , copy) NSString *phone;//联系电话
@property (nonatomic , copy) NSString *userLevel;//用户等级
@property (nonatomic , copy) NSString *portraitUri;//用户头像
@property(nonatomic , copy) NSString *token;//用户token

@property (nonatomic , strong) NSString *userForecast;//用户预测次数

@property (nonatomic , assign) BOOL isExchange;
@end

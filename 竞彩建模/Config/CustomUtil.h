//
//  CustomUtil.h
//  SimpleSrore
//
//  Created by ggx on 2017/3/15.
//  Copyright © 2017年 高广校. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EntityUser.h"

//用户信息
#define U_INFO @"U_INFO"//用户信息
#define U_TOKEN @"TOKEN"
@interface CustomUtil : NSObject
+(BOOL)isUserLogin;
+(void)saveAcessToken:(NSString *)token;
+(void)delAcessToken;
+(NSString *)getToken;

+(void)saveUserInfo:(EntityUser *)info;
+(EntityUser *)getUserInfo;
+(void)deleUserInfo;
@end

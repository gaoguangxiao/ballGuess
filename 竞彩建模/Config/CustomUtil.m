//
//  CustomUtil.m
//  SimpleSrore
//
//  Created by ggx on 2017/3/15.
//  Copyright © 2017年 高广校. All rights reserved.
//

#import "CustomUtil.h"
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]
@implementation CustomUtil

+(BOOL)isUserLogin{
    if ([self getToken].length) {
        return YES;
    }else{
        return NO;
    }
}
+(void)saveAcessToken:(NSString *)token{
    NSUserDefaults  *settings = USER_DEFAULT;
    [settings setObject:token forKey:U_TOKEN];
    [settings synchronize];
}
+(NSString *)getToken{
    NSUserDefaults  *settings = USER_DEFAULT;
    return [settings valueForKey:U_TOKEN]?[settings valueForKey:U_TOKEN]:@"";
}
+(void)delAcessToken{
    NSUserDefaults  *settings = USER_DEFAULT;
    [settings removeObjectForKey:U_TOKEN];
    [settings synchronize];
}

+(void)saveUserInfo:(EntityUser *)info{
    NSUserDefaults  *settings = USER_DEFAULT;
    [settings setObject:[NSKeyedArchiver archivedDataWithRootObject:[info mj_keyValues]] forKey:U_INFO];
    [settings synchronize];
}

+(EntityUser *)getUserInfo{
    NSUserDefaults  *settings = USER_DEFAULT;
    NSDictionary *d = [NSKeyedUnarchiver unarchiveObjectWithData:[settings valueForKey:U_INFO]];
    return [EntityUser mj_objectWithKeyValues:d];
}

+(void)deleUserInfo{
    NSUserDefaults *settings = USER_DEFAULT;
    [settings removeObjectForKey:U_INFO];
    [settings synchronize];
}

@end

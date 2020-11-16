//
//  EFUser.h
//  EagleFast
//
//  Created by ggx on 2017/7/5.
//  Copyright © 2017年 高广校. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EFUser : BmobUser

/**
 用户注册

 @param userName 用户昵称
 @param psw 登陆密码
 @param tele 用户电话号码
 @param block <#block description#>
 */
+(void)registerUserUserName:(NSString *)userName andPassWord:(NSString *)psw andTelepnone:(NSString *)tele andBackResult:(void(^)(EntityUser *user,BOOL isSuccessful, NSError *error))block;



/// 用户登录
/// @param userName <#userName description#>
/// @param psw <#psw description#>
/// @param block <#block description#>
+(void)loginYQUserName:(NSString *)userName andPassWord:(NSString *)psw andBackResult:(void(^)(EntityUser *user,BOOL isSuccessful, NSError *error))block;


+(void)updateUserMoneyAmount:(float )changeAmount andStateAdd:(BOOL)isAdd andBackResult:(void(^)(BOOL isSuccessful, NSError *error))block;

/**
 更新用户余额信息

 @param changeAmount 变动的金额
 @param isAdd 是否增加
 */
+(void)updateUserAmount:(NSDictionary *)changeAmount andStateAdd:(BOOL)isAdd andBackResult:(void(^)(BOOL isSuccessful, NSError *error))block;

/**
 更新帖子对应用户的领取情况

 @param state 需要更新的状态
 @param block <#block description#>
 */
+(void)updatePostUserRationState:(NSString *)state andPostId:(BmobObject *)post andBackResult:(void (^)(BOOL, NSError *))block;

/**
 更新用户头像

 @param userLogo <#userLogo description#>
 */
+(void)updateUserUserLoad:(UIImage *)userLogo andBackResult:(void (^)(BOOL, NSError *))block;

/**
 获取用户信息

 @param block <#block description#>
 */
+(void)getUserInfo:(BmobUserResultBlock)block;
@end

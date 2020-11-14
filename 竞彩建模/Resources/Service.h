//
//  Service.h
//  CPetro
//
//  Created by ggx on 2017/3/10.
//  Copyright © 2017年 高广校. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"

#import "CGDataResult.h"

typedef void (^returnObject)(CGDataResult *obj,BOOL b);

@interface Service : NSObject


@property(nonatomic,strong) AFHTTPSessionManager * manager;
/**
 *  获取网络数据
 *
 *  @param parameters @{}
 *  @param methodName 接口名字
 *
 *  @return return value description
 */
+(CGDataResult *)loadNetWorkingByParameters:(NSDictionary *)parameters andBymethodName:(NSString *)methodName;


+(void)loadBmobanimation:(BOOL)animated andTitle:(NSString *)title andObjectByParameters:(NSDictionary *)parameters andByStoreName:(NSString *)storeName constructingBodyWithBlock:(returnObject)block;
/**
 获取bmob数据

 @param parameters 请求的参数
 @param storeName 表的名称
 @ 返回的数据
 */
+(void)loadBmobObjectByParameters:(NSDictionary *)parameters andByStoreName:(NSString *)storeName constructingBodyWithBlock:(returnObject)block;
+(CGDataResult *)postImageByUrlByParameters:(NSDictionary *)parameters andBymethodName:(NSString *)methodName andByImageData:(NSData *)imageData andImageKey:(NSString *)imageKey;
//+(void)postImageByUrl:(NSString*)url withParameters:(NSDictionary*)parameters andImageData:(NSData*)imageData imageKey:(NSString *)imageKey andComplain:(returnObject)complain;
/*!
 *  @author mac
 *
 *  @brief 多张图片上传，图片的二进制数据直接放在对应的key里面，统一放在argvs内部
 *
 */
+(CGDataResult *)postMany:(NSDictionary *)argvs andUrl:(NSString *)url;
@end

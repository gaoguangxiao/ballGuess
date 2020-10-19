//
//  RRCNetworkTool.h
//  MXSFramework
//
//  Created by 晓松 on 2018/11/14.
//  Copyright © 2018年 MXS. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "CGDataResult.h"
NS_ASSUME_NONNULL_BEGIN

@interface RRCNetWorkManager : AFHTTPSessionManager

//地址
@property (nonatomic, strong) NSString *webUrl;

//H5地址
@property (nonatomic , strong) NSString *h5Url;

//配置基础参数
@property (nonatomic, strong) NSMutableDictionary *baseParameters;

/**
 创建网络请求工具类的单例
 */
+ (instancetype)sharedTool;

- (void)loadRequestWithURLString: (NSString *)URLString
                      parameters: (NSDictionary *)parameters
                         success:(void (^)(CGDataResult *result))success;


- (void)loadRequestWithURLString: (NSString *)URLString
    isfull: (BOOL)isfull
parameters: (NSDictionary *)parameters
                         success:(void (^)(CGDataResult *result))success;

//取消所有网络请求
- (void)cancelAllTask;
// 取消当前请求任务
- (void)cancelCurrentTask;

@property (nonatomic,copy) NSURLSessionDataTask *task;
@end

NS_ASSUME_NONNULL_END

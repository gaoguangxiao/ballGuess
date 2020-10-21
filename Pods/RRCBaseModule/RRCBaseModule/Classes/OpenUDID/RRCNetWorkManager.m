//
//  RRCNetworkTool.m
//  MXSFramework
//
//  Created by 晓松 on 2018/11/14.
//  Copyright © 2018年 MXS. All rights reserved.
//

#import "RRCNetWorkManager.h"
#import "OpenUDID.h"
#import "MJExtension.h"
@interface RRCNetWorkManager()
@property(nonatomic ,assign) NSUInteger taskIdentifier;

@end

@implementation RRCNetWorkManager

+ (instancetype)sharedTool {
    static RRCNetWorkManager * instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //timeoutIntervalForRequest
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfig.timeoutIntervalForRequest = 60.0f;
        instance = [[self alloc] initWithBaseURL:nil sessionConfiguration:sessionConfig];
        instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",@"image/jpeg",nil];
        
        //避免没有地址而崩溃
        instance.webUrl = @"http://123.56.15.17:8081/rrcapp";
        
        // 1.获得网络监控的管理者
        instance.reachabilityManager = [AFNetworkReachabilityManager sharedManager];
        [instance.requestSerializer setValue:@"any-value" forHTTPHeaderField:@"If-None-Match"];
        instance.securityPolicy.allowInvalidCertificates = NO;
        // 2.设置网络状态改变后的处理
        [instance.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        }];
        // 3.开始监控
        [instance.reachabilityManager startMonitoring];
    });
    
    return instance;
}

//取消全部请求
-(void)cancelAllRequest{
    [self.operationQueue cancelAllOperations];
}
/// 取消当前请求任务
- (void)cancelCurrentTask {
    // cancel specific task
    for (NSURLSessionDataTask* task in [self tasks]) {
        if (task.taskIdentifier == self.taskIdentifier) {
            [task cancel];
        }
    }
}
/// 取消所有请求任务
- (void)cancelAllTask {
    [self.task cancel];
}
- (void)loadRequestWithURLString: (NSString *)URLString
                          isfull: (BOOL)isfull
                      parameters: (NSDictionary *)parameters
                         success:(void (^)(CGDataResult *result))success{
    NSString *requestMethod = @"POST";
    NSString *webserviceUrl = self.webUrl;
    NSMutableDictionary *parametersdic = [[NSMutableDictionary alloc]init];
    NSString *deviceId = [OpenUDID value];
    deviceId = @"8a4636842d9f2736e3fcb57b0977e08851ecf8e0";
//    e05582c4aa36e1f10f21c4396ebf1cb5827004de
    
    if (isfull) {
        webserviceUrl = URLString;
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        
        NSMutableDictionary *dictTemp = [NSMutableDictionary new];
        [dictTemp addEntriesFromDictionary:parameters];
        
        [dictTemp setValue:app_Version forKey:@"version"];
        [dictTemp setValue:@"1" forKey:@"v"];
        [dictTemp setValue:@"ios" forKey:@"platform"];
        [dictTemp setValue:@"1" forKey:@"device_type"];
        [dictTemp setValue:deviceId forKey:@"device_id"];
        
        [parametersdic setValue:dictTemp forKey:@"params"];
        
    }else{
        NSString *device_id_key = [OpenUDID value];
        if ([[NSUserDefaults standardUserDefaults]valueForKey:device_id_key]) {
            webserviceUrl = [[NSUserDefaults standardUserDefaults]valueForKey:device_id_key];
        }
        webserviceUrl = [webserviceUrl stringByAppendingPathComponent:URLString];
        
        [parametersdic addEntriesFromDictionary:parameters];
        if (deviceId) {
            [parametersdic setValue:deviceId forKey:@"device_id"];
        }
    }
    NSLog(@"deviceId:%@",deviceId);
    // 请求参数字典
    if (self.baseParameters) {
        [parametersdic addEntriesFromDictionary:self.baseParameters];
    }

    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:requestMethod URLString:webserviceUrl parameters:parametersdic error:nil];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    self.task = [self dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            NSData *data = nil;
            if (responseObject != nil) {
                data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
            }
            CGDataResult *r = [CGDataResult getResultFromDic:responseObject];
//            NSLog(@"响应参数：%@",[responseObject mj_JSONString]);
            success(r);
        } else {
            NSMutableDictionary *errorDict = [NSMutableDictionary new];
            [errorDict setValue:@"网络不好，请检查您的网络设置" forKey:@"msg"];
            [errorDict setValue:@(404) forKey:@"code"];
            if (error.code == -999) {
                //已取消 网络取消
                [errorDict setValue:error.userInfo[@"NSLocalizedDescription"] forKey:@"msg"];
                [errorDict setValue:@(error.code) forKey:@"code"];
            }else if (error.code == -1009){
                //断开连接
            }
            CGDataResult *r = [CGDataResult getResultFromDic:errorDict];
            success(r);
        }
    }];
    self.taskIdentifier = self.task.taskIdentifier;
    [self.task resume];
}

- (void)loadRequestWithURLString: (NSString *)URLString
                      parameters: (NSDictionary *)parameters
                         success:(void (^)(CGDataResult *result))success{
    [self loadRequestWithURLString:URLString isfull:NO parameters:parameters success:^(CGDataResult *result) {
        success(result);
    }];
}

-(NSDictionary*)getSystemInfo{
    //统一参数拼接
    /*
     1、sysname：平台标识；如：ios、andorid；
     2、deviceid：设备标示符；如：quid；
     3、appversion：应用版本号：如1.0.1
     可选：
     4、sysversion：系统版本号；如9.3系统版本
     5、syssn：系统型号；如iphone，iPad，
     6、appname：软件名称
     7.appbundleid
     */
    NSString * sysname = @"ios";
    NSString * deviceid  = [OpenUDID value];
    NSString * appversion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString * sysversion=  [[UIDevice currentDevice] systemVersion];
    NSString *appname = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    NSString* syssn = [[UIDevice currentDevice] model];
    NSString *appbundleid = [[NSBundle mainBundle] bundleIdentifier];
    NSDictionary * sysInfo = @{
        @"YBSysName":sysname,
        @"YBDeviceId":deviceid,
        @"YBAppVersion":appversion,
        @"YBSysVersion":sysversion,
        @"YBSyssn":syssn,
        @"YBAppName":appname,
        @"YBAppbundleid":appbundleid
    };
    return sysInfo;
}

-(NSMutableDictionary *)baseParameters{
    if (!_baseParameters) {
        _baseParameters = [NSMutableDictionary new];
    }
    return _baseParameters;
}
@end

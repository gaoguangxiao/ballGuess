//
//  RRCUpLoadImageTools.m
//  MXSFramework
//
//  Created by 晓松 on 2018/11/19.
//  Copyright © 2018年 MXS. All rights reserved.
//

#import "RRCUpLoadImageTools.h"
#import "QiniuSDK.h"
#import "RRCNetWorkManager.h"
@implementation RRCUpLoadImageTools
/**
 单张上传
 
 @param image data
 */
- (void)uploadImage:(NSData *)image success:(void (^)(NSDictionary *responseObject))success failure:(void (^)(NSError *error))failure{
    //先获取token
    [[RRCNetWorkManager sharedTool]loadRequestWithURLString:@"qiniutoken" parameters:@{} success:^(CGDataResult * _Nonnull result) {
        if (result.status.boolValue) {
            NSString *token = result.data;
            QNConfiguration *config =[QNConfiguration build:^(QNConfigurationBuilder *builder) {
                //设置区域
                builder.zone=[QNFixedZone zone1];
            }];
            NSString *key2 = [NSString stringWithFormat:@"%@", [self getDateTimeString]];
            QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration: config];
            [upManager putData:image key:key2 token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                success(@{@"imagesUrl":key2});
            } option:nil];
        }else{
            NSError *error = [NSError errorWithDomain:result.errorMsg code:result.code userInfo:@{}];
            failure(error);
        }
    }];
    
}

//imageArr 可以是图片也可以是data
-(void)uploadImageArray:(NSArray*)imageArray keyArray:(NSArray *)keyArray success:(void(^)(NSDictionary*responseObject))success failure:(void(^)(NSError *error))failure{
    
    [[RRCNetWorkManager sharedTool]loadRequestWithURLString:@"qiniutoken" parameters:@{} success:^(CGDataResult * _Nonnull result) {
        if (result.status.boolValue) {
            NSString *token = result.data;
                NSMutableArray *dataArray = [NSMutableArray array];
                NSMutableArray * paiXuArray = [NSMutableArray array];
                
                for (int i=0;i<imageArray.count;i++) {
                    id obj= imageArray[i];
                    if ([obj isKindOfClass:[NSString class]]) {
                        [paiXuArray addObject:obj];
                        [dataArray addObject:obj];
                        if (paiXuArray.count == imageArray.count) {
                            success(@{@"imagesUrl":paiXuArray});
                        }
                    }else{
                        NSData * ImgData = obj;
                        NSString *key = [NSString stringWithFormat:@"%@", keyArray[i]];
                        QNConfiguration *config =[QNConfiguration build:^(QNConfigurationBuilder *builder) {
                            //设置区域
                            builder.zone=[QNFixedZone zone1];
                        }];
                        QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration: config];
                        
                        [upManager putData:ImgData key:key token:token
                                  complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                                      
                                      if (!info.error) {
                                          [dataArray addObject:key];
                                          if (dataArray.count == imageArray.count) {
                                              
                                              success(@{@"imagesUrl":keyArray});
                                          }
                                      }else{
                                          failure(info.error);
                                      }
                                      
                                  } option:nil];
                    }
                }
            }
        else{
            NSError *error = [NSError errorWithDomain:result.errorMsg code:result.code userInfo:@{}];
            failure(error);
        }
    }];
    
}

//给图片命名
- (NSString*)getDateTimeString
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%.f",a];
    return timeString;
}

@end

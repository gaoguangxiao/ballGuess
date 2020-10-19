//
//  RRCUpLoadImageTools.h
//  MXSFramework
//
//  Created by 晓松 on 2018/11/19.
//  Copyright © 2018年 MXS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RRCUpLoadImageTools : NSObject
//单张图片
- (void)uploadImage:(NSData *)image success:(void (^)(NSDictionary *responseObject))success failure:(void (^)(NSError *error))failure;
//多张图片
-(void)uploadImageArray:(NSArray*)imageArray keyArray:(NSArray *)keyArray success:(void(^)(NSDictionary*responseObject))success failure:(void(^)(NSError *error))failure;
@end

NS_ASSUME_NONNULL_END

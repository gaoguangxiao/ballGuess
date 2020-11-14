//
//  RRCPortSecretTool.h
//  MXSFramework
//
//  Created by 人人彩 on 2020/9/16.
//  Copyright © 2020 MXS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RRCPortSecretTool : NSObject
+(instancetype)defaultManager;
-(NSString *)portSectetWithParameter:(NSDictionary *)parameters;
@end

NS_ASSUME_NONNULL_END


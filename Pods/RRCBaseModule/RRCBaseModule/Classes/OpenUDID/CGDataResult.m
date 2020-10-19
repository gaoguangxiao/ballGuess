//
//  RRCDataResult.m
//  MXSFramework
//
//  Created by gaoguangxiao on 2019/7/4.
//  Copyright © 2019 MXS. All rights reserved.
//

#import "CGDataResult.h"

@implementation CGDataResult

+(CGDataResult *)getResultFromDic:(NSDictionary *)dic{
    CGDataResult *result = [[CGDataResult alloc]init];
    
    if (dic&&([[dic objectForKey:@"code"] isKindOfClass:[NSNumber class]] || [[dic objectForKey:@"code"] isKindOfClass:[NSString class]])) {//成功
        result.code = [dic[@"code"] integerValue];
        result.serviceCode = result.code;
        result.errorMsg = [dic objectForKey:@"msg"];
        result.status = @(YES);
      
        id data = [dic objectForKey:@"data"];//是否包含list
        result.originalData = data;
        if ([data isKindOfClass:[NSDictionary class]] &&  [data valueForKey:@"list"]) {
            result.data = data[@"list"];
            result.extraInfo = [CGDataPageResult getResultFromDic:data];
        }else{
            result.data = data;
        }
    }else{
        result.code = 404;
        result.errorMsg = @"网络不好，请检查您的网络设置";
        result.status = @(NO);
    }
    return result;
}
@end

@implementation CGDataPageResult

+(CGDataPageResult *)getResultFromDic:(NSDictionary *)dic{
    CGDataPageResult *p = [[CGDataPageResult alloc]init];
    p.page_num     = [dic[@"page_num"] integerValue];
    p.page_size    = [dic[@"page_size"] integerValue];
    p.is_last_page = [dic[@"is_last_page"] boolValue];
    p.total_row    = [dic[@"total_row"] integerValue];
    p.total_page   = [dic[@"total_page"] integerValue];
    return p;
}

@end

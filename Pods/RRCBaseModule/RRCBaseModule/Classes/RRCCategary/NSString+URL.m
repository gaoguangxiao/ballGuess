//
//  NSString+URL.m
//  MXSFramework
//
//  Created by gaoguangxiao on 2019/10/14.
//  Copyright © 2019 MXS. All rights reserved.
//

#import "NSString+URL.h"
@implementation NSString (URL)

+(BOOL)isLinkUrl:(NSString *)linkStr{
    NSString*emailRegex = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES  %@",emailRegex];
    return [predicate evaluateWithObject:linkStr];
}

+(NSString *)exponentUrlWithMatchId:(NSString *)matchid andCompanyId:(NSString *)companyId andparaterUrl:(NSString *)urlName{
    NSString *urlStr;
    urlStr = [NSString stringWithFormat:@"%@?matchId=%@&companyId=%@",urlName,matchid,companyId];
    return urlStr;
}

+(NSString *)urlwebWithUrlName:(NSString *)urlName andBaseUrl:(NSString *)webUrl{
    NSInteger nightState = 0;
    if (@available(iOS 13.0, *)) {
        if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            nightState = 1;
        }
    }
    NSString *urlStr;
    if ([urlName containsString:@"?"]) {
        urlStr = [NSString stringWithFormat:@"%@/%@&night=%ld",webUrl,urlName,nightState];
    }else{
        urlStr = [NSString stringWithFormat:@"%@/%@?night=%ld",webUrl,urlName,nightState];
    }
    NSLog(@"拼接的URL：%@",urlStr);
    return urlStr;
}
@end

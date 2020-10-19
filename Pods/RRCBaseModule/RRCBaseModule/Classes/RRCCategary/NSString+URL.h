//
//  NSString+URL.h
//  MXSFramework
//
//  Created by gaoguangxiao on 2019/10/14.
//  Copyright © 2019 MXS. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (URL)

+(BOOL)isLinkUrl:(NSString * )linkStr;

/// 拼接H5地址参数
/// @param matchid <#matchid description#>
/// @param companyId <#companyId description#>
/// @param urlName <#urlName description#>
+(NSString *)exponentUrlWithMatchId:(NSString *)matchid andCompanyId:(NSString *)companyId andparaterUrl:(NSString *)urlName;


/// 拼接地址
/// @param urlName <#urlName description#>
/// @param webUrl <#webUrl description#>
+(NSString *)urlwebWithUrlName:(NSString *)urlName andBaseUrl:(NSString *)webUrl;
@end

NS_ASSUME_NONNULL_END

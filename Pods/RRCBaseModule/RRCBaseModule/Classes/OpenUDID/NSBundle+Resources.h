//
//  NSBundle+Resources.h
//  RRCBaseModule
//
//  Created by gaoguangxiao on 2020/5/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (Resources)

+ (NSBundle *)bundleName:(NSString *)bundleName andResourcesBundleName:(NSString *)resourcesName;
@end

NS_ASSUME_NONNULL_END

//
//  UIImage+Bundle.h
//  RRCBaseModule
//
//  Created by gaoguangxiao on 2020/5/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Bundle)

+ (nullable UIImage *)imageNamed:(NSString *)name inBundleName:(nullable NSString *)bundleName;

@end

NS_ASSUME_NONNULL_END

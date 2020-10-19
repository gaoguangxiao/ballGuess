//
//  UIImage+FIXbaseModule.m
//  Pods
//
//  Created by gaoguangxiao on 2020/5/14.
//

#import "UIImage+FIXbaseModule.h"
#import "UIImage+Bundle.h"
@implementation UIImage (FIXbaseModule)

+ (nonnull UIImage *)fixbaseModuleImageNamed:(nonnull NSString *)name
{
    return [UIImage imageNamed:name inBundleName:@"rrcfixbasemodule"];
}

@end

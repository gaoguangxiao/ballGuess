//
//  UIImage+Bundle.m
//  RRCBaseModule
//
//  Created by gaoguangxiao on 2020/5/15.
//

#import "UIImage+Bundle.h"

@implementation UIImage (Bundle)

+ (nullable UIImage *)imageNamed:(NSString *)name inBundleName:(nullable NSString *)bundleName {
    NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:bundleName withExtension:@"bundle"];
    NSBundle *resource_bundle = [NSBundle mainBundle];
    if (bundleURL) {
        resource_bundle = [NSBundle bundleWithURL:bundleURL];
    }else{
        //找Frameworks
        bundleURL = [[NSBundle mainBundle] URLForResource:@"Frameworks" withExtension:nil];
        //找仓库framework位置
        bundleURL = [bundleURL URLByAppendingPathComponent:bundleName];
        bundleURL = [bundleURL URLByAppendingPathExtension:@"framework"];
        //找bundle位置
        bundleURL = [bundleURL URLByAppendingPathComponent:bundleName];
        bundleURL = [bundleURL URLByAppendingPathExtension:@"bundle"];
        //实例bunble对象
        resource_bundle = [NSBundle bundleWithURL:bundleURL];
    }
    UIImage *image =  [UIImage imageNamed:name inBundle:resource_bundle compatibleWithTraitCollection:nil];
    return  image;
}

@end

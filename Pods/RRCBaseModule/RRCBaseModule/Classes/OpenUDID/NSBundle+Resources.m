//
//  NSBundle+Resources.m
//  RRCBaseModule
//
//  Created by gaoguangxiao on 2020/5/22.
//

#import "NSBundle+Resources.h"

@implementation NSBundle (Resources)

+ (NSBundle *)bundleName:(NSString *)bundleName andResourcesBundleName:(NSString *)resourcesName {
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
    
    //找资源bundle
    if (resourcesName.length) {
        NSURL *url = [resource_bundle URLForResource:resourcesName withExtension:@"bundle"];
        resource_bundle = [NSBundle bundleWithURL:url];
    }
    return resource_bundle;
}
@end

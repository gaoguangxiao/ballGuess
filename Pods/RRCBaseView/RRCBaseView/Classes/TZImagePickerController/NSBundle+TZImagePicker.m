//
//  NSBundle+TZImagePicker.m
//  TZImagePickerController
//
//  Created by 谭真 on 16/08/18.
//  Copyright © 2016年 谭真. All rights reserved.
//

#import "NSBundle+TZImagePicker.h"
#import "TZImagePickerController.h"

@implementation NSBundle (TZImagePicker)

+ (NSBundle *)tz_imagePickerBundle {
    NSString *bundleName = @"RRCBaseView";
    NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:@"RRCBaseView" withExtension:@"bundle"];
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
    NSURL *url = [resource_bundle URLForResource:@"TZImagePickerController" withExtension:@"bundle"];
    NSBundle *tziImageResource = [NSBundle bundleWithURL:url];
    return tziImageResource;
}

+ (NSString *)tz_localizedStringForKey:(NSString *)key {
    return [self tz_localizedStringForKey:key value:@""];
}

+ (NSString *)tz_localizedStringForKey:(NSString *)key value:(NSString *)value {
    NSBundle *bundle = [TZImagePickerConfig sharedInstance].languageBundle;
    NSString *value1 = [bundle localizedStringForKey:key value:value table:nil];
    return value1;
}

@end

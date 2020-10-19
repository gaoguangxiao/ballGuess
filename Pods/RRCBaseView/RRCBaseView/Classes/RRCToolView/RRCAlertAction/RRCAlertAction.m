//
//  AlertAction.m
//  GGAlertAction
//
//  Created by 吉祥 on 2017/8/21.
//  Copyright © 2017年 jixiang. All rights reserved.
//

#import "RRCAlertAction.h"

@interface RRCAlertAction()

@property (nonatomic, strong, readwrite) UIImage *image; ///< 图标
@property (nonatomic, copy, readwrite) NSString *title; ///< 风格
@property (nonatomic, copy, readwrite) void(^handler)(RRCAlertAction *action); ///< 选择回调

@end

@implementation RRCAlertAction


+ (instancetype)actionWithTitle:(NSString *)title handler:(void (^)(RRCAlertAction *action))handler {
    return [self actionWithImage:nil title:title handler:handler];
}

+ (instancetype)actionWithImage:(UIImage *)image title:(NSString *)title handler:(void (^)(RRCAlertAction *action))handler {
    RRCAlertAction *action = [[self alloc] init];
    action.image = image;
    action.title = title ? : @"";
    action.handler = handler ? : NULL;
    return action;
}

+ (instancetype)actionWithTitle:(NSString *)title titleColor:(UIColor *)color handler:(void (^)(RRCAlertAction *action))handler {
    RRCAlertAction *action = [[self alloc] init];
    action.image = nil;
    action.title = title ? : @"";
    action.textColor = color;
    action.handler = handler ? : NULL;
    return action;
}

@end

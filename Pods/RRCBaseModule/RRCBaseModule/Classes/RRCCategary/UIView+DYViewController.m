//
//  UIView+ViewController.m
//  WeiBo_TYH
//
//  Created by IOS on 14-7-4.
//  Copyright (c) 2014年 www.iphonetrain.com. All rights reserved.
//

#import "UIView+DYViewController.h"

@implementation UIView (DYViewController)

- (UIViewController *)viewController
{
    
    id next = self.nextResponder;
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return next;
        }
        next = [next nextResponder];
    } while (next != nil);
    
    if(next == nil){
        next = [[UIApplication sharedApplication] delegate].window.rootViewController;
        if([next isKindOfClass:[UINavigationController class]]){
            next = ((UINavigationController *)next).topViewController;
        }
        return next;
    }
    return nil;
}

- (UIViewController *)jsd_getRootViewController{
    
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    NSAssert(window, @"The window is empty");
    return window.rootViewController;
}


- (UIViewController *)jsd_getCurrentViewController{
    
    UIViewController* currentViewController = [self jsd_getRootViewController];
    BOOL runLoopFind = YES;
    while (runLoopFind) {
        if (currentViewController.presentedViewController) {
            
            currentViewController = currentViewController.presentedViewController;
        } else if ([currentViewController isKindOfClass:[UINavigationController class]]) {
            
            UINavigationController* navigationController = (UINavigationController* )currentViewController;
            currentViewController = [navigationController.childViewControllers lastObject];
            
        } else if ([currentViewController isKindOfClass:[UITabBarController class]]) {
            
            UITabBarController* tabBarController = (UITabBarController* )currentViewController;
            currentViewController = tabBarController.selectedViewController;
        } else {
            
            NSUInteger childViewControllerCount = currentViewController.childViewControllers.count;
            if (childViewControllerCount > 0) {
                
                currentViewController = currentViewController.childViewControllers.lastObject;
                
                return currentViewController;
            } else {
                
                return currentViewController;
            }
        }
        
    }
    return currentViewController;
}

@end

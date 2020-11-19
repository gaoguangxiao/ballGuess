//
//  HUDHelper.m
//  
//
//  Created by Alexi on 12-11-28.
//  Copyright (c) 2012年 . All rights reserved.
//

#import "HUDHelper.h"

#import "NSString+Common.h"
//#import "UIAlertView+BlocksKit.h"

@implementation HUDHelper

static HUDHelper *_instance = nil;


+ (HUDHelper *)sharedInstance
{
    @synchronized(_instance)
    {
        if (_instance == nil)
        {
            _instance = [[HUDHelper alloc] init];
        }
        return _instance;
    }
}

- (MBProgressHUD *)loading
{
    return [self loading:nil];
}

- (MBProgressHUD *)loading:(NSString *)msg{
    return [self loading:msg inView:nil];
}

- (MBProgressHUD *)loading:(NSString *)msg inView:(UIView *)view
{
    UIView *inView = view ? view : [[UIApplication sharedApplication]keyWindow];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:inView];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![NSString isEmpty:msg]){
            hud.mode = MBProgressHUDModeIndeterminate;
            hud.label.text = msg;
        }
        [inView addSubview:hud];
        [hud showAnimated:YES];
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:YES afterDelay:10.0];//十秒之后隐藏
    });
    return hud;
}

- (void)loading:(NSString *)msg delay:(CGFloat)seconds execute:(void (^)())exec completion:(void (^)())completion
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *inView = [[UIApplication sharedApplication]keyWindow];
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:inView];
        if (![NSString isEmpty:msg])
        {
            hud.mode = MBProgressHUDModeText;
            hud.label.text = msg;
        }
        
        [inView addSubview:hud];
        [hud showAnimated:YES];
        if (exec)
        {
            exec();
        }
        
        // 超时自动消失
        [hud hideAnimated:YES afterDelay:seconds];
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (completion)
            {
                completion();
            }
        });
    });
}


- (void)stopLoading:(MBProgressHUD *)hud
{
    [self stopLoading:hud message:nil];
}

- (void)stopLoading:(MBProgressHUD *)hud message:(NSString *)msg
{
    [self stopLoading:hud message:msg delay:0 completion:nil];
}
- (void)stopLoading:(MBProgressHUD *)hud message:(NSString *)msg delay:(CGFloat)seconds completion:(void (^)())completion
{
    if (hud)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![NSString isEmpty:msg])
            {
                hud.label.text = msg;
                hud.mode = MBProgressHUDModeText;
            }
            [hud hideAnimated:YES afterDelay:seconds];
            _syncHUD = nil;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (completion)
                {
                    completion();
                }
            });
        });
    }
    
}


- (void)tipMessage:(NSString *)msg
{
    [self tipMessage:msg delay:2];
}

- (void)tipMessage:(NSString *)msg delay:(CGFloat)seconds
{
    [self tipMessage:msg delay:seconds completion:nil];
    
}

- (void)tipMessage:(NSString *)msg delay:(CGFloat)seconds completion:(void (^)())completion
{
    if ([NSString isEmpty:msg])
    {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *inView = [[UIApplication sharedApplication]keyWindow];
        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:inView];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![NSString isEmpty:msg]){
                hud.mode = MBProgressHUDModeIndeterminate;
                hud.label.text = msg;
            }
            [inView addSubview:hud];
            [hud showAnimated:YES];
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [hud hideAnimated:YES];
            if (completion){
                completion();
            }
        });
    });
}


#define kSyncHUDStartTag  100000

// 网络请求
- (void)syncLoading
{
    [self syncLoading:nil];
}
- (void)syncLoading:(NSString *)msg
{
    [self syncLoading:msg inView:nil];
}
- (void)syncLoading:(NSString *)msg inView:(UIView *)view
{
    if (_syncHUD)
    {
        _syncHUD.tag++;
        
        if (![NSString isEmpty:msg])
        {
            _syncHUD.label.text = msg;
            _syncHUD.mode = MBProgressHUDModeText;
        }
        else
        {
            _syncHUD.label.text = nil;
            _syncHUD.mode = MBProgressHUDModeIndeterminate;
        }
        [_syncHUD showAnimated:YES];
        return;
    }
    _syncHUD = [self loading:msg inView:view];
    _syncHUD.tag = kSyncHUDStartTag;
}

- (void)syncStopLoading
{
    [self syncStopLoadingMessage:nil delay:0 completion:nil];
}
- (void)syncStopLoadingMessage:(NSString *)msg
{
    [self syncStopLoadingMessage:msg delay:1 completion:nil];
}
- (void)syncStopLoadingMessage:(NSString *)msg delay:(CGFloat)seconds completion:(void (^)())completion
{
    _syncHUD.tag--;
    if (_syncHUD.tag > kSyncHUDStartTag){
        if (![NSString isEmpty:msg])
        {
            _syncHUD.label.text = msg;
            _syncHUD.mode = MBProgressHUDModeText;
        }
        else
        {
            _syncHUD.label.text = nil;
            _syncHUD.mode = MBProgressHUDModeIndeterminate;
        }
        
    }
    else
    {
        [self stopLoading:_syncHUD message:msg delay:seconds completion:completion];
    }
}



@end

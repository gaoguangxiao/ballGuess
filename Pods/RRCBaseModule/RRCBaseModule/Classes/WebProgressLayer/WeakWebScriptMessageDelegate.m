//
//  WeakScriptMessageDelegate.m
//  MXSFramework
//
//  Created by gaoguangxiao on 2020/3/27.
//  Copyright © 2020 MXS. All rights reserved.
//

#import "WeakWebScriptMessageDelegate.h"

@implementation WeakWebScriptMessageDelegate

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate {
    self = [super init];
    if (self) {
        _scriptDelegate = scriptDelegate;
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    [self.scriptDelegate userContentController:userContentController didReceiveScriptMessage:message];
}

-(void)dealloc{
    NSLog(@"%@ -- dealloc",self.class);
}
@end

//
//  UserRegViewController.m
//  hongbao
//
//  Created by mac on 15/4/9.
//  Copyright (c) 2015年 wang shuguan. All rights reserved.
//

#import "UserReg1ViewController.h"
#import "EFUser.h"

#import <MJExtension.h>
#import "EntityUser.h"
@interface UserReg1ViewController (){
    dispatch_source_t timer;
    __block int count;
    
    int numberCode;
}


@end

@implementation UserReg1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"注册";
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//注册的
- (IBAction)next:(UIButton *)sender {
    
    [self noWithInvitationCodeAndError];
    
}

-(void)noWithInvitationCodeAndError{
    if (_userName.text.length == 0) {
        [[RRCAlertManager sharedRRCAlertManager]showPostingWithtitle:@"请填写用户名"];
        return;
    }
    if (_telNumber.text.length == 0) {
        [[RRCAlertManager sharedRRCAlertManager]showPostingWithtitle:@"请填写手机号"];
        return;
    }
    
    if (_textFieldTel.text.length == 0) {
        [[RRCAlertManager sharedRRCAlertManager]showPostingWithtitle:@"密码为空"];
        return;
    }
    
    
    [[HUDHelper sharedInstance]syncLoading:@"正在注册"];
    [EFUser registerUserUserName:_userName.text andPassWord:_textFieldTel.text andTelepnone:_telNumber.text andBackResult:^(EntityUser *user, BOOL isSuccessful, NSError *error) {
        
        if (isSuccessful) {
            
            [[HUDHelper sharedInstance]syncStopLoadingMessage:@"注册成功"];

            [CustomUtil saveUserInfo:user];
            [CustomUtil saveAcessToken:user.token];
             
            [[NSNotificationCenter defaultCenter]postNotificationName:K_APNNOTIFICATIONLOGIN object:@(YES)];
            
            //登录成功
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            
            });

        }else{
            
            [[HUDHelper sharedInstance]syncStopLoadingMessage:[error description]];
        
        }

    }];
    
    
}




@end

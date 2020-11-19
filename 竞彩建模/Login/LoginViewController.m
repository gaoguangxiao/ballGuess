//
//  LoginViewController.m
//  CPetro
//
//  Created by ggx on 2017/3/8.
//  Copyright © 2017年 高广校. All rights reserved.
//

#import "LoginViewController.h"
#import "EFUser.h"
//#import "LRMoreInputView.h"
//#import "BSButtonView.h"
//#import "CGBarButtonItem.h"
@interface LoginViewController ()
{
    __weak IBOutlet UITextField *_textFieldPassword;
    __weak IBOutlet UITextField *_textFieldAccount;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"登陆";
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];

}

#pragma mark - 登陆
-(IBAction)didActionBottomIndex:(NSInteger)index{
    NSString *loginAccount = _textFieldAccount.text;
    NSString *passwordTf   = _textFieldPassword.text;
    if (loginAccount.length == 0) {
        [[RRCAlertManager sharedRRCAlertManager]showPostingWithtitle:@"请输入账号"];
        return;
    }
    if (passwordTf.length == 0) {
        [[RRCAlertManager sharedRRCAlertManager]showPostingWithtitle:@"请输入密码"];
        return;
    }
    
    [[HUDHelper sharedInstance]syncLoading:@"正在登陆"];
    
    [self.view endEditing:NO];
    
    [EFUser loginYQUserName:loginAccount andPassWord:passwordTf andBackResult:^(EntityUser *user, BOOL isSuccessful, NSError *error) {
        
        if (isSuccessful) {
            
            [[HUDHelper sharedInstance]syncStopLoadingMessage:@"登陆成功"];
            
            [CustomUtil saveUserInfo:user];
            [CustomUtil saveAcessToken:user.token];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:K_APNNOTIFICATIONLOGIN object:@(YES)];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            
            });
        }else{
            NSLog(@"%@",error);
            [[HUDHelper sharedInstance]syncStopLoadingMessage:[error description]];
        }
       
    }];
    
}
#pragma mark -注册账户
- (IBAction)RegisterUser:(id)sender {
    [self.navigationController pushViewController:CreateViewController(@"UserReg1ViewController") animated:YES];
}

#pragma mark -忘记密码

-(void)loginToService{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

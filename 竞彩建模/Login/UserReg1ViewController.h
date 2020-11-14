//
//  UserRegViewController.h
//  hongbao
//
//  Created by mac on 15/4/9.
//  Copyright (c) 2015年 wang shuguan. All rights reserved.
//

#import "RRCRootViewController.h"

@interface UserReg1ViewController : RRCRootViewController{
    //密码的输入
    __weak IBOutlet UITextField *_textFieldTel;
    //校验码的输入
//    __weak IBOutlet UITextField *_textFieldCode;

    __weak IBOutlet UITextField *_userName;
 
    //所要输入的手机号
    __weak IBOutlet UITextField *_telNumber;
    //获取验证码
    __weak IBOutlet UIButton *_btGetCode;
    
    
}

@end

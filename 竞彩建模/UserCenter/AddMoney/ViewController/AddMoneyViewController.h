//
//  AddMoneyViewController.h
//  hongbao
//
//  Created by 高广校 on 15/8/3.
//  Copyright (c) 2015年 wang shuguan. All rights reserved.
//

#import "RRCRootViewController.h"
//#import "EntityFee.h"
typedef NS_ENUM(NSInteger, UserCenterAmountType){
    UserCenterAmountTypeAlipay=1,
    UserCenterAmountTypeYinlian=0
};

@interface AddMoneyViewController : RRCRootViewController
{
    __weak IBOutlet UIButton *_submitBt;//提交按钮
    __weak IBOutlet UITextField *_textFieldMoney;//输入金额
    
    __weak IBOutlet UIButton *_btZhifu;
    __weak IBOutlet UIButton *_btImageViewUnionpay;//设置图片的
    
    __weak IBOutlet UIView *_touchView;//添加支付宝手势
    __weak IBOutlet UIView *_touchViewOnUnionpay;//添加银联的手势
    
    __weak IBOutlet UIImageView *_unionPayImeg;//银联图片
    __weak IBOutlet UILabel *_labelPay;
    
    __weak IBOutlet NSLayoutConstraint *_layoutOnUnionpay;//控制银联的是否开启支付
    

}
/**
 *  是否开启 银联充值
 */
@property(nonatomic,strong)NSString *enable_unionpay;

@end

//
//  UserHeadCell.m
//  dongni
//
//  Created by gaoguangxiao on 16/8/16.
//  Copyright © 2016年 河南善泽文化传媒有限公司. All rights reserved.
//

#import "UserHeadCell.h"
//#import "APPImageRadius.h"
#import "UIImageView+WebCache.h"
@interface UserHeadCell()
{
    __weak IBOutlet UIImageView *_headImage;
    __weak IBOutlet UILabel *_nameLabel;
    __weak IBOutlet UILabel *_numLabel;
    
    __weak IBOutlet UIImageView *_lavelLabel;//级别标示
    
    __weak IBOutlet UILabel *_amount;
}
@end

@implementation UserHeadCell

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(void)setViewColor{
    self.backgroundColor = RRCSplitViewColor;
}

-(void)setUserData:(EntityUser *)user{
    
    self.data = user;
    //        /**
    //         *  用户头像
    //         */
    NSURL *urlImages = [NSURL URLWithString:[NSString stringWithFormat:@"%@",user.portraitUri]];
    [_headImage sd_setImageWithURL:urlImages placeholderImage:[UIImage imageNamed:@"默认头像"]];
    ;
    [_headImage addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(PartAndCharge)]];
    /**
     *  用户手机号
     */
    _numLabel.text = [NSString stringWithFormat:@"手机号：%@",kSafeString(user.phone)];
    /**
     *  用户昵称
     */
    _nameLabel.text = [NSString stringWithFormat:@"昵称：%@",kSafeString(user.username)];
    
    _amount.text = [NSString stringWithFormat:@"账户余额：%@",kSafeString(user.amount)];
    /**
     *  级别标示
     */
    if ([user.userLevel intValue] == 1)_lavelLabel.image =[UIImage imageNamed:@"center_Vip_Grade.png"];
    else if([user.userLevel intValue] == 2) _lavelLabel.image =[UIImage imageNamed:@"center_Vip_Grade_Supper"];
    else if([user.userLevel intValue] == 3)_lavelLabel.image =[UIImage imageNamed:@"center_Vip_Grade_Ag_Supper"];
    else if([user.userLevel intValue] == 4)_lavelLabel.image =[UIImage imageNamed:@"center_Vip_Grade_Most_Supper"];
    else _lavelLabel.image =[UIImage imageNamed:@"center_Vip_Grade_Most_Supper"];
}

- (void)PartAndCharge{
    //    UIButton *btn = (UIButton *)sender;
//    if (self.PushPartAndCharge&&self.data) {
//        self.PushPartAndCharge(101);
//    }
}

@end

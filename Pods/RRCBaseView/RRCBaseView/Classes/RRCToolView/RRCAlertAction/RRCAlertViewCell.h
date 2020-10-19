//
//  AlertViewCell.h
//  GGAlertAction
//
//  Created by 吉祥 on 2017/8/21.
//  Copyright © 2017年 jixiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RRCAlertAction.h"
#import "YBColorConfigure.h"
#import "RRCDeviceConfigure.h"
@class RRCAlertAction;

@interface RRCAlertViewCell : UITableViewCell
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIImageView *selectImage;

- (void)setAction:(RRCAlertAction *)action;

@end

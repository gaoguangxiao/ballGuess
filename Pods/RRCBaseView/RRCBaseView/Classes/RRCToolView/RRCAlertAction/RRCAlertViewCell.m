//
//  AlertViewCell.m
//  GGAlertAction
//
//  Created by 吉祥 on 2017/8/21.
//  Copyright © 2017年 jixiang. All rights reserved.
//

#import "RRCAlertViewCell.h"

#import <Masonry/Masonry.h>
@interface RRCAlertViewCell ()

@end
@implementation RRCAlertViewCell

#pragma mark - Life Cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    self.backgroundColor = RRCUnitViewColor;
    self.contentView.backgroundColor = self.backgroundColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // initialize
    [self initialize];
    return self;
}

#pragma mark - Private
// 初始化
- (void)initialize {
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0,0)];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:18 * Device_Ccale];
    self.titleLabel.textColor = RRCThemeTextColor;
    [self.contentView addSubview:self.titleLabel];
    
    self.selectImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth - 50, 17, 20, 15)];
    [self.contentView addSubview:self.selectImage];
    self.selectImage.hidden = YES;
    
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(self.contentView);
    }];
}

#pragma mark - Public
- (void)setAction:(RRCAlertAction *)action {
    self.titleLabel.text = action.title;
    self.selectImage.image = action.image;
    if (action.textColor) {
        self.titleLabel.textColor = action.textColor;
    }
}

@end

//
//  UserCenterCell.m
//  SimpleSrore
//
//  Created by ggx on 2017/3/16.
//  Copyright © 2017年 高广校. All rights reserved.
//

#import "UserCenterCell.h"

#import "NSString+Common.h"

#import "EntityUser.h"

@implementation UserCenterCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self.contentView addSubview:self.keyText];
        //约束
        [self.keyText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@13);
            make.width.equalTo(@80);
            make.centerY.equalTo(self.contentView);
        }];
        
        [self.contentView addSubview:self.userText];
        [self.userText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leftMargin.equalTo(self.keyText.mas_right).offset(10);
            make.centerY.equalTo(self.contentView);
        }];
    }

    return self;
    
}
-(UILabel *)keyText{
    if (!_keyText) {
        _keyText = [[UILabel alloc]init];
    }
    _keyText.textColor = [UIColor lightGrayColor];
    _keyText.font      = [UIFont systemFontOfSize:13.0];
    return _keyText;
}
-(UILabel *)userText{
    if (!_userText) {
        _userText = [[UILabel alloc]init];
        _userText.textColor = K_SubmitTitleColor;
        _userText.font      = [UIFont systemFontOfSize:14.0];
    }
    return _userText;
}
-(void)setUserDic:(NSDictionary *)userDic{
//    NSString *allString = [NSString stringWithFormat:@"%@%@",userDic[@"text"],userDic[@"value"]];
   
    self.keyText.text = [NSString stringWithFormat:@"%@：",userDic[@"text"]];
    
    self.userText.text = userDic[@"value"];
    
//    self.userText.attributedText = [allString containsString:userDic[@"value"] andkeyColor:[UIColor darkGrayColor]];
}

@end

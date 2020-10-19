//
//  RRCTableViewCell.m
//  MXSFramework
//
//  Created by 人人彩 on 2019/5/27.
//  Copyright © 2019 MXS. All rights reserved.
//

#import "RRCTableViewCell.h"

@implementation RRCTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initBaseCell];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)coder{
    if (self = [super initWithCoder:coder]) {
        [self initBaseCell];
    }
    return self;
}
-(void)initBaseCell{
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = RRCLineViewColor;
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(12*Device_Ccale);
        make.right.mas_offset(-12*Device_Ccale);
        make.height.mas_offset(.5);
        make.bottom.mas_offset(0);
    }];
    [self creatCell];
    
    [self setViewColor];
}

-(void)creatCell{
    
}

-(void)setViewColor{
    
    self.lineView.backgroundColor = RRCLineViewColor;
    
    self.contentView.backgroundColor = RRCUnitViewColor;
}

-(void)layoutSubviews{
    [super layoutSubviews];
//    [self setViewColor];
}

-(void)setIsHiddenLastLineView:(BOOL)isHiddenLastLineView{
    _isHiddenLastLineView = isHiddenLastLineView;
    if (isHiddenLastLineView) {
        if (self.indexPath.row == self.indexPathAll - 1) {
            self.lineView.hidden = YES;
        }else{
            self.lineView.hidden = NO;
        }
    }
}
@end

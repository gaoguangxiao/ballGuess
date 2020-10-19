//
//  RRCRightSortView.m
//  MXSFramework
//
//  Created by gaoguangxiao on 2020/4/18.
//  Copyright © 2020 MXS. All rights reserved.
//

#import "RRCRightSortView.h"

@implementation RRCRightSortView

-(void)setUpView{
        
    [self addSubview:self.dateSortBtn];
    [self addSubview:self.mathSortBtn];
    [self addSubview:self.lineView];
    
    [self.mathSortBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(self.dateSortBtn.mas_width);
        make.right.mas_equalTo(0);
    }];
    
    [self.dateSortBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(self.mathSortBtn.mas_left).offset(0);
        make.width.mas_equalTo(self.mathSortBtn.mas_width);
        make.left.mas_offset(0);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.height.mas_equalTo(0.5);
    }];
    
}

#pragma mark - Getter
-(UIButton *)dateSortBtn{
    if (!_dateSortBtn) {
        _dateSortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dateSortBtn setImage:[UIImage imageNamed:@"选择日期"] forState:UIControlStateNormal];
    }
    return _dateSortBtn;
}

-(UIButton *)mathSortBtn{
    if (!_mathSortBtn) {
        _mathSortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mathSortBtn setImage:[UIImage imageNamed:@"即时比分筛选"] forState:UIControlStateNormal];
    }
    return _mathSortBtn;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 0.5, kScreenWidth, 0.5)];
        _lineView.backgroundColor = RRCLineViewColor;
        _lineView.hidden = YES;
    }
    return _lineView;
}
@end

//
//  HomeCell.m
//  CPetro
//
//  Created by ggx on 2017/3/9.
//  Copyright © 2017年 高广校. All rights reserved.
//

#import "RecordOrderCell.h"


@implementation RecordOrderCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //添加视图
        [self setBackgroundColor:[UIColor clearColor]];
        
        [self.contentView addSubview:self.backView];
        [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.equalTo(@10);
            make.right.bottom.equalTo(@-10);
        }];
        
        [self.backView addSubview:self.orderId];
        //约束
        [self.orderId mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@13);
            make.top.equalTo(@8);
        }];
        
        [self.backView addSubview:self.orderTime];
        [self.orderTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.orderId.mas_top);
            make.right.equalTo(@-8);//
        }];
        
        [self.backView addSubview:self.orderDetail];
        [self.orderDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_offset(0);
            make.left.mas_offset(13);
        }];
    }
    return self;
}

#pragma mark -界面绘制
-(void)setObjectBmob:(BmobObject *)objectBmob{
    _objectBmob = objectBmob;
    
    self.orderId.text   = [NSString stringWithFormat:@"订单号：%@",[objectBmob objectForKey:@"orderId"]];
    
    NSString *oldTimeString = [objectBmob objectForKey:@"createdAt"];
    NSDate *date = [U_SERVER_FORMATTER dateFromString:oldTimeString];//将字符串转nsdate
    NSDateFormatter *todayFommater = [NSDateFormatter dateFormatterWithFormat:@"MM/dd HH:mm"];
    NSString *timeString = [todayFommater stringFromDate:date];
    self.orderTime.text = [NSString stringWithFormat:@"订单时间：%@",timeString];
    
    NSString *oD = [NSString stringWithFormat:@"%@",[objectBmob objectForKey:@"hmd"]];
    self.orderDetail.text = [NSString stringWithFormat:@"%@ %@ %@VS%@",[objectBmob objectForKey:@"league"],oD,[objectBmob objectForKey:@"home"],[objectBmob objectForKey:@"away"]];

}
//首页订单
-(void)setHomeOrderEntity:(HomeOrderEntity *)homeOrderEntity{
    _homeOrderEntity = homeOrderEntity;
    
    self.orderId.text   = [NSString stringWithFormat:@"订单号：%@",homeOrderEntity.uorderid];
    self.orderTime.text = [NSString stringWithFormat:@"%@",homeOrderEntity.addtime];
}

#pragma mark - 懒加载
-(UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = [UIColor whiteColor];
    }
    return _backView;
}
-(UILabel *)orderId{
    if (!_orderId) {
        _orderId = [[UILabel alloc]init];
        _orderId.textColor = [UIColor darkGrayColor];
        _orderId.font = K_SystemFont;
    }
    return _orderId;
}
-(UILabel *)orderTime{
    if (!_orderTime) {
        _orderTime = [[UILabel alloc]init];
        _orderTime.textColor = [UIColor darkGrayColor];
        _orderTime.font = [UIFont systemFontOfSize:14.0];
    }
    return _orderTime;
}

-(UILabel *)orderDetail{
    if (!_orderDetail) {
        _orderDetail = [[UILabel alloc]init];
        _orderDetail.textColor = [UIColor darkGrayColor];
        _orderDetail.font = [UIFont systemFontOfSize:14.0];
    }
    return _orderDetail;
}
@end

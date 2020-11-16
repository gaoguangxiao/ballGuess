//
//  RRCLeafueDelcell.m
//  竞彩建模
//
//  Created by gaoguangxiao on 2020/11/6.
//  Copyright © 2020 renrencai. All rights reserved.
//

#import "RRCLeafueDelcell.h"
#import "NSString+DYLineWordSpace.h"

@interface RRCLeafueDelcell (){
    
    __weak IBOutlet UILabel *leagueName;
    __weak IBOutlet UIButton *DeleteBtn;
    __weak IBOutlet UILabel *_teamName;
    
    __weak IBOutlet UILabel *_dxqMethod;
    __weak IBOutlet UIButton *_dxqMoney;
    __weak IBOutlet UILabel *_dxqWin;
    
    __weak IBOutlet UILabel *_yzMethod;
    __weak IBOutlet UIButton *_yzMoney;
    __weak IBOutlet UILabel *_yzWin;
    
    __weak IBOutlet UILabel *_orderState;
    __weak IBOutlet UIButton *_updateBtn;
    
}

@end

@implementation RRCLeafueDelcell

-(void)setLeResultModel:(RRCBetRecordModel *)leResultModel{
    
    _leResultModel = leResultModel;
    
    leagueName.attributedText = [[NSString stringWithFormat:@"%@\n%@",leResultModel.league,leResultModel.hmd] changeLineSpace:3 * Device_Ccale];
    //联赛名字
    leagueName.textAlignment = NSTextAlignmentCenter;
    if (leResultModel.status.integerValue) {
        _teamName.attributedText = [[NSString stringWithFormat:@"%@\n%@:%@\n%@",leResultModel.home , leResultModel.homeScore,leResultModel.awayScore,leResultModel.away] changeLineSpace:3 * Device_Ccale];
    }else{
        _teamName.attributedText = [[NSString stringWithFormat:@"%@\nVS\n%@",leResultModel.home,leResultModel.away] changeLineSpace:3 * Device_Ccale];
    }
    _teamName.textAlignment = NSTextAlignmentCenter;
    
    NSString *dxText = [NSString stringWithFormat:@"%@",leResultModel.dxq_dxdif.floatValue > 0 ? @"大":@"小"];
    _dxqMethod.text = [NSString stringWithFormat:@"%@%@\n@%@",dxText,leResultModel.dxq_pk,leResultModel.dxq_pk_water];
    [_dxqMoney setTitle:[NSString stringWithFormat:@"%@",leResultModel.dxq_money] forState:UIControlStateNormal];
    
    
    NSString *yzText = [NSString stringWithFormat:@"%@%@",(leResultModel.yz_dxdif.floatValue > 0 ? @"主":@"客"),(leResultModel.yz_pk_water.floatValue > 0 ? @"让":@"受让")];
    
    _yzMethod.text = [NSString stringWithFormat:@"%@%@\n@%@",yzText,leResultModel.yz_pk,leResultModel.yz_pk_water];
    
    [_yzMoney setTitle:[NSString stringWithFormat:@"%@",leResultModel.yz_money] forState:UIControlStateNormal];

    _dxqWin.text = [NSString stringWithFormat:@"%@",leResultModel.dxq_winMoney];
    _yzWin.text = [NSString stringWithFormat:@"%@",leResultModel.yz_winMoney];
    
    _updateBtn.userInteractionEnabled = YES;
    [_updateBtn setBackgroundColor:RRCThemeViewColor];
    if (leResultModel.orderState.integerValue == 0) {
        _orderState.text = @"未完成";
    }else if (leResultModel.orderState.integerValue == 1){
        _orderState.text = @"进行中";
    }else if (leResultModel.orderState.integerValue == 2){
        _orderState.text = @"已结束";
        _updateBtn.userInteractionEnabled = NO;
        [_updateBtn setBackgroundColor:RRCSplitViewColor];
    }else{
        _orderState.text = @"赛事异常";
        _updateBtn.userInteractionEnabled = NO;
        [_updateBtn setBackgroundColor:RRCSplitViewColor];
    }
}

- (IBAction)ChoseDelete:(UIButton *)sender {
    
    if (self.didActionUpdateScore) {
        self.didActionUpdateScore(_leResultModel);
    }
    
}

@end

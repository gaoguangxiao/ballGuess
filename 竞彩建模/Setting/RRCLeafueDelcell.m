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
}

@end

@implementation RRCLeafueDelcell

-(void)setLeResultModel:(ResultModel *)leResultModel{
    
    _leResultModel = leResultModel;
    
    leagueName.attributedText = [[NSString stringWithFormat:@"%@ %@ %@\n%@ VS%@",leResultModel.league,leResultModel.mmdd,leResultModel.hhmm,leResultModel.home,leResultModel.away] changeLineSpace:5 * Device_Ccale];// resultModel.home;
    
    if (leResultModel.isEditDelete) {
        [DeleteBtn setImage:[UIImage imageNamed:@"赛事选中条件边框"] forState:UIControlStateNormal];
    }else{
        [DeleteBtn setImage:[UIImage imageNamed:@"赛事未选条件边框"] forState:UIControlStateNormal];
    }
}

- (IBAction)ChoseDelete:(UIButton *)sender {
    
    _leResultModel.isEditDelete = !_leResultModel.isEditDelete;
    
    if (_leResultModel.isEditDelete) {
        [DeleteBtn setImage:[UIImage imageNamed:@"赛事选中条件边框"] forState:UIControlStateNormal];
    }else{
        [DeleteBtn setImage:[UIImage imageNamed:@"赛事未选条件边框"] forState:UIControlStateNormal];
    }
}

@end

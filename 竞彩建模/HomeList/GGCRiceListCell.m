//
//  ResultTableViewCell.m
//  竞彩建模
//
//  Created by gaoguangxiao on 2020/6/8.
//  Copyright © 2020 renrencai. All rights reserved.
//

#import "GGCRiceListCell.h"
#import "NSString+DYLineWordSpace.h"
#import "UIView+DYViewController.h"
#import "GGCBigSmallBallViewController.h"
#import "GGCWarResultViewController.h"
@interface GGCRiceListCell ()

@property (weak, nonatomic) IBOutlet UIButton *deleteTag;//删除标志

@property (weak, nonatomic) IBOutlet UILabel *homeName;//主队名字
@property (weak, nonatomic) IBOutlet UILabel *awayName;//客队名字

@property (weak, nonatomic) IBOutlet UILabel *homeCompositeScore;//主队计算得分
@property (weak, nonatomic) IBOutlet UILabel *awayCompositeScore;//客队计算得分

@property (weak, nonatomic) IBOutlet UILabel *homeEnterBallScore;//主队进球数
@property (weak, nonatomic) IBOutlet UILabel *awayEnterBallScore;//客队进球数

//主队波胆数
@property (weak, nonatomic) IBOutlet UILabel *homeBdScore;
@property (weak, nonatomic) IBOutlet UILabel *BdBallScore;//客队进球数

//主队胜平负
@property (weak, nonatomic) IBOutlet UILabel *homeWinScore;
//胜平负第二选项
@property (weak, nonatomic) IBOutlet UILabel *homeWinSecondScore;

@property (weak, nonatomic) IBOutlet UILabel *resultBigMoney;//大小球建议下注量
@property (weak, nonatomic) IBOutlet UILabel *resultBigSmallCompany;//大小球盘口

@property (weak, nonatomic) IBOutlet UILabel *resultYazhiMoney;
@property (weak, nonatomic) IBOutlet UILabel *resultYazhiCompany; //亚指预测

@property (weak, nonatomic) IBOutlet UIView *resultScoreBd;//波胆预测结果

@property (weak, nonatomic) IBOutlet UILabel *remainMoney;

@property (nonatomic, strong) ResultModel *local_ResultModel;
@end

@implementation GGCRiceListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    //盘口添加一个手势
    UITapGestureRecognizer *yatap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(yapanSee:)];
    [_resultYazhiCompany addGestureRecognizer:yatap];
    //    NSLog(@"%@",_resultYazhiCompany);
    
    UITapGestureRecognizer *bigtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bigSmallSee:)];
    [_resultBigSmallCompany addGestureRecognizer:bigtap];
    //    NSLog(@"%@",_resultYazhiCompany);
}

-(void)yapanSee:(UITapGestureRecognizer *)tap{
    if (self.didActionyazhi) {
        self.didActionyazhi();
    }
    
    GGCWarResultViewController *Vc  = [[GGCWarResultViewController alloc]init];
    Vc.homeName = _local_ResultModel.home;
    Vc.lastResultModel = _local_ResultModel;
    [self.viewController.navigationController pushViewController:Vc animated:YES];
}

#pragma mark - 选中某个

- (IBAction)editRow:(id)sender {
    if (self.didActionDelete) {
        self.didActionDelete();
    }
    
    _local_ResultModel.isEditDelete = !_local_ResultModel.isEditDelete;
}

-(void)bigSmallSee:(UITapGestureRecognizer *)tap{
    GGCBigSmallBallViewController *Vc  = [[GGCBigSmallBallViewController alloc]init];
    Vc.homeName = _local_ResultModel.home;
    Vc.lastResultModel = _local_ResultModel;
    [self.viewController.navigationController pushViewController:Vc animated:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setupResultModel:(ResultModel *)resultModel{
    
    _local_ResultModel = resultModel;
    
    _deleteTag.selected = resultModel.isEditDelete;
    
    self.homeName.attributedText = [[NSString stringWithFormat:@"%@%@\n%@\n%@",resultModel.league,resultModel.mmdd,resultModel.hhmm,resultModel.home] changeLineSpace:5];// resultModel.home;
    self.homeName.textAlignment = NSTextAlignmentCenter;
    self.awayName.text = [NSString stringWithFormat:@"%@",resultModel.away];
    
    self.homeCompositeScore.text = [NSString stringWithFormat:@"%.2f", resultModel.homeProportion];
    self.awayCompositeScore.text = [NSString stringWithFormat:@"%.2f", resultModel.awayProportion];
    
    //如果计算主队分数大于客队 并且主队让球或者平手，那么预测是正向。
    if (resultModel.homeProportion - resultModel.awayProportion >= 0) {
        //
        if (resultModel.companyYazhiNumber <= 0) {
            self.homeCompositeScore.textColor = RRC0F9958Color;
        }else{
            //预测反向【黄色警告】
            self.homeCompositeScore.textColor = RRCFFC60AColor;
        }
    }else{
        //主队分数小于客队 指数应该
        if (resultModel.companyYazhiNumber >= 0) {
            self.homeCompositeScore.textColor = RRC0F9958Color;
            
        }else{
            //预测反向【黄色警告】
            self.homeCompositeScore.textColor = RRCFFC60AColor;
        }
    }
    
    self.awayCompositeScore.textColor = self.homeCompositeScore.textColor;
    
    
    
//    self.awayBdBallScore.attributedText = [[NSString stringWithFormat:@"虚：%.2f\n实：%@", resultModel.awayCompositeScore,resultModel.awayScore] changeLineSpace:5];
    
    //胜平负
    self.homeWinScore.text = resultModel.finishWinText;
    self.homeWinScore.backgroundColor = resultModel.finishWinViewColor;

    //胜平负第二选项
    self.homeWinSecondScore.text = resultModel.finishWinSText;
    self.homeWinSecondScore.backgroundColor = resultModel.finishWinSViewColor;
    
    //大小球盘口
    self.resultBigMoney.text = [NSString stringWithFormat:@"%@",resultModel.finishBigMoney];
    self.resultBigSmallCompany.attributedText = [resultModel.finishBigText changeLineSpace:5];
    self.resultBigSmallCompany.textAlignment = NSTextAlignmentCenter;
    self.resultBigSmallCompany.backgroundColor = resultModel.finishBigViewColor;
    self.resultBigSmallCompany.textColor     = resultModel.finishBigTextColor;
    
    //亚指结果
    self.resultYazhiMoney.text = [NSString stringWithFormat:@"%@",resultModel.finishYazhiMoney];
    self.resultYazhiCompany.attributedText = [resultModel.finishYazhiText changeLineSpace:5];
    self.resultYazhiCompany.textAlignment = NSTextAlignmentCenter;
    self.resultYazhiCompany.backgroundColor = resultModel.finishYazhiViewColor;
    self.resultYazhiCompany.textColor     = resultModel.finishYazhiTextColor;
    
    if (resultModel.benjinMoney.floatValue > 0) {
        //盈利为红色
        self.remainMoney.textColor = RRCHighLightTitleColor;
    }else{
        //否则为绿色
        self.remainMoney.textColor = RRC0F9958Color;
    }
    self.remainMoney.text = [NSString stringWithFormat:@"剩余本金：%@",resultModel.benjinMoney];
    
    //进球数由双方份数比例计算而得
    self.BdBallScore.text = [NSString stringWithFormat:@"赛果：%@ : %@", resultModel.homeScore,resultModel.awayScore];
    //波胆命中
    self.homeBdScore.text = [NSString stringWithFormat:@"预测：%@ : %@",resultModel.bd_home_score,resultModel.bd_away_score];
    self.homeBdScore.backgroundColor = resultModel.finishScoreViewColor;
    self.BdBallScore.backgroundColor = resultModel.finishScoreViewColor;

}

@end

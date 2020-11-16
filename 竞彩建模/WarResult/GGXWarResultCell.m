//
//  ResultTableViewCell.m
//  竞彩建模
//
//  Created by gaoguangxiao on 2020/6/8.
//  Copyright © 2020 renrencai. All rights reserved.
//

#import "GGXWarResultCell.h"
#import "NSString+DYLineWordSpace.h"
@interface GGXWarResultCell ()

@property (weak, nonatomic) IBOutlet UILabel *homeName;//主队名字
@property (weak, nonatomic) IBOutlet UILabel *awayName;//客队名字

@property (weak, nonatomic) IBOutlet UILabel *homeCompositeScore;//主队计算得分
@property (weak, nonatomic) IBOutlet UILabel *awayCompositeScore;//客队计算得分

@property (weak, nonatomic) IBOutlet UILabel *homeEnterBallScore;//主队进球数
@property (weak, nonatomic) IBOutlet UILabel *awayEnterBallScore;//客队进球数

@property (weak, nonatomic) IBOutlet UILabel *resultCompany;//亚指盘口
@property (weak, nonatomic) IBOutlet UILabel *resultForecastAllScore; //结果预测
@property (weak, nonatomic) IBOutlet UILabel *resultScoreDifference;//亚指数差值

@property (weak, nonatomic) IBOutlet UILabel *resultCompanyyazhi;//公司所开亚指

@property (weak, nonatomic) IBOutlet UILabel *finishResultRed;//推荐结果 红黑 红：红背景 黑：黑背景，字体为白色

@end

@implementation GGXWarResultCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setupResultModel:(ResultModel *)resultModel{
    
    self.homeName.text = resultModel.home;
    self.awayName.text = resultModel.away;
    
    self.homeCompositeScore.text = [NSString stringWithFormat:@"%.2f", resultModel.homeProportion];
    self.awayCompositeScore.text = [NSString stringWithFormat:@"%.2f", resultModel.awayProportion];
    
    //进球数由双方份数比例计算而得
    self.homeEnterBallScore.attributedText = [[NSString stringWithFormat:@"虚：%.2f\n实：%@", resultModel.homeCompositeScore,resultModel.homeScore] changeLineSpace:5];
    
    self.awayEnterBallScore.attributedText = [[NSString stringWithFormat:@"虚：%.2f\n实：%@", resultModel.awayCompositeScore,resultModel.awayScore] changeLineSpace:5];
    
    //亚指盘口
    self.resultCompany.text = [NSString stringWithFormat:@"%@",resultModel.yp_pk];
    //胜负数
    self.resultForecastAllScore.text = [NSString stringWithFormat:@"%.2f",resultModel.homeCompositeScore - resultModel.awayCompositeScore];
    

    self.resultScoreDifference.attributedText = [resultModel.finishScoreYazhiDif changeLineSpace:5];
    self.resultScoreDifference.textAlignment  = NSTextAlignmentCenter;
 

    self.resultScoreDifference.backgroundColor = resultModel.finishYazhiViewColor;

    
}

@end

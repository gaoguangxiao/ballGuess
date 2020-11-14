//
//  RRCMatchInfoCell.m
//  JHChartDemo
//
//  Created by renrencai on 2019/4/17.
//  Copyright © 2019年 JH. All rights reserved.
//

#import "RRCMatchInfoCell.h"
#import <Masonry/Masonry.h>
#import "DYUIViewExt.h"
#import "RRCDeviceConfigure.h"
@interface RRCMatchInfoCell ()<RRCMatchHandleProtocol>

@property (nonatomic , strong) RRCMatchInfoView *matchInfoView;
@end

@implementation RRCMatchInfoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self showTableView];
    }
    return self;
}

- (void)showTableView{
    self.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.matchInfoView];
    [self.matchInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(self.contentView);
    }];
    
}

-(void)setMatchInfoState:(RRCMatchInfoListState)matchInfoState{
    _matchInfoState = matchInfoState;
    self.matchInfoView.matchInfoState = matchInfoState;
}

-(void)setUpMatchInfoList:(RRCMatchModel *)matchModel{
    
    self.matchInfoView.matchModel =  matchModel;
    [self.matchInfoView showChartAnimation];
    self.chartHeight = self.matchInfoView.height;
}

#pragma mark - RRCMatchHandleProtocol
-(void)insertMatchInfoBymatchId:(NSString *)macthId andMatchInfo:(RRCMatchInfoModel *)matchInfo{
    if (self.delegate && [self.delegate respondsToSelector:@selector(insertMatchInfoBymatchId:andMatchInfo:)]) {
        [self.delegate insertMatchInfoBymatchId:macthId andMatchInfo:matchInfo];
    }
}
-(void)deleteMatchInfoBymatchId:(NSString *)matchId{
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteMatchInfoBymatchId:)]) {
        [self.delegate deleteMatchInfoBymatchId:matchId];
    }
}
-(void)deleteMatchByMatchModel:(RRCMatchModel *)matchModel{
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteMatchByMatchModel:)]) {
        [self.delegate deleteMatchByMatchModel:matchModel];
    }
}
-(void)editMatchByMatchModel:(RRCMatchModel *)matchModel{
    if (self.delegate && [self.delegate respondsToSelector:@selector(editMatchByMatchModel:)]) {
        [self.delegate editMatchByMatchModel:matchModel];
    }
}

#pragma mark - Getter/Setter
-(RRCMatchInfoView *)matchInfoView{
    if (!_matchInfoView) {
        _matchInfoView = [[RRCMatchInfoView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth  - 24 * Device_Ccale, self.height)];
        _matchInfoView.matchInfoState = self.matchInfoState;
        _matchInfoView.delegate = self;
    }
    return _matchInfoView;
}
@end

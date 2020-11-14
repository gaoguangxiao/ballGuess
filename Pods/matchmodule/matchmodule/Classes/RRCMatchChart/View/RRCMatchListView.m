//
//  RRCMatchListView.m
//  MXSFramework
//
//  Created by renrencai on 2019/4/18.
//  Copyright © 2019年 MXS. All rights reserved.
//

#import "RRCMatchListView.h"
//管理类
#import "RRCMatchManager.h"

#import "MXSRefreshHeader.h"
#import "RRCMatchChartConfig.h"
#import "RRCMatchInfoCell.h"
//模型
#import "RRCMatchModel.h"
//工具
#import "MBProgressHUD.h"
#import <Masonry/Masonry.h>
#import "YBColorConfigure.h"
#import "DYUIViewExt.h"
@interface RRCMatchListView ()<UITableViewDelegate,UITableViewDataSource,RRCMatchHandleProtocol>

@property (nonatomic , strong) UITableView *tableView;
@end

@implementation RRCMatchListView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(startReloadListInfo) name:UIApplicationWillEnterForegroundNotification object:nil];
        
        [self setUpView];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [self.tableView reloadData];
}

-(void)startReloadListInfo{
    [self.tableView reloadData];
}

-(void)setUpView{
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(self);
    }];
}
-(void)setMatchInfoState:(RRCMatchInfoListState)matchInfoState{
    _matchInfoState = matchInfoState;
    //添加比赛时具备刷新功能
    if (self.matchInfoState == RRCMatchInfoListStateAdd) {
        [self addTableViewRefresh];
    }else if (self.matchInfoState == RRCMatchInfoListStatePreview){
        self.tableView.scrollEnabled = NO;
    }else if (self.matchInfoState == RRCMatchInfoListStateCommentDelete){
        [self addTableViewRefresh];//评论为列表，可以添加
    }
}
-(void)setMatchConfig:(RRCMatchChartConfig *)matchConfig{
    _matchConfig = matchConfig;
    self.tableView.backgroundColor = matchConfig.tableBackColor ? :RRCUnitViewColor;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, matchConfig.bottomSpace, 0);
}
// 添加下拉刷新
- (void)addTableViewRefresh
{
    MXSRefreshHeader *header = [MXSRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    self.tableView.mj_header = header;
}
#pragma mark - Event response
-(void)requestData{
    if (self.delegate && [self.delegate respondsToSelector:@selector(reloadAllMatchInfo)]) {
        [self.delegate reloadAllMatchInfo];
    }
}

-(void)reloadDataAndOffyToTop{
    [self.tableView reloadData];
    [self.tableView layoutIfNeeded];
    self.tableView.scrollsToTop = YES;
    [self.tableView setContentOffset:CGPointMake(0, 0)];
}

-(void)reloadMatchList{
    [self.tableView reloadData];
    [self.tableView layoutIfNeeded];
    
    __block CGFloat heightMatchAll = 0.1;
    [self.matchListArr enumerateObjectsUsingBlock:^(RRCMatchModel *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        heightMatchAll += obj.heightTitleChart;
    }];
    self.tableViewheight = heightMatchAll < 0?0.1:heightMatchAll;
}
-(void)beginRefreshing{
    [self.tableView.mj_header beginRefreshing];
}
-(void)endRefreshing{
    [self.tableView.mj_header endRefreshing];
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.matchListArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    RRCMatchModel *matchModel = self.matchListArr[indexPath.row];
    return matchModel.heightTitleChart;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RRCMatchInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RRCMatchInfoCell"];
    if (cell == nil) {
        cell = [[RRCMatchInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RRCMatchInfoCell"];
        
    }
    cell.delegate = self;
    cell.matchInfoState = self.matchInfoState;
    [cell setUpMatchInfoList:self.matchListArr[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - RRCMatchHandleProtocol
-(void)editMatchByMatchModel:(RRCMatchModel *)matchModel{
    
    [self resetShopCarState];
    
    if ([self.delegate respondsToSelector:@selector(updateMatchInfoSuccessful)]) {
        [self.delegate updateMatchInfoSuccessful];
    }
}
#pragma mark -删除赛事
-(void)deleteMatchByMatchModel:(RRCMatchModel *)matchModel{
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    if (self.matchInfoState == RRCMatchInfoListStateEdit) {
        [[RRCMatchManager sharedRRCMatchManager]deleteShopCarMatchInfo:matchModel.matchArr.firstObject andLoadDeleteResult:^(BOOL isEnd) {
            
            [self resetShopCarState];
            
            [self deleteMatchSuccessful:matchModel];
        }];
    }else{
        
        [[RRCMatchManager sharedRRCMatchManager]deleteMatchInfo:matchModel.game_type andByRaftId:matchModel.ID andComplete:^(BOOL isEnd) {
            if (isEnd) {
                [self deleteMatchSuccessful:matchModel];
            }
            [MBProgressHUD hideHUDForView:self animated:YES];
        }];
        
    }
}
-(void)resetShopCarState{
    [RRCMatchManager sharedRRCMatchManager].matchModel.seriesSubmitNum = @"0";
    [RRCMatchManager sharedRRCMatchManager].matchModel.isSeries = NO;
    [RRCMatchManager sharedRRCMatchManager].matchModel.matchSubmitNum = @"0";
    [RRCMatchManager sharedRRCMatchManager].matchModel.matchsListModelsArr = @[];
}
-(void)deleteMatchSuccessful:(RRCMatchModel *)matchModel{
    [MBProgressHUD hideHUDForView:self animated:YES];
    NSInteger index = [self.matchListArr indexOfObject:matchModel];
    [self.matchListArr removeObjectAtIndex:index];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
    if ([self.delegate respondsToSelector:@selector(deleteMatchInfoSuccessful)]) {
        [self.delegate deleteMatchInfoSuccessful];
    }
    
    if (self.matchListArr.count == 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(deleteMatchWhileListCountZero)]) {
            [self.delegate deleteMatchWhileListCountZero];
        }
    }
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    
}
#pragma mark - Getter/setter
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = RRCUnitViewColor;
    }
    return _tableView;
}
-(NSMutableArray *)matchListArr{
    if (!_matchListArr) {
        _matchListArr = [NSMutableArray new];
    }
    return _matchListArr;
}
@end

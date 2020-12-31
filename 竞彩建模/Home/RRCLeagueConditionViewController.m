//
//  RRCMatchConditionViewController.m
//  MXSFramework
//
//  Created by gaoguangxiao on 2019/7/12.
//  Copyright © 2019 MXS. All rights reserved.
//

#import "RRCLeagueConditionViewController.h"

#import "RRCCheckCollectionCell.h"

#import "RRCProgressHUD.h"

#import "ResultViewModel.h"
#import "RRCLeaguesModel.h"
//#import "RRCLeagueConditionViewModel.h"
static NSString * const leagueCoViewCellIdentifier= @"RRCCheckCollectionCell_ID";

@interface RRCLeagueConditionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) ResultViewModel *resultViewModel;
@property (weak, nonatomic) IBOutlet UILabel *allCounts;

@property (weak, nonatomic) IBOutlet UICollectionView *collection;

@property (nonatomic, strong) NSMutableArray *allCountArr;
@end

@implementation RRCLeagueConditionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _resultViewModel = [[ResultViewModel alloc]init];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 12 * Device_Ccale;
    layout.minimumInteritemSpacing = 4*Device_Ccale;  //每个的横向间距
    _collection.contentInset = UIEdgeInsetsMake(12 * Device_Ccale, 12 * Device_Ccale, 12 * Device_Ccale, 12 * Device_Ccale);
    _collection.collectionViewLayout = layout;
    [_collection registerClass:[RRCCheckCollectionCell class] forCellWithReuseIdentifier:leagueCoViewCellIdentifier];
    
    [self reloadData];
}

-(void)dealloc{
    NSLog(@"--%@--dealloc",self.class);
    
}
//网络失败重新加载方法
-(void)reloadNetWorking:(UIButton *)sender{
    [self reloadData];
}

//重新加载数据
-(void)reloadData{
    
    [RRCProgressHUD showLoadView:self.view andHeight:self.view.frame.size.height];
    
    [_resultViewModel previewMatchListLeagueWithParameters:@{} Complete:^(NSArray * _Nonnull loadArr, NSInteger count) {
        
        if (loadArr.count == 0) {
            [self listZeroViewText:@"暂无数据" andImageName:@"" andView:self.collection];
        }else{
            [self hiddenNoDataView];
        }
        
        [RRCProgressHUD hideRRCForView:self.view animated:YES];
        
        [self.dataArrayList removeAllObjects];
        [self.dataArrayList addObjectsFromArray:loadArr];
        
        [self.collection reloadData];
    }];
    
}
- (IBAction)handleSubmitData:(id)sender {
    NSMutableArray *leagueListArr = [NSMutableArray new];
    NSString *vcTitle = @"";
    for (NSInteger i = 0 ; i < self.allCountArr.count; i++) {
        
        RRCLeaguesModel *temp_m = self.allCountArr[i];
        
        vcTitle = temp_m.name;
        
        [leagueListArr addObjectsFromArray:temp_m.leagueList];
    }
        
    if (self.submitChoseCondition) {
        self.submitChoseCondition(leagueListArr,vcTitle);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    //    }];
}
#pragma mark - UICollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArrayList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RRCCheckCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:leagueCoViewCellIdentifier forIndexPath:indexPath];
    RRCLeaguesModel *temp_m = self.dataArrayList[indexPath.row];
    cell.nameLab.text =  [NSString stringWithFormat:@"%@【%ld场】",kSafeString(temp_m.name),temp_m.leagueList.count];
    cell.yzLab.text = [NSString stringWithFormat:@"亚指：%@",temp_m.yzRate];
    cell.dxqLab.text = [NSString stringWithFormat:@"球数：%@",temp_m.dxqRate];
    cell.bdLab.text = [NSString stringWithFormat:@"波胆：%@",temp_m.bdRate];
    cell.jcLab.text = [NSString stringWithFormat:@"竞彩：%@",temp_m.jcRate];
    cell.selectStatus = [temp_m.isSelect integerValue] ? YES : NO;
    cell.contentView.backgroundColor = RRCViewCOLOR(temp_m.recommendViewColor);
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    RRCLeaguesModel *itemModel = self.dataArrayList[indexPath.row];
    itemModel.isSelect = [NSString stringWithFormat:@"%@",[itemModel.isSelect integerValue] == 1 ? @"0":@"1"];
    
    __block NSInteger all_count = 0;
    [self.allCountArr removeAllObjects];
    
    [self.dataArrayList enumerateObjectsUsingBlock:^(RRCLeaguesModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.isSelect integerValue] == 1) {
            all_count += obj.leagueList.count;
            [self.allCountArr addObject:obj];
        }
    }];
    //
    NSSet *allSet = [NSSet setWithArray:self.allCountArr];
    if (allSet.count != all_count && all_count == self.allCountArr.count) {
        //        NSLog(@"去重操作了");
        all_count = allSet.count;
    }
    self.allCounts.text  = [NSString stringWithFormat:@"已选%ld场",all_count];
    
    [self.collection reloadData];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kScreenWidth - 24*Device_Ccale - 24*Device_Ccale)/3, 105*Device_Ccale);
}

-(NSMutableArray *)allCountArr{
    if (!_allCountArr) {
        _allCountArr = [NSMutableArray new];
    }
    return _allCountArr;
}

@end

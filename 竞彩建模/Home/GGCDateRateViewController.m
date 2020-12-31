//
//  GGCDateRateViewController.m
//  竞彩建模
//
//  Created by gaoguangxiao on 2020/9/29.
//  Copyright © 2020 renrencai. All rights reserved.
//

#import "GGCDateRateViewController.h"
#import "RRCCheckCollectionCell.h"

#import "RRCProgressHUD.h"

#import "ResultViewModel.h"
#import "RRCMatchRateModel.h"

#import "NSString+DYLineWordSpace.h"

#import "RRCAlertView.h"
static NSString * const leagueCoViewCellIdentifier= @"RRCCheckCollectionCell_ID";
@interface GGCDateRateViewController ()

@property (nonatomic, strong) ResultViewModel *resultViewModel;
@property (weak, nonatomic) IBOutlet UILabel *allCounts;

@property (weak, nonatomic) IBOutlet UICollectionView *collection;

@property (nonatomic, strong) NSMutableArray *allCountArr;

@end

@implementation GGCDateRateViewController

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
    
    [_resultViewModel previewDateListLeagueWithParameters:@{} Complete:^(NSArray * _Nonnull loadArr, NSInteger count) {
        
        if (loadArr.count == 0) {
            [self listZeroViewText:@"暂无数据" andImageName:@"" andView:self.collection];
        }else{
            [self hiddenNoDataView];
        }
        
        [RRCProgressHUD hideRRCForView:self.view animated:YES];
        
        [self.dataArrayList removeAllObjects];
        [self.dataArrayList addObjectsFromArray:loadArr];
        
        self.allCounts.text  = [NSString stringWithFormat:@"总盈利：%ld元",count];
        
        [self.collection reloadData];
    }];
    
}

-(IBAction)changeRateMone:(id)sender{
    RRCAlertView *alertView = [RRCAlertView popoverView];
    alertView.showShade = YES; // 显示阴影背景
    
    NSInteger rateMoneyIndex = [KUserDefault(@"RateMoneyArr") integerValue];
    
    RRCAlertAction *itemAction0 = [RRCAlertAction actionWithTitle:@"均注50" titleColor:rateMoneyIndex == 0 ? RRCHighLightTitleColor : RRCThemeTextColor handler:^(RRCAlertAction *action) {
        [[NSUserDefaults standardUserDefaults]setValue:@"0" forKey:@"RateMoneyArr"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self reloadData];
    }];
   
    RRCAlertAction *itemAction1 = [RRCAlertAction actionWithTitle:@"10倍投" titleColor:rateMoneyIndex == 1 ? RRCHighLightTitleColor : RRCThemeTextColor handler:^(RRCAlertAction *action) {
        [[NSUserDefaults standardUserDefaults]setValue:@"1" forKey:@"RateMoneyArr"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self reloadData];
    }];
    
    RRCAlertAction *itemAction2 = [RRCAlertAction actionWithTitle:@"25倍投" titleColor:rateMoneyIndex == 2 ? RRCHighLightTitleColor : RRCThemeTextColor handler:^(RRCAlertAction *action) {
        [[NSUserDefaults standardUserDefaults]setValue:@"2" forKey:@"RateMoneyArr"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [self reloadData];
        
    }];
    
    RRCAlertAction *itemAction3 = [RRCAlertAction actionWithTitle:@"50为倍投" titleColor:rateMoneyIndex == 3 ? RRCHighLightTitleColor : RRCThemeTextColor handler:^(RRCAlertAction *action) {
        [[NSUserDefaults standardUserDefaults]setValue:@"3" forKey:@"RateMoneyArr"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [self reloadData];
    }];
    
    RRCAlertAction *itemAction4 = [RRCAlertAction actionWithTitle:@"1135投注" titleColor:rateMoneyIndex == 4 ? RRCHighLightTitleColor : RRCThemeTextColor handler:^(RRCAlertAction *action) {
        [[NSUserDefaults standardUserDefaults]setValue:@"4" forKey:@"RateMoneyArr"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [self reloadData];
    }];
    
    RRCAlertAction *itemAction5 = [RRCAlertAction actionWithTitle:@"资金80分之一倍投，支持4连黑" titleColor:rateMoneyIndex == 5 ? RRCHighLightTitleColor : RRCThemeTextColor handler:^(RRCAlertAction *action) {
        [[NSUserDefaults standardUserDefaults]setValue:@"5" forKey:@"RateMoneyArr"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [self reloadData];
    }];
    
    RRCAlertAction *cancelAction = [RRCAlertAction actionWithTitle:@"取消" handler:^(RRCAlertAction *action) {
    }];
    
    NSMutableArray *actionArrAll = [NSMutableArray arrayWithObjects:@[itemAction0,itemAction1,itemAction2,itemAction3,itemAction4,itemAction5], @[cancelAction], nil];
    [alertView showWithActions:actionArrAll];
}

- (IBAction)handleSubmitData:(id)sender {
    NSMutableArray *dateMartchListArr = [NSMutableArray new];
    NSString *vcTitle = @"";
    for (NSInteger i = 0 ; i < self.allCountArr.count; i++) {
        
        RRCMatchRateModel *temp_m = self.allCountArr[i];
        
        vcTitle = temp_m.mmdd;
        
        [dateMartchListArr addObjectsFromArray:temp_m.dateMartchList];
    }
    
    if (self.submitChoseCondition) {
        self.submitChoseCondition(dateMartchListArr,vcTitle);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UICollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArrayList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RRCCheckCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:leagueCoViewCellIdentifier forIndexPath:indexPath];
    RRCMatchRateModel *temp_m = self.dataArrayList[indexPath.row];
    cell.nameLab.text =  [NSString stringWithFormat:@"%@：%ld场",kSafeString(temp_m.mmdd),temp_m.dateMartchList.count];
    cell.yzLab.attributedText = [[NSString stringWithFormat:@"亚指：\n%@",temp_m.yzRate] changeLineSpace:5];
    cell.dxqLab.attributedText = [[NSString stringWithFormat:@"大小球：\n%@",temp_m.dxqRate] changeLineSpace:5
                        ];
    cell.bdLab.attributedText = [[NSString stringWithFormat:@"总盈利：\n%@",temp_m.dxqYzRate] changeLineSpace:5];
    if (temp_m.dxqYzRate.integerValue > 0) {
        cell.bdLab.textColor = RRCHighLightTitleColor;
    }else{
        cell.bdLab.textColor = RRC0F9958Color;
    }
//    cell.jcLab.attributedText = [[NSString stringWithFormat:@"竞彩：\n%@",temp_m.jcRate] changeLineSpace:5];
    cell.selectStatus = [temp_m.isSelect integerValue] ? YES : NO;
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    RRCMatchRateModel *itemModel = self.dataArrayList[indexPath.row];
    itemModel.isSelect = [NSString stringWithFormat:@"%@",[itemModel.isSelect integerValue] == 1 ? @"0":@"1"];
    
    __block NSInteger all_count = 0;
    [self.allCountArr removeAllObjects];
    
    [self.dataArrayList enumerateObjectsUsingBlock:^(RRCMatchRateModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.isSelect integerValue] == 1) {
            all_count += obj.dateMartchList.count;
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
    return CGSizeMake((kScreenWidth - 42*Device_Ccale - 24*Device_Ccale)/3, 145*Device_Ccale);
}

-(NSMutableArray *)allCountArr{
    if (!_allCountArr) {
        _allCountArr = [NSMutableArray new];
    }
    return _allCountArr;
}


@end

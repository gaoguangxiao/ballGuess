//
//  BlogTableViewHelper.m
//  SimpleSrore
//
//  Created by ggx on 2017/3/16.
//  Copyright © 2017年 高广校. All rights reserved.
//

#import "BlogTableViewHelper.h"
#import "UserHeadCell.h"
//#import "UserCenterCell.h"
//#import "OnceTitleCell.h"
#import "HomeModuleCell.h"
#import "UserCenterFootCell.h"

#import <MJRefresh.h>
#import "EFUser.h"
@interface BlogTableViewHelper()<UserCenterFootCellDelegate,HomeModuleCellDelegate>

@property (weak, nonatomic) UITableView *tableView;

@property (nonatomic,strong)NSArray *userArray;
//@property (assign, nonatomic) NSUInteger userId;
//@property (strong, nonatomic) NSMutableArray *blogs;
//@property (strong, nonatomic) UserAPIManager *apiManager;

@end
@implementation BlogTableViewHelper
+ (instancetype)helperWithTableView:(UITableView *)tableView userId:(NSUInteger)userId {
    return [[BlogTableViewHelper alloc] initWithTableView:tableView userId:userId];
}
- (instancetype)initWithTableView:(UITableView *)tableView userId:(NSUInteger)userId {
    if (self = [super init]) {
        
        //        self.userId = userId;
        tableView.delegate = self;
        tableView.dataSource = self;
//        self.blogs = [NSMutableArray new];
        self.tableView = tableView;
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshView)];
        self.tableView.mj_header = header;
        //用户登陆中
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateUserInfo) name:K_APNNOTIFICATIONLOGIN object:nil];
        
    }
    return self;
}
-(void)refreshView{
    //更新用户信息、必须使用账户和密码进行更新信息
     [EFUser getUserInfo:^(BmobUser *user, NSError *error) {
         
         [_tableView.mj_header endRefreshing];
         
         [self->_tableView reloadData];
     
     }];
   
}
-(void)updateUserInfo{
    [EFUser getUserInfo:^(BmobUser *user, NSError *error) {
        [self->_tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource && Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0?1:2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *cellIdenti = @"UserHeadCell";
        UserHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenti];
        if (!cell) {
            cell = CreateCell(@"UserHeadCell");
            cell.lineView.hidden = YES;
        }
        [cell setUserData:[CustomUtil getUserInfo]];// = [BmobUser currentUser];
        cell.PushPartAndCharge = ^(NSInteger index) {
            if (self.didSelectRowAtPushViewIndexPath) {
                self.didSelectRowAtPushViewIndexPath(101);//
            }
        };
        return cell;
    }else{
        //最后一个四股
        if (indexPath.row == 0) {
            static NSString *cellIdenti = @"HomeModuleCell";
            HomeModuleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenti];
            if (!cell) {
                cell = CreateCell(@"HomeModuleCell");
                cell.lineView.hidden = YES;
            }
            cell.delegate = self;
            return cell;
        }else{
            static NSString *cellIdenti = @"UserCenterFootCell";
            UserCenterFootCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenti];
            if (!cell) {
                cell = [[UserCenterFootCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdenti];
                cell.lineView.hidden = YES;
            }
            cell.delegate  = self;
            return cell;
        }
        
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section == 0?110:(indexPath.row == 0)?150:100;
}

#pragma mark -
-(void)homeModuleActionAtIndedx:(NSInteger)index{
    if (self.didSelectRowAtPushViewIndexPath) {
        self.didSelectRowAtPushViewIndexPath(index + 3);//
    }
}
#pragma mark - UserCenterFoot delegate
-(void)exitAction:(NSInteger)index{
    [CustomUtil delAcessToken];//删除 token
    if (self.didSelectRowAtPushViewIndexPath) {
        self.didSelectRowAtPushViewIndexPath(100);
    }
}

@end

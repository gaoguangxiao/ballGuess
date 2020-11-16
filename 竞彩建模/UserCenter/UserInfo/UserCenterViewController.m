//
//  UserCenterViewController.m
//  CPetro
//
//  Created by ggx on 2017/3/8.
//  Copyright © 2017年 高广校. All rights reserved.
//

#import "UserCenterViewController.h"

#import "BlogTableViewHelper.h"
#import "EFUser.h"

@interface UserCenterViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    __weak IBOutlet UITableView *_tableView;
}
@property (strong, nonatomic) BlogTableViewHelper *blogTableViewHelper;
@end

@implementation UserCenterViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //判断用户信息
    if (![CustomUtil isUserLogin]) {
        [self.navigationController presentViewController:CreateViewControllerWithNav(@"LoginViewController") animated:YES completion:^{
           
            [self.blogTableViewHelper updateUserInfoView];
        
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"个人中心";
    
    __weak typeof(self) weakSelf = self;
    
    //所有的店员加载 View
    self.blogTableViewHelper = [BlogTableViewHelper helperWithTableView:_tableView userId:1];
    self.blogTableViewHelper.didSelectRowAtPushViewIndexPath = ^(NSInteger tag){
        if (tag == 100) {
            
            [weakSelf.navigationController presentViewController:CreateViewControllerWithNav(@"LoginViewController") animated:YES completion:^{
                
                [BmobUser logout];
                
                [CustomUtil delAcessToken];
                
                [CustomUtil deleUserInfo];
                
                [weakSelf.blogTableViewHelper updateUserInfoView];
            }];
        }else if (tag == 101){
            //选择照片
            [weakSelf showActionSheet];
        }else{
            if ([CustomUtil isUserLogin]) {
                [weakSelf pushCenterViewController:tag];
            }else{
                [weakSelf.navigationController presentViewController:CreateViewControllerWithNav(@"LoginViewController") animated:YES completion:nil];
            }
            
        }
    };

}
- (void)showActionSheet{
    UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"打开照相机",@"本地相册", nil];
    [sheet setActionSheetStyle:UIActionSheetStyleBlackOpaque];
    [sheet showInView:[self.view window]];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0||buttonIndex == 1) {
        [self addOfCamera:buttonIndex];
    }
}
- (void) addOfCamera:(NSInteger)index
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
    [picker.navigationBar setBackgroundImage:[UIImage imageNamed:@"001"] forBarMetrics:UIBarMetricsDefault];
    picker.delegate = self;
    
    if (index == 0) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
            
        }
        picker.allowsEditing = YES;
    }else{
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
            picker.allowsEditing = YES;
        }
    }
    [self presentViewController:picker animated:YES completion:nil];
}
#pragma mark Camera View Delegate Methods
//点击相册中的图片或者照相机照完后点击use 后触发的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image;
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary){//如果打开相册
        image = [info objectForKey:UIImagePickerControllerEditedImage];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        //照相机
        [picker dismissViewControllerAnimated:YES completion:^{
            
        }];//关掉照相机
        image = [info objectForKey:UIImagePickerControllerEditedImage] ;
    }
    [[HUDHelper sharedInstance]syncLoading];
    [EFUser updateUserUserLoad:image andBackResult:^(BOOL isSu, NSError *error) {
        if (isSu) {
            NSLog(@"上传成功");
            [[HUDHelper sharedInstance]syncStopLoadingMessage:@"上传成功" delay:1.0 completion:^{
                [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }];
        }else{
            [[HUDHelper sharedInstance]syncStopLoadingMessage:@"失败"];
        }
        
    }];
}

//点击cancel调用的方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark  递交个人信息
#pragma mark - view control
-(void)pushCenterViewController:(NSInteger)pushIndex{
    switch (pushIndex) {
        case 2:
            PushViewControllerName(@"ChangeTelViewController");
            break;
        case 3:
            PushViewControllerName(@"AddMoneyViewController");
            break;
        case 4:
            PushViewControllerName(@"ForecastRecordListViewController");//预测订单形成的预测列表
            break;
        case 5:
            PushViewControllerName(@"GGCBetRecordListVC");//下注记录
            break;
        case 6:
            PushViewControllerName(@"FeedBackViewController");
            break;
        case 7:
            PushViewControllerName(@"HistorryOrderViewController");//交易记录 预测订单
            break;
        default:
            //清除缓存
            [[HUDHelper sharedInstance]syncLoading:@"清除缓存"];
            
            [[HUDHelper sharedInstance]syncStopLoading];
            [[HUDHelper sharedInstance]syncStopLoadingMessage:@"清除缓存" delay:1.0 completion:^{

            }];
            [HUDHelper alert:@"清除缓存" cancel:@"OK"];
            
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

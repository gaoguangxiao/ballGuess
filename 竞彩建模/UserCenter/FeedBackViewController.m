//
//  FeedBackViewController.m
//  CPetro
//
//  Created by ggx on 2017/3/8.
//  Copyright © 2017年 高广校. All rights reserved.
//

#import "FeedBackViewController.h"

@interface FeedBackViewController ()
{
    __weak IBOutlet UITextField *_textField;
}
@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"意见反馈";
}
- (IBAction)FeedAction:(id)sender {
    if (_textField.text.length == 0) {
        
        [[RRCAlertManager sharedRRCAlertManager]showPostingWithtitle:@"输入反馈内容"];
        
        return;
    }
    
    BmobObject *gameScore = [BmobObject objectWithClassName:@"FeedBackStore"];
    [gameScore setObject:[BmobUser currentUser].username forKey:@"username"];
    [gameScore setObject:_textField.text forKey:@"content"];
    [gameScore saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
   
            [[RRCAlertManager sharedRRCAlertManager]showPostingWithtitle:@"反馈成功"];
   
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            POP;
        });
        
    }];

    
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

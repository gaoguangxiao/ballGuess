//
//  RRCMatchSetViewController.m
//  竞彩建模
//
//  Created by gaoguangxiao on 2020/10/20.
//  Copyright © 2020 renrencai. All rights reserved.
//

#import "RRCMatchSetViewController.h"

@interface RRCMatchSetViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *preDirection;

@end

@implementation RRCMatchSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //获取当前设置
    NSString *directionPre = [[NSUserDefaults standardUserDefaults] valueForKey:@"preDirection"];
   
    if (directionPre) {
        [_preDirection setOn:[directionPre integerValue]];
    }else{
        [_preDirection setOn:1];
    }
    
}

- (IBAction)ChangePredictDirection:(UISwitch *)sender {
    
    NSLog(@"开光当前状态：%d",sender.isOn);
    
    [[NSUserDefaults standardUserDefaults]setValue:[NSString stringWithFormat:@"%d",sender.on] forKey:@"preDirection"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
- (IBAction)deleteLeague:(id)sender {
    
//    [self performSegueWithIdentifier:@"GGCLeagueDeleteListVC" sender:self];
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

//
//  WCLoginViewController.m
//  weChat
//
//  Created by XSUNT45 on 17/3/10.
//  Copyright © 2017年 XSUNT45. All rights reserved.
//

#import "WCLoginViewController.h"

@interface WCLoginViewController ()

@property (weak, nonatomic) IBOutlet UILabel *userLabel;
- (IBAction)loginBtnClick;
- (IBAction)registerBtnClick;
- (IBAction)forgetPwdBtnClick;


@end

@implementation WCLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //设置用户名为上次登录的用户名
    
    //从沙盒获取用户名
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    
    self.userLabel.text = userName;
    
    
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

- (IBAction)loginBtnClick {
}

- (IBAction)registerBtnClick {
}

- (IBAction)forgetPwdBtnClick {
}
@end

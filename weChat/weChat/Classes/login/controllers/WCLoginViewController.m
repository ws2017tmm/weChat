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
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

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
    NSString *userName = [WCUserInfo sharedWCUserInfo].user;
    self.userLabel.text = userName;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 登录
- (IBAction)loginBtnClick {
    // 保存数据到单例
    
    WCUserInfo *userInfo = [WCUserInfo sharedWCUserInfo];
    userInfo.user = self.userLabel.text;
    userInfo.pwd = self.pwdField.text;
    
    // 调用父类的登录
    [self login];
}

#pragma mark - 注册
- (IBAction)registerBtnClick {
}

#pragma mark - 忘记密码
- (IBAction)forgetPwdBtnClick {
}
@end

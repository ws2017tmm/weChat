//
//  WCLoginViewController.m
//  weChat
//
//  Created by XSUNT45 on 17/3/10.
//  Copyright © 2017年 XSUNT45. All rights reserved.
//

#import "WCLoginViewController.h"
#import "WCNavController.h"
#import "WCRegisterViewController.h"

@interface WCLoginViewController ()<WCRegisgerViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
- (IBAction)pwdFieldTextChange;

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
    // 调用父类的登录
    [self login:self.userLabel.text];
    
    // 保存数据到单例
    WCUserInfo *userInfo = [WCUserInfo sharedWCUserInfo];
    userInfo.user = self.userLabel.text;
    userInfo.pwd = self.pwdField.text;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    // 获取注册控制器
    id destVc = segue.destinationViewController;
    
    
    if ([destVc isKindOfClass:[WCNavController class]]) {
        WCNavController *nav = destVc;
        //获取根控制器
        WCRegisterViewController *registerVc =  (WCRegisterViewController *)nav.visibleViewController;
        if ([registerVc isKindOfClass:[WCRegisterViewController class]]) {
            // 设置注册控制器的代理
            registerVc.delegate = self;
        }
    }
    
}

#pragma mark regisgerViewController的代理
-(void)regisgerViewControllerDidFinishRegister{
    // 完成注册 userLabel显示注册的用户名
    self.userLabel.text = [WCUserInfo sharedWCUserInfo].registerUser;
    
    // 提示
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 1.2秒之后再消失
    [hud hideAnimated:YES afterDelay:1.2];
    hud.label.text = @"请重新输入密码进行登录";
    
    
}




#pragma mark - 注册
- (IBAction)registerBtnClick {
}

#pragma mark - 忘记密码
- (IBAction)forgetPwdBtnClick {
}
#pragma mark - 输入密码按钮才可以点击
- (IBAction)pwdFieldTextChange {
    self.loginBtn.enabled = self.pwdField.hasText;
}
@end

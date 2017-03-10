//
//  WCBaseLoginViewController.m
//  weChat
//
//  Created by XSUNT45 on 17/3/10.
//  Copyright © 2017年 XSUNT45. All rights reserved.
//

#import "WCBaseLoginViewController.h"
#import "AppDelegate.h"

@interface WCBaseLoginViewController ()

@end

@implementation WCBaseLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 登录
/*
 * 官方的登录实现
 
 * 1.把用户名和密码放在沙盒
 * 2.调用 AppDelegate的一个login 连接服务并登录
 */
- (void)login {
    
    //隐藏键盘
    [self.view endEditing:YES];
    
    // 登录之前给个提示
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在登录中...";
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    //防止循环引用
    __weak typeof(self) selfVc = self;
    [app xmppUserLogin:^(XMPPResultType type) {
        [selfVc handleResultType:type];
    }];
    
}


-(void)handleResultType:(XMPPResultType)type{
    // 主线程刷新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        switch (type) {
            case XMPPResultTypeLoginSuccess:
                NSLog(@"登录成功");
                [self enterMainPage];
                break;
            case XMPPResultTypeLoginFailure: {
                NSLog(@"登录失败");
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                // 隐藏时候从父控件中移除
                hud.removeFromSuperViewOnHide = YES;
                // 1秒之后再消失
                [hud hideAnimated:YES afterDelay:1.2];
                hud.label.text = @"用户名或者密码不正确";
                
            }
                break;
            case XMPPResultTypeNetErr: {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                // 隐藏时候从父控件中移除
                hud.removeFromSuperViewOnHide = YES;
                // 1秒之后再消失
                [hud hideAnimated:YES afterDelay:1.2];
                hud.label.text = @"网络不给力";
            }
                break;
            default:
                break;
        }
    });
    
}

// 登录成功
-(void)enterMainPage{
    // 隐藏模态窗口
    [self dismissViewControllerAnimated:NO completion:nil];
    
    // 登录成功来到主界面
    // 此方法是在子线程补调用，所以在主线程刷新UI
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.view.window.rootViewController = storyboard.instantiateInitialViewController;
}


@end

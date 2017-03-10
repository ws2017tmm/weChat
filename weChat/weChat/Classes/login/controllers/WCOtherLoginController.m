//
//  WCOtherLoginController.m
//  weChat
//
//  Created by XSUNT45 on 17/3/9.
//  Copyright © 2017年 XSUNT45. All rights reserved.
//

#import "WCOtherLoginController.h"
#import "AppDelegate.h"


@interface WCOtherLoginController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidth;

@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)loginBtnClick;

- (IBAction)cancle:(UIBarButtonItem *)sender;


@end

@implementation WCOtherLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //判断当前设备
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {//ipad
        self.viewWidth.constant = 500;
        
    }
    
    // 设置TextFeild的背景
    self.userField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    self.pwdField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    
    [self.loginBtn setResizeN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];
    
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
- (IBAction)loginBtnClick {
    WCUserInfo *userInfo = [WCUserInfo sharedWCUserInfo];
    userInfo.user = self.userField.text;
    userInfo.pwd = self.pwdField.text;
    
    [self login];
}




//取消
- (IBAction)cancle:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)dealloc{
    NSLog(@"%s",__func__);
}



@end

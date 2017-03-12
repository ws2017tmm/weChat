//
//  WCRegisterViewController.m
//  weChat
//
//  Created by XSUNT45 on 17/3/10.
//  Copyright © 2017年 XSUNT45. All rights reserved.
//

#import "WCRegisterViewController.h"
#import "AppDelegate.h"

@interface WCRegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
- (IBAction)registerBtnClick;
- (IBAction)cancleRegister:(UIBarButtonItem *)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWidth;

- (IBAction)textChanged;

@end

@implementation WCRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"注册";
    
    //判断当前设备
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {//ipad
        self.viewWidth.constant = 500;
        
    }
    
    // 设置TextFeild的背景
    self.userField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    self.pwdField.background = [UIImage stretchedImageWithName:@"operationbox_text"];
    
    [self.registerBtn setResizeN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];
    
    
    
    
}

// 点击注册按钮
- (IBAction)registerBtnClick {
    // 1.把用户注册的数据保存单例
    WCUserInfo *userInfo = [WCUserInfo sharedWCUserInfo];
    userInfo.registerUser = self.userField.text;
    userInfo.registerPwd = self.pwdField.text;
    
    
    // 2.调用AppDelegate的xmppUserRegister
    
    WCXMPPTool *tool = [WCXMPPTool sharedWCXMPPTool];
    tool.registerOperation = YES;
    
    //隐藏键盘
    [self.view endEditing:YES];
    
    // 登录之前给个提示
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"正在注册中...";
    
    //防止循环引用
    __weak typeof(self) selfVc = self;
    [tool xmppUserRegister:^(XMPPResultType type) {
        [selfVc handleResultType:type];
    }];
}

-(void)handleResultType:(XMPPResultType)type{
    // 主线程刷新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        switch (type) {
            case XMPPResultTypeRegisterSuccess: //注册成功
                NSLog(@"注册成功");
                // 回到上个控制器
                [self dismissViewControllerAnimated:YES completion:nil];
                
                if ([self.delegate respondsToSelector:@selector(regisgerViewControllerDidFinishRegister)]) {
                    [self.delegate regisgerViewControllerDidFinishRegister];
                }
                break;
            case XMPPResultTypeRegisterFailure: { //注册失败
                NSLog(@"注册失败");
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                // 隐藏时候从父控件中移除
                hud.removeFromSuperViewOnHide = YES;
                // 1.2秒之后再消失
                [hud hideAnimated:YES afterDelay:1.2];
                hud.label.text = @"用户已存在或者不正确";
                
            }
                break;
            case XMPPResultTypeNetErr: { //网络不好
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                // 隐藏时候从父控件中移除
                hud.removeFromSuperViewOnHide = YES;
                // 1.2秒之后再消失
                [hud hideAnimated:YES afterDelay:1.2];
                hud.label.text = @"网络不给力";
            }
                break;
            default:
                break;
        }
    });
    
}


//取消注册
- (IBAction)cancleRegister:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//检测文本框，判断注册按钮是否可以点击
- (IBAction)textChanged {
    // 设置注册按钮的可能状态
    
//    BOOL enabled = (self.userField.text.length != 0 && self.pwdField.text.length != 0);
    BOOL enabled = self.userField.hasText && self.pwdField.hasText;
    self.registerBtn.enabled = enabled;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

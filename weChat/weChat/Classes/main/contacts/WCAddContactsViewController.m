//
//  WCAddContactsViewController.m
//  weChat
//
//  Created by wusheng on 17/3/12.
//  Copyright © 2017年 XSUNT45. All rights reserved.
//

#import "WCAddContactsViewController.h"

@interface WCAddContactsViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;


@end

@implementation WCAddContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加好友";
    
    // 右边添加个按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addContacts)];
}

-(void)addContacts{
    [self addContact];
}

- (void)addContact {
    // 添加好友
    //退出键盘
    [self.textField resignFirstResponder];
    // 1.获取好友账号
    NSString *user = self.textField.text;
    NSLog(@"%@",user);
    
    // 判断这个账号是否为手机号码
    //    if(![textField isTelphoneNum]){
    //        //提示
    //        [self showHUD:@"请输入正确的手机号码"];
    //        return;
    //    }
    
    
    //判断是否添加自己
    if([user isEqualToString:[WCUserInfo sharedWCUserInfo].user]){
        
        [self showHUD:@"不能添加自己为好友"];
        return;
    }
    
    NSString *jidStr = [NSString stringWithFormat:@"%@@%@",user,domain];
    XMPPJID *friendJid = [XMPPJID jidWithString:jidStr];
    //判断好友是否已经存在
    if([[WCXMPPTool sharedWCXMPPTool].rosterStorage userExistsWithJID:friendJid xmppStream:[WCXMPPTool sharedWCXMPPTool].xmppStream]){
        [self showHUD:@"当前好友已经存在"];
        return;
    }
    
    
    // 2.发送好友添加的请求
    // 添加好友,xmpp有个叫订阅
    [[WCXMPPTool sharedWCXMPPTool].roster subscribePresenceToUser:friendJid];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self addContact];
    return YES;
}

-(void)showHUD:(NSString *)msg{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 1秒之后再消失
    [hud hideAnimated:YES afterDelay:1.2];
    hud.label.text = msg;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


@end

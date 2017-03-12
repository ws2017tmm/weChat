//
//  WCMeTableViewController.m
//  weChat
//
//  Created by wusheng on 17/3/10.
//  Copyright © 2017年 XSUNT45. All rights reserved.
//

#import "WCMeTableViewController.h"
#import "WCProfileViewController.h"
#import "AppDelegate.h"

@interface WCMeTableViewController ()<WCProfileViewControllerDelegate>

/**
 *  头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *headView;

/**
 *  昵称
 */
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

/**
 *  微信号
 */
@property (weak, nonatomic) IBOutlet UILabel *weixinNumLabel;

@end

@implementation WCMeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"注销" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
    
    /** 如何使用CoreData获取数据
        // 1.上下文【关联到数据】
        
        // 2.FetchRequest
        
        // 3.设置过滤和排序
        
        // 4.执行请求获取数据
    */
    
    //xmpp提供了一个方法，直接获取个人信息
    XMPPvCardTemp *myVCard =[WCXMPPTool sharedWCXMPPTool].vCard.myvCardTemp;
    
    // 设置头像
    if(myVCard.photo){
        self.headView.image = [UIImage imageWithData:myVCard.photo];
    }
    
    // 设置昵称
    self.nickNameLabel.text = myVCard.nickname;
    
    // 设置微信号[用户名]
    
    NSString *user = [WCUserInfo sharedWCUserInfo].user;
    self.weixinNumLabel.text = [NSString stringWithFormat:@"微信号:%@",user];
    
}

- (void)logout {
    //直接调用 appdelegate的注销方法
    [[WCXMPPTool sharedWCXMPPTool] xmppUserlogout];
}



 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
     //获取编辑个人信息的控制
     id destVc = segue.destinationViewController;
     if ([destVc isKindOfClass:[WCProfileViewController class]]) {
         WCProfileViewController *profileV = destVc;
         profileV.delegate = self;
     }
 }

#pragma mark - WCProfileViewControllerDelegate
- (void)profileViewControllerHeadViewDidChanged:(UIImage *)headView {
    self.headView.image = headView;
}



@end

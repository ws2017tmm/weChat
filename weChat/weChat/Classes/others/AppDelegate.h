//
//  AppDelegate.h
//  weChat
//
//  Created by XSUNT45 on 17/3/7.
//  Copyright © 2017年 XSUNT45. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    XMPPResultTypeLoginSuccess,//登录成功
    XMPPResultTypeLoginFailure,//登录失败
    XMPPResultTypeNetErr//网络不给力
}XMPPResultType;

// XMPP请求结果的block
typedef void(^XMPPResultsBlock) (XMPPResultType type);


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**
 *  用户登录
 */
-(void)xmppUserLogin:(XMPPResultsBlock)result;

/**
 *  用户注销
 */
-(void)xmppUserlogout;

@end


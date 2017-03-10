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
    XMPPResultTypeNetErr,//网络不给力
    XMPPResultTypeRegisterSuccess,//注册成功
    XMPPResultTypeRegisterFailure//注册失败
}XMPPResultType;

// XMPP请求结果的block
typedef void(^XMPPResultsBlock) (XMPPResultType type);


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**
 *  注册标识 YES 注册 / NO 登录
 */
@property (nonatomic, assign,getter=isRegisterOperation) BOOL  registerOperation;//注册操作



/**
 *  用户登录
 */
-(void)xmppUserLogin:(XMPPResultsBlock)result;

/**
 *  用户注销
 */
-(void)xmppUserlogout;

/**
 *  用户注册
 */
-(void)xmppUserRegister:(XMPPResultsBlock)resultBlock;

@end


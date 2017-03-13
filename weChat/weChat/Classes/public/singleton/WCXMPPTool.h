//
//  WCXMPPTool.h
//  weChat
//
//  Created by XSUNT45 on 17/3/10.
//  Copyright © 2017年 XSUNT45. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSSingleton.h"
@import XMPPFramework;

typedef enum {
    XMPPResultTypeLoginSuccess,//登录成功
    XMPPResultTypeLoginFailure,//登录失败
    XMPPResultTypeNetErr,//网络不给力
    XMPPResultTypeRegisterSuccess,//注册成功
    XMPPResultTypeRegisterFailure//注册失败
}XMPPResultType;

// XMPP请求结果的block
typedef void(^XMPPResultsBlock) (XMPPResultType type);



@interface WCXMPPTool : NSObject
WSSingletonH(WCXMPPTool)


/**
 *  注册标识 YES 注册 / NO 登录
 */
@property (nonatomic, assign,getter=isRegisterOperation) BOOL  registerOperation;

@property (nonatomic, strong, readonly)XMPPStream *xmppStream;
@property (nonatomic, strong, readonly)XMPPRoster *roster;//花名册模块
@property (nonatomic, strong, readonly) XMPPvCardTempModule *vCard;//电子名片
@property (nonatomic, strong, readonly)XMPPRosterCoreDataStorage *rosterStorage;//花名册数据存储
@property (nonatomic, strong, readonly)XMPPMessageArchivingCoreDataStorage *msgStorage;//聊天的数据存储


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

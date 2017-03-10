//
//  WCRegisterViewController.h
//  weChat
//
//  Created by XSUNT45 on 17/3/10.
//  Copyright © 2017年 XSUNT45. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WCRegisgerViewControllerDelegate <NSObject>

/**
 *  完成注册
 */
-(void)regisgerViewControllerDidFinishRegister;

@end


@interface WCRegisterViewController : UIViewController

@property (nonatomic, weak) id<WCRegisgerViewControllerDelegate> delegate;


@end

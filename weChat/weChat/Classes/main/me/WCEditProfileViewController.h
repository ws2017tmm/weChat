//
//  WCEditProfileViewController.h
//  weChat
//
//  Created by wusheng on 17/3/11.
//  Copyright © 2017年 XSUNT45. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WCEditProfileViewControllerDelegate <NSObject>

-(void)editProfileViewControllerDidSave;


@end

@interface WCEditProfileViewController : UITableViewController

@property (nonatomic, strong) UITableViewCell *cell;

@property (nonatomic, weak) id<WCEditProfileViewControllerDelegate> delegate;

@end

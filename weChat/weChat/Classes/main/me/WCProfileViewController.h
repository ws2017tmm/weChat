//
//  WCProfileViewController.h
//  weChat
//
//  Created by wusheng on 17/3/11.
//  Copyright © 2017年 XSUNT45. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WCProfileViewControllerDelegate <NSObject>

@optional
- (void)profileViewControllerHeadViewDidChanged:(UIImage *)headView;

@end

@interface WCProfileViewController : UITableViewController

@property (nonatomic, weak) id<WCProfileViewControllerDelegate> delegate;


@end

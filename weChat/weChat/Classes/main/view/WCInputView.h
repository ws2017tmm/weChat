//
//  WCInputView.h
//  WeChat
//
//  Created by apple on 14/12/11.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCInputView : UIView
@property (weak, nonatomic) IBOutlet UITextView *textView;

+(instancetype)inputView;

@end

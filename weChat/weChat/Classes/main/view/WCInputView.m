//
//  WCInputView.m
//  WeChat
//
//  Created by apple on 14/12/11.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "WCInputView.h"

@implementation WCInputView


+(instancetype)inputView{
    return [[[NSBundle mainBundle] loadNibNamed:@"WCInputView" owner:nil options:nil] lastObject];
}
@end

//
//  WCProfileViewController.m
//  weChat
//
//  Created by wusheng on 17/3/11.
//  Copyright © 2017年 XSUNT45. All rights reserved.
//

#import "WCProfileViewController.h"
#import "WCEditProfileViewController.h"

@interface WCProfileViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,WCEditProfileViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *headView;//头像
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;//昵称
@property (weak, nonatomic) IBOutlet UILabel *weixinLabel;//微信号

@property (weak, nonatomic) IBOutlet UILabel *orgNameLabel;//公司
@property (weak, nonatomic) IBOutlet UILabel *orgunitLabel;//部门
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//职位
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;//电话
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;//邮件



@end

@implementation WCProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"个人信息";
    [self loadVCard];
}

/**
 *  加载电子名片信息
 */
-(void)loadVCard{
    //显示人个信息
    
    //xmpp提供了一个方法，直接获取个人信息
    XMPPvCardTemp *myVCard =[WCXMPPTool sharedWCXMPPTool].vCard.myvCardTemp;
    
    // 设置头像
    if(myVCard.photo){
        self.headView.image = [UIImage imageWithData:myVCard.photo];
    }
    
    // 设置昵称
    self.nickNameLabel.text = myVCard.nickname;
    
    // 设置微信号[用户名]
    
    self.weixinLabel.text = [WCUserInfo sharedWCUserInfo].user;
    
    // 公司
    self.orgNameLabel.text = myVCard.orgName;
    
    // 部门
    if (myVCard.orgUnits.count > 0) {
        self.orgunitLabel.text = myVCard.orgUnits[0];
    }
    
    //职位
    self.titleLabel.text = myVCard.title;
    
    //电话
    //myVCard.telecomsAddresses 这个get方法，没有对电子名片的xml数据进行解析
    // 使用note字段充当电话
    self.phoneLabel.text = myVCard.note;
    
    //邮件
    // 用mailer充当邮件
    self.emailLabel.text = myVCard.mailer;
}

#pragma mark - Table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 获取cell.tag
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSInteger tag = cell.tag;
    
    // 判断
    if (tag == 1) {//不做任务操作
        NSLog(@"不做任务操作");
        return;
    }
    
    if(tag == 0){//选择照片
        NSLog(@"选择照片");
        
        
        
        UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
            
        }];
        
        UIAlertAction *camera = [UIAlertAction actionWithTitle:@"打开相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            }
            [self presentViewController:imagePicker animated:YES completion:nil];
            
        }];
        
        UIAlertAction *picture = [UIAlertAction actionWithTitle:@"打开相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
                
            }
            pickerImage.delegate = self;
            pickerImage.allowsEditing = YES;
            
            [self presentViewController:pickerImage animated:YES completion:nil];
        }];
        [alertVc addAction:cancle];
        [alertVc addAction:camera];
        [alertVc addAction:picture];
        [self presentViewController:alertVc animated:YES completion:nil];
        
        
    }else{//跳到下一个控制器
        NSLog(@"跳到下一个控制器");
        [self performSegueWithIdentifier:@"EditVCardSegue" sender:cell];
        
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //获取编辑个人信息的控制
    id destVc = segue.destinationViewController;
    if ([destVc isKindOfClass:[WCEditProfileViewController class]]) {
        WCEditProfileViewController *editVc = destVc;
        editVc.cell = sender;
        editVc.delegate = self;
    }
}

#pragma mark 编辑个人信息的控制器代理
-(void)editProfileViewControllerDidSave{
    // 保存
    //获取当前的电子名片信息
    XMPPvCardTemp *myvCard = [WCXMPPTool sharedWCXMPPTool].vCard.myvCardTemp;
    
    // 图片
//    myvCard.photo = UIImagePNGRepresentation(self.headView.image);
    
    // 昵称
    myvCard.nickname = self.nickNameLabel.text;
    
    // 公司
    myvCard.orgName = self.orgNameLabel.text;
    
    // 部门
    if (self.orgunitLabel.text.length > 0) {
        myvCard.orgUnits = @[self.orgunitLabel.text];
    }
    
    // 职位
    myvCard.title = self.titleLabel.text;
    
    // 电话
    myvCard.note =  self.phoneLabel.text;
    
    // 邮件
    myvCard.mailer = self.emailLabel.text;
    
    //更新 这个方法内部会实现数据上传到服务，无需程序自己操作
    [[WCXMPPTool sharedWCXMPPTool].vCard updateMyvCardTemp:myvCard];
}



#pragma mark - 图片选择器的代理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"%@",info);
    // 获取图片 设置图片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    self.headView.image = image;
    
    // 隐藏当前模态窗口
    [self dismissViewControllerAnimated:YES completion:^{
        
        //获取当前的电子名片信息
        XMPPvCardTemp *myvCard = [WCXMPPTool sharedWCXMPPTool].vCard.myvCardTemp;
        
        //保存图片
        myvCard.photo = UIImagePNGRepresentation(image);
        
        //更新 这个方法内部会实现数据上传到服务，无需程序自己操作
        [[WCXMPPTool sharedWCXMPPTool].vCard updateMyvCardTemp:myvCard];
        
        //通知代理
        if ([_delegate respondsToSelector:@selector(profileViewControllerHeadViewDidChanged:)]) {
            [_delegate profileViewControllerHeadViewDidChanged:image];
        }
        
    }];
}

@end

//
//  WCChatViewController.m
//  weChat
//
//  Created by XSUNT45 on 17/3/13.
//  Copyright © 2017年 XSUNT45. All rights reserved.
//

#import "WCChatViewController.h"
#import "WCInputView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Masonry.h"

@interface WCChatViewController ()<UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate,UITextViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>{
    
    NSFetchedResultsController *_resultsContrl;
    
}

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) WCInputView *inputViewBar;


@property (nonatomic, strong) HttpTool *httpTool;

@end

@implementation WCChatViewController

-(HttpTool *)httpTool{
    if (!_httpTool) {
        _httpTool = [[HttpTool alloc] init];
    }
    
    return _httpTool;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    
    // 键盘监听
    // 监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // 加载数据
    [self loadMsgs];
    
}

-(void)setupView{
    // 代码方式实现自动布局 VFL
    // 创建一个Tableview;
    UITableView *tableView = [[UITableView alloc] init];
//    tableView.backgroundColor = [UIColor redColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
    }];
    self.tableView = tableView;
    
    // 创建输入框View
    WCInputView *inputViewBar = [WCInputView inputView];
    // 添加按钮事件
    [inputViewBar.addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    // 设置TextView代理
    inputViewBar.textView.delegate = self;
    
    [self.view addSubview:inputViewBar];
    
    [inputViewBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.bottom);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.bottom.equalTo(self.view.bottom);
        make.height.mas_equalTo(44);
    }];
    
    self.inputViewBar = inputViewBar;
}

-(void)keyboardWillShow:(NSNotification *)noti{
    NSLog(@"%@",noti);
    // 获取键盘的高度
    CGRect kbEndFrm = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardDuration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGFloat kbHeight =  kbEndFrm.size.height;
    
    //更新约束
    [self.inputViewBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.bottom).offset(-kbHeight);
    }];
    // 更新约束
    [UIView animateWithDuration:keyboardDuration animations:^{
        
        [self.view layoutIfNeeded];
        
    }];
    //表格滚动到底部
    [self scrollToTableBottom];
    
}

-(void)keyboardWillHide:(NSNotification *)noti{
    // 隐藏键盘的进修 距离底部的约束永远为0
    [self.inputViewBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.bottom);
    }];
    
    CGFloat keyboardDuration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 更新约束
    [UIView animateWithDuration:keyboardDuration animations:^{
        
        [self.view layoutIfNeeded];
        
    }];
}


#pragma mark 加载XMPPMessageArchiving数据库的数据显示在表格
-(void)loadMsgs{
    
    // 上下文
    NSManagedObjectContext *context = [WCXMPPTool sharedWCXMPPTool].msgStorage.mainThreadManagedObjectContext;
    // 请求对象
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
    
    
    // 过滤、排序
    // 1.当前登录用户的JID的消息
    // 2.好友的Jid的消息
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@ AND bareJidStr = %@",[WCUserInfo sharedWCUserInfo].jid,self.friendJid.bare];
    NSLog(@"%@",pre);
    request.predicate = pre;
    
    // 时间升序
    NSSortDescriptor *timeSort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    request.sortDescriptors = @[timeSort];
    
    // 查询
    _resultsContrl = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    NSError *err = nil;
    // 代理
    _resultsContrl.delegate = self;
    
    [_resultsContrl performFetch:&err];
    
    NSLog(@"%@",_resultsContrl.fetchedObjects);
    if (err) {
        NSLog(@"%@",err);
    }
}

#pragma mark - Table view data source

#pragma mark - 表格的数据源
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"_resultsContrl.fetchedObjects.count = %zd",_resultsContrl.fetchedObjects.count);
    return _resultsContrl.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"ChatCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    
    // 获取聊天消息对象
    XMPPMessageArchiving_Message_CoreDataObject *msg =  _resultsContrl.fetchedObjects[indexPath.row];
    
    NSLog(@"msg.body = %@",msg.body);
    // 判断是图片还是纯文本
    NSString *chatType = [msg.message attributeStringValueForName:@"bodyType"];
    if ([chatType isEqualToString:@"image"]) {
        //下图片显示
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:msg.body] placeholderImage:[UIImage imageNamed:@"DefaultProfileHead_qq"]];
        cell.textLabel.text = nil;
    }else if([chatType isEqualToString:@"chat"]){
        //显示消息
        if (msg.isOutgoing) {//自己发
            cell.textLabel.text = [NSString stringWithFormat:@"Me: %@",msg.body];
        }else{//别人发的
            cell.textLabel.text = [NSString stringWithFormat:@"Other: %@",msg.body];
        }
        
        cell.imageView.image = nil;
    }
    
    return cell;
}

#pragma mark ResultController的代理
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    // 刷新数据
    [self.tableView reloadData];
    [self scrollToTableBottom];
}


#pragma mark TextView的代理
-(void)textViewDidChange:(UITextView *)textView{
    NSString *text = textView.text;
    // 换行就等于点击了的send
    if ([text rangeOfString:@"\n"].length != 0) {
        NSLog(@"发送数据 %@",text);
        [self sendMsgWithText:text bodyType:@"chat"];
        //清空数据
        textView.text = nil;
        
    }else{
        NSLog(@"%@",textView.text);
        
    }
}


#pragma mark 发送聊天消息
-(void)sendMsgWithText:(NSString *)text bodyType:(NSString *)bodyType {
    
    XMPPMessage *msg = [XMPPMessage messageWithType:@"chat" to:self.friendJid];
    
    //text 纯文本
    //image 图片
    [msg addAttributeWithName:@"bodyType" stringValue:bodyType];
    
    // 设置内容
    [msg addBody:text];
    NSLog(@"%@",msg);
    [[WCXMPPTool sharedWCXMPPTool].xmppStream sendElement:msg];
}


#pragma mark 滚动到底部
-(void)scrollToTableBottom{
    if (!_resultsContrl.fetchedObjects.count) return;
    NSInteger lastRow = _resultsContrl.fetchedObjects.count - 1;
    NSIndexPath *lastPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    
    [self.tableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


#pragma mark 选择图片
-(void)addBtnClick{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

#pragma mark 选取后图片的回调
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"%@",info);
    // 隐藏图片选择器的窗口
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // 获取图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    // 把图片发送到文件服务器
    //http post put
    /**
     * put实现文件上传没post那烦锁，而且比POST快
     * put的文件上传路径就是下载路径
     
     *文件上传路径 http://127.0.0.1/ + "图片名"
     */
    
    // 1.取文件名 用户名 + 时间(201412111537)年月日时分秒
    NSString *user = [WCUserInfo sharedWCUserInfo].user;
    
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc] init];
    dataFormatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *timeStr = [dataFormatter stringFromDate:[NSDate date]];
    
    //
    NSString *fileName = [user stringByAppendingString:timeStr];
    
    // 2.拼接上传路径
    NSString *uploadUrl = [@"http://127.0.0.1/" stringByAppendingString:fileName];
    
    
    // 3.使用HTTP put 上传
    [self.httpTool uploadData:UIImageJPEGRepresentation(image, 0.75) url:[NSURL URLWithString:uploadUrl] progressBlock:nil completion:^(NSError *error) {
        
        if (!error) {
            NSLog(@"上传成功");
            // 图片发送成功，把图片的URL传Openfire的服务
            [self sendMsgWithText:uploadUrl bodyType:@"image"];
        }
    }];
}


@end

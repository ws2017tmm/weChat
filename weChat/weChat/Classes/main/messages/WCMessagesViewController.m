//
//  WCMessagesViewController.m
//  weChat
//
//  Created by XSUNT45 on 17/3/13.
//  Copyright © 2017年 XSUNT45. All rights reserved.
//

#import "WCMessagesViewController.h"
#import "WCChatViewController.h"

@interface WCMessagesViewController () <UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate>{
    
    NSFetchedResultsController *_resultsContrl;
}
@end

@implementation WCMessagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //获取最近聊天信息
    /**
       1.最近聊天的人，最后一条信息
       2.显示到tableView上
     
     */
    
    // 加载数据
    [self loadContacts];
    
    
}

#pragma mark 加载XMPPMessageArchiving数据库的数据显示在表格
-(void)loadContacts{
    
    // 上下文
    NSManagedObjectContext *context = [WCXMPPTool sharedWCXMPPTool].msgStorage.mainThreadManagedObjectContext;
    // 请求对象 关联 联系人表(最近联系人和最近消息)
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Contact_CoreDataObject"];
    
    //mostRecentMessageBody
    
    // 过滤、排序
    // 1.当前登录用户的JID的消息
    // 2.好友的Jid的消息
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr = %@ AND bareJidStr = %@",[WCUserInfo sharedWCUserInfo].jid];
    NSLog(@"%@",pre);
    request.predicate = pre;
    
    // 时间升序
    NSSortDescriptor *timeSort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    request.sortDescriptors = @[timeSort];
    
    // 查询
    _resultsContrl = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    NSError *err = nil;
    [_resultsContrl performFetch:&err];
    
    // 代理
    _resultsContrl.delegate = self;
    if (err) {
        NSLog(@"%@",err);
    }
}

#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _resultsContrl.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"messagesCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    // 获取聊天消息对象
    XMPPMessageArchiving_Contact_CoreDataObject *msg =  _resultsContrl.fetchedObjects[indexPath.row];
    
    //显示消息
    //联系人
    cell.textLabel.text = msg.bareJid.user;
    //最近消息
    cell.detailTextLabel.text = msg.mostRecentMessageBody;
    
    return cell;
}


#pragma mark ResultController的代理
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    // 刷新数据
    [self.tableView reloadData];
}


#pragma mark - Table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //获取好友
    XMPPMessageArchiving_Contact_CoreDataObject *contact = _resultsContrl.fetchedObjects[indexPath.row];
    
    //选中表格进行聊天界面
    [self performSegueWithIdentifier:@"ChatSegue" sender:contact.bareJid];
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    id destVc = segue.destinationViewController;
    
    if ([destVc isKindOfClass:[WCChatViewController class]]) {
        WCChatViewController *chatVc = destVc;
        chatVc.friendJid = sender;
    }
}



@end

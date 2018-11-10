//
//  HMDevListViewController.m
//  Demo
//
//  Created by guofeixu on 15/10/10.
//  Copyright © 2015年 guofeixu. All rights reserved.
//

#import "HMDevListViewController.h"
#import "HMPlayerViewController.h"
#import "UIActionSheet+Channel.h"

@interface HMDevListViewController ()<UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *deviceList;
@property (strong, nonatomic) NSMutableArray *list;
@property (strong, nonatomic) UIStoryboard *storyboard;
@property (strong, nonatomic) HMNodeObject *sourceNodeObject;
@property (strong, nonatomic) HMChannelObject *sourceChannelObject;
@end

@implementation HMDevListViewController

@synthesize deviceList;
@synthesize node;
@synthesize list;
@synthesize storyboard;
@synthesize sourceNodeObject;
@synthesize sourceChannelObject;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    deviceList = [[UITableView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    deviceList.delegate = self;
    deviceList.dataSource = self;
    [self.view addSubview:deviceList];
    
    
    list = [NSMutableArray array];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        list = [self nodeArray];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [deviceList reloadData];
        });
    });
    
    
   
    
    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)nodeArray{
    
    int32 nodeCount = 0;
    hm_server_get_children_count(node, &nodeCount);
    
    NSMutableArray *nodeList = [[NSMutableArray alloc] init];
    
    for (int32 childNodeIndex = 0; childNodeIndex < nodeCount; childNodeIndex++) {
        
        HMNodeObject *nodeObject = [[HMNodeObject alloc] init];
        
        //1.获取节点句柄
        node_handle tempHandle = NULL;
        hm_server_get_child_at(node, childNodeIndex, &tempHandle);
        nodeObject.nodeHandle = tempHandle;
        
        //2.获取节点类型
        NODE_TYPE_INFO tempType;
        hm_server_get_node_type(tempHandle, &tempType);
        nodeObject.nodeType = tempType;
        
        
        //3.获取节点名称
        cpchar cpname;
        hm_server_get_node_name(tempHandle, &cpname);
        NSString *tempName;
        
        if (cpname != NULL) {
            
            tempName = [NSString stringWithUTF8String:cpname];
            
        }else{
            
            tempName = @"ipcamera";
        }
        nodeObject.nodeName = tempName;
        
        //4.若节点为设备或者DVS,获取在线状态
        if (tempType == HME_NT_DEVICE || tempType == HME_NT_DVS) {
            
            bool isOnline = false;
            
            hm_result onlineResult = hm_server_is_online(tempHandle, &isOnline);
            
            if (onlineResult == HMEC_OK) {
                
                nodeObject.nodeIsOnline = isOnline;
            }
            
            
        }
        
        [nodeList addObject:nodeObject];
    }
    
    
    
    return nodeList;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return list.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ide = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ide];
   
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ide];
    }
    
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:20.0];
    
    HMNodeObject *nodeObject = list[indexPath.row];
    cell.textLabel.text = nodeObject.nodeName;
    
    UIImage *cellImage;
    
    if (nodeObject.nodeType == HME_NT_GROUP) {
        
        
        cellImage = [UIImage imageNamed:@"folder1.png"];
    }
    else if(nodeObject.nodeType == HME_NT_DEVICE)
    {
        
        cellImage = [UIImage imageNamed:@"device_offline.png"];
        if (nodeObject.nodeIsOnline) {
            
            cellImage = [UIImage imageNamed:@"device.png"];
        }
    }
    else if(nodeObject.nodeType == HME_NT_DVS)
    {
        cellImage = [UIImage imageNamed:@"dvs_offline.png"];
        if (nodeObject.nodeIsOnline) {
            
            cellImage = [UIImage imageNamed:@"dvs.png"];
        }
    }
    
    cell.imageView.image = cellImage;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HMNodeObject *nodeObject = list[indexPath.row];
    
    if (nodeObject.nodeType == HME_NT_GROUP) {
        
        
        HMDevListViewController *devList = [storyboard instantiateViewControllerWithIdentifier:@"devlist"];
        devList.node = nodeObject.nodeHandle;
        devList.powerActor = self.powerActor;
        
        [self.navigationController pushViewController:devList animated:YES];
        
    }else if (nodeObject.nodeType == HME_NT_DEVICE){
        
        
        if (!nodeObject.nodeIsOnline) {
            
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"设备不在线"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定", nil];
            [alert show];
            
        }else{
        
            sourceNodeObject = nodeObject;
            [self performSegueWithIdentifier:@"playerPush" sender:self];
            
            
            
        }
    }else if (nodeObject.nodeType == HME_NT_DVS){
        
        if (!nodeObject.nodeIsOnline) {
            
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"设备不在线"
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定", nil];
            [alert show];
        }else{
            
            sourceNodeObject = nodeObject;
            UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                          initWithTitle:nodeObject.nodeName
                                          delegate:self
                                          cancelButtonTitle:nil
                                          destructiveButtonTitle: nil
                                          otherButtonTitles:nil];
            //DVS的处理
            int count ;
            hm_server_get_children_count(nodeObject.nodeHandle,&count);
            
            NSMutableArray *channelListArray = [[NSMutableArray alloc] init];
            
            CHANNEL_INFO *channelInfo = NULL;
            
            for (int i=0; i<count; i++) {
                
                HMChannelObject *channelObject = [[HMChannelObject alloc] init];
                node_handle childnode;
                hm_result childResult = hm_server_get_child_at(nodeObject.nodeHandle, i,&childnode);
                
                hm_result channelResult = hm_server_get_channel_info(childnode, &channelInfo);
                
                if (channelResult == HMEC_OK) {
                    
                    NSString *tempName;
                    if (channelInfo->name != NULL) {
                        
                        tempName = [NSString stringWithUTF8String:channelInfo->name];
                    }else{
                        
                        tempName = @"channel";
                    }
                    
                    channelObject.channelName = tempName;
                    channelObject.channelIndex = channelInfo->index;
                    channelObject.channelNodeHandle = childnode;
                    channelObject.additionalIndex = i;
                    
                    [channelListArray addObject:channelObject];
                }
            }
            
            for (HMChannelObject *object in channelListArray) {
                
                
                [actionSheet addButtonWithTitle:object.channelName];
            }
            
            [actionSheet setChannelArray:channelListArray];
            //添加取消按钮
            NSInteger cancelIndex = [actionSheet addButtonWithTitle: @"取消"];
            [actionSheet setCancelButtonIndex: cancelIndex];
            [actionSheet showInView:self.view];
        }
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger) buttonIndex
{
    //当用户按下cancel按钮
    
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }else if (buttonIndex == actionSheet.destructiveButtonIndex){
        
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
        
    }else if (buttonIndex < [actionSheet getChannelArray].count){
        
        
        sourceChannelObject = [actionSheet getChannelArray][buttonIndex];
        
        [self performSegueWithIdentifier:@"playerPush" sender:self];
        
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"playerPush"]) {
        
        HMPlayerViewController *playerViewController = segue.destinationViewController;
        
        playerViewController.nodeObject = sourceNodeObject;
        playerViewController.channelObject = sourceChannelObject;
        playerViewController.powerActor = self.powerActor;
    }
    
    
}


@end

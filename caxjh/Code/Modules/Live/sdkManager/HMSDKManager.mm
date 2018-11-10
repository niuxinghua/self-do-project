//
//  HMSDKManager.m
//  caxjh
//
//  Created by niuxinghua on 2017/8/30.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import "HMSDKManager.h"
#import "HMNodeObject.h"
@implementation HMSDKManager
static id sharedSDKManager = nil;
+ (id)allocWithZone:(struct _NSZone *)zone {
    if (!sharedSDKManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedSDKManager = [super allocWithZone:zone];
        });
    }
    return sharedSDKManager;
}
- (id)init {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSDKManager = [super init];
    });
    return sharedSDKManager;
}
+ (instancetype)sharedInstance {
    return [[self alloc] init];
}
+ (id)copyWithZone:(struct _NSZone *)zone {
    return sharedSDKManager;
}
+ (id)mutableCopyWithZone:(struct _NSZone *)zone {
    return sharedSDKManager;
}



- (void)initSDK
{
    
    hm_sdk_init();
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _realNodeList = [[NSMutableArray alloc]init];
        //  [self authenticateWithData];
    });
}
- (NSArray *)getAllDevice:(NSString *)domain account:(NSString *)account passWord:(NSString *)passWord port:(int)port
{
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self authenticateWithData:domain account:account passWord:passWord port:port];
        dispatch_semaphore_signal(sema);
    });
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    return _realNodeList.copy;
    
}











- (void)authenticateWithData:(NSString *)domian account:(NSString *)account passWord:(NSString *)pass port:(int)port{
    
    pchar server,name,key;
    server = (pchar)[domian UTF8String];
    name = (pchar)[account UTF8String];
    key = (pchar)[pass UTF8String];
    
    
    LOGIN_SERVER_INFO loginInfo ;
    loginInfo.ip =  server;
    loginInfo.port =  port;
    loginInfo.user =  name;
    loginInfo.password = key;
    loginInfo.plat_type = "ios";
    loginInfo.keep_time = 60;
    loginInfo.hard_ver = "iPhone";
    loginInfo.soft_ver = "";
    
    
    char err[512] = {0};
    hm_result result = hm_server_connect(&loginInfo, &_server_Id,err,512);
    
    NSString *errorStr = [NSString stringWithUTF8String:err];
    
    NSLog(@"result:%0x",result);
    NSLog(@"errorStr:%@",errorStr);
    NSLog(@"server_id:%s",_server_Id);
    
    if ( result == HMEC_OK)
    {
        NSLog(@"连接服务器成功");
        [self loginServerOperation];
    }
    else
    {
        
        return;
        
    }
    
}
#pragma mark -获取登录时的信息
- (void)loginServerOperation{
    
    hm_result deviceListResult = hm_server_get_device_list(_server_Id);
    
    NSLog(@"deviceListResult:%0x",deviceListResult);
    
    if ( deviceListResult != HMEC_OK) {
        return;
    }
    
    //getTime
    uint64 time;
    hm_server_get_time(_server_Id, &time);
    
    if (time < HMEC_OK) {
        return;
    }
    
    NSLog(@"time:%llu",time);
    
    //getUserInfo
    P_USER_INFO userInfo;
    hm_server_get_user_info(_server_Id,&userInfo);
    if (userInfo == NULL)
    {
        NSLog(@"获取用户信息失败,%s",userInfo->name);
        return;
    }
    
    //getTransferInfo
    if (userInfo->use_transfer_service != HMEC_OK)
    {
        if (hm_server_get_transfer_info(_server_Id) != HMEC_OK)
        {
            NSLog(@"获取穿透信息失败");
            return;
        }
    }
    
    //test getTree;
    if (hm_server_get_tree(_server_Id, &_tree_hd) != HMEC_OK)
    {
        NSLog(@"获取设备树失败");
        return;
    }
    
    int deviceCount = 0;
    hm_result deviceResult = hm_server_get_all_device_count(_tree_hd, &deviceCount);
    
    for (int i=0; i<deviceCount; i++) {
        node_handle node;
        
        if(hm_server_get_all_device_at(_tree_hd, i, &node)==0)
        {
            
            //获取设备权限
            if(hm_server_get_device_power(node,&_actorPower)==0)
            {
                break;
            }
        }
    }
    
    
    [self handleDeviceTree];
    
    
}

#pragma mark -处理设备树接口
- (void)handleDeviceTree{
    
    
    if (_tree_hd != NULL)
    {
        hm_server_get_root(_tree_hd,&_root);
        if (_root != NULL)
        {
            // [self performSegueWithIdentifier:@"devPush" sender:self];
            [self nodeArray:_root];
        }
    }
    
}

#pragma mark --node
- (void)nodeArray:(node_handle)nodehandle{
    
    int32 nodeCount = 0;
    hm_server_get_children_count(nodehandle, &nodeCount);
    
    NSMutableArray *nodeList = [[NSMutableArray alloc] init];
    
    for (int32 childNodeIndex = 0; childNodeIndex < nodeCount; childNodeIndex++) {
        
        HMNodeObject *nodeObject = [[HMNodeObject alloc] init];
        
        //1.获取节点句柄
        node_handle tempHandle = NULL;
        hm_server_get_child_at(nodehandle, childNodeIndex, &tempHandle);
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
    
    for (HMNodeObject *node in nodeList) {
        if (node.nodeType == HME_NT_GROUP) {
            [self nodeArray:node.nodeHandle];
        }
        else if(node.nodeType == HME_NT_DEVICE){
            cpchar device_sn;
            hm_server_get_device_sn(node.nodeHandle, &device_sn);
            NSLog(@"%@",[NSString stringWithUTF8String:device_sn]);
            node.SN = [NSString stringWithUTF8String:device_sn];
            BOOL shouldAdd = YES;
            for (HMNodeObject *node1 in _realNodeList) {
                if ([node1.SN isEqualToString:node.SN]) {
                    shouldAdd = NO;
                }
            }
            if (shouldAdd) {
                [_realNodeList addObjectsFromArray:@[node]];
            }
        }
    }
    
    // return nodeList;
}


@end

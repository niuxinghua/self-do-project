//
//  HMLoginViewController.m
//  Demo
//
//  Created by guofeixu on 15/10/10.
//  Copyright © 2015年 guofeixu. All rights reserved.
//

#import "HMLoginViewController.h"
#import "HMDevListViewController.h"

@interface HMLoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *serverUrlTextField;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *userKeyTextField;
@property (strong, nonatomic) UIActivityIndicatorView *activityView;

@property (assign, nonatomic) node_handle root;
@property (assign, nonatomic) tree_handle tree_hd;
@property (assign, nonatomic) server_id server_Id;
@property (assign, nonatomic) int64 actorPower;

@end

@implementation HMLoginViewController

@synthesize serverUrlTextField;
@synthesize userNameTextField;
@synthesize userKeyTextField;
@synthesize activityView;
@synthesize root;
@synthesize tree_hd;
@synthesize server_Id;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.frame = CGRectMake((self.view.bounds.size.width -20)/2, (self.view.bounds.size.height - 20)/2, 20, 20);
    
    [self.view addSubview:activityView];
    
    activityView.hidden = YES;
    tree_hd = NULL;
    server_Id = NULL;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)login:(UIButton *)sender {
    
    [serverUrlTextField resignFirstResponder];
    [userNameTextField resignFirstResponder];
    [userKeyTextField resignFirstResponder];
    
    if (userNameTextField.text.length == 0 || userKeyTextField.text.length == 0 || serverUrlTextField.text.length==0) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"请输入正确的登录信息" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    
    [activityView setHidden:NO];
    [activityView startAnimating];
    
    
    [self performSelectorInBackground: @selector(authenticateWithData) withObject:nil];
    
    
}

- (void)authenticateWithData{
    
    pchar server,name,key;
    server = (pchar)[serverUrlTextField.text UTF8String];
    name = (pchar)[userNameTextField.text UTF8String];
    key = (pchar)[userKeyTextField.text UTF8String];
    
    
    LOGIN_SERVER_INFO loginInfo ;
    loginInfo.ip =  server;
    loginInfo.port =  80;
    loginInfo.user =  name;
    loginInfo.password = key;
    loginInfo.plat_type = "ios";
    loginInfo.keep_time = 60;
    loginInfo.hard_ver = "iPhone";
    loginInfo.soft_ver = "";

    
    char err[512] = {0};
    hm_result result = hm_server_connect(&loginInfo, &server_Id,err,512);
    
    NSString *errorStr = [NSString stringWithUTF8String:err];
    
    NSLog(@"result:%0x",result);
    NSLog(@"errorStr:%@",errorStr);
    NSLog(@"server_id:%s",server_Id);
    
    if ( result == HMEC_OK)
    {
        NSLog(@"连接服务器成功");
        
        
        [self loginServerOperation];
    }
    else
    {
        [activityView stopAnimating];
        [activityView setHidden:YES];
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"登录失败" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return;
        
    }
    
}

#pragma mark -获取登录时的信息
- (void)loginServerOperation{
    
    hm_result deviceListResult = hm_server_get_device_list(server_Id);
    
    NSLog(@"deviceListResult:%0x",deviceListResult);
    
    if ( deviceListResult != HMEC_OK) {
        
        [activityView stopAnimating];
        [activityView setHidden:YES];
        return;
    }
    
    //getTime
    uint64 time;
    hm_server_get_time(server_Id, &time);
    
    if (time < HMEC_OK) {
        
        [activityView stopAnimating];
        [activityView setHidden:YES];
        return;
    }
    
    NSLog(@"time:%llu",time);
    
    //getUserInfo
    P_USER_INFO userInfo;
    hm_server_get_user_info(server_Id,&userInfo);
    if (userInfo == NULL)
    {
        NSLog(@"获取用户信息失败,%s",userInfo->name);
        [activityView stopAnimating];
        [activityView setHidden:YES];
        return;
    }
    
    //getTransferInfo
    if (userInfo->use_transfer_service != HMEC_OK)
    {
        if (hm_server_get_transfer_info(server_Id) != HMEC_OK)
        {
            NSLog(@"获取穿透信息失败");
            [activityView stopAnimating];
            [activityView setHidden:YES];
            return;
        }
    }
    
    //test getTree;
    if (hm_server_get_tree(server_Id, &tree_hd) != HMEC_OK)
    {
        NSLog(@"获取设备树失败");
        [activityView stopAnimating];
        [activityView setHidden:YES];
        return;
    }
    
    int deviceCount = 0;
    hm_result deviceResult = hm_server_get_all_device_count(tree_hd, &deviceCount);
    
    for (int i=0; i<deviceCount; i++) {
        node_handle node;
        
        
        if(hm_server_get_all_device_at(tree_hd, i, &node)==0)
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
   
    [activityView stopAnimating];
    [activityView setHidden:YES];
    
    if (tree_hd != NULL)
    {
        hm_server_get_root(tree_hd,&root);
        if (root != NULL)
        {
            [self performSegueWithIdentifier:@"devPush" sender:self];
        }
    }
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"devPush"]) {
        HMDevListViewController *detailedList = segue.destinationViewController;
        detailedList.node = root;
        detailedList.powerActor = self.actorPower;
    }
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

@end

//
//  HMLanDevSearchViewController.m
//  Demo
//
//  Created by guofeixu on 15/10/10.
//  Copyright © 2015年 guofeixu. All rights reserved.
//

#import "HMLanDevSearchViewController.h"
#import "HMPlayerViewController.h"


@interface HMLanDevSearchViewController ()

@property (assign, nonatomic) lan_device_search_handle lan_wifi_handle;
@property (strong, nonatomic) NSMutableArray*devSearchArray;

- (void)addSearchWifiDevToArray:(P_LAN_DEVICE_SEARCH_RES) ldsr;

@end

@implementation HMLanDevSearchViewController

@synthesize lan_wifi_handle;
@synthesize devSearchArray;

static void lan_wifi_device_search_cb(user_data data, LAN_DEVICE_SEARCH_RES ldsr, hm_result result)
{
    if (result != HMEC_OK) return;
    
    //选择局域网搜索的设备，容易出现崩溃的现象
    //将搜索出来的设备添加到数组里面，如果数组里面已经存在该设备，就不添加
    HMLanDevSearchViewController* promptView = (__bridge HMLanDevSearchViewController*)data;
    [promptView addSearchWifiDevToArray:&ldsr];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   devSearchArray = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self startSearchWifiDev];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self stopSearchWifiDev];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 局域网搜索处理函数
- (void)startSearchWifiDev
{
    if (lan_wifi_handle!=NULL) return;
    
    NSLog(@"开启wifi搜索");
    LAN_DEVICE_SEARCH_PARAM param = {};
    param.data  = (__bridge user_data)(self);
    param.cb_search = lan_wifi_device_search_cb;
    param.search_mode  = (LAN_SEARCH_MODE)(HME_LSM_MC|HME_LSM_BC); // HME_LSM_BC;  // 多播搜索
    
    hm_result result = hm_util_lan_device_search_init(&param, &lan_wifi_handle);
    printf("result=%x\n",result);
    if ( result == HMEC_OK) {
        hm_util_lan_device_search_query(lan_wifi_handle);
        //        printf("result=%x\n",result);
    }
    else
    {
        //        printf("result=%x\n",result);
    }
    
}

- (void)stopSearchWifiDev
{
    NSLog(@"关闭wifi搜索");
    if (lan_wifi_handle != 0) {
        hm_util_lan_device_search_uninit(lan_wifi_handle);
        lan_wifi_handle = 0;
    }
}


- (void)addSearchWifiDevToArray:(P_LAN_DEVICE_SEARCH_RES) ldsr
{
    printf("/* 打印局域网搜索消息 */\n");
    printf("ip=%s\n",ldsr->ip_addr);
    printf("port=%d\n",ldsr->port);
    printf("sn=%s\n",ldsr->device_sn);
    printf("name=%s\n",ldsr->device_name);
    printf("channel_name=%s\n",ldsr->channel_name);
    printf("channel_count=%d\n",ldsr->channel_count);
    printf("device_type=%s\n",ldsr->device_type);
    printf("Key=%s\n",ldsr->device_key);
    
    NSString* name      = [[NSString alloc] initWithUTF8String:ldsr->device_name];
    NSString* sn        = [[NSString alloc] initWithUTF8String:ldsr->device_sn];
    NSString* ip        = [[NSString alloc] initWithUTF8String:ldsr->ip_addr];
    NSString* port      = [[NSString alloc] initWithFormat:@"%d",ldsr->port];
    NSString* key       = [[NSString alloc] initWithUTF8String:ldsr->device_key];
    
    
    for (NSArray* dev in devSearchArray) {
        NSString* devSN = [dev objectAtIndex:1];
        if ([devSN isEqual:sn]) {
            return;
        }
    }
    
    NSArray* dev = [[NSArray alloc] initWithObjects:name,sn,ip,port,key, nil];
    [devSearchArray addObject:dev];
    
    
    [self performSelectorInBackground:@selector(refreshTableView) withObject:nil];
}

- (void)refreshTableView
{
    [self.tableView reloadData];
}

#pragma mark - Table view data source

#pragma mark - TableView代理函数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [devSearchArray count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ide = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: ide];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier: ide];
    }
    
    cell.textLabel.font = [UIFont boldSystemFontOfSize:20];		//设置cell中字体的大小
    //	cell.textLabel.textColor = [UIColor blackColor];			//设置cell中字体的颜色
    
    NSArray* array = [devSearchArray objectAtIndex:[indexPath row]];
    
    cell.textLabel.text = [array objectAtIndex:0];
    cell.imageView.image = [UIImage imageNamed:@"device.png"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray* array = [devSearchArray objectAtIndex:[indexPath row]];
    
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

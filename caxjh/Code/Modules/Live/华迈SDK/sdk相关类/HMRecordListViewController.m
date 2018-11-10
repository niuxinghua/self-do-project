//
//  HMRecordListViewController.m
//  Demo
//
//  Created by guofeixu on 15/11/6.
//  Copyright © 2015年 guofeixu. All rights reserved.
//

#import "HMRecordListViewController.h"

@interface HMRecordListViewController () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *recordList;
@property (strong, nonatomic) UITableView *recordTableView;

@end

@implementation HMRecordListViewController

@synthesize nodeObject;
@synthesize channelObject;
@synthesize recordList;
@synthesize recordTableView;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"录像列表";
    
    recordTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    recordTableView.delegate = self;
    recordTableView.dataSource = self;
    [self.view addSubview:recordTableView];
    

        


    
    
    recordList = [[NSMutableArray alloc] init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self searchRecordList];
    });
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchRecordList{
    
    CONNECT_INFO coninfo;
    
    coninfo.ct = CT_MOBILE;
    coninfo.cp = CPI_DEF;
    coninfo.cm = CM_DIR|CM_NAT;
    
    user_id userId = NULL;
    
    hm_result loginResult = hm_pu_login_ex(nodeObject.nodeHandle, &coninfo,&userId);
    
    NSLog(@"RemoteLoginResult:%0x",loginResult);
    
    if (loginResult == HMEC_OK)
    {
        FIND_FILE_PARAM param = {};
        param.search_mode = HME_SM_BEG_AND_END_TIME;
        param.record_type = 1|2|4;
        param.channel = 0;
        
        if (nodeObject.nodeType == HME_NT_DVS) {
            
            param.channel = (int32)channelObject.channelIndex;
        }
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        
        NSDate *endDate = [NSDate date];
        NSDate *startDate = [NSDate dateWithTimeIntervalSinceNow:-10*24*60*60];
        NSString *startDateStr = [dateFormatter stringFromDate:startDate];
        NSString *endDateStr = [dateFormatter stringFromDate:endDate];
        
        strcpy(param.start_time, [startDateStr UTF8String]);
        strcpy(param.end_time, [endDateStr UTF8String]);
        
        find_file_handle findfilehandle;
        if (hm_pu_find_file(userId, &param, &findfilehandle) == HMEC_OK)
        {
            
            FIND_FILE_DATA data = {};
            
            while (hm_pu_find_next_file(findfilehandle, &data) != HMEC_GEN_FIND_FILE_OVER) {
                
                HMRecordVideoObject *videoObject = [[HMRecordVideoObject alloc] init];
                videoObject.startTime = [[NSString alloc] initWithUTF8String:data.start_time];
                videoObject.endTime = [[NSString alloc] initWithUTF8String:data.end_time];
                videoObject.fileName = [[NSString alloc] initWithUTF8String:data.file_name] ;
                videoObject.channelId = 0;
                if (nodeObject.nodeType == HME_NT_DVS) {
                    
                    videoObject.channelId = [NSString stringWithFormat:@"%d",(int32)channelObject.channelIndex];
                }
                videoObject.userId = userId;
                
                if ([videoObject.fileName hasPrefix:@"/nvs/"]) {
                    
                    videoObject.deviceRecordType = DeviceRecordTypeFromNVS;
                    
                }
                
                
                [recordList addObject:videoObject];
            }
            
            
            
            //对文件开始时间进行排序
            [recordList sortUsingComparator:^NSComparisonResult(HMRecordVideoObject *obj1, HMRecordVideoObject *obj2) {
                
                if ([obj1.startTime compare:obj2.startTime] == NSOrderedDescending) {
                    
                    return (NSComparisonResult)NSOrderedAscending;
                }else if ([obj1.startTime compare:obj2.startTime] == NSOrderedAscending){
                    
                    return (NSComparisonResult)NSOrderedDescending;
                }
                return (NSComparisonResult)NSOrderedSame;
            }];
            
            hm_pu_close_find_file(findfilehandle);
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.recordTableView reloadData];
    });
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return recordList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ide = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ide];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ide];
    }
    
    HMRecordVideoObject *objc = recordList[indexPath.row];
    
    cell.textLabel.text = objc.fileName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

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

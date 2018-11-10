//
//  HMPicListViewController.m
//  Demo
//
//  Created by guofeixu on 15/11/5.
//  Copyright © 2015年 guofeixu. All rights reserved.
//

#import "HMPicListViewController.h"
#import "HMPicObject.h"

@interface HMPicListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *picTableView;
@property (strong, nonatomic) NSMutableArray *picList;
@property (strong, nonatomic) NSMutableData *imageData;
@property (assign, nonatomic) get_picture_handle picHandle;

- (void)addDataToImageData:(char *)data length:(uint32)len result:(int32)result;
@end

@implementation HMPicListViewController

@synthesize userId;
@synthesize nodeObject;
@synthesize channelObject;
@synthesize picHandle;
@synthesize picTableView;
@synthesize picList;
@synthesize imageData;


static void picDownloadCallback(user_data data, P_DOWNLOAD_PIC_INFO pic_info, cpointer file_data, uint32 data_length, int32 data_result){
    
    HMPicListViewController * picListController = (__bridge HMPicListViewController *)(data);
    
    NSLog(@"data_result:%0x",data_result);
    [picListController addDataToImageData:(char *)file_data length:data_length result:data_result];
    
    
    

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"图片列表";
    
    picTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    picTableView.delegate = self;
    picTableView.dataSource = self;
    [self.view addSubview:picTableView];

    
    imageData = [[NSMutableData alloc] init];
    picHandle = NULL;
    
    [self seachPicFile];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
    });
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)seachPicFile{
    
    
    FIND_PICTURE_PARAM picParam;
    picParam.cap_type = 1|2|4;
    picParam.channel = 0;
    
    if (nodeObject.nodeType == HME_NT_DVS) {
        
        picParam.channel = (uint32)channelObject.channelIndex;
    }
    picParam.search_mode = HME_SM_BEG_AND_END_TIME;
    
    
    NSDateFormatter *monthFormatter = [[NSDateFormatter alloc] init];
    [monthFormatter setDateFormat:@"yyyy-MM"];
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *endDate = [NSDate date];
    NSDate *startDate = [endDate dateByAddingTimeInterval:-2 * 24 *60 * 60];
    NSString *endTimeStr = [dayFormatter stringFromDate:endDate];
    NSString *startTimeStr = [dayFormatter stringFromDate:startDate];
    NSString *monthDateStr = [monthFormatter stringFromDate:endDate];
    
    
    strcpy(picParam.search_month, [monthDateStr UTF8String]);
    strcpy(picParam.start_time, [startTimeStr UTF8String]);
    strcpy(picParam.end_time, [endTimeStr UTF8String]);
    
    find_picture_handle find_pic_handle = NULL;
    
    hm_result find_result = hm_pu_find_picture(userId, &picParam, &find_pic_handle);
    
    NSLog(@"find_result = %0x",find_result);
    
    if (find_result == HMEC_OK) {
        
        NSLog(@"查询图片信息成功");
        picList = [[NSMutableArray alloc] init];
        FIND_PICTURE_DATA data = {};
        
        while (hm_pu_find_next_picture(find_pic_handle, &data) != HMEC_GEN_FIND_FILE_OVER) {
            
            HMPicObject *tempObject = [[HMPicObject alloc] init];
            tempObject.fileName = [NSString stringWithUTF8String:data.file_name];
            tempObject.fileSize = data.file_size;
            tempObject.capType = data.cap_type;
            tempObject.capTime = [NSString stringWithUTF8String:data.cap_time];
            
            NSLog(@"tempFileName:%@",tempObject.fileName);
            
            [picList addObject:tempObject];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.picTableView reloadData];
        });
        
        
    }else{
        
        NSLog(@"查询图片信息失败");
    }
    
   
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return picList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ide = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ide];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ide];
    }
    
    HMPicObject *object = picList[indexPath.row];
    
    cell.textLabel.text = object.fileName;
    cell.detailTextLabel.text = @"下载";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HMPicObject *object = picList[indexPath.row];
    
    imageData = [[NSMutableData alloc] init];
    
    picHandle = NULL;
    GET_PICTURE_RES pic_res = {};
    pic_res.file_count = 10;
    GET_PICTURE_PARAM pic_param = {};
    
    pic_param.channel = 0;
    if (nodeObject.nodeType == HME_NT_DVS) {
        
        pic_param.channel = (uint32)channelObject.channelIndex;
    }
    pic_param.download_mode = HME_PDM_FILENAME;
    pic_param.data = (__bridge user_data)(self);
    pic_param.cb_data = picDownloadCallback;
    strcpy(pic_param.file_name, [object.fileName UTF8String]);
    
    
    hm_result downloadResult = hm_pu_open_get_picture(userId, &pic_param, &pic_res, &picHandle);
    
    NSLog(@"downloadResult:%0x",downloadResult);
    NSLog(@"fileCount:%d",pic_res.file_count);
}

- (void)addDataToImageData:(char *)data length:(uint32)len result:(int32)result{
    
    NSLog(@"添加数据");
    
    if (result != 0) {
        
        UIImage *image = [UIImage imageWithData:imageData];
        
        if (image) {
            
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
        }
        
        hm_result closeResult = hm_pu_close_get_picture(picHandle);
        
        NSLog(@"关闭:%0x",closeResult);
        
        
    }else{
        
        if (data && len) {
            
            [imageData appendBytes:data length:len];
        }
        
    }
    
    
}


- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = @"呵呵";
    if (!error) {
        message = @"成功保存到相册";
        imageData = [[NSMutableData alloc] init];
    }else
    {
        message = [error description];
    }
    NSLog(@"message is %@",message);
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

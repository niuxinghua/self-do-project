//
//  XJHVideoPlayBackViewController.m
//  caxjh
//
//  Created by niuxinghua on 2017/9/25.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import "XJHVideoPlayBackViewController.h"
#import "LiveRoomTableViewCell.h"
#import "HMNodeObject.h"
#import "THDatePickerView.h"
#include <stdio.h>
#include <vector>
#import <IQKeyboardManager.h>
#import "UIView+Toast.h"
#import "UIColor+HexString.h"
#import "UIColor+EAHexColor.h"
@interface XJHVideoPlayBackViewController ()<UITableViewDelegate,UITableViewDataSource,THDatePickerViewDelegate>
@property (nonatomic,strong)UITableView *deviceTable;
@property (nonatomic,strong)UITableView *videoTable;
@property (nonatomic,strong)THDatePickerView *datePicker;
@property (nonatomic,strong)HMNodeObject *currentNode;
@end

@implementation XJHVideoPlayBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _deviceTable = [[UITableView alloc]init];
    _deviceTable.frame = CGRectMake(0, 280, 200, self.view.frame.size.height - 280 - 44 - 64);
    _deviceTable.tableFooterView = [UIView new];
    _deviceTable.dataSource = self;
    _deviceTable.delegate = self;
    [_deviceTable registerClass:[LiveRoomTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_deviceTable];
    
    
    
    _videoTable = [[UITableView alloc]init];
    _videoTable.frame = CGRectMake(200, 280, self.view.frame.size.width - 200, self.view.frame.size.height - 280 - 44 - 64);
    _videoTable.tableFooterView = [UIView new];
    _videoTable.dataSource = self;
    _videoTable.delegate = self;
    [_videoTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"videocell"];
    [self.view addSubview:_videoTable];
    
    _datePicker = [[THDatePickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 300)];
    _datePicker.delegate = self;
    _datePicker.title = @"请选择时间";
    [self.view addSubview:_datePicker];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldLogout) name:@"NOTIFICATION_SHOULD_LOGOUT" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshdevice:) name:@"devicechange" object:nil];
    
}

- (void)refreshdevice:(NSNotification *)notification
{
    
    self.deviceList = notification.object;
    
}
- (void)shouldLogout
{
    self.deviceList = @[].mutableCopy;
    self.videoList = @[].mutableCopy;
    [self.videoTable reloadData];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
//    [IQKeyboardManager sharedManager].enable = YES;
}

#pragma mark setter
- (void)setVideoList:(NSMutableArray *)videoList
{
    _videoList = videoList;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([videoList count] == 0) {
       // [self.view makeToast:@"无播放文件" duration:1.0 position:CSToastPositionCenter];
        }
        [_videoTable reloadData];
    });
    
}
- (void)setDeviceList:(NSMutableArray *)deviceList
{
    _deviceList = deviceList;
    [_deviceTable reloadData];
    if (_deviceList.count == 0) {
       // [self.view makeToast:@"不支持回放" duration:1.0 position:CSToastPositionCenter];
        self.videoList = @[].mutableCopy;
    }
}
#pragma mark-datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_videoTable == tableView) {
        if (!_videoList) {
            return 0;
        }
        return [_videoList count];
    }
    
    if (!_deviceList) {
        return 0;
    }
    return [_deviceList count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_videoTable == tableView) {
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        if (_videoList) {
            NSDictionary *dic = [_videoList objectAtIndex:[indexPath row]];
            NSString *start = [[[dic objectForKey:@"start"] componentsSeparatedByString:@" "] lastObject];
            
            NSString *last = [[[dic objectForKey:@"end"] componentsSeparatedByString:@" "] lastObject];
            NSString *name1 = [NSString stringWithFormat:@"%@-%@",start,last];
            cell.textLabel.text = name1;
            cell.textLabel.font = [UIFont systemFontOfSize:8];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    
    
    
    
    LiveRoomTableViewCell *cell1 = [[LiveRoomTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    HMNodeObject *node = [_deviceList objectAtIndex:[indexPath row]];
    [cell1 setName:node.showName];
    return cell1;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _videoTable) {
        NSDictionary *dic = [_videoList objectAtIndex:[indexPath row]];
        if (self.playfileBlock) {
            self.playfileBlock(_currentNode,[dic objectForKey:@"name"]);
            UITableViewCell *selectedcell = [tableView cellForRowAtIndexPath:indexPath];
            for (LiveRoomTableViewCell *cell in [tableView visibleCells]) {
                cell.textLabel.textColor = [UIColor colorWithHex:@"#6b6b6b"];
            }
            selectedcell.textLabel.textColor = [UIColor colorWithHex:@"#ff6767"];

        }
        return;
    }
    HMNodeObject *node = [_deviceList objectAtIndex:[indexPath row]];
    _currentNode = node;
    LiveRoomTableViewCell *selectedcell = [tableView cellForRowAtIndexPath:indexPath];
    for (LiveRoomTableViewCell *cell in [tableView visibleCells]) {
        [cell setSelected:NO];
    }
    [selectedcell setSelected:YES];
    [self showDatepicker];
    
}

#pragma mark -datepicker
-(void)showDatepicker
{
    [UIView animateWithDuration:0.3 animations:^{
        self.datePicker.frame = CGRectMake(0, self.view.frame.size.height - 300 - 44, self.view.frame.size.width, 300);
        [self.datePicker show];
    }];
}
#pragma mark - THDatePickerViewDelegate
/**
 保存按钮代理方法
 
 @param timer 选择的数据
 */
- (void)datePickerViewSaveBtnClickDelegate:(NSString *)timer {
    NSLog(@"保存点击");
    
    if (self.playbackBlock) {
        self.playbackBlock(_currentNode, timer);
        [UIView animateWithDuration:0.3 animations:^{
            self.datePicker.frame = CGRectMake(0, self.view.frame.size.height , self.view.frame.size.width, 300);
        }];
    }
}

/**
 取消按钮代理方法
 */
- (void)datePickerViewCancelBtnClickDelegate {
    NSLog(@"取消点击");
    [UIView animateWithDuration:0.3 animations:^{
        self.datePicker.frame = CGRectMake(0, self.view.frame.size.height , self.view.frame.size.width, 300);
    }];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end

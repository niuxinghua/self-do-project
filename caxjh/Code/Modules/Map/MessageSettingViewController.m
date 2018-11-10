//
//  MessageSettingViewController.m
//  caxjh
//
//  Created by niuxinghua on 2017/12/31.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import "MessageSettingViewController.h"
#import "UIBarButtonItem+UC.h"
#import "MapSettingTableViewCell.h"
#import "PPNetworkHelper.h"
#import "MBProgressHUD.h"
#import "Const.h"
#import "SocketManager.h"
#import "UIView+Toast.h"
@interface MessageSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *table;

@property (nonatomic,strong)NSDictionary *datadic;

@property (nonatomic,assign)BOOL isdropon;

@property (nonatomic,assign)BOOL issoson;

@end

@implementation MessageSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"短信提醒";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem uc_backBarButtonItemWithAction:^{
        [[NSNotificationCenter defaultCenter]removeObserver:self];
        [self.navigationController popViewControllerAnimated:NO];
    }];
    _table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.view.backgroundColor = [UIColor whiteColor];
    _table.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    _table.tableHeaderView = [self headView];
    _table.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_table];
    _table.tableFooterView = [UIView new];
    _table.dataSource = self;
    _table.delegate = self;
    [_table registerClass:[MapSettingTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_table];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dogetSMS:) name:@"SOSSMS" object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dogetDrop:) name:@"DROP" object:nil];
    [self getData];
   
}
- (UIView *)headView
{
    UIView *backgroundView = [[UIView alloc]init];
    
    UIImageView *bgView = [[UIImageView alloc]init];
    
    [backgroundView addSubview:bgView];
    
    bgView.userInteractionEnabled = YES;
    bgView.frame = CGRectMake(0, 0, self.view.frame.size.width, 220);
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(120, (220-75)/2.0, 75, 75)];
    imageView.image = [UIImage imageNamed:@"messageicon.png"];
    imageView.center = CGPointMake(bgView.center.x, bgView.center.y);
    [bgView addSubview:imageView];
    
    UILabel *topLable = [[UILabel alloc]initWithFrame:CGRectMake(0, (220-75)/2.0 + 75, self.view.frame.size.width, 40)];
    
   
    [bgView addSubview:topLable];
    
    [topLable setText:@"短信提醒"];
    topLable.textAlignment = NSTextAlignmentCenter;
    topLable.textColor = [UIColor colorWithRed:0 green:164/255.0 blue:263/255.0 alpha:1.0];
    return bgView;
    
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MapSettingTableViewCell *cell = [[MapSettingTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    
    if ([indexPath row] == 0) {
        [cell setHeadImage:nil topLableStr:@"SOS短信提醒" bottomLableStr:@"紧急情况时进行短信提醒"];
        if(![[_datadic objectForKey:@"isSosSMS"]isEqual:[NSNull null]])
        {
        [cell setSwithOn:[[_datadic objectForKey:@"isSosSMS"] boolValue]];
        }
        cell.changeBlock = ^(BOOL isOn) {
           // if (isOn) {
                [self dosetSOS:isOn];
            _issoson = isOn;
           // }
        };
        
    }
    
    if ([indexPath row] == 1) {
        
        [cell setHeadImage:nil topLableStr:@"手表脱落提醒" bottomLableStr:@"手表从手腕脱落时进行短信提醒"];
        if(![[_datadic objectForKey:@"isDropSMS"]isEqual:[NSNull null]])
        {
         [cell setSwithOn:[[_datadic objectForKey:@"isDropSMS"] boolValue]];
        }
        
        cell.changeBlock = ^(BOOL isOn) {
          //  if (isOn) {
                [self dosetDROP:isOn];
            
            _isdropon = isOn;
           // }
        };
    }
    
    [cell setLayoutForMessage];
    return cell;
}


#pragma mark-datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
#pragma mark methods
- (void)dosetSOS:(BOOL)isOn
{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [[SocketManager sharedInstance]setSOSSMS:isOn];
    
    
}
- (void)dosetDROP:(BOOL)isOn
{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [[SocketManager sharedInstance]setDROP:isOn];
    
}
- (void)getData
{
    NSDictionary *locationDic = [SocketManager sharedInstance].locationDic;
    NSString *watchId = [locationDic objectForKey:@"id"];
    
    NSDictionary *dic = @{
                          @"table": @"Watch",
                          @"filter": @{
                                  @"id":@{@"eq":watchId}
                                  },
                          @"columns": @[
                                  @"upLocationInterval",@"centerNumber",@"sos1Number",@"sos2Number",@"sos3Number",@"isActive",@"isDropSMS",@"isFenceSMS",@"isSosSMS"
                                  ]
                          };
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [PPNetworkHelper POST:kAPIQueryWatch parameters:dic success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        if ([responseObject objectForKey:@"data"]) {
            NSDictionary *dic = [responseObject objectForKey:@"data"][0];
            _datadic = [dic copy];
            [_table reloadData];
            
        }
        [_table reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    }];
    
    
    
}
//dogetDrop

- (void)dogetDrop:(NSNotification *)obj
{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    if ([obj.object containsString:@"OK"]) {
        //[self.view makeToast:@"设置成功"];
        [self setDrop:_isdropon];
    }else{
        [self.view makeToast:@"设置失败"];
        
    }
    
}


- (void)dogetSMS:(NSNotification *)obj
{
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    if ([obj.object containsString:@"OK"]) {
        //[self.view makeToast:@"设置成功"];
        
        [self setSOS:_issoson];
    }else{
        [self.view makeToast:@"手表不在线"];
        
    }
    
}


//header：https://children.xiangjianhai.com:999/app/update?token=7205589feec837eba4ae654e200daa4
//请求参数：
//{ "table": "Watch",
//    "fields":{"isDropSMS":"no","isSosSMS":"yes","isFenceSMS":"yes"},
//    "id":"ff8080815fe29647015fe29b14680000"
//}
//
//备注：sos报警提醒，脱落报警提醒，进出围栏报警

- (void)setDrop:(BOOL)ison
{
    NSString *on = ison ? @"yes":@"no";
    NSDictionary *locationDic = [SocketManager sharedInstance].locationDic;
    NSString *watchId = [locationDic objectForKey:@"id"];
    
    NSDictionary *dic = @{
                          @"table": @"Watch",
                          @"fields": @{
                                  @"isDropSMS":on
                                  
                                  },
                          @"id":watchId
                                  };
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [PPNetworkHelper POST:kAPIEditFence parameters:dic success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        if ([responseObject objectForKey:@"data"]) {
            [self.view makeToast:@"设置成功"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Mapsetting" object:nil];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
         [self.view makeToast:@"设置失败"];
    }];
    
    
    
}
- (void)setSOS:(BOOL)ison
{
    NSString *on = ison ? @"yes":@"no";
    NSDictionary *locationDic = [SocketManager sharedInstance].locationDic;
    NSString *watchId = [locationDic objectForKey:@"id"];
    
    NSDictionary *dic = @{
                          @"table": @"Watch",
                          @"fields": @{
                                  @"isSosSMS":on
                                  
                                  },
                          @"id":watchId
                          };
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [PPNetworkHelper POST:kAPIEditFence parameters:dic success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        if ([[responseObject objectForKey:@"code"] integerValue]==0) {
            [self.view makeToast:@"设置成功"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Mapsetting" object:nil];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            [self.view makeToast:@"设置失败"];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [self.view makeToast:@"设置失败"];
    }];
    
    
    
}

@end

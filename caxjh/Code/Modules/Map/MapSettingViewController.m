//
//  MapSettingViewController.m
//  caxjh
//
//  Created by niuxinghua on 2017/11/29.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import "MapSettingViewController.h"
#import "UIBarButtonItem+UC.h"
#import "UIViewController+StatusBar.h"
#import "MapSettingTableViewCell.h"
#import "SettingCenterViewController.h"
#import "SOSSettingViewController.h"
#import "AlarmListViewController.h"
#import "CustomIOSAlertView.h"
#import "AlartContentView.h"
#import "PPNetworkHelper.h"
#import "SocketManager.h"
#import "UIView+Toast.h"
#import "WatchBindViewController.h"
#import "MessageSettingViewController.h"
#import "UIImageView+WebCache.h"
@interface MapSettingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *table;

@property (nonatomic,assign)CGFloat timeinterval;

@property (nonatomic,strong)NSMutableDictionary * datadic;

@property (nonatomic,strong)UILabel *topLable;

@property (nonatomic,strong)UIImageView *headimageView;
@end

@implementation MapSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _datadic = [[NSMutableDictionary alloc]init];
    // Do any additional setup after loading the view.
    self.title = @"设备信息";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem uc_backBarButtonItemWithAction:^{
        [[NSNotificationCenter defaultCenter]removeObserver:self];
        [self.navigationController popViewControllerAnimated:NO];
    }];
    
    [self setStatusBarDefaultColor];
    _table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.view.backgroundColor = [UIColor whiteColor];
    _table.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64);
    
    _table.tableHeaderView = [self headView];
    _table.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_table];
    _table.tableFooterView = [UIView new];
    _table.dataSource = self;
    _table.delegate = self;
    [_table registerClass:[MapSettingTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_table];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSetTimeInterval:) name:@"TimeIntervalSetting" object:nil];
    [self getData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getData) name:@"Mapsetting" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(watchnamechange) name:@"watchname" object:nil];
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(watchimagechange:) name:@"watchImage" object:nil];
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
#pragma mark-datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (UIView *)headView
{
    UIView *backgroundView = [[UIView alloc]init];
    
    UIImageView *bgView = [[UIImageView alloc]init];
    
    [backgroundView addSubview:bgView];
    
    bgView.userInteractionEnabled = YES;
    bgView.frame = CGRectMake(0, 0, self.view.frame.size.width, 220);
    _headimageView = [[UIImageView alloc]initWithFrame:CGRectMake(120, (220-75)/2.0, 75, 75)];
   // imageView.image = [UIImage imageNamed:@"mapsettinghead.png"];
    [_headimageView sd_setImageWithURL:[NSURL URLWithString:[_datadic objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"mapsettinghead.png"]];
    _headimageView.layer.masksToBounds = YES;
    _headimageView.layer.cornerRadius = 75/2.0;
    _headimageView.center = CGPointMake(bgView.center.x, bgView.center.y);
    [bgView addSubview:_headimageView];
    
    _topLable = [[UILabel alloc]initWithFrame:CGRectMake(165, 30, 120, 40)];
    
    NSDictionary *dic = [SocketManager sharedInstance].locationDic;
    
    _topLable.text = [dic objectForKey:@"name"];
    
    _topLable.center = CGPointMake(bgView.center.x, bgView.center.y + 60);
    
    _topLable.textAlignment = NSTextAlignmentCenter;
    
    _topLable.textColor = [UIColor colorWithHex:@"#ffffff"];
    
    // topLable.textColor = [UIColor colorWithRed:0 green:159/255.0 blue:229/255.0 alpha:1.0];
    [bgView addSubview:_topLable];
    
    UIImageView *icon = [[UIImageView alloc]init];
    [icon setImage:[UIImage imageNamed:@"rightarrow"]];
    icon.frame = CGRectMake(bgView.center.x +60, bgView.center.y + 55, 10, 10);
    
    [bgView addSubview:icon];
    
    [bgView setImage:[UIImage imageNamed:@"devicebg"]];
    bgView.backgroundColor =  [UIColor colorWithRed:251/255.0 green:111/255.0 blue:113/255.0 alpha:1.0];
    
    UITapGestureRecognizer *single = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    _topLable.userInteractionEnabled = YES;
    [_topLable addGestureRecognizer:single];
    
    [icon addGestureRecognizer:single];
    [bgView addGestureRecognizer:single];
    return bgView;
    
    
    
    
}

- (void)tap{
    
    WatchBindViewController *bind = [[WatchBindViewController alloc]init];
    bind.hidesBottomBarWhenPushed = YES;
    bind.isedit = YES;
    bind.dic = _datadic;
    [self.navigationController pushViewController:bind animated:NO];
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImageView *bgView = [[UIImageView alloc]init];
    bgView.frame = CGRectMake(0, 0, self.view.frame.size.width, 220);
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(120, (220-75)/2.0, 75, 75)];
   // imageView.image = [UIImage imageNamed:@"mapsettinghead.png"];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[_datadic objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"mapsettinghead.png"]];
    imageView.center = CGPointMake(bgView.center.x, bgView.center.y);
    [bgView addSubview:imageView];
    
    _topLable = [[UILabel alloc]initWithFrame:CGRectMake(165, 30, 80, 40)];
    
   NSDictionary *dic = [SocketManager sharedInstance].locationDic;
    
    _topLable.text = [dic objectForKey:@"name"];
    
    _topLable.center = CGPointMake(bgView.center.x, bgView.center.y + 60);
    
    _topLable.textAlignment = NSTextAlignmentCenter;
    
    _topLable.textColor = [UIColor colorWithHex:@"#ffffff"];
    
   // topLable.textColor = [UIColor colorWithRed:0 green:159/255.0 blue:229/255.0 alpha:1.0];
    [bgView addSubview:_topLable];
    
    UIImageView *icon = [[UIImageView alloc]init];
    [icon setImage:[UIImage imageNamed:@"rightarrow"]];
    icon.frame = CGRectMake(bgView.center.x + 40, bgView.center.y + 55, 10, 10);
    
    [bgView addSubview:icon];
    
    [bgView setImage:[UIImage imageNamed:@"devicebg"]];
    bgView.backgroundColor =  [UIColor colorWithRed:251/255.0 green:111/255.0 blue:113/255.0 alpha:1.0];
    
    return bgView;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MapSettingTableViewCell *cell = [[MapSettingTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
   
    if ([indexPath row] == 0) {
          [cell setHeadImage:[UIImage imageNamed:@"alarmmessage"] topLableStr:@"报警列表" bottomLableStr:@""];
        [cell setRelayout];
    }
    
    if ([indexPath row] == 1) {
        
        [cell setHeadImage:[UIImage imageNamed:@"phoneicon"] topLableStr:@"中心号码" bottomLableStr:@"通过该号码可发送短信指令以及各种报警短信"];
        if(![[_datadic objectForKey:@"centerNumber"] isEqual:[NSNull null]] && ![[_datadic objectForKey:@"centerNumber"] isEqualToString:@""]) {
            [cell setSettingText:@"已设置" defaultColor:YES];
        }else{
          [cell setSettingText:@"未设置" defaultColor:NO];
        }
    }else if ([indexPath row] == 2){
        
        [cell setHeadImage:[UIImage imageNamed:@"sosicon"] topLableStr:@"SOS号码" bottomLableStr:@"触发SOS警情时，终端向设置的几个号码打电话，同时发送短信"];
        if(((![[_datadic objectForKey:@"sos1Number"] isEqual:[NSNull null]]) && [_datadic objectForKey:@"sos1Number"] && ![[_datadic objectForKey:@"sos1Number"]isEqualToString:@""]) || ((![[_datadic objectForKey:@"sos2Number"] isEqual:[NSNull null]])&&[_datadic objectForKey:@"sos2Number"]&& ![[_datadic objectForKey:@"sos2Number"]isEqualToString:@""]) || ((![[_datadic objectForKey:@"sos3Number"] isEqual:[NSNull null]])&&[_datadic objectForKey:@"sos3Number"]&& ![[_datadic objectForKey:@"sos3Number"]isEqualToString:@""])) {
            [cell setSettingText:@"已设置" defaultColor:YES];
        }else{
            [cell setSettingText:@"未设置" defaultColor:NO];
        }
    }
    else if ([indexPath row] == 3){

        [cell setHeadImage:[UIImage imageNamed:@"messageicon"] topLableStr:@"短信提醒" bottomLableStr:@"包括SOS短信提醒，手表脱落提醒，围栏提醒"];
        if((![[_datadic objectForKey:@"isDropSMS"] isEqual:[NSNull null]] && [[_datadic objectForKey:@"isDropSMS"] isEqualToString:@"yes"] ) || (![[_datadic objectForKey:@"isSosSMS"] isEqual:[NSNull null]]&&[_datadic objectForKey:@"isSosSMS"] && [[_datadic objectForKey:@"isSosSMS"] isEqualToString:@"yes"])) {
            [cell setSettingText:@"已开启" defaultColor:YES];
        }else
        {
           [cell setSettingText:@"未开启" defaultColor:NO];
            
        }

    }
    else if ([indexPath row] == 4){
        
        [cell setHeadImage:[UIImage imageNamed:@"timeicon"] topLableStr:@"上报间隔" bottomLableStr:@"设置手表上报时间的间隔"];
        if([_datadic objectForKey:@"upLocationInterval"]) {
            if([[_datadic objectForKey:@"upLocationInterval"] intValue]==30){
               [cell setSettingText:[NSString stringWithFormat:@"%d秒/次",[[_datadic objectForKey:@"upLocationInterval"] intValue]] defaultColor:NO];
            }
            if([[_datadic objectForKey:@"upLocationInterval"] intValue]==60){
                [cell setSettingText:[NSString stringWithFormat:@"一分钟/次"]defaultColor:NO];
            }
            if([[_datadic objectForKey:@"upLocationInterval"] intValue]==300){
                [cell setSettingText:[NSString stringWithFormat:@"五分钟/次"]defaultColor:NO];
            }
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic1 = [SocketManager sharedInstance].locationDic;
    NSString *watchid = [dic1 objectForKey:@"id"];
    if (!watchid) {
        
        [self.view makeToast:@"未绑定手表,不能操作!"];
        
        return;
    }
    if ([indexPath row] == 0) {
        
        AlarmListViewController *alarm = [[AlarmListViewController alloc]init];
        [self.navigationController pushViewController:alarm animated:NO];
    }
    
    if ([indexPath row] == 1) {
        SettingCenterViewController *center = [[SettingCenterViewController alloc]init];
        [self.navigationController pushViewController:center animated:NO];
        
    }else if ([indexPath row] == 2){
        SOSSettingViewController *sos = [[SOSSettingViewController alloc]init];
        [self.navigationController pushViewController:sos animated:NO];
        
    }else if([indexPath row] == 3)
    {
        
        MessageSettingViewController *message = [[MessageSettingViewController alloc]init];
        [self.navigationController pushViewController:message animated:NO];
        
        
    }
    
    else if ([indexPath row] == 4)
    {
        CustomIOSAlertView *alert = [[CustomIOSAlertView alloc]init];
       AlartContentView  *contentView = [[AlartContentView alloc]initWithFrame:CGRectMake(0, 0, 300, 150)];
        contentView.timeinterval = _timeinterval;
        [alert setContainerView: contentView];
        
        __weak MapSettingViewController *weakSelf = self;
        alert.block = ^(NSString *time) {
            //[weakSelf doPostTime:time];
            _timeinterval = [time floatValue];
            [[SocketManager sharedInstance] setTimeInterval:time];
        };
        [alert show];
    }
    
    
}
- (void)didSetTimeInterval:(NSNotification *)notification
{
    
    if ([notification.object containsString:@"OK"]) {
        [self doPostTime:[NSString stringWithFormat:@"%f",_timeinterval]];
    }else{
        
        [self.view makeToast:@"设置失败"];
    }
    
}
#pragma mark -methods
- (void)doPostTime:(NSString *)time
{
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    NSString *watchid = [[SocketManager sharedInstance].locationDic objectForKey:@"id"];
    NSDictionary *dic = @{@"table": @"Watch",
        @"fields":@{@"upLocationInterval":@([time floatValue])},
        @"id":watchid
                          };
    NSLog(@"%@",kAPISetUploadTimeInterval);
    [PPNetworkHelper POST:kAPISetUploadTimeInterval parameters:dic success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        if ([responseObject objectForKey:@"code"]) {
            
            [self.view makeToast:@"成功"];
            _timeinterval = [time floatValue];
            [_datadic setObject:@(_timeinterval) forKey:@"upLocationInterval"];
            [self.table reloadData];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [self.view makeToast:@"失败"];
    }];
    
}

//imei：手表唯一标识，App和Server通讯，用到的yyyyyyyyyy就是这个10位的imei
//centerNumber：中心号码
//sos1Number，sos2Number，sos3Number：手表的三个sos号码
//isActive：手表是不是已经设置过语言时区，位置上报间隔等初始化信息。yes  no
//isDropSMS：脱落报警短信 开关，yes 或 no，打开或者关闭
//isFenceSMS：进出围栏报警短信，开关
//isSosSMS：sos报警短信开关
//upLocationInterval
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
                                  @"image",@"upLocationInterval",@"centerNumber",@"sos1Number",@"sos2Number",@"sos3Number",@"isActive",@"isDropSMS",@"isFenceSMS",@"isSosSMS"
                                  ]
                          };
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [PPNetworkHelper POST:kAPIQueryWatch parameters:dic success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        if ([responseObject objectForKey:@"data"]) {
            NSDictionary *dic = [responseObject objectForKey:@"data"][0];
             _datadic = [dic mutableCopy];
            if ([dic objectForKey:@"upLocationInterval"]) {
                _timeinterval = [[dic objectForKey:@"upLocationInterval"] longValue];
            }
             [_headimageView sd_setImageWithURL:[NSURL URLWithString:[_datadic objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"mapsettinghead.png"]];
            
        }
        [_table reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    }];
    
    
    
}
- (void)watchnamechange
{
    
    NSDictionary *dic = [SocketManager sharedInstance].locationDic;
    
    _topLable.text = [dic objectForKey:@"name"];
    
}
- (void)watchimagechange:(NSNotification *)notification
{
   [_headimageView sd_setImageWithURL:[NSURL URLWithString:notification.object] placeholderImage:[UIImage imageNamed:@"mapsettinghead.png"]];
    
    
}
@end

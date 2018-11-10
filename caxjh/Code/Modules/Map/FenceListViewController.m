//
//  FenceListViewController.m
//  caxjh
//
//  Created by niuxinghua on 2017/12/2.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import "FenceListViewController.h"
#import "FenceListTableViewCell.h"
#import "PPNetworkHelper.h"
#import "UIBarButtonItem+UC.h"
#import "SocketManager.h"
#import "AddFenceViewController.h"
@interface FenceListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *datalist;

@end

@implementation FenceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    _datalist =  [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc]init];
    _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64);
    _tableView.tableFooterView = [self footerView];
  
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[FenceListTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem uc_backBarButtonItemWithAction:^{
        [self.navigationController popViewControllerAnimated:NO];
    }];
    self.title = @"电子围栏";
    [self getData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getData) name:@"didaddsuccess" object:nil];
}

- (void)getData
{
//    {
//        "table": "Fence",
//        "filter": {
//            "watch.id":{"eq":"ff8080815fe29647015fe29b14680000"}
//        },
//        "columns": [
//                    "id","name","latDireaction","latitude","lonDirection","longitude","radius","alarmType","state"
//                    ]
//    }
    NSDictionary *dic1 = [SocketManager sharedInstance].locationDic;
    NSString *imei = [dic1 objectForKey:@"imei"];
    NSString *watchid = [dic1 objectForKey:@"id"];
    if (!imei) {
        return;
    }
    NSDictionary *dic = @{@"table":@"Fence",@"columns":@[@"id",@"name",@"latDireaction",@"latitude",@"lonDirection",@"location",@"longitude",@"alarmType",@"radius",@"state",@"location"],@"filter":@{@"watch.id":@{@"eq":watchid}}};
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [PPNetworkHelper POST:kAPIQueryFence parameters:dic success:^(id responseObject) {
        if (responseObject && ![responseObject isEqual:[NSNull null]]) {
            
            _datalist = [responseObject objectForKey:@"data"];
            
            [_tableView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:NO];
        }
    } failure:^(NSError *error) {
       [MBProgressHUD hideHUDForView:self.view animated:NO];
    }];
    
    
}

- (void)gotoAdd
{
        AddFenceViewController *fence = [[AddFenceViewController alloc]init];
        fence.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:fence animated:NO];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}




- (UIView *)footerView
{
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    addButton.center = CGPointMake(bgView.center.x, bgView.center.y);
    
    [addButton setTitle:@"添加新围栏" forState:UIControlStateNormal];
    
    [addButton setTitleColor:[UIColor colorWithHex:@"#ff6767"] forState:UIControlStateNormal];
    
    [addButton addTarget:self action:@selector(gotoAdd) forControlEvents:UIControlEventTouchUpInside];
    
    [bgView addSubview:addButton];
    
    return bgView;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return nil;
}
#pragma mark-datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_datalist count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FenceListTableViewCell *cell = [[FenceListTableViewCell alloc]init];
    
    cell.dic = [_datalist objectAtIndex:[indexPath row]];
    
    cell.block = ^(BOOL isOn) {
        [self doSelect:isOn indexPath:indexPath];
    };
    return cell;
    
}
- (void)doSelect:(BOOL)isOn indexPath:(NSIndexPath*)indexpath
{
//    围栏的开启关闭
//https://children.xiangjianhai.com:998/app/update?token=7205589feec837eba4ae654e200daa40
//    { "table": "Fence",
//        "fields":{
//            "state":"yes"
//        },
//        "id":"bbb1af9e5fe6f1f6015fe720faf70009"
//    }
//    返回：
//    {
//        "type": "success",
//        "code": "0",
//        "text": "ok",
//        "error": null,
//        "data": null
//    }
    
   NSDictionary *dic = [_datalist objectAtIndex:[indexpath row]];
    NSString *on = @"yes";
    if (!isOn) {
        on = @"no";
    }
    NSDictionary *dic1 = @{@"table":@"Fence",@"fields":@{@"state":on},@"id":[dic objectForKey:@"id"]};
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [PPNetworkHelper POST:kAPIEditFence parameters:dic1 success:^(id responseObject) {
        if (responseObject && ![responseObject isEqual:[NSNull null]]) {
            
           
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            
            [self.view makeToast:@"设置成功"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [self.view makeToast:@"失败"];
    }];
    
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddFenceViewController *add = [[AddFenceViewController alloc]init];
    add.dic = [_datalist objectAtIndex:[indexPath row]];
    [self.navigationController pushViewController:add animated:NO];
    
    
}
- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
@end

//
//  XJHOrderListViewController.m
//  caxjh
//
//  Created by Yingchao Zou on 30/08/2017.
//  Copyright © 2017 Yingchao Zou. All rights reserved.
//

#import "XJHOrderListViewController.h"
#import "MyOrderTableViewCell.h"
#import "UIViewController+StatusBar.h"
#import "XJHAllOrderViewController.h"
#import "Const.h"
#import "UIViewController+PlaceHolderImageView.h"
@interface XJHOrderListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *datalist;
@property (nonatomic,strong)UIButton *lookAllButton;

@end

@implementation XJHOrderListViewController

- (void)viewDidLoad {
    self.title = @"我的套餐";
    [self setStatusBarDefaultColor];
    _tableView = [[UITableView alloc]init];
    _datalist = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-120);
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [UIView new];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[MyOrderTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem uc_backBarButtonItemWithAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    _lookAllButton = [[UIButton alloc]init];
    [_lookAllButton setTitle:@"查看所有套餐" forState:UIControlStateNormal];
    [_lookAllButton setTitleColor:[UIColor colorWithHex:@"#ff6767"] forState:UIControlStateNormal];
    _lookAllButton.titleLabel.font = [UIFont systemFontOfSize:15];
    _lookAllButton.frame = CGRectMake(self.view.frame.size.width/2.0-70, self.view.frame.size.height - 120, 140, 50);
   [self.view addSubview:_lookAllButton];
    [_lookAllButton addTarget:self action:@selector(gotoAllorder) forControlEvents:UIControlEventTouchUpInside];
    [self getData];
}
-(void)getData{
    
    NSDictionary *dic = @{@"columns":@[@"id",@"name",@"liveDeadTime",@"videoDeadTime",@"securityCardDeadTime",@"member",@"student",@"supportLive",@"supportPlayback",@"supportSecurityCard"],@"order":@{},@"filter":@{@"member.id":@{@"eq":[[NSUserDefaults standardUserDefaults]stringForKey:@"USER_ID"]}},@"table":@"AllPackageEAuthority"};
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
    [PPNetworkHelper POST:kAPIQueryUrl parameters:dic success:^(id responseObject) {
        if ([responseObject objectForKey:@"data"]) {
            NSArray *array = [responseObject objectForKey:@"data"];
            if ([array count]) {
                for (NSDictionary *dic in array) {
                  [self filter:dic];
                }
                [self.tableView reloadData];
            }
            if (_datalist.count==0) {
                [self shownormalEmptyImageView];
            }else{
                [self hidePlaceHolderImageView];
            }
            
        }
            } failure:^(NSError *error) {
       
    }];
    
}
-(void)filter:(NSDictionary *)data{

    if (![[data objectForKey:@"supportPlayback"] isKindOfClass:[NSNull class]] && [[data objectForKey:@"supportPlayback"] boolValue]) {
        NSString *stuName = @"";
        if (![[data objectForKey:@"student"] isKindOfClass:[NSNull class]] && ![[[data objectForKey:@"student"] objectForKey:@"name"] isKindOfClass:[NSNull class]]) {
            stuName = [[data objectForKey:@"student"] objectForKey:@"name"];
        }
        NSDictionary *dic = @{@"videoDeadTime":[self cStringFromTimestamp:[[data objectForKey:@"videoDeadTime"] longValue]/1000.0],@"name":[data objectForKey:@"name"],@"stuName":stuName};
        [_datalist addObject:dic];
    }
    if (![[data objectForKey:@"supportLive"] isKindOfClass:[NSNull class]] &&[[data objectForKey:@"supportLive"]boolValue]) {
        NSString *stuName = @"";
        if (![[data objectForKey:@"student"] isKindOfClass:[NSNull class]] && ![[[data objectForKey:@"student"] objectForKey:@"name"] isKindOfClass:[NSNull class]]) {
            stuName = [[data objectForKey:@"student"] objectForKey:@"name"];
        }
        NSDictionary *dic = @{@"liveDeadTime":[self cStringFromTimestamp:[[data objectForKey:@"liveDeadTime"] longValue]/1000.0],@"name":[data objectForKey:@"name"],@"stuName":stuName};
        [_datalist addObject:dic];
    }
    if (![[data objectForKey:@"supportSecurityCard"] isKindOfClass:[NSNull class]] &&[[data objectForKey:@"supportSecurityCard"] boolValue]) {
        NSString *stuName = @"";
        if (![[data objectForKey:@"student"] isKindOfClass:[NSNull class]] && ![[[data objectForKey:@"student"] objectForKey:@"name"] isKindOfClass:[NSNull class]]) {
            stuName = [[data objectForKey:@"student"] objectForKey:@"name"];
        }
        NSDictionary *dic = @{@"securityCardDeadTime":[self cStringFromTimestamp:[[data objectForKey:@"securityCardDeadTime"] longValue]/1000.0],@"name":[data objectForKey:@"name"],@"stuName":stuName};
        [_datalist addObject:dic];
    }
}
-(NSString *)cStringFromTimestamp:(long)timestamp{
    //时间戳转时间的方法
    NSDate *timeData = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd"];
    NSString *strTime = [dateFormatter stringFromDate:timeData];
    return strTime;
}
//-(NSString*)getCurrentTimestamp{
//    
//    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
//    
//    NSTimeInterval a=[dat timeIntervalSince1970];
//    
// //   NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
//    
//    return timeString;
//    
//}


-(void)gotoAllorder
{
    XJHAllOrderViewController *all = [[XJHAllOrderViewController alloc]init];
    all.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:all animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 205;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    view.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, self.view.frame.size.width, 20)];
    [view addSubview:label];
    NSDictionary *dic = [_datalist objectAtIndex:section];
    label.text = [NSString stringWithFormat:@"      %@",[dic objectForKey:@"stuName"]];
    label.textColor = [UIColor grayColor];
    label.backgroundColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:14];
    return view;
}
#pragma mark-datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_datalist count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyOrderTableViewCell *cell = [[MyOrderTableViewCell alloc]init];
    cell.dic = [_datalist objectAtIndex:[indexPath section]];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}






@end

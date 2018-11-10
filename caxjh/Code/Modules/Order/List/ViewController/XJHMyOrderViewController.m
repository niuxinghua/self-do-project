//
//  XJHMyOrderViewController.m
//  caxjh
//
//  Created by niuxinghua on 2017/9/7.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import "XJHMyOrderViewController.h"
#import "Const.h"
#import "UIViewController+StatusBar.h"
#import "UIBarButtonItem+UC.h"
#import "MyPurchedOrderTableViewCell.h"
@interface XJHMyOrderViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *datalist;
@end

@implementation XJHMyOrderViewController

- (void)viewDidLoad {
    self.title = @"我的订单";
    [self setStatusBarDefaultColor];
    _tableView = [[UITableView alloc]init];
    _datalist = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [UIView new];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[MyPurchedOrderTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem uc_backBarButtonItemWithAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self getData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentHaveResult) name:@"XJH_PAYMENT_HAVE_RESULT" object:nil];
}

- (void)paymentHaveResult {
    [self getData];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)getData{
    NSDictionary *dic = @{@"columns":@[@"id",@"amountMoney",@"payTime",@"status",@"receiveAccount",@"receiveName",@"orderNumber",@{@"contract":@[@"id",@"name",@"contractType"]},@"platform"],@"order":@{@"createTime":@"desc"},@"filter":@{},@"table":@"Order"};
    
   // NSString *url = @"http://children.xiangjianhai.com:999/app/queryamountMoney";
    [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
    [PPNetworkHelper POST:kAPIQueryUrl parameters:dic success:^(id responseObject) {
        _datalist = [responseObject objectForKey:@"data"];
        if (_datalist && [_datalist count]) {
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
#pragma mark-datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_datalist count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyPurchedOrderTableViewCell *cell = [[MyPurchedOrderTableViewCell alloc]init];
    cell.dic = [_datalist objectAtIndex:[indexPath row]];
    return cell;
    
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

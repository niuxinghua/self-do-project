//
//  AlarmListViewController.m
//  caxjh
//
//  Created by niuxinghua on 2017/12/3.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import "AlarmListViewController.h"
#import "PPNetworkHelper.h"
#import "UIBarButtonItem+UC.h"
#import "SocketManager.h"
#import "AddFenceViewController.h"
#import "AlarmMessageTableViewCell.h"
#import "PPNetworkHelper.h"
#import "VerticalButton.h"
@interface AlarmListViewController()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *datalist;
@property (nonatomic,strong)NSMutableArray *filterdatalist;
@property (nonatomic,strong)UIView *selectView;
@end

@implementation AlarmListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _datalist =  [[NSMutableArray alloc]init];
    _filterdatalist = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc]init];
    _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64);
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [UIView new];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[AlarmMessageTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem uc_backBarButtonItemWithAction:^{
        [self.navigationController popViewControllerAnimated:NO];
    }];
    self.title = @"报警列表";
    UIImage *img = [UIImage imageNamed:@"分类"];
   img =  [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:img style:UIBarButtonItemStylePlain target:self action:@selector(showSelect)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self getData];
}
- (UIView *)selectView
{
    if (!_selectView) {
        _selectView = [[UIView alloc]initWithFrame:_tableView.frame];
        _selectView.backgroundColor = [UIColor colorWithRed:0 green:0.0 blue:0.0 alpha:0.8];
        VerticalButton *drop = [[VerticalButton alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        drop.center = CGPointMake(self.view.center.x, 70);
        [drop setTitle:@"手表脱落报警" forState:UIControlStateNormal];
        [drop setImage:[UIImage imageNamed:@"drop"] forState:UIControlStateNormal];
        drop.tag = 1000;
        [drop addTarget:self action:@selector(filter:) forControlEvents:UIControlEventTouchUpInside];
        drop.titleLabel.font = [UIFont systemFontOfSize:12];
        [_selectView addSubview:drop];
        
        VerticalButton *low = [[VerticalButton alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        low.center = CGPointMake(self.view.center.x, 70 + 100 + 20);
        [low setTitle:@"低电量报警" forState:UIControlStateNormal];
        [low setImage:[UIImage imageNamed:@"low"] forState:UIControlStateNormal];
        low.tag = 2000;
        low.titleLabel.font = [UIFont systemFontOfSize:12];
        [low addTarget:self action:@selector(filter:) forControlEvents:UIControlEventTouchUpInside];
        [_selectView addSubview:low];
        
        VerticalButton *fence = [[VerticalButton alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        fence.center = CGPointMake(self.view.center.x, 70 + 100 + 20 + 120);
        [fence setTitle:@"围栏报警" forState:UIControlStateNormal];
        [fence setImage:[UIImage imageNamed:@"fence-1"] forState:UIControlStateNormal];
        fence.tag = 3000;
        fence.titleLabel.font = [UIFont systemFontOfSize:12];
        [fence addTarget:self action:@selector(filter:) forControlEvents:UIControlEventTouchUpInside];
        [_selectView addSubview:fence];
        
        VerticalButton *sos = [[VerticalButton alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        sos.center = CGPointMake(self.view.center.x, 70 + 100 + 20 + 120 + 120);
        [sos setTitle:@"SOS报警" forState:UIControlStateNormal];
        [sos setImage:[UIImage imageNamed:@"sos-1"] forState:UIControlStateNormal];
        sos.titleLabel.font = [UIFont systemFontOfSize:12];
        sos.tag = 4000;
        [sos addTarget:self action:@selector(filter:) forControlEvents:UIControlEventTouchUpInside];
        [_selectView addSubview:sos];
        UITapGestureRecognizer *re = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissSelf)];
        [_selectView addGestureRecognizer:re];
    }
    
    return _selectView;
    
}
- (void)dismissSelf
{
    [_selectView removeFromSuperview];
    
}
- (void)filter:(UIButton *)sender
{
    [_filterdatalist removeAllObjects];
    if (sender.tag == 3000) {
        for (NSDictionary *dic in _datalist) {
            if ([[dic valueForKey:@"type"] isEqualToString:@"fenceIn"] || [[dic valueForKey:@"type"] isEqualToString:@"fenceOut"]) {
                [_filterdatalist addObject:dic];
            }
        }
    }
    if (sender.tag == 1000) {
        for (NSDictionary *dic in _datalist) {
            if ([[dic valueForKey:@"type"] isEqualToString:@"drop"]) {
                [_filterdatalist addObject:dic];
            }
        }
    }
    if (sender.tag == 2000) {
        for (NSDictionary *dic in _datalist) {
            if ([[dic valueForKey:@"type"] isEqualToString:@"low"]) {
                [_filterdatalist addObject:dic];
            }
        }
    }
    if (sender.tag == 4000) {
        for (NSDictionary *dic in _datalist) {
            if ([[dic valueForKey:@"type"] isEqualToString:@"sos"]) {
                [_filterdatalist addObject:dic];
            }
        }
    }
    
    //_datalist = _filterdatalist;
    [_tableView reloadData];
    [_selectView removeFromSuperview];
    
    
}
- (void)showSelect
{
    [self.view addSubview:self.selectView];
    
}
- (void)getData{
    NSDictionary *dic1 = [SocketManager sharedInstance].locationDic;
    NSString *watchid = [dic1 objectForKey:@"id"];
    if(!watchid)
    {
        watchid = @"";
    }
    NSDictionary *dic =
    @{@"table":@"Alarm",
      @"filter": @{
              @"watch.id":@{@"eq":watchid}
              },
       @"order":@{@"createTime":@"desc"},
      @"columns": @[
              @"name",@"createTime",@"type",@"latDirection",@"latitude",@"lonDirection",@"longitude"
              ]
      };
    
    [PPNetworkHelper POST:kAPIQueryFence parameters:dic success:^(id responseObject) {
        if (responseObject) {
            _datalist =[responseObject objectForKey:@"data"];
            _filterdatalist = _datalist.mutableCopy;
            if (_datalist && ![_datalist isEqual:[NSNull null]]) {
                [_tableView reloadData];
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
    
    
}
#pragma mark-datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return 3;
    
    return [_filterdatalist count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AlarmMessageTableViewCell *cell = [[AlarmMessageTableViewCell alloc]init];
    
    cell.dic = [_filterdatalist objectAtIndex:[indexPath row]];
    
    return cell;
    
}


@end

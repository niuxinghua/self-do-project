//
//  XJHPostMemberListViewController.m
//  caxjh
//
//  Created by Yingchao Zou on 30/08/2017.
//  Copyright © 2017 Yingchao Zou. All rights reserved.
//

#import "XJHPostMemberListViewController.h"
#import "MemberDataController.h"
#import "ArticleCell.h"
#import "MJRefresh.h"
#import "ArticleDetilViewController.h"
@interface XJHPostMemberListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,strong)NSArray *datalist;
@property(nonatomic,assign)int start;
@end

@implementation XJHPostMemberListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"热门文章";
    if (_type == ArticleTypeVIP) {
        self.title = @"幼儿园热点事件";
    }
    _start = 0;
    _datalist = [[NSArray alloc]init];
    _tableView = [[UITableView alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [UIView new];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[ArticleCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
    self.tabBarController.tabBar.hidden = YES;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _start = 0;
        _datalist = @[];
        [self getData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getData)];
    [self getData];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem uc_backBarButtonItemWithAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];

}

- (void)getData{
    _tableView.userInteractionEnabled = NO;
    [MemberDataController getMemberArticleDataFromStart:[NSString stringWithFormat:@"%d",_start] OnSuccess:^(id response) {
        if (response && [response objectForKey:@"data"]) {
            NSArray *data = [response objectForKey:@"data"];
            if ([data count]) {
                //加载到数据了
                _start += [data count];
                _datalist = [_datalist arrayByAddingObjectsFromArray:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }else{
                //已经没有更多数据了
                
            }
            if ([self.tableView.mj_header isRefreshing]) {
                [self.tableView.mj_header endRefreshing];
            }
            if ([self.tableView.mj_footer isRefreshing]) {
                [self.tableView.mj_footer endRefreshing];
            }
            _tableView.userInteractionEnabled = YES;
        }
    } fail:^(id error) {
        if ([self.tableView.mj_header isRefreshing]) {
            [self.tableView.mj_header endRefreshing];
        }
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
        }
        _tableView.userInteractionEnabled = YES;
    }];
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
    return [_datalist count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ArticleCell *cell = [[ArticleCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    [cell bindData:[_datalist objectAtIndex:[indexPath row]]];
    cell.type = _type;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ArticleDetilViewController *detil = [[ArticleDetilViewController alloc]init];
    detil.dic = [_datalist objectAtIndex:[indexPath row]];
    [self.navigationController pushViewController:detil animated:NO];
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

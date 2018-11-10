//
//  HistoryArticleViewController.m
//  caxjh
//
//  Created by niuxinghua on 2017/8/30.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import "HistoryArticleViewController.h"
#import "ArticleCell.h"
#import "HisoryDataController.h"
#import "MJRefresh.h"
#import "MBProgressHUD.h"
#import "ArticleDetilViewController.h"
#import "UIBarButtonItem+UC.h"
@interface HistoryArticleViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,strong)NSArray *datalist;
@property(nonatomic,strong)NSMutableArray *searchdatalist;
@property(atomic,assign)BOOL isSearching;
@property(nonatomic,assign)int start;
@end

@implementation HistoryArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"历史文章";
    _start = 0;
    _datalist = [[NSArray alloc]init];
    _searchdatalist = [[NSMutableArray alloc]init];
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
        [_searchBar removeFromSuperview];
        [self.navigationController popViewControllerAnimated:YES];
    }];
  
    [self.navigationController.navigationBar addSubview:[self searchBar]];
    self.searchBar.center = CGPointMake(self.navigationController.navigationBar.center.x, self.navigationController.navigationBar.center.y - 20);
}

-(UISearchBar*)searchBar
{
    if (!_searchBar) {
         _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 250, 30)];
        _searchBar.backgroundColor = [UIColor colorWithRed:251/255.0 green:111/255.0 blue:113/255.0 alpha:1.0];
       // _searchBar.backgroundColor = [UIColor blackColor];
        _searchBar.delegate = self;
    }
    return _searchBar;
}
- (void)viewWillAppear:(BOOL)animated
{
    _searchBar.hidden = NO;
  //  [self.navigationController.navigationBar addSubview:_searchBar];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    
    _searchBar.hidden = YES;
    
}
- (void)getData{
    _tableView.userInteractionEnabled = NO;
    [HisoryDataController getHisoryArticleDataFromStart:[NSString stringWithFormat:@"%d",_start] OnSuccess:^(id response) {
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
    if (_isSearching) {
        return [_searchdatalist count];
    }
    return [_datalist count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ArticleCell *cell = [[ArticleCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    cell.type = ArticleTypeSearch;
    if (_isSearching) {
          [cell bindData:[_searchdatalist objectAtIndex:[indexPath row]]];
    }else
    {
       [cell bindData:[_datalist objectAtIndex:[indexPath row]]];
    }
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ArticleDetilViewController *detil = [[ArticleDetilViewController alloc]init];
    if (_isSearching) {
       detil.dic = [_searchdatalist objectAtIndex:[indexPath row]];
    }else{
       detil.dic = [_datalist objectAtIndex:[indexPath row]];
    }
    [self.navigationController pushViewController:detil animated:NO];
}
#pragma mark -searchBar
- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText
{
    _isSearching = YES;
    [_searchdatalist removeAllObjects];
    if (searchText.length==0) {
        _isSearching = NO;
        _tableView.mj_footer.hidden = NO;
        _tableView.mj_header.hidden = NO;
        [_tableView reloadData];
        return;
    }
    [self searchArrayWith:searchText];
    _tableView.mj_footer.hidden = YES;
    _tableView.mj_header.hidden = YES;
    
}
-(void)searchArrayWith:(NSString *)searchText
{
    _isSearching = YES;
    for (NSDictionary *dic in _datalist) {
        NSString *str = [dic objectForKey:@"name"];
        if ([str containsString:searchText]) {
            [_searchdatalist addObject:dic];
        }
    }
    [_tableView reloadData];
}
@end

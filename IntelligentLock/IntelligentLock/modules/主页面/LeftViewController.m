//
//  LeftViewController.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/3/2.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "LeftViewController.h"
#import "LockStoreManager.h"
#import "Const.h"
#import "LeftViewTableViewCell.h"
#import "EVNCustomSearchBar.h"
@interface LeftViewController ()<UITableViewDelegate,UITableViewDataSource,EVNCustomSearchBarDelegate>


@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *dataList;

@property(nonatomic,strong)EVNCustomSearchBar *searchBar;

@property(nonatomic,strong)NSMutableArray *searchdatalist;

@property (nonatomic,assign)BOOL isSearching;

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _dataList = [[NSMutableArray alloc]init];
    _searchdatalist = [[NSMutableArray alloc]init];
    if (isiPhoneX) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height - 44)];
//        if (@available(iOS 11.0, *)){
//            
//            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64 + 30, self.view.frame.size.width, self.view.frame.size.height - 64 - 30)];
//        }
    }else
    {_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
//        if (@available(iOS 11.0, *)){
//            
//            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
//        }
    }
    

    _tableView.tableFooterView = [UIView new];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[LeftViewTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableView];
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    [headerView addSubview:self.searchBar];
    self.tableView.tableHeaderView = headerView;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dismisssearch) name:@"searchdismiss" object:nil];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     NSArray *storeLockList = [[NSUserDefaults standardUserDefaults] objectForKey:@"locklist"];
    if (![LockStoreManager sharedManager].selectedLock && storeLockList.count) {
        [LockStoreManager sharedManager].selectedLock = storeLockList[0];
    }
    [LockStoreManager sharedManager].lockList = storeLockList.mutableCopy;
    _dataList = [LockStoreManager sharedManager].lockList;
    [_tableView reloadData];
    if (isiPhoneX) {
        _tableView.frame = CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height - 44);
    }else
    {_tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64);
    }
    

    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_searchBar endEditing:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
    
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
        return _searchdatalist.count;
    }
    
    return _dataList.count;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LeftViewTableViewCell* cell=[[LeftViewTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    if (_isSearching) {
        cell.dic = _searchdatalist[[indexPath row]];
    }else{
        
    cell.dic = _dataList[[indexPath row]];
        
    }
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_isSearching)
    {
         [LockStoreManager sharedManager].selectedLock = _searchdatalist[[indexPath row]];
        
    }else{
        
    [LockStoreManager sharedManager].selectedLock = _dataList[[indexPath row]];
    }
  [[NSUserDefaults standardUserDefaults] synchronize];
    [_searchBar resignFirstResponder];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"closeleft" object:nil];
    
    
    
}
-(EVNCustomSearchBar*)searchBar
{
    if (!_searchBar) {
        _searchBar = [[EVNCustomSearchBar alloc]initWithFrame:CGRectMake(10, 0, 250, 20)];
       // _searchBar.backgroundColor = [UIColor colorWithRed:251/255.0 green:111/255.0 blue:113/255.0 alpha:1.0];

        _searchBar.delegate = self;
        _searchBar.textColor = [UIColor blackColor];
        [_searchBar setIconImage:[UIImage imageNamed:@"search"]];
        _searchBar.placeholder = [kMultiTool getMultiLanByKey:@"search"];
        

    }
    return _searchBar;
}
#pragma mark -searchBar
- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText
{
    _isSearching = YES;
    [_searchdatalist removeAllObjects];
    if (searchText.length==0) {
        _isSearching = NO;
        [_tableView reloadData];
        return;
    }
    [self searchArrayWith:searchText];
    
}
-(void)searchArrayWith:(NSString *)searchText
{
    _isSearching = YES;
    for (NSDictionary *dic in _dataList) {
        NSString *str = [dic objectForKey:@"name"];
        if ([str containsString:searchText]) {
            [_searchdatalist addObject:dic];
        }
    }
    [_tableView reloadData];
}
- (void)dismisssearch
{
    [_searchBar resignFirstResponder];
    
}
- (void)searchBarCancelButtonClicked:(EVNCustomSearchBar *)searchBar
{
    _searchdatalist = _dataList;
    [_tableView reloadData];
    
}

@end

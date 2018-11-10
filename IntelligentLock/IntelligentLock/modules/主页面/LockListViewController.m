//
//  LockListViewController.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/3/10.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "LockListViewController.h"
#import "LockListTableViewCell.h"
#import "Masonry.h"
#import "LoginModel.h"
#import "LockStoreManager.h"
#import "NSDictionary+Null.h"
@interface LockListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *dataList;


@end

@implementation LockListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationUI];
     _dataList = [[NSMutableArray alloc]init];
    [self.view addSubview:self.tableView];
    [self makeConstrains];
    [self getLockList];
}

- (UIView *)headerView
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, kWINDOW.frame.size.width, 50)];
    
    UILabel *flable = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, kWINDOW.frame.size.width/3.0, 50)];
    flable.backgroundColor = UICOLOR_HEX(0xe1eed6);
    UILabel *slable = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, kWINDOW.frame.size.width/3.0, 50)];
    slable.backgroundColor = UICOLOR_HEX(0xe1eed6);
    UILabel *tlable = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, kWINDOW.frame.size.width/3.0, 50)];
    tlable.backgroundColor = UICOLOR_HEX(0xe1eed6);
    flable.textColor = UICOLOR_HEX(0x336130);
    slable.textColor = UICOLOR_HEX(0x336130);
    tlable.textColor = UICOLOR_HEX(0x336130);
    flable.text = [kMultiTool getMultiLanByKey:@"suomingcheng"];
    slable.text = [kMultiTool getMultiLanByKey:@"suoleixing"];
    tlable.text = [kMultiTool getMultiLanByKey:@"suoleixingbianma"];
   // flable.textAlignment = NSTextAlignmentCenter;
    // slable.textAlignment = NSTextAlignmentCenter;
  //   tlable.textAlignment = NSTextAlignmentCenter;
 
    
    [headerView addSubview:flable];
    [headerView addSubview:slable];
    [headerView addSubview:tlable];
    
    flable.center = CGPointMake(kWINDOW.frame.size.width/6.0, 25);
    slable.center = CGPointMake(kWINDOW.frame.size.width/2.0, 25);
    tlable.center = CGPointMake(kWINDOW.frame.size.width/6.0 * 5, 25);
    
    return headerView;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        [_tableView registerClass:[LockListTableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = [self headerView];
    }
    
    return _tableView;
}
- (void)makeConstrains
{
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view.mas_top);
    }];
    
    
}
- (void)setNavigationUI
{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    
    titleLabel.textColor = [UIColor whiteColor];
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    titleLabel.text = [kMultiTool getMultiLanByKey:@"locklist"];
    
    self.navigationItem.titleView = titleLabel;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
   [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbackimage"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem uc_backBarButtonItemWithAction:^{
        
        // self.navigationController.navigationBar.hidden = YES;
        [self.navigationController popViewControllerAnimated:NO];
        
    }];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@""] forBarMetrics:UIBarMetricsDefault];
    
    
}
#pragma mark-tableview delegate


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
    
    return _dataList.count;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LockListTableViewCell* cell = [[LockListTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.dic = _dataList[[indexPath row]];
    return cell;
    
}
- (void)getLockList
{
    NSDictionary *logindic =
    [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
    
    LoginModel *loginModel = [LoginModel yy_modelWithJSON:logindic];
    
    if (loginModel.retval.token) {
        
    }
    NSDictionary *dic = @{@"app":@"userloginapp",@"act":@"lock",@"token":loginModel.retval.token};
    
    
    //[PPNetworkHelper setValue:<#(NSString *)#> forHTTPHeaderField:<#(NSString *)#>];
    [PPNetworkHelper  GET:kBaseUrl parameters:dic success:^(id responseObject) {
        NSString *msg = [responseObject objectForKey:@"msg"];
        if ([msg containsString:@"login failed"]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"logout" object:nil];
            return ;
        }
        if([responseObject objectForKey:@"retval"]){
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSDictionary nullArr:[responseObject objectForKey:@"retval"]] forKey:@"locklist"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSArray *array = [responseObject objectForKey:@"retval"];
            _dataList = array.mutableCopy;
           //_dataList = [[_dataList reverseObjectEnumerator] allObjects].mutableCopy;
            [_tableView reloadData];
            
        }
        
        
    } failure:^(NSError *error) {
       
        
    }];
    
    
    
}
@end

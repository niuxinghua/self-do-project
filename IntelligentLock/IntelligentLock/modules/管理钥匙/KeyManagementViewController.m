//
//  KeyManagementViewController.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/2/22.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "KeyManagementViewController.h"
#import "KeyManageMentHeaderView.h"
#import "Const.h"
#import "Masonry.h"
#import "KeyManagementTableViewCell.h"
#import "LockStoreManager.h"
#import "loginModel.h"
@interface KeyManagementViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)KeyManageMentHeaderView *headerView;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataList;

@end

@implementation KeyManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationUI];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.tableView];
    [self makeConstrians];
    _dataList = [[NSMutableArray alloc]init];
   // [self getData];
   
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getData];
    
}

- (void)getData
{
    //取出keylist 把type=0的去除掉。
   // http://27.223.89.54:8012/index.php?lock_id=49&app=userloginapp&act=lock_info&token=lock_token_20180223ca537880ea199f7ddb6879e566b13eee
    
 NSDictionary *lock = [LockStoreManager sharedManager].selectedLock;
    if (!lock) {
        return;
    }
    NSDictionary *logindic =
    [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];

    LoginModel *loginModel = [LoginModel yy_modelWithJSON:logindic];
    NSDictionary *dic = @{@"app":@"userloginapp",@"act":@"lock_info",@"token":loginModel.retval.token,@"lock_id":[lock objectForKey:@"lock_id"]};
    
    
   
    [PPNetworkHelper GET:kBaseUrl parameters:dic success:^(id responseObject) {
        
        NSDictionary *dic = [responseObject objectForKey:@"retval"];
        NSArray *keyList = [dic objectForKey:@"keylist"];
        [_dataList removeAllObjects];
        for (NSDictionary *dic in keyList) {
            if (![[dic objectForKey:@"type"] isEqualToString:@"0"]) {
                [_dataList addObject:dic];
            }
        }
        NSLog(@"datalist====%@",_dataList);
        [_tableView reloadData];
        
        
    } failure:^(NSError *error) {
        
    }];
    
    
    
    
}
- (void)makeConstrians

{
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(@40);
        
    }];
    
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.equalTo(self.view);
        make.top.equalTo(self.headerView.mas_bottom);
    }];
    
    
}
- (void)setNavigationUI
{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    
    titleLabel.textColor = [UIColor whiteColor];
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    titleLabel.text = [kMultiTool getMultiLanByKey:@"managekey"];
    
    self.navigationItem.titleView = titleLabel;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbackimage"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem uc_backBarButtonItemWithAction:^{
        
        // self.navigationController.navigationBar.hidden = YES;
        [self.navigationController popViewControllerAnimated:NO];
        
    }];
    
}
#pragma mark - UI getters

- (KeyManageMentHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[KeyManageMentHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    }
    
    return _headerView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        [_tableView registerClass:[KeyManagementTableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    
    return _tableView;
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
    if (_dataList.count > 0) {
        return _dataList.count;
    }
    
    return 0;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KeyManagementTableViewCell* cell = [[KeyManagementTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    if (_dataList.count) {
    cell.dic = _dataList[indexPath.row];
    }
    
    return cell;
    
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    return YES;
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    return UITableViewCellEditingStyleDelete;
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle ==UITableViewCellEditingStyleDelete) {//如果编辑样式为删除样式
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[kMultiTool getMultiLanByKey:@"quedingshanchu"] message:nil preferredStyle:UIAlertControllerStyleAlert];
        alert.popoverPresentationController.sourceView = self.view;
        alert.popoverPresentationController.sourceRect = CGRectMake(0, 0, 1.0, 1.0);
        
        UIAlertAction * takingPicAction = [UIAlertAction actionWithTitle:[kMultiTool getMultiLanByKey:@"queding"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self deleteItem:indexPath];
        }];
        [alert addAction:takingPicAction];
        [alert addAction:[UIAlertAction actionWithTitle:[kMultiTool getMultiLanByKey:@"cancell"] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            
        }]];
        [self.navigationController presentViewController:alert animated:NO completion:^{
            
        }];
        
            
        }
        
    }
    

- (void)deleteItem:(NSIndexPath *)indexPath
{
      NSDictionary *lock = [LockStoreManager sharedManager].selectedLock;
    if (!lock) {
        return;
    }
    [kWINDOW makeToastActivity:CSToastPositionCenter];
    NSDictionary *keydic = [_dataList objectAtIndex:[indexPath row]];
    NSDictionary *logindic =
    [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
    
    LoginModel *loginModel = [LoginModel yy_modelWithJSON:logindic];
    NSDictionary *dic = @{@"app":@"userloginapp",@"act":@"delete_key",@"token":loginModel.retval.token,@"key_id":[keydic objectForKey:@"key_id"]};
    
    
    @WeakSelf(self);
    [PPNetworkHelper GET:kBaseUrl parameters:dic success:^(id responseObject) {
        [kWINDOW hideToastActivity];
        [weakSelf getData];
        
        
    } failure:^(NSError *error) {
        [kWINDOW hideToastActivity];
    }];
    

    
    
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [kMultiTool getMultiLanByKey:@"shanchu"];
}

@end

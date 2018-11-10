//
//  UserManagementViewController.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/3/26.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "UserManagementViewController.h"
#import "Const.h"
#import "UserMangeMentTableViewCell.h"
#import "BlueToothManager.h"
@interface UserManagementViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataList;
@property (nonatomic,strong)NSString *userName;

@property (nonatomic,strong)NSNotification *deletenotification;

@property (nonatomic,strong)NSMutableArray *groupToDelete;

@property (nonatomic,assign)BOOL isuserDelete;

@property (nonatomic,assign)BOOL isgroupDelete;

@property (nonatomic,assign)BOOL shouldShowAlert;

@property (nonatomic,strong) NSDictionary *usertoDelete;

@end

@implementation UserManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationUI:@"yonghuguanli"];
    [self.view addSubview:self.tableView];
    [self makeConstrains];
    _dataList = [[NSMutableArray alloc]init];
    [self getData];
   
}
- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteUser:) name:@"deleteuser" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modifyUser:) name:@"modifyuser" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteGroup:) name:@"deletegroup" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modifyGroup:) name:@"modifygroup" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(douploaddeleteuser:) name:@"lockdeleteusersuccess" object:nil];
    
}

- (void)makeConstrains
{
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuide);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
    }];
    
    
}
- (void)getData
{
    //showLoadingDialog(getResources().getString(R.string.zhengzaitijiao), true); OkGo.get(getResources().getString(R.string.APP_URL)).params("lock_id", id).params("en", MainAppclation.isZh)         .params("app", "userloginapp").params("act", "getTag")         .params("token", PreferenceUtils.getPrefString(currentActivity, "token", ""))         .cacheKey("getTag")
    NSDictionary *selectDic = [LockStoreManager sharedManager].selectedLock;
    NSDictionary *logindic =
    [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
    LoginModel *loginModel = [LoginModel yy_modelWithJSON:logindic];
    NSDictionary *dic = @{@"app":@"userloginapp",@"token":loginModel.retval.token,@"act":@"getTag",@"lock_id":[selectDic objectForKey:@"lock_id"]};
    @WeakSelf(self);
    [PPNetworkHelper GET:kBaseUrl parameters:dic success:^(id responseObject) {
        if ([[responseObject objectForKey:@"done"] intValue]) {
           weakSelf.dataList = [responseObject objectForKey:@"retval"];
            [weakSelf.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];

}


- (void)deleteUser:(NSNotification *)notification
{
    
    //OkGo.get(getResources().getString(R.string.APP_URL)).params("id", lock_id)         .params("sn", sn).params("type", type).params("en", MainAppclation.isZh)         .params("app", "userloginapp").params("act", "drop")         .params("token", PreferenceUtils.getPrefString(currentActivity, "token", ""))         .cacheKey("drop")
    
    
    if (_isgroupDelete) {
        _isuserDelete = YES;
        _deletenotification = notification;
        NSDictionary *userDic = notification.object;
        _usertoDelete = userDic;
        [[BlueToothManager sharedManager] addorDeleteUser:[[userDic objectForKey:@"sn"]intValue] isAdd:NO type:[[userDic objectForKey:@"type"]intValue]];
        return;
    }
    
    
    
    
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[kMultiTool getMultiLanByKey:@"shanchuyonghutishi"] message:nil preferredStyle:UIAlertControllerStyleAlert];
    alert.popoverPresentationController.sourceView = self.view;
    alert.popoverPresentationController.sourceRect = CGRectMake(0, 0, 1.0, 1.0);
    UIAlertAction * takingPicAction = [UIAlertAction actionWithTitle:[kMultiTool getMultiLanByKey:@"queding"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        _isuserDelete = YES;
        _deletenotification = notification;
        NSDictionary *userDic = notification.object;
        _usertoDelete = userDic;
        [[BlueToothManager sharedManager] addorDeleteUser:[[userDic objectForKey:@"sn"]intValue] isAdd:NO type:[[userDic objectForKey:@"type"]intValue]];
        
        
    }];
    UIAlertAction * cancell = [UIAlertAction actionWithTitle:[kMultiTool getMultiLanByKey:@"cancell"] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
        
    }];
  
    [alert addAction:takingPicAction];
    [alert addAction:cancell];
    [self presentViewController:alert animated:YES completion:nil];
    
    
 

    
    
}

- (void)douploaddeleteuser:(NSNotification *)notification
{
   // if (_groupToDelete.count && !_isuserDelete) {
     //   [self deleteGroup:nil];
       // return;
  //  }
    [kWINDOW makeToastActivity:CSToastPositionCenter];
    NSDictionary *selectDic = [LockStoreManager sharedManager].selectedLock;
    NSDictionary *userDic = _usertoDelete;
    NSDictionary *logindic =
    [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
    LoginModel *loginModel = [LoginModel yy_modelWithJSON:logindic];
    NSDictionary *dic = @{@"app":@"userloginapp",@"token":loginModel.retval.token,@"act":@"drop",@"id":[selectDic objectForKey:@"lock_id"],@"type":[userDic objectForKey:@"type"],@"sn":[userDic objectForKey:@"sn"]};
    @WeakSelf(self);
    [PPNetworkHelper GET:kBaseUrl parameters:dic success:^(id responseObject) {
        [kWINDOW hideToastActivity];
        if (_isuserDelete) {
          [kWINDOW makeToast:[responseObject objectForKey:@"msg"]];
        }
        if ([[responseObject objectForKey:@"done"] intValue]) {
            //    NSDictionary *userDic = notification.object;
            //    NSDictionary *logindic =
            if (!_isuserDelete) {
                weakSelf.usertoDelete = nil;
                [self deleteGroup:nil];
                return;
            }else
            {
                if (weakSelf.isuserDelete) {
                    weakSelf.isuserDelete = NO;
                    weakSelf.deletenotification = nil;
                }
                 [weakSelf getData];
            }
        }
    } failure:^(NSError *error) {
        [kWINDOW hideToastActivity];
    }];
}
- (void)deleteGroup:(NSNotification *)notification
{
    _shouldShowAlert = YES;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[kMultiTool getMultiLanByKey:@"shanchufenzu"] message:nil preferredStyle:UIAlertControllerStyleAlert];
    alert.popoverPresentationController.sourceView = self.view;
    alert.popoverPresentationController.sourceRect = CGRectMake(0, 0, 1.0, 1.0);
    UIAlertAction * takingPicAction = [UIAlertAction actionWithTitle:[kMultiTool getMultiLanByKey:@"queding"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _shouldShowAlert = NO;
        if ([notification isEqual:[NSNull null]]) {
            NSDictionary *dic1 = _groupToDelete.firstObject;
            [_groupToDelete removeObject:dic1];
            _usertoDelete = dic1;
            [[BlueToothManager sharedManager] addorDeleteUser:[[dic1 objectForKey:@"sn"]intValue] isAdd:NO type:[[dic1 objectForKey:@"type"]intValue]];
            _isgroupDelete = YES;
            return;
        }else
            if (notification.object && !_deletenotification) {
                _deletenotification = notification;
            }
        NSDictionary *dic = _deletenotification.object;
        if (dic && !_groupToDelete) {
            NSArray *list = [dic objectForKey:@"list"];
            _groupToDelete = [[NSMutableArray alloc]initWithArray:list];
        }
        
        if (_groupToDelete.count == 0) {
            //已经没有需要删除的用户了直接删除分组
            self.shouldShowAlert = NO;
            _groupToDelete = nil;
            [self douploaddeletegroup];
        }else
        {
            NSDictionary *dic1 = _groupToDelete.firstObject;
            _usertoDelete = dic1;
            [_groupToDelete removeObject:dic1];
            [[BlueToothManager sharedManager] addorDeleteUser:[[dic1 objectForKey:@"sn"]intValue] isAdd:NO type:[[dic1 objectForKey:@"type"]intValue]];
            _isgroupDelete = YES;
            
        }
        
        
    }];
    UIAlertAction * cancell = [UIAlertAction actionWithTitle:[kMultiTool getMultiLanByKey:@"cancell"] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        _shouldShowAlert = YES;
        
    }];
    
    [alert addAction:takingPicAction];
    [alert addAction:cancell];
    if (_shouldShowAlert && !_usertoDelete && !_isgroupDelete) {
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
   
    
    if ([notification isEqual:[NSNull null]]) {
        NSDictionary *dic1 = _groupToDelete.firstObject;
        [_groupToDelete removeObject:dic1];
        _usertoDelete = dic1;
        [[BlueToothManager sharedManager] addorDeleteUser:[[dic1 objectForKey:@"sn"]intValue] isAdd:NO type:[[dic1 objectForKey:@"type"]intValue]];
        return;
    }else
        if (notification.object && !_deletenotification) {
            _deletenotification = notification;
        }
    NSDictionary *dic = _deletenotification.object;
    if (dic && !_groupToDelete) {
        NSArray *list = [dic objectForKey:@"list"];
        _groupToDelete = [[NSMutableArray alloc]initWithArray:list];
    }
    
    if (_groupToDelete.count == 0) {
        //已经没有需要删除的用户了直接删除分组
        self.shouldShowAlert = NO;
        _groupToDelete = nil;
        [self douploaddeletegroup];
    }else
    {
        NSDictionary *dic1 = _groupToDelete.firstObject;
        _usertoDelete = dic1;
        [_groupToDelete removeObject:dic1];
        [[BlueToothManager sharedManager] addorDeleteUser:[[dic1 objectForKey:@"sn"]intValue] isAdd:NO type:[[dic1 objectForKey:@"type"]intValue]];
        _isgroupDelete = YES;
        
    }
    

  
    //删除分组里的每个用户 再吊接口删除分组
    
    
    
    
    
}
- (void)douploaddeletegroup
{
    _isgroupDelete = NO;
    [kWINDOW makeToastActivity:CSToastPositionCenter];
    NSDictionary *selectDic = [LockStoreManager sharedManager].selectedLock;
    NSDictionary *userDic = _deletenotification.object;
    NSDictionary *logindic =
    [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
    LoginModel *loginModel = [LoginModel yy_modelWithJSON:logindic];
    NSString *rid = [userDic objectForKey:@"tid"];
    if (!rid) {
        rid = [userDic objectForKey:@"id"];
    }
    NSDictionary *dic = @{@"app":@"userloginapp",@"token":loginModel.retval.token,@"act":@"dropTag",@"id":rid,@"lock_id":[selectDic objectForKey:@"lock_id"]};
    @WeakSelf(self);
    [PPNetworkHelper GET:kBaseUrl parameters:dic success:^(id responseObject) {
        [kWINDOW hideToastActivity];
        [kWINDOW makeToast:[responseObject objectForKey:@"msg"]];
        if ([[responseObject objectForKey:@"done"] intValue]) {
            //    NSDictionary *userDic = notification.object;
            //    NSDictionary *logindic =
            weakSelf.usertoDelete = nil;
            weakSelf.deletenotification = nil;
            weakSelf.isgroupDelete = NO;
            [weakSelf getData];
        }
    } failure:^(NSError *error) {
        [kWINDOW hideToastActivity];
    }];
    
    
}

- (void)modifyGroup:(NSNotification *)notification
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[kMultiTool getMultiLanByKey:@"username"] message:nil preferredStyle:UIAlertControllerStyleAlert];
    alert.popoverPresentationController.sourceView = self.view;
    alert.popoverPresentationController.sourceRect = CGRectMake(0, 0, 1.0, 1.0);
    //按钮：从相册选择，类型：UIAlertActionStyleDefault
    UIAlertAction * takingPicAction = [UIAlertAction actionWithTitle:[kMultiTool getMultiLanByKey:@"queding"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self modifyUserName:notification isGroup:YES];
        
    }];
    UIAlertAction * cancell = [UIAlertAction actionWithTitle:[kMultiTool getMultiLanByKey:@"cancell"] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
        
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = [kMultiTool getMultiLanByKey:@"usernamep"];
      
       [textField addTarget:self action:@selector(watchTextFieldMethod:) forControlEvents:UIControlEventEditingChanged];
        
    }];
    [alert addAction:takingPicAction];
    [alert addAction:cancell];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}
- (void)modifyUser:(NSNotification *)notification
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[kMultiTool getMultiLanByKey:@"username"] message:nil preferredStyle:UIAlertControllerStyleAlert];
    alert.popoverPresentationController.sourceView = self.view;
    alert.popoverPresentationController.sourceRect = CGRectMake(0, 0, 1.0, 1.0);
    //按钮：从相册选择，类型：UIAlertActionStyleDefault
    UIAlertAction * takingPicAction = [UIAlertAction actionWithTitle:[kMultiTool getMultiLanByKey:@"queding"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self modifyUserName:notification isGroup:NO];
        
    }];
    UIAlertAction * cancell = [UIAlertAction actionWithTitle:[kMultiTool getMultiLanByKey:@"cancell"] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
        
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = [kMultiTool getMultiLanByKey:@"usernamep"];
        
        [textField addTarget:self action:@selector(watchTextFieldMethod:) forControlEvents:UIControlEventEditingChanged];
        
    }];
    [alert addAction:takingPicAction];
    [alert addAction:cancell];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}
- (void)watchTextFieldMethod:(UITextField*)textFeild
{
    
    _userName = textFeild.text;
    
    
}
- (void)modifyUserName:(NSNotification *)notification isGroup:(BOOL)isGroup
{
    //OkGo.get(getResources().getString(R.string.APP_URL)).params("id", lock_id)         .params("sn", id).params("note", note).params("type", type).params("en", MainAppclation.isZh)         .params("app", "userloginapp").params("act", "editNote")         .params("token", PreferenceUtils.getPrefString(currentActivity, "token", ""))         .cacheKey("editNote")
  //分组
  //  OkGo.get(getResources().getString(R.string.APP_URL))         .params("id", id).params("tag", tag).params("en", MainAppclation.isZh)         .params("app", "userloginapp").params("act", "edit")         .params("token", PreferenceUtils.getPrefString(currentActivity, "token", ""))         .cacheKey("edit")

    [kWINDOW makeToastActivity:CSToastPositionCenter];
    NSDictionary *selectDic = [LockStoreManager sharedManager].selectedLock;
    NSDictionary *userDic = notification.object;
    NSDictionary *logindic =
    [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
    LoginModel *loginModel = [LoginModel yy_modelWithJSON:logindic];
    NSDictionary *dic;
    if(isGroup)
    {
        dic = @{@"app":@"userloginapp",@"token":loginModel.retval.token,@"act":@"edit",@"id":[userDic objectForKey:@"tid"],@"tag":_userName};
        
    }else{
        dic = @{@"app":@"userloginapp",@"token":loginModel.retval.token,@"act":@"editNote",@"id":[selectDic objectForKey:@"lock_id"],@"type":[userDic objectForKey:@"type"],@"sn":[userDic objectForKey:@"sn"],@"note":_userName};
    }
    @WeakSelf(self);
    [PPNetworkHelper GET:kBaseUrl parameters:dic success:^(id responseObject) {
        [kWINDOW hideToastActivity];
        [kWINDOW makeToast:[responseObject objectForKey:@"msg"]];
        if ([[responseObject objectForKey:@"done"] intValue]) {
            //    NSDictionary *userDic = notification.object;
            //    NSDictionary *logindic =
            [weakSelf getData];
        }
    } failure:^(NSError *error) {
        [kWINDOW hideToastActivity];
    }];
    
    
    
    
}

#pragma mark - UI Getters

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
       [_tableView registerClass:[UserMangeMentTableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    
    return _tableView;
}

#pragma mark -tableview
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = [_dataList objectAtIndex:[indexPath row]];
    NSArray *listArray = [dic objectForKey:@"list"];
    if (listArray.count) {
        
        return listArray.count * 60 + 80;
    }
    return 80;
    
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
    
    UserMangeMentTableViewCell* cell=[[UserMangeMentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.dic = [_dataList objectAtIndex:[indexPath row]];
    
    //删除一个分组
    @WeakSelf(self);
    cell.deleteBlock = ^(NSString *tagId) {
        NSDictionary *dic = [_dataList objectAtIndex:[indexPath row]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"deletegroup" object:dic];
    };
    cell.modifyBlock  = ^(NSString *tagId) {
        NSDictionary *dic = [_dataList objectAtIndex:[indexPath row]];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"modifygroup" object:dic];
    };
    
   return cell;
    
}


@end

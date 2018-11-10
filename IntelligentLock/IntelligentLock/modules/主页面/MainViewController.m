//
//  MainViewController.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/1/26.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "MainViewController.h"
#import "Const.h"
#import "LoginModel.h"
#import "MainIconCollectionViewCell.h"
#import "BlueToothManager.h"
#import "SendKeyViewController.h"
#import "KeyManagementViewController.h"
#import "AddUserViewController.h"
#import "SettingViewController.h"
#import "LockStoreManager.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "CircleLoaderView.h"
#import "BindAdminiViewController.h"
#import "PPNetworkHelper.h"
#import "UserManagementViewController.h"
#import "PowderUtil.h"
#import "NSDictionary+Null.h"
#import "JPUSHService.h"
static NSString * const identifier = @"reuseId";
#define kLockResultKey [NSString stringWithFormat:@"%@%@",kLoginModel.retval.n,[kdicSelected objectForKey:@"lock_id"]]
#define kLoginDic [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"]

#define kLoginModel [LoginModel yy_modelWithJSON:kLoginDic]
#define kLockUseNum [NSString stringWithFormat:@"use%@%@",kLoginModel.retval.n,[kdicSelected objectForKey:@"key_id"]]
#define kLockOffNum [NSString stringWithFormat:@"off%@%@",kLoginModel.retval.n,[kdicSelected objectForKey:@"key_id"]]
@interface MainViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)CircleLoaderView *iconImageView;
@property (nonatomic,assign)int numberToshow;
@property (nonatomic,strong)UILabel *nulllable;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDictionary *logindic = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
    
    LoginModel *loginModel = [LoginModel yy_modelWithJSON:logindic];
    
    if (loginModel.retval.user_id) {

            [JPUSHService setAlias:loginModel.retval.user_id completion:nil seq:nil];
        
    }
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = [kMultiTool getMultiLanByKey:@"home"];
    [self.view addSubview:self.collectionView];
    [self setupLeftMenuButton];
    // [self getLockList];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didgetInfo:) name:@"lockinfo1" object:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(leftClose) name:@"closeleft" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(plustouch:) name:@"didtapplus" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLockList) name:@"deletesuccess" object:nil];
    _nulllable = [[UILabel alloc]init];
    _nulllable.frame = CGRectMake(0, 0, 200, 30);
    _nulllable.text = [kMultiTool getMultiLanByKey:@"weitianjiasuo"];
    _nulllable.center = self.view.center;
    _nulllable.hidden = YES;
    _nulllable.textColor = [UIColor grayColor];
    [self.view addSubview:_nulllable];
     [NSTimer scheduledTimerWithTimeInterval:60*5 target:self selector:@selector(getLockList) userInfo:nil repeats:YES];
    
}

- (void)didgetInfo:(NSNotification *)notification
{
    //获取到蓝牙返回的电量
    //更新到本地
    
    NSInteger percent = [PowderUtil percentFrom:notification.object];
    
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%ld%%",percent] forKey:@"lockinfo"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self.view hideToastActivity];
    kWINDOW.userInteractionEnabled = YES;
    
}
- (NSString *)nowTime
{
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *timeStr1 = [formatter stringFromDate:[NSDate date]];
    return timeStr1;
    
}
- (void)uploadLockRecord
{
    
    //time开锁时间，type开锁类型(蓝牙开锁-5)，uuid蓝牙开锁穿0，uid用户id,keyid钥匙id,exp_type跟锁列表返回的一样
    
    NSDictionary *logindic =
    [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
    
    LoginModel *loginModel = [LoginModel yy_modelWithJSON:logindic];
    NSDictionary *dicSelected = [LockStoreManager sharedManager].selectedLock;
    
    NSDictionary *dic = @{@"time":[self nowTime],@"type":@"5",@"uuid":@"0",@"uid":loginModel.retval.user_id,@"exp_type":[dicSelected objectForKey:@"type"],@"key_id":[dicSelected objectForKey:@"key_id"]};
    NSMutableArray *arraylock = [[NSMutableArray alloc]init];
    NSArray *array = [[NSUserDefaults standardUserDefaults] objectForKey:kLockResultKey];
    if (array.count && ![array isEqual:[NSNull null]]) {
        [arraylock addObjectsFromArray:array];
    }
    
    [arraylock addObject:dic];
    if (![PPNetworkHelper isNetwork]) {
        [[NSUserDefaults standardUserDefaults] setObject:arraylock.copy forKey:kLockResultKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return;
    }
    
    NSDictionary *dic1 = @{@"lock_id":[dicSelected objectForKey:@"lock_id"],@"app":@"userloginapp",@"act":@"wlocklog",@"token":loginModel.retval.token,@"g":[self jsonStringWithArray:arraylock]};
    
    
    
    [PPNetworkHelper  GET:kBaseUrl parameters:dic1 success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        
    } failure:^(NSError *error) {
        
    }];
    
    
    
    
    
    
}
- (void)uploadLocalLockRecord
{
    
    if (![PPNetworkHelper isNetwork]) {
        //无网络
        [self.view hideToastActivity];
        
        return;
    }
    
    //time开锁时间，type开锁类型(蓝牙开锁-5)，uuid蓝牙开锁穿0，uid用户id,keyid钥匙id,exp_type跟锁列表返回的一样
    
    NSDictionary *logindic =
    [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
    
    LoginModel *loginModel = [LoginModel yy_modelWithJSON:logindic];
    NSDictionary *dicSelected = [LockStoreManager sharedManager].selectedLock;
    NSMutableArray *array = [[NSMutableArray alloc]init];
    NSMutableArray *arraylock = [[NSUserDefaults standardUserDefaults] objectForKey:kLockResultKey];
    if (arraylock && arraylock.count) {
        [array addObjectsFromArray:arraylock.copy];
    }
    if (!arraylock) {
        return;
    }
    
    
    NSDictionary *dic1 = @{@"lock_id":[dicSelected objectForKey:@"lock_id"],@"app":@"userloginapp",@"act":@"wlocklog",@"token":loginModel.retval.token,@"g":[self jsonStringWithArray:arraylock]};
    
    
    
    [PPNetworkHelper  GET:kBaseUrl parameters:dic1 success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        
    } failure:^(NSError *error) {
        
    }];
    
    
    
    
    
    
}

- (void)plustouch:(NSNotification *)notification
{
    if(![notification.object isEqual:@0])
    {
        return;
    }
    if (![self.navigationController.viewControllers.lastObject isKindOfClass:[BindAdminiViewController class]]) {
        
        BindAdminiViewController *bind = [[BindAdminiViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:bind];
        [self presentViewController:nav animated:NO completion:^{
            
        }];
        
        
    }
    
    
    
}
//视图已经消失
- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"unlocksuccess" object:nil];
    [super viewDidDisappear:animated];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadLockRecord) name:@"unlocksuccess" object:nil];

    [self setNavigationUI];
    [self getLockList];
    [self uploadLocalLockRecord];
    // [self.view endEditing:YES];
    // [self setupLeftMenuButton];
    
}

-(void)setupLeftMenuButton{
    MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
    [leftDrawerButton setImage:[UIImage imageNamed:@"menu"]];
    // [leftDrawerButton setTitle:@"左侧栏"];
    self.navigationController.navigationItem.leftBarButtonItem = leftDrawerButton;
    
}
-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:^(BOOL finished) {
        
    }];
}
- (void)leftClose
{
    [_collectionView reloadData];
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        NSDictionary *dic = [LockStoreManager sharedManager].selectedLock;
        if ([dic objectForKey:@"name"]) {
            self.mm_drawerController.navigationItem.title = [dic objectForKey:@"name"];
        }
        
    }];
    
    
}
- (void)setNavigationUI
{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    
    titleLabel.textColor = [UIColor blackColor];
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    titleLabel.text = [kMultiTool getMultiLanByKey:@"home"];
    
    self.navigationItem.titleView = titleLabel;
    UIButton *leftbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
    [leftbutton setBackgroundColor:[UIColor redColor]];
    //  [leftbutton setTitle:@"左侧栏" forState:UIControlStateNormal];
    [leftbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftbutton setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    
    UIBarButtonItem * leftDrawerButton = [[UIBarButtonItem alloc] initWithCustomView:leftbutton];
    self.navigationItem.leftBarButtonItem = leftDrawerButton;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    
    
    
    self.navigationItem.titleView = leftbutton;
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    //  self.navigationController.navigationBar
    
}

#pragma mark - getter
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        //_collectionView.userInteractionEnabled = NO;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.sectionInset   = UIEdgeInsetsMake(0,0,0,0);
        layout.minimumInteritemSpacing = 0.0;
        layout.minimumLineSpacing   = 0.0;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0,64,kScreenWidth,kScreenHeight-20)collectionViewLayout:layout];
        [_collectionView registerClass:[MainIconCollectionViewCell class] forCellWithReuseIdentifier:identifier];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
        _collectionView.backgroundColor = [UIColor colorWithRed:248/255.0 green:250/255.0 blue:244/255.0 alpha:1.0];
    }
    return _collectionView;
    
    
}

#pragma mark -- UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section

{
    
    NSDictionary *dic = [LockStoreManager sharedManager].selectedLock;
    NSLog(@"dic =====%@",dic);
    _numberToshow = 0;
    if ([[dic objectForKey:@"type"] intValue]!=0) {
        return 0;
    }else{
        if ([[dic objectForKey:@"send_key"] intValue] == 1) {
            _numberToshow += 3;
        }
        
        if ([[dic objectForKey:@"user_run"] intValue] == 1) {
            _numberToshow += 2;
        }
        
    }
    
    
    return _numberToshow;
    
}

//定义展示的Section的个数

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView

{
    
    return 1;
    
}

//每个UICollectionView展示的内容

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath

{
    
    MainIconCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    NSInteger indexPathRow = [indexPath row];
    if (indexPathRow == 0) {
        [cell setImage:[UIImage imageNamed:@"sendkey"] Text:[kMultiTool getMultiLanByKey:@"sendkey"]];
    }else if (indexPathRow == 1){
        [cell setImage:[UIImage imageNamed:@"managekey"] Text:[kMultiTool getMultiLanByKey:@"managekey"]];
    }else if(indexPathRow == 2){
        if (_numberToshow==3) {
            [cell setImage:[UIImage imageNamed:@"setting"] Text:[kMultiTool getMultiLanByKey:@"setting"]];
        }else{
            [cell setImage:[UIImage imageNamed:@"adduser"] Text:[kMultiTool getMultiLanByKey:@"adduser"]];
        }
        
    }else if(indexPathRow == 3){
        [cell setImage:[UIImage imageNamed:@"manageuser"] Text:[kMultiTool getMultiLanByKey:@"manageuser"]];
    }else if (indexPathRow == 4){
        [cell setImage:[UIImage imageNamed:@"setting"] Text:[kMultiTool getMultiLanByKey:@"setting"]];
    }
    
    return cell;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    
    return CGSizeMake(kScreenWidth, kScreenHeight - 48 - 64 - 200);
    
}

//这个也是最重要的方法 获取Header的 方法。
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    
    UICollectionReusableView *supplementaryView;
    _iconImageView = [[CircleLoaderView alloc]initWithFrame:CGRectMake(0, 0, 150, 150)];
    [_iconImageView setCircleIconImage:[UIImage imageNamed:@"disconnected"]];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        supplementaryView = (UICollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
        supplementaryView.backgroundColor = [UIColor whiteColor];
        
    }
    _iconImageView.center = supplementaryView.center;
    [supplementaryView addSubview:_iconImageView];
    
    _iconImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapHeader)];
    [_iconImageView addGestureRecognizer:tap];
    
  //  [BlueToothManager sharedManager].loader = _iconImageView;
    return supplementaryView;
}

- (void)didTapHeader
{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
    LoginModel *loginModel = [LoginModel yy_modelWithJSON:dic];
    BlueToothManager *manager = [BlueToothManager sharedManager];
    // manager.loader = _iconImageView;
    manager.loginModel = loginModel;
    manager.loader = _iconImageView;
    //需要先判断有没有开锁权限
    
    if ([self canOpenLock]) {
        [manager openLock];
    }
    
    
    
    
    
}
- (BOOL)canOpenLock
{
    NSDictionary *dic = [LockStoreManager sharedManager].selectedLock;
    
    int type = [[dic objectForKey:@"type"] intValue];
    if ([PPNetworkHelper isNetwork]) {//有网
        if (type == 0){//管理员
            return YES;
        }else if (type == 1 ) { //永久
            return YES;
        }else if (type == 2 ){//临时
            int exp_type = [[dic objectForKey:@"exp_type"] intValue];
            if (exp_type == 1) {
                NSString *week = [dic objectForKey:@"week"];
                if ([week containsString:@"-1"]) {
                    if ([self dateTime:[NSDate date] isBetweenDate:[self dateTimeFromStr:[dic objectForKey:@"start_time"]] andDate:[self dateTimeFromStr:[dic objectForKey:@"end_time"]]]) {
                        return YES;
                    }else
                    {
                        [kWINDOW makeToast: [kMultiTool getMultiLanByKey:@"wuquankaisuo"]];
                        return NO;
                    }
                }
                if([week containsString:[self getWeekDayFordate:[NSDate date]]])
                {
                    if ([self dateTime:[NSDate date] isBetweenDate:[self dateTimeFromStr:[dic objectForKey:@"start_time"]] andDate:[self dateTimeFromStr:[dic objectForKey:@"end_time"]]]) {
                        return YES;
                    }else
                    {
                        [kWINDOW makeToast: [kMultiTool getMultiLanByKey:@"wuquankaisuo"]];
                        return NO;
                    }
                }
                
            }else if (exp_type==0) {
                if ([self date:[NSDate date] isBetweenDate:[self dateFromStr:[dic objectForKey:@"start_time"]] andDate:[self dateFromStr:[dic objectForKey:@"end_time"]]]) {
                    return YES;
                }else
                {
                    [kWINDOW makeToast: [kMultiTool getMultiLanByKey:@"wuquankaisuo"]];
                    return NO;
                }
            }else  if (exp_type==2 ){
                if (([[[NSUserDefaults standardUserDefaults] objectForKey:kLockUseNum] intValue] > 0)) {
                    int usenum = [[[NSUserDefaults standardUserDefaults] objectForKey:kLockUseNum] intValue]  - 1;
                    [[NSUserDefaults standardUserDefaults] setObject:@(usenum) forKey:kLockUseNum];
                    return YES;
                }else {
                    [kWINDOW makeToast: [kMultiTool getMultiLanByKey:@"wuquankaisuo"]];
                    return NO;
                    
                }
            }else{
                [kWINDOW makeToast: [kMultiTool getMultiLanByKey:@"wuquankaisuo"]];
                return NO;
            }
        }else{
            [kWINDOW makeToast: [kMultiTool getMultiLanByKey:@"wuquankaisuo"]];
            return NO;
        }
    }else{//离线开锁
        if ([[dic objectForKey:@"offline"] intValue]==1
            &&[[[NSUserDefaults standardUserDefaults] objectForKey:kLockOffNum] intValue] > 0){//离线开锁允许离线开锁
            int offnum = [[[NSUserDefaults standardUserDefaults] objectForKey:kLockOffNum] intValue]  - 1;
            [[NSUserDefaults standardUserDefaults] setObject:@(offnum) forKey:kLockOffNum];
            if (type == 0){//管理员
                return YES;
            }else if (type == 1 ) { //永久
                return YES;
            }else if (type == 2 ){//临时
                int exp_type = [[dic objectForKey:@"exp_type"] intValue];
                if (exp_type == 1) {
                    NSString *week = [dic objectForKey:@"week"];
                    if ([week containsString:@"-1"]) {
                        if ([self dateTime:[NSDate date] isBetweenDate:[self dateTimeFromStr:[dic objectForKey:@"start_time"]] andDate:[self dateTimeFromStr:[dic objectForKey:@"end_time"]]]) {
                            return YES;
                        }else
                        {
                            [kWINDOW makeToast: [kMultiTool getMultiLanByKey:@"wuquankaisuo"]];
                            return NO;
                        }
                    }
                    if([week containsString:[self getWeekDayFordate:[NSDate date]]])
                    {
                        if ([self dateTime:[NSDate date] isBetweenDate:[self dateTimeFromStr:[dic objectForKey:@"start_time"]] andDate:[self dateTimeFromStr:[dic objectForKey:@"end_time"]]]) {
                            return YES;
                        }else
                        {
                            [kWINDOW makeToast: [kMultiTool getMultiLanByKey:@"wuquankaisuo"]];
                            return NO;
                        }
                    }
                    
                }else if (exp_type==0) {
                    if ([self date:[NSDate date] isBetweenDate:[self dateFromStr:[dic objectForKey:@"start_time"]] andDate:[self dateFromStr:[dic objectForKey:@"end_time"]]]) {
                        return YES;
                    }else
                    {
                        [kWINDOW makeToast: [kMultiTool getMultiLanByKey:@"wuquankaisuo"]];
                        return NO;
                    }
                }else  if (exp_type==2 ){
                    if (([[[NSUserDefaults standardUserDefaults] objectForKey:kLockUseNum] intValue] > 0)) {
                        int usenum = [[[NSUserDefaults standardUserDefaults] objectForKey:kLockUseNum] intValue]  - 1;
                        [[NSUserDefaults standardUserDefaults] setObject:@(usenum) forKey:kLockUseNum];
                        return YES;
                    }else {
                        [kWINDOW makeToast: [kMultiTool getMultiLanByKey:@"wuquankaisuo"]];
                        return NO;
                        
                    }
                }else{
                    [kWINDOW makeToast: [kMultiTool getMultiLanByKey:@"wuquankaisuo"]];
                    return NO;
                }
            }else{
                [kWINDOW makeToast: [kMultiTool getMultiLanByKey:@"wuquankaisuo"]];
                return NO;
            }
        }else{
            [kWINDOW makeToast: [kMultiTool getMultiLanByKey:@"wuquankaisuo"]];
            return NO;
        }
    }
    
    
//    //管理员
//    if (type == 0 && [PPNetworkHelper isNetwork]) {
//        return YES;
//    }else if (type == 0 && ![PPNetworkHelper isNetwork] && [[[NSUserDefaults standardUserDefaults] objectForKey:kLockOffNum] intValue] > 0 )
//    {
//        int offnum = [[[NSUserDefaults standardUserDefaults] objectForKey:kLockOffNum] intValue]  - 1;
//        [[NSUserDefaults standardUserDefaults] setObject:@(offnum) forKey:kLockOffNum];
//        
//        return YES;
//    }else if (type == 0 && ![PPNetworkHelper isNetwork] && ([[[NSUserDefaults standardUserDefaults] objectForKey:kLockOffNum] intValue] <= 0))
//    {
//        
//        [kWINDOW makeToast: [kMultiTool getMultiLanByKey:@"wuquankaisuo"]];
//        
//        return NO;
//    }
//    
//    
//    //永久
//    if (type == 1 && [PPNetworkHelper isNetwork]) {
//        return YES;
//    }else if (type == 1 && ![PPNetworkHelper isNetwork] && [[dic objectForKey:@"offline"] boolValue] && ([[[NSUserDefaults standardUserDefaults] objectForKey:kLockOffNum] intValue] > 0))
//    {
//        int offnum = [[[NSUserDefaults standardUserDefaults] objectForKey:kLockOffNum] intValue]  - 1;
//        [[NSUserDefaults standardUserDefaults] setObject:@(offnum) forKey:kLockOffNum];
//        return YES;
//    }
//    //临时
//    if(type==2)
//    {
//        int exp_type = [[dic objectForKey:@"exp_type"] intValue];
//        if (exp_type == 1) {
//            NSString *week = [dic objectForKey:@"week"];
//            if ([week containsString:@"-1"]) {
//                if ([self dateTime:[NSDate date] isBetweenDate:[self dateTimeFromStr:[dic objectForKey:@"start_time"]] andDate:[self dateTimeFromStr:[dic objectForKey:@"end_time"]]]) {
//                    
//                    
//                    
//                    
//                    return YES;
//                }else
//                {
//                    [kWINDOW makeToast: [kMultiTool getMultiLanByKey:@"wuquankaisuo"]];
//                    return NO;
//                }
//                return NO;
//            }
//            if([week containsString:[self getWeekDayFordate:[NSDate date]]])
//            {
//                if ([self dateTime:[NSDate date] isBetweenDate:[self dateTimeFromStr:[dic objectForKey:@"start_time"]] andDate:[self dateTimeFromStr:[dic objectForKey:@"end_time"]]]) {
//                    return YES;
//                }else
//                {
//                    [kWINDOW makeToast: [kMultiTool getMultiLanByKey:@"wuquankaisuo"]];
//                    return NO;
//                }
//                
//                
//                return NO;
//            }
//            
//        }
//        if (exp_type==0) {
//            if ([self date:[NSDate date] isBetweenDate:[self dateFromStr:[dic objectForKey:@"start_time"]] andDate:[self dateFromStr:[dic objectForKey:@"end_time"]]]) {
//                return YES;
//            }else
//            {
//                [kWINDOW makeToast: [kMultiTool getMultiLanByKey:@"wuquankaisuo"]];
//                return NO;
//            }
//            
//            
//        }
//        NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:kLockUseNum]);
//        if (exp_type==2 && ([[[NSUserDefaults standardUserDefaults] objectForKey:kLockUseNum] intValue] > 0 && [PPNetworkHelper isNetwork])) {
//            int usenum = [[[NSUserDefaults standardUserDefaults] objectForKey:kLockUseNum] intValue]  - 1;
//            [[NSUserDefaults standardUserDefaults] setObject:@(usenum) forKey:kLockUseNum];
//            return YES;
//        }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:kLockUseNum] intValue] <= 0)
//        {
//            [kWINDOW makeToast: [kMultiTool getMultiLanByKey:@"wuquankaisuo"]];
//            return NO;
//            
//        }else if (![PPNetworkHelper isNetwork])
//        {
//            NSLog(@"offnum-----%@",[[NSUserDefaults standardUserDefaults] objectForKey:kLockOffNum]);
//            int offnum = [[[NSUserDefaults standardUserDefaults] objectForKey:kLockOffNum] intValue]  - 1;
//            [[NSUserDefaults standardUserDefaults] setObject:@(offnum) forKey:kLockOffNum];
//            int usenum = [[[NSUserDefaults standardUserDefaults] objectForKey:kLockUseNum] intValue]  - 1;
//            [[NSUserDefaults standardUserDefaults] setObject:@(usenum) forKey:kLockUseNum];
//            if ((offnum >= 0) && (usenum >=0) ) {
//                return YES;
//            }else{
//                [kWINDOW makeToast: [kMultiTool getMultiLanByKey:@"wuquankaisuo"]];
//                return NO;
//            }
//            
//        }
//        
//    }
    
    return NO;
}
- (NSString *)getWeekDayFordate:(NSDate*)date {
    NSArray *weekday = [NSArray arrayWithObjects: [NSNull null], @"7", @"1", @"2", @"3", @"4", @"5", @"6", nil];
    
    // NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:data];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:date];
    
    NSString *weekStr = [weekday objectAtIndex:components.weekday];
    return weekStr;
}
- (void)getLockList
{
    if (![PPNetworkHelper isNetwork]) {
        //无网络
        [self.view hideToastActivity];
        NSArray *storeLockList = [[NSUserDefaults standardUserDefaults] objectForKey:@"locklist"];
        if (storeLockList.count > 0) {
            if (![LockStoreManager sharedManager].selectedLock) {
                
                
                [LockStoreManager sharedManager].selectedLock = storeLockList[0];
                [[BlueToothManager sharedManager] cancelCheck];
                [LockStoreManager sharedManager].lockList = storeLockList.copy;
                if ([[LockStoreManager sharedManager].selectedLock objectForKey:@"name"]) {
                    self.mm_drawerController.navigationItem.title = [[LockStoreManager sharedManager].selectedLock objectForKey:@"name"];
                    //self.mm_drawerController.navigationItem.title = @"home";
                }
            }
            if ([LockStoreManager sharedManager].lockList.count == 0) {
                _nulllable.hidden = NO;
                _collectionView.hidden = !_nulllable.hidden;
            }else
            {
                _nulllable.hidden = YES;
                _collectionView.hidden = !_nulllable.hidden;
            }
            [_collectionView reloadData];
        }
        return;
    }
    NSDictionary *logindic =
    [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
    
    LoginModel *loginModel = [LoginModel yy_modelWithJSON:logindic];
    
    if (loginModel&&loginModel.retval) {
        
    
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
                if (array.count <= 0) {
                    [LockStoreManager sharedManager].selectedLock = nil;
                    self.mm_drawerController.navigationItem.title = [kMultiTool getMultiLanByKey:@"home"];
                }
                if (array.count > 0) {
                  
                    if ([LockStoreManager sharedManager].selectedLock) {
                        Boolean has=NO;
                        for (NSDictionary *dic in array) {
                            NSString * se_mac=[[LockStoreManager sharedManager].selectedLock objectForKey: @"code"];
                            NSString *mac =[dic objectForKey: @"code"];
                            if ([se_mac isEqualToString:mac]) {
                                has=YES;
                                 [LockStoreManager sharedManager].selectedLock = dic;
                                break;
                            }
                        }
                        if (has==NO) {
                            [LockStoreManager sharedManager].selectedLock = array[0];
                        }
                    }else{
                        [LockStoreManager sharedManager].selectedLock = array[0];
                    }
                    [[BlueToothManager sharedManager] cancelCheck];
                    [LockStoreManager sharedManager].lockList = array.copy;
                    if ([[LockStoreManager sharedManager].selectedLock objectForKey:@"name"]) {
                        self.mm_drawerController.navigationItem.title = [[LockStoreManager sharedManager].selectedLock objectForKey:@"name"];
                    }
                }
                if (![LockStoreManager sharedManager].lockList||[LockStoreManager sharedManager].lockList.count == 0) {
                    _nulllable.hidden = NO;
                    _collectionView.hidden = !_nulllable.hidden;
                }else
                {
                    _nulllable.hidden = YES;
                    _collectionView.hidden = !_nulllable.hidden;
                }
                [_collectionView reloadData];
                
            }
            if ([LockStoreManager sharedManager].lockList){
                for (NSDictionary *dic in [LockStoreManager sharedManager].lockList) {
                    //判断本地是否存储了offnume
                    NSString *offnumkey = [NSString stringWithFormat:@"off%@%@",kLoginModel.retval.n,[dic objectForKey:@"key_id"]];
                    NSString *usenumkey = [NSString stringWithFormat:@"use%@%@",kLoginModel.retval.n,[dic objectForKey:@"key_id"]];
//                    if(![[NSUserDefaults standardUserDefaults] objectForKey:offnumkey])
//                    {
                        [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"offline_num"] forKey:offnumkey];
                        
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
//                    }
//                    if(![[NSUserDefaults standardUserDefaults] objectForKey:usenumkey])
//                    {
                        [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"usetime"] forKey:usenumkey];
                        
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
//                    }
                }

            }
            
        } failure:^(NSError *error) {
            NSArray *storeLockList = [[NSUserDefaults standardUserDefaults] objectForKey:@"locklist"];
            if (storeLockList.count > 0) {
                if (![LockStoreManager sharedManager].selectedLock) {
                    
                    
                    [LockStoreManager sharedManager].selectedLock = storeLockList[0];
                    [[BlueToothManager sharedManager] cancelCheck];
                    [LockStoreManager sharedManager].lockList = storeLockList.copy;
                    if ([[LockStoreManager sharedManager].selectedLock objectForKey:@"name"]) {
                        self.mm_drawerController.navigationItem.title = [[LockStoreManager sharedManager].selectedLock objectForKey:@"name"];
                        //self.mm_drawerController.navigationItem.title = @"home";
                    }
                }
                if ([LockStoreManager sharedManager].lockList.count == 0) {
                    _nulllable.hidden = NO;
                    _collectionView.hidden = !_nulllable.hidden;
                }else
                {
                    _nulllable.hidden = YES;
                    _collectionView.hidden = !_nulllable.hidden;
                }
                [_collectionView reloadData];
            }
            
        }];
    
    }
    
}

//}


#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个UICollectionView的大小

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath

{
    
    return CGSizeMake(kScreenWidth/4.0,60);
    
}

//定义每个UICollectionView的 margin

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section

{
    
    return UIEdgeInsetsMake(0,0,0,0);
    
}

#pragma mark -- UICollectionViewDelegate

//UICollectionView被选中时调用的方法

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath

{
    if (indexPath.row == 0) {
        SendKeyViewController *sendkey = [[SendKeyViewController alloc]init];
        [self.navigationController pushViewController:sendkey animated:NO];
        
        
    }else if (indexPath.row == 1)
    {
        KeyManagementViewController *keymanage = [[KeyManagementViewController alloc]init];
        [self.navigationController pushViewController:keymanage animated:NO];
        
        
    }else if (indexPath.row == 2)
    {
        if (_numberToshow == 3) {
            SettingViewController *keymanage = [[SettingViewController alloc]init];
            [self.navigationController pushViewController:keymanage animated:NO];
        }else
        {
            AddUserViewController *keymanage = [[AddUserViewController alloc]init];
            [self.navigationController pushViewController:keymanage animated:NO];
        }
        
    }else if (indexPath.row == 3)
    {
        UserManagementViewController *keymanage = [[UserManagementViewController alloc]init];
        [self.navigationController pushViewController:keymanage animated:NO];
        
    }else if (indexPath.row == 4)
    {
        SettingViewController *keymanage = [[SettingViewController alloc]init];
        [self.navigationController pushViewController:keymanage animated:NO];
        
    }
    
    
    
}

#pragma mark -method 上传开锁记录

/**
 未知类型（仅限字典/数组/字符串）
 
 @param object 字典/数组/字符串
 @return 字符串
 */
-(NSString *) jsonStringWithObject:(id) object{
    NSString *value = nil;
    if (!object) {
        return value;
    }
    if ([object isKindOfClass:[NSString class]]) {
        value = [self jsonStringWithString:object];
    }else if([object isKindOfClass:[NSDictionary class]]){
        value = [self jsonStringWithDictionary:object];
    }else if([object isKindOfClass:[NSArray class]]){
        value = [self jsonStringWithArray:object];
    }
    return value;
}

/**
 字符串类型转JSON
 
 @param string 字符串类型
 @return 返回字符串
 */
-(NSString *) jsonStringWithString:(NSString *) string{
    return [NSString stringWithFormat:@"%@",
            [[string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""]
            ];
}

/**
 数组类型转JSON
 
 @param array 数组类型
 @return 返回字符串
 */
-(NSString *) jsonStringWithArray:(NSArray *)array{
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"["];
    NSMutableArray *values = [NSMutableArray array];
    for (id valueObj in array) {
        NSString *value = [self jsonStringWithObject:valueObj];
        if (value) {
            [values addObject:[NSString stringWithFormat:@"%@",value]];
        }
    }
    [reString appendFormat:@"%@",[values componentsJoinedByString:@","]];
    [reString appendString:@"]"];
    return reString;
}

/**
 字典类型转JSON
 
 @param dictionary 字典数据
 @return 返回字符串
 */
-(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary{
    NSArray *keys = [dictionary allKeys];
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"{"];
    NSMutableArray *keyValues = [NSMutableArray array];
    for (int i=0; i<[keys count]; i++) {
        NSString *name = [keys objectAtIndex:i];
        id valueObj = [dictionary objectForKey:name];
        NSString *value = [self jsonStringWithObject:valueObj];
        if (value) {
            [keyValues addObject:[NSString stringWithFormat:@"\"%@\":\"%@\"",name,value]];
        }
    }
    [reString appendFormat:@"%@",[keyValues componentsJoinedByString:@","]];
    [reString appendString:@"}"];
    return reString;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    
}


- (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSString *realStr = [formatter stringFromDate:[NSDate date]];
    date = [formatter dateFromString:realStr];
    if ([date compare:beginDate] ==NSOrderedAscending)
        return NO;
    
    if ([date compare:endDate] ==NSOrderedDescending)
        return NO;
    
    return YES;
}
- (BOOL)dateTime:(NSDate*)date1 isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    
    NSDate *date = [NSDate date]; // 获得时间对象
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone]; // 获得系统的时区
    
    NSTimeInterval time = [zone secondsFromGMTForDate:date];// 以秒为单位返回当前时间与系统格林尼治时间的差
    
    NSDate *dateNow = [date dateByAddingTimeInterval:time];
    if ([dateNow compare:beginDate] == NSOrderedAscending)
    {
        return NO;
    }
    
    if ([dateNow compare:endDate] ==NSOrderedDescending)
    {
        return NO;
    }
    
    return YES;
}

- (NSDate *)dateFromStr:(NSString *)str
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    //NSString转NSDate
    NSDate *date=[formatter dateFromString:str];
    
    return date;
    
}
- (NSDate *)dateTimeFromStr:(NSString *)str
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //NSString转NSDate
    formatter.timeZone =  [NSTimeZone systemTimeZone];
    NSString *nowStr = [formatter stringFromDate:[NSDate date]];
    nowStr = [NSString stringWithFormat:@"%@ %@",nowStr,str];
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init] ;
    [formatter1 setDateFormat:@"yyyy-MM-dd HH:mm"];
    formatter1.timeZone =  [NSTimeZone systemTimeZone];
    NSDate *date1 = [formatter1 dateFromString:nowStr];
    NSLog(@"%@",date1);
    NSTimeZone *zone = [NSTimeZone systemTimeZone]; // 获得系统的时区
    
    NSTimeInterval time = [zone secondsFromGMTForDate:date1];// 以秒为单位返回当前时间与系统格林尼治时间的差
    
    NSDate *dateNow = [date1 dateByAddingTimeInterval:time];
    return dateNow;
}



@end

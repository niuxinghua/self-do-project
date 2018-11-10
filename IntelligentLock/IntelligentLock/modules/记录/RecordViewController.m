//
//  RecordViewController.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/1/30.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "RecordViewController.h"
#import "Masonry.h"
#import "Const.h"
#import "LoginModel.h"
#import "RecordTableViewCell.h"
#import "LockStoreManager.h"
#import "BindAdminiViewController.h"
#import "BlueToothManager.h"
#import "RecordHeaderView.h"
#import "MJRefresh.h"
static int const PageSize = 20;

#define kRecordUpdateTime [NSString stringWithFormat:@"lastupdatetime%@%@",kLoginModel.retval.n,[kdicSelected objectForKey:@"key_id"]]
#define kMaxATime [NSString stringWithFormat:@"maxatime%@%@",kLoginModel.retval.n,[kdicSelected objectForKey:@"key_id"]]
#define kRecordListKey [NSString stringWithFormat:@"%@%@",kLoginModel.retval.n,[kdicSelected objectForKey:@"key_id"]]

@interface RecordViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)NSMutableArray *dataList;

@property (nonatomic,strong)RecordHeaderView *headView;

@property (nonatomic,assign)NSInteger currentIndex;

@property (nonatomic,strong)NSMutableArray *dataListToshow;


@end

@implementation RecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    //self.title = @"记录";
    self.navigationItem.title = [kMultiTool getMultiLanByKey:@"record"];
    
    _headView = [[RecordHeaderView alloc]init];
    [self.view addSubview:_headView];
    
    [self.view addSubview:self.tableView];
    [self makeConstrains];
    _dataListToshow = [[NSMutableArray alloc]init];
    _dataList = [[NSMutableArray alloc]init];
    _currentIndex = 1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(plustouch:) name:@"didtapplus" object:nil];
    [self.navigationController setNavigationBarHidden:YES];
    NSDictionary *dicSelected = [LockStoreManager sharedManager].selectedLock;
//    NSString *time = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"lastupdatetime%@%@",kLoginModel.retval.n,[dicSelected objectForKey:@"key_id"]]];
    NSString *time = [[NSUserDefaults standardUserDefaults] objectForKey:kRecordUpdateTime];
    if (!time) {
        time = [kMultiTool getMultiLanByKey:@"lastupdatetime"];
    }
    [_headView setLableText:time];
    
    _headView.synckBlock = ^{
         NSDictionary *dicSelected = [LockStoreManager sharedManager].selectedLock;
        if (dicSelected!=nil&&[[dicSelected objectForKey:@"type"]integerValue]==0) {
            [kWINDOW  makeToastActivity:CSToastPositionCenter];
            [[BlueToothManager sharedManager] getLockLogs];

        }else{
             [self getData];
        }
               // [self getData];
    };
    
    _headView.clearBlock = ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[kMultiTool getMultiLanByKey:@"qingchujilutishi"] message:nil preferredStyle:UIAlertControllerStyleAlert];
        alert.popoverPresentationController.sourceView = self.view;
        alert.popoverPresentationController.sourceRect = CGRectMake(0, 0, 1.0, 1.0);
       
        UIAlertAction * takingPicAction = [UIAlertAction actionWithTitle:[kMultiTool getMultiLanByKey:@"queding"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kRecordListKey];
            _dataList = [NSMutableArray new];
            _currentIndex = 1;
            _dataListToshow = @[].mutableCopy;
            [_tableView reloadData];
        }];
        [alert addAction:takingPicAction];
        [alert addAction:[UIAlertAction actionWithTitle:[kMultiTool getMultiLanByKey:@"cancell"] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            
        }]];
        [self.navigationController presentViewController:alert animated:NO completion:^{
            
        }];
       
    };
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _currentIndex = 1;
        [self getData];
    }];
    
  
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        //Call this Block When enter the refresh status automatically
        [self footMethod];
    }];
//    self.tableView.mj_footer = [MJRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(footMethod)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getLockrecord:) name:@"getlockrecord" object:nil];
   
    
}

- (void)footMethod
{
    
    
    _currentIndex ++;
    if (_dataList.count >= _currentIndex * PageSize) {
        _dataListToshow = [_dataList subarrayWithRange:NSMakeRange(0, _currentIndex * PageSize - 1)].mutableCopy;
    }else
    {
        _dataListToshow = _dataList;
        
    }
    [self.tableView reloadData];
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
}
- (void)getLockrecord:(NSNotification *)notification
{
    //将蓝牙里面的记录上传服务器
    [kWINDOW hideToastActivity];
  //  NSMutableDictionary *notificationdic = notification.object;
    NSDictionary *logindic =
    [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
    
    LoginModel *loginModel = [LoginModel yy_modelWithJSON:logindic];
    NSDictionary *dicSelected = [LockStoreManager sharedManager].selectedLock;
    NSMutableArray *muArray = [[NSMutableArray alloc]init];
//    for (NSString *key in notificationdic.allKeys) {
//        NSMutableDictionary *dicm ;
//        if (![key isEqualToString:@"uuid"]) {
//            dicm = @{@"time":key,@"type":[notificationdic objectForKey:key],@"uid":loginModel.retval.user_id,@"key_id":[dicSelected objectForKey:@"key_id"]}.mutableCopy;
//        }
//    }
//    [dicm setObject:[notificationdic objectForKey:@"uuid"] forKey:@"uuid"];
//    [muArray addObject:dicm.copy];
   
    NSArray *dataArray = notification.object;
    for (NSDictionary *dicobj in dataArray) {
        NSDictionary *dicm = @{@"time":[dicobj objectForKey:@"time"],@"type":[dicobj objectForKey:@"type"],@"uuid":[dicobj objectForKey:@"uuid"],@"uid":loginModel.retval.user_id,@"key_id":[dicSelected objectForKey:@"key_id"]};
        [muArray addObject:dicm];
    }
    NSString *kLockResultKey= [NSString stringWithFormat:@"%@%@",kLoginModel.retval.n,[kdicSelected objectForKey:@"lock_id"]];
    NSMutableArray *arraylock = [[NSUserDefaults standardUserDefaults] objectForKey:kLockResultKey];
    if (arraylock && arraylock.count) {
        [muArray addObjectsFromArray:arraylock.copy];
    }
    
            //time开锁时间，type开锁类型(蓝牙开锁5)，uuid蓝牙开锁穿0，uid用户id,keyid钥匙id,exp_type跟锁列表返回的一样
        
            
            NSDictionary *dic1 = @{@"lock_id":[dicSelected objectForKey:@"lock_id"],@"app":@"userloginapp",@"act":@"wlocklog",@"token":loginModel.retval.token,@"g":[self jsonStringWithArray:muArray]};
            
            
            
            [PPNetworkHelper  GET:kBaseUrl parameters:dic1 success:^(id responseObject) {
                NSLog(@"%@",responseObject);
                [self getData];
            } failure:^(NSError *error) {
                [self getData];
            }];
            
        
        
        
    
    
}

- (void)plustouch:(NSNotification *)notification
{
    if (![notification.object isEqual:@1]) {
        return;
    }
    if (![self.navigationController.viewControllers.lastObject isKindOfClass:[BindAdminiViewController class]]) {
        
        BindAdminiViewController *bind = [[BindAdminiViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:bind];
        [self presentViewController:nav animated:NO completion:^{
            
        }];
        
        
    }
    
    
    

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   // _currentIndex = 1;
     [self getLocalData];
    [self.navigationController setNavigationBarHidden:YES];
    // [[BlueToothManager sharedManager] getLockLogs];
}

- (void)makeConstrains
{
    [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.mas_topLayoutGuide);
        make.height.equalTo(@80);
        
    }];
    
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(_headView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
        
        
    }];
    
    
}
- (void)getLocalData
{
    _currentIndex = 1;
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:kRecordListKey] isEqual:[NSNull null]]) {
        NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:kRecordListKey];
        _dataList = [self stringToJSON:str].copy;
        [[_dataList reverseObjectEnumerator] allObjects];
        if (_dataList.count > PageSize * _currentIndex) {
            _dataListToshow = [_dataList subarrayWithRange:NSMakeRange(0, PageSize * _currentIndex - 1)].mutableCopy;
        }else {
            _dataListToshow = _dataList;
            
        }
        [_tableView reloadData];
        
        [_tableView reloadData];
    }
    NSString *time = [[NSUserDefaults standardUserDefaults] objectForKey:kRecordUpdateTime];
    if (!time) {
        time = [kMultiTool getMultiLanByKey:@"lastupdatetime"];
    }
    [_headView setLableText:time];
    
}
- (void)getData
{
    
//    锁记录
    
    _currentIndex = 1;
    NSDictionary *lock = [LockStoreManager sharedManager].selectedLock;
    if (!lock) {
        
        [_tableView.mj_footer endRefreshing];
        [_tableView.mj_header endRefreshing];
        kWINDOW.userInteractionEnabled = YES;
        return;
    }
    NSDictionary *logindic =
    [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
    NSDictionary *dicSelected = [LockStoreManager sharedManager].selectedLock;
    NSString *timeStr = [[NSUserDefaults standardUserDefaults] objectForKey:kRecordUpdateTime];
    if (!timeStr) {
        timeStr = @"";
    }
    [_headView setLableText:timeStr];
    
    NSLog(@"%@",timeStr);
    
//    int log_id=0;
    NSString *add_time = [[NSUserDefaults standardUserDefaults] objectForKey:kMaxATime];

//    if (![[[NSUserDefaults standardUserDefaults] objectForKey:kRecordListKey] isEqual:[NSNull null]]) {
//        NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:kRecordListKey];
//        NSMutableArray *dataList1 = [self stringToJSON:str].copy;
//        if (dataList1!=nil) {
//            int count = dataList1.count;//减少调用次数
//            for( int i=0; i<count; i++){
//                NSDictionary *dic=[dataList1 objectAtIndex:i];
//                int g_id=[[dic objectForKey:@"log_id"] integerValue];
//                if (g_id>log_id) {
//                    log_id=g_id;
//                    add_time=[dic objectForKey:@"a_time"];
//                }
//            }
//        }
//    }

    if (!add_time) {
        add_time = @"";
    }
    
    LoginModel *loginModel = [LoginModel yy_modelWithJSON:logindic];
    NSDictionary *dic = @{@"app":@"userloginapp",@"act":@"unlock_log",@"token":loginModel.retval.token,@"add_time": add_time,@"lock_id":[lock objectForKey:@"lock_id"]};
    [self.view makeToastActivity:CSToastPositionCenter];
    [PPNetworkHelper GET:kBaseUrl parameters:dic success:^(id responseObject) {
        if (_dataList.count) {
            _dataList = @[].mutableCopy;
        }
        
        [self.view hideToastActivity];
        NSArray *array;
        if ([responseObject objectForKey:@"retval"] && ![[responseObject objectForKey:@"retval"] isEqual:[NSNull null]]) {
          array =[[[responseObject objectForKey:@"retval"] reverseObjectEnumerator] allObjects];
            if (![array isEqual:[NSNull null]] && array.count) {
              
            }
            [self setNewUpdateTime];
        }
       _dataList = [NSMutableArray arrayWithArray:array];
        if (![[[NSUserDefaults standardUserDefaults] objectForKey:kRecordListKey] isEqual:[NSNull null]]) {
            NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:kRecordListKey];
            if (str.length) {
                NSArray *array = [self stringToJSON:str];

                for (int i=0; i<array.count; i++) {
                    NSDictionary *dic = array[i];
                    if (![_dataList containsObject:dic]) {
                        [_dataList addObject:dic];
                    }
                }
                 [[NSUserDefaults standardUserDefaults] setObject:add_time forKey:kMaxATime];
            }
            [[_dataList reverseObjectEnumerator] allObjects];
            [_tableView reloadData];
        }
        if (_dataList) {
        
            int log_id=0;
            NSString *add_time=@"";
        
            for (int i=0; i<array.count; i++) {
                NSDictionary *dic = array[i];
                int g_id=[[dic objectForKey:@"log_id"] integerValue];
                if (g_id>log_id) {
                    log_id=g_id;
                    add_time=[dic objectForKey:@"a_time"];
                }
                
            }
            [[NSUserDefaults standardUserDefaults] setObject:add_time forKey:kMaxATime];
            
        }
        [[NSUserDefaults standardUserDefaults] setObject:[self jsonStringWithArray:_dataList] forKey:kRecordListKey];
        [[_dataList reverseObjectEnumerator] allObjects];
        if (_dataList.count > PageSize * _currentIndex) {
            _dataListToshow = [_dataList subarrayWithRange:NSMakeRange(0, PageSize * _currentIndex - 1)].mutableCopy;
        }else {
            _dataListToshow = _dataList;
        
        }
        [_tableView reloadData];
      
        [self.tableView.mj_header endRefreshing];
       
    } failure:^(NSError *error) {
        if (![[[NSUserDefaults standardUserDefaults] objectForKey:kRecordListKey] isEqual:[NSNull null]]) {
            NSString *str = [[NSUserDefaults standardUserDefaults] objectForKey:kRecordListKey];
            _dataList = [self stringToJSON:str].copy;
            [[_dataList reverseObjectEnumerator] allObjects];
            if (_dataList.count > PageSize * _currentIndex) {
                _dataListToshow = [_dataList subarrayWithRange:NSMakeRange(0, PageSize * _currentIndex  -1)].mutableCopy;
            }else {
                _dataListToshow = _dataList;
                
            }
            [_tableView reloadData];
            
            [_tableView reloadData];
        }
        [self.view hideToastActivity];
       [self.tableView.mj_header endRefreshing];
    }];
    
}
- (void)setNewUpdateTime
{
    
    NSDictionary *dicSelected = [LockStoreManager sharedManager].selectedLock;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *timeStr1 = [formatter stringFromDate:[NSDate date]];
    [[NSUserDefaults standardUserDefaults] setObject:timeStr1 forKey:kRecordUpdateTime];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [_headView setLableText:timeStr1];

    
}
#pragma mark UI getters

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[RecordTableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    
    return  _tableView;
}
#pragma mark-tableview delegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}



#pragma mark-datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(!_dataListToshow)
    {
        return 0;
        
    }
    if (_dataListToshow && _dataListToshow.count && ![_dataListToshow isEqual:[NSNull null]]) {
        return _dataListToshow.count;
    }
    return 0;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RecordTableViewCell* cell=[[RecordTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    if (_dataListToshow && _dataListToshow.count) {
        NSDictionary *dic = _dataListToshow[indexPath.row];
        cell.dic = dic;
    }
 
    return cell;
    
}







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

- (NSArray *)stringToJSON:(NSString *)jsonStr {
    if (jsonStr) {
        id tmp = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments | NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
        
        if (tmp) {
            if ([tmp isKindOfClass:[NSArray class]]) {
                
                return tmp;
                
            } else if([tmp isKindOfClass:[NSString class]]
                      || [tmp isKindOfClass:[NSDictionary class]]) {
                
                return [NSArray arrayWithObject:tmp];
                
            } else {
                return nil;
            }
        } else {
            return nil;
        }
        
    } else {
        return nil;
    }
}
@end

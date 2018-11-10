//
//  AddUserViewController.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/2/22.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "AddUserViewController.h"
#import "AddUserHeaderView.h"
#import "Masonry.h"
#import "AddUserTextView.h"
#import "BlueToothManager.h"
@interface AddUserViewController ()

@property (nonatomic,strong)AddUserHeaderView *headerView;
@property (nonatomic,strong)AddUserTextView *textView1;
@property (nonatomic,strong)AddUserTextView *textView2;
@property (nonatomic,strong)AddUserTextView *textView3;
@property (nonatomic,strong)UIButton *confirmButton;

@property (nonatomic,assign)int sn;

@property (nonatomic,strong)UILabel *textLable;

@end

@implementation AddUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationUI];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.textView1];
   // [self.view addSubview:self.textView2];
    [self.view addSubview:self.textView3];
    [self.view addSubview:self.confirmButton];
    _textLable = [[UILabel alloc]init];
    _textLable.numberOfLines = 0;
    [_textLable setText:[kMultiTool getMultiLanByKey:@"tianjiayonghubeizhu"]];
    _textLable.textColor = [UIColor grayColor];
    _textLable.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_textLable];
    
    [self makeConstrains];
  
    
}
- (void)viewDidAppear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addUser:) name:@"lockadduser" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(modifyUser:) name:@"lockmodifyuser" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteUser:) name:@"lockdeleteuser" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearUser:) name:@"lockclearuser" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reset:) name:@"lockreset" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nodata:) name:@"locknodata" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterset) name:@"enterset" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploaduser) name:@"addusersuccess" object:nil];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"lockadduser" object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"lockmodifyuser" object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"lockdeleteuser" object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"lockclearuser" object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"lockreset" object:nil];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"enterset" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"locknodata" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"addusersuccess" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)enterset
{
    kWINDOW.userInteractionEnabled = NO;
    [kWINDOW makeToast:[kMultiTool getMultiLanByKey:@"jinrushezhichenggong"] duration:2*60 position:CSToastPositionCenter];
     [self performSelector:@selector(reset) withObject:nil afterDelay:2*60];
}
- (void)reset
{
    [kWINDOW makeToast:[kMultiTool getMultiLanByKey:@"caozuoshibai"] duration:2 position:CSToastPositionCenter];
    kWINDOW.userInteractionEnabled = YES;
}
- (void)addUser:(NSNotification *)notification
{
   
    NSDictionary *dicm = notification.object;
    NSDictionary *selectDic = [LockStoreManager sharedManager].selectedLock;
    NSDictionary *userDic = notification.object;
    NSDictionary *logindic =
    [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
    LoginModel *loginModel = [LoginModel yy_modelWithJSON:logindic];
    NSDictionary *dicm1 = @{@"lock_id":[selectDic objectForKey:@"lock_id"],@"sn":[NSString stringWithFormat:@"%@",[dicm objectForKey:@"userType"]],@"type":[NSString stringWithFormat:@"%@",[dicm objectForKey:@"userType"]],@"tag":[kMultiTool getMultiLanByKey:@"moren"],@"note":[NSString stringWithFormat:@"%@%@",[kMultiTool getMultiLanByKey:@"moren"],[dicm objectForKey:@"userCode"]]};
    NSArray *arraym1 = @[dicm1];
    [kWINDOW makeToastActivity:CSToastPositionCenter];
    
    NSDictionary *dic = @{@"app":@"userloginapp",@"token":loginModel.retval.token,@"act":@"add",@"g":[self jsonStringWithArray:arraym1]};
    
    @WeakSelf(self);
    [PPNetworkHelper GET:kBaseUrl parameters:dic success:^(id responseObject) {
        [kWINDOW hideToastActivity];
        [kWINDOW makeToast:[responseObject objectForKey:@"msg"]];
        if ([[responseObject objectForKey:@"done"] intValue]) {
            
            [[BlueToothManager sharedManager]syncBlueTooth];
        }
    } failure:^(NSError *error) {
        [kWINDOW hideToastActivity];
    }];
    
    
    

    
    
}

- (void)uploaduser
{
    __block int type = _headerView.currentIndex;
//    if (type == 1) {
//        type = 2;
//    }else if (type==2) {
//        type = 1;
//    }
   // NSDictionary *dicm = notification.object;
    NSDictionary *selectDic = [LockStoreManager sharedManager].selectedLock;
   // NSDictionary *userDic = notification.object;
    NSDictionary *logindic =
    [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
    LoginModel *loginModel = [LoginModel yy_modelWithJSON:logindic];
    NSDictionary *dicm1 = @{@"lock_id":[selectDic objectForKey:@"lock_id"],@"sn":[NSString stringWithFormat:@"%d",_sn],@"type":[NSString stringWithFormat:@"%d",type],@"tag":[_textView1 getText],@"note":[_textView3 getText]};
    NSArray *arraym1 = @[dicm1];
    [kWINDOW makeToastActivity:CSToastPositionCenter];
    
    NSDictionary *dic = @{@"app":@"userloginapp",@"token":loginModel.retval.token,@"act":@"add",@"g":[self jsonStringWithArray:arraym1]};
    
    @WeakSelf(self);
    [PPNetworkHelper GET:kBaseUrl parameters:dic success:^(id responseObject) {
        [kWINDOW hideToastActivity];
        [kWINDOW makeToast:[responseObject objectForKey:@"msg"]];
        if ([[responseObject objectForKey:@"done"] intValue]) {
            self.navigationController.navigationBar.hidden = YES;
            [self.navigationController popViewControllerAnimated:NO];
            
        }
    } failure:^(NSError *error) {
        [kWINDOW hideToastActivity];
    }];
    
    
    
    
}

- (void)modifyUser:(NSNotification *)notification
{
   [[BlueToothManager sharedManager]syncBlueTooth];
    
}
- (void)deleteUser:(NSNotification *)notification
{
  
    NSDictionary *dicm = notification.object;
    NSDictionary *selectDic = [LockStoreManager sharedManager].selectedLock;
    NSDictionary *userDic = notification.object;
    NSDictionary *logindic =
    [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
    LoginModel *loginModel = [LoginModel yy_modelWithJSON:logindic];
    NSDictionary *dic = @{@"lock_id":[selectDic objectForKey:@"lock_id"],@"sn":[dicm objectForKey:@"userCode"],@"type":[dicm objectForKey:@"userType"],@"act":@"drop",@"token":loginModel.retval.token};
     [kWINDOW makeToastActivity:CSToastPositionCenter];
    @WeakSelf(self);
    [PPNetworkHelper GET:kBaseUrl parameters:dic success:^(id responseObject) {
        [kWINDOW hideToastActivity];
        [kWINDOW makeToast:[responseObject objectForKey:@"msg"]];
        if ([[responseObject objectForKey:@"done"] intValue]) {
           [[BlueToothManager sharedManager]syncBlueTooth];
            
        }
    } failure:^(NSError *error) {
        [kWINDOW hideToastActivity];
    }];
    

    
    
}
- (void)clearUser:(NSNotification *)notification
{

    
    NSDictionary *dicm = notification.object;
    NSDictionary *selectDic = [LockStoreManager sharedManager].selectedLock;
    NSDictionary *userDic = notification.object;
    NSDictionary *logindic =
    [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
    LoginModel *loginModel = [LoginModel yy_modelWithJSON:logindic];
    NSDictionary *dic = @{@"app":@"userloginapp",@"id":[selectDic objectForKey:@"lock_id"],@"act":@"dropLock",@"token":loginModel.retval.token};
     [kWINDOW makeToastActivity:CSToastPositionCenter];
    @WeakSelf(self);
    [PPNetworkHelper GET:kBaseUrl parameters:dic success:^(id responseObject) {
        [kWINDOW hideToastActivity];
        [kWINDOW makeToast:[responseObject objectForKey:@"msg"]];
        if ([[responseObject objectForKey:@"done"] intValue]) {
           [[BlueToothManager sharedManager]syncBlueTooth];
            
        }
    } failure:^(NSError *error) {
        [kWINDOW hideToastActivity];
    }];
    
    
}
- (void)reset:(NSNotification *)notification
{
    [self clearUser:notification];
    
}
- (void)nodata:(NSNotification *)notification
{
    NSDictionary *selectDic = [LockStoreManager sharedManager].selectedLock;
    NSDictionary *userDic = notification.object;
    NSDictionary *logindic =
    [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
   __block int type = _headerView.currentIndex;
//    if (type == 1) {
//        type = 2;
//    }else if (type==2) {
//        type = 1;
//    }
    LoginModel *loginModel = [LoginModel yy_modelWithJSON:logindic];
    NSDictionary *dic = @{@"id":[selectDic objectForKey:@"lock_id"],@"act":@"getSn",@"token":loginModel.retval.token,@"type":@(type),@"app":@"userloginapp"};
     [kWINDOW makeToastActivity:CSToastPositionCenter];
    @WeakSelf(self);
    [PPNetworkHelper GET:kBaseUrl parameters:dic success:^(id responseObject) {
       // [kWINDOW hideToastActivity];
        //[kWINDOW makeToast:[responseObject objectForKey:@"msg"]];
        if ([[responseObject objectForKey:@"done"] intValue]) {
            NSDictionary *dic = [responseObject objectForKey:@"retval"];
            weakSelf.sn = [[dic objectForKey:@"cid"]intValue];
           
            [[BlueToothManager sharedManager] addorDeleteUser:[[dic objectForKey:@"cid"]intValue] isAdd:YES type:type];
            
        }
    } failure:^(NSError *error) {
       // [kWINDOW makeToast:error.description];
        [kWINDOW hideToastActivity];
    }];


    
}

- (void)makeConstrains
{
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(@120);
        
    }];
    [_textView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(_headerView.mas_bottom);
        make.height.equalTo(@50);
    }];
    [_textView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(_textView1.mas_bottom);
        make.height.equalTo(@50);
    }];
    
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self.view);
        make.width.equalTo(@120);
        make.top.equalTo(self.textView3.mas_bottom).offset(60);
        make.height.equalTo(@40);
        
    }];
    [_textLable mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.equalTo(@80);
        
        
    }];
    
    
}


- (void)setNavigationUI
{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    
    titleLabel.textColor = [UIColor whiteColor];
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    titleLabel.text = [kMultiTool getMultiLanByKey:@"adduser"];
    
    self.navigationItem.titleView = titleLabel;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbackimage"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem uc_backBarButtonItemWithAction:^{
        
        // self.navigationController.navigationBar.hidden = YES;
        [self.navigationController popViewControllerAnimated:NO];
        
    }];
    
}

#pragma mark -UI getters

- (AddUserHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[AddUserHeaderView alloc]init];
        NSDictionary *dic = [LockStoreManager sharedManager].selectedLock;
        NSMutableArray *array = [[NSMutableArray alloc]init];
        if ([[dic objectForKey:@"fingerprint"]integerValue]) {
            [array addObject:@1];
        }else
        {
            [array addObject:@0];
        }
        if ([[dic objectForKey:@"pwd"]integerValue]) {
            [array addObject:@1];
        }else
        {
            [array addObject:@0];
        }
        if ([[dic objectForKey:@"iccard"]integerValue]) {
            [array addObject:@1];
        }else
        {
            [array addObject:@0];
        }
        if ([[dic objectForKey:@"remote"]integerValue]) {
            [array addObject:@1];
        }else
        {
            [array addObject:@0];
        }
        _headerView.enableList = array;
        
    }
    
    return  _headerView;
    
}

- (AddUserTextView *)textView1
{
    
    if (!_textView1) {
        _textView1 = [[AddUserTextView alloc]init];
        [_textView1 setLeftText:[kMultiTool getMultiLanByKey:@"nickname"]];
    }
    return _textView1;
}

- (AddUserTextView *)textView2
{
    
    if (!_textView2) {
        _textView2 = [[AddUserTextView alloc]init];
        [_textView2 setLeftText:[kMultiTool getMultiLanByKey:@"code"]];
    }
    return _textView2;
}

- (AddUserTextView *)textView3
{
    
    if (!_textView3) {
        _textView3 = [[AddUserTextView alloc]init];
        [_textView3 setLeftText:[kMultiTool getMultiLanByKey:@"info"]];
    }
    return _textView3;
}

- (UIButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [[UIButton alloc]init];
        [_confirmButton setBackgroundImage:[UIImage imageNamed:@"navbackimage"] forState:UIControlStateNormal];
        [_confirmButton setTitle:[kMultiTool getMultiLanByKey:@"adduser"] forState:UIControlStateNormal];
        _confirmButton.layer.cornerRadius = 20;
        _confirmButton.layer.masksToBounds = YES;
        [_confirmButton addTarget:self action:@selector(confirmclick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _confirmButton;
}

- (void)confirmclick
{
    if (_headerView.currentIndex == 0) {
        
        [kWINDOW makeToast:[kMultiTool getMultiLanByKey:@"xuanzeleixing"]];
        
        return;
    }
    
    if (![_textView1 getText].length) {
        [kWINDOW makeToast:[kMultiTool getMultiLanByKey:@"shurunicheng"]];
        return;
    }
    if (![_textView3 getText].length) {
        [kWINDOW makeToast:[kMultiTool getMultiLanByKey:@"qingshurubeizhu"]];
        return;
    }
    [kWINDOW makeToastActivity:CSToastPositionCenter];
    [[BlueToothManager sharedManager] syncBlueTooth];
    
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
@end

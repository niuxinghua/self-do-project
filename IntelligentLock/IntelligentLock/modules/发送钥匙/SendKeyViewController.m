



#import "SendKeyViewController.h"
#import "UIBarButtonItem+UC.h"
#import "SendKeyTextView.h"
#import "Masonry.h"
#import "SendKeyBottomView.h"
#import "UCQRCodeViewController.h"
#import "BlueToothManager.h"
#import "PPNetworkHelper.h"
#import "LockStoreManager.h"
#import "Const.h"

@interface SendKeyViewController ()

@property (nonatomic,strong)SendKeyTextView *keyTypeView;

@property (nonatomic,strong)SendKeyTextView *keyAccountView;

@property (nonatomic,strong)SendKeyTextView *keyInfoView;


@property (nonatomic,strong)SendKeyTextView *offlineView;

@property (nonatomic,strong)SendKeyTextView *messageView;

@property (nonatomic,strong)UIButton *sendButton;

@property (nonatomic,strong)SendKeyBottomView *bottomView;

@property (nonatomic,assign)BOOL isPermanent;
@property (nonatomic,assign)BOOL isOffline;
@property (nonatomic,assign)BOOL isMessage;

@property (nonatomic,strong)NSDictionary *scanDic;

@end

@implementation SendKeyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationUI];
    [self.view addSubview:self.keyTypeView];
    [self.view addSubview:self.keyAccountView];
    [self.view addSubview:self.keyInfoView];
    [self.view addSubview:self.offlineView];
//    [self.view addSubview:self.messageView];
    [self.view addSubview:self.sendButton];
    [self.view addSubview:self.bottomView];
    _isPermanent = YES;
    [self makeConstrians];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(success) name:@"addkeysuccess" object:nil];
    
}
- (void)viewDidDisappear:(BOOL)animated

{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark private methods

- (void)makeConstrians
{
    [self.keyTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top);
        make.height.equalTo(@60);
    }];
    
    [self.keyAccountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.keyTypeView.mas_bottom);
        make.height.equalTo(@60);
    }];
    [self.keyInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.keyAccountView.mas_bottom);
        make.height.equalTo(@60);
    }];
    [self.offlineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.keyInfoView.mas_bottom);
        make.height.equalTo(@60);
    }];
//    [self.messageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self.view);
//        make.top.equalTo(self.offlineView.mas_bottom);
//        make.height.equalTo(@60);
//    }];
    
    if (!_isPermanent) {
        [self.sendButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view.mas_bottom);
            make.height.equalTo(@60);
        }];
        [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.left.equalTo(self.view);
            make.top.equalTo(self.offlineView.mas_bottom);
            make.bottom.equalTo(self.sendButton.mas_top);
        }];
        self.bottomView.hidden = NO;
        
        
        
    }else
    {
        self.bottomView.hidden = YES;
        [self.sendButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.mas_bottomLayoutGuide);
            make.height.equalTo(@60);
        }];
        
    }
    
    
    
}
-(NSString *)dictToJsonStr:(NSDictionary *)dict{
    
    //    NSMutableDictionary *dict = [NSMutableDictionary new];
    //    [dict setObject:@"" forKey:@"AWL_LAN"];
    //    [dict setObject:@"" forKey:@"AWL_LON"];
    //    [dict setObject:@"1"  forKey:@"U_ID"];
    NSString *jsonString = nil;
    if ([NSJSONSerialization isValidJSONObject:dict])
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
        jsonString =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //NSLog(@"json data:%@",jsonString);
        if (error) {
            NSLog(@"Error:%@" , error);
        }
    }
    return jsonString;
}
- (void)success
{
    
    //  永久 usetime传0 临时传输入次数传次数没有穿哦
    // exp 永久传空 临时时间段传json数组。次数的都传空。
    //type 永久 @“yong” 临时 @“lin”
    NSDictionary *dic1 = [LockStoreManager sharedManager].selectedLock;
    NSDictionary *logindic =
    [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
    LoginModel *loginModel = [LoginModel yy_modelWithJSON:logindic];
    NSDictionary *paraDic;
    if (_isPermanent) {
        paraDic = @{
                    @"token":loginModel.retval.token,
                    @"exp":@"",
                    @"tel":[_keyAccountView getText],
                    @"usetime":@"0",
                    @"type":@"yong",
                    @"phoneMac":[_scanDic objectForKey:@"bluemac"],
                    @"app" : @"userloginapp",
                    @"act" : @"add_key",
                    @"remark":_keyInfoView.textFeild.text?_keyInfoView.textFeild.text:loginModel.retval.n,
                    @"offline":@(_isOffline),
                    @"send":@(_isMessage),
                    @"lock_id":[dic1 objectForKey:@"lock_id"]
                    };
        
    }else
    {
        if (_bottomView.currentType == tempBottomTypeTime) {
            if (!self.keyAccountView.textFeild.text.length)
            {
                [kWINDOW makeToast:[kMultiTool getMultiLanByKey:@"shoujihaobudui"]];
                return;
            }
            if (!self.keyInfoView.textFeild.text.length)
            {
                [kWINDOW makeToast:[kMultiTool getMultiLanByKey:@"qingshurubeizhu"]];
                return;
            }
            
            if (!_bottomView.timeView.startTime ) {
                [kWINDOW makeToast:[kMultiTool getMultiLanByKey:@"shurukaishishijian"]];
                return;
            }
            if ( !_bottomView.timeView.endTime) {
                [kWINDOW makeToast:[kMultiTool getMultiLanByKey:@"shurujieshushijian"]];
                return;
            }
            NSDictionary *expdic = @{@"s":_bottomView.timeView.startTime,@"e":_bottomView.timeView.endTime};
            NSArray *expArray = @[expdic];
            paraDic = @{
                        @"token":loginModel.retval.token,
                        @"exp":[self jsonStringWithArray:expArray],
                        @"tel":[_keyAccountView getText],
                        @"usetime":@"-1",
                        @"type":@"lin",
                        @"phoneMac":loginModel.retval.bluemac,
                        @"app" : @"userloginapp",
                        @"act" : @"add_key",
                        @"remark":_keyInfoView.textFeild.text?_keyInfoView.textFeild.text:loginModel.retval.n,
                        @"offline":@(_isOffline),
                        @"send":@(_isMessage),
                        @"lock_id":[dic1 objectForKey:@"lock_id"]
                        };
            
            
            
            
        }else if (_bottomView.currentType == tempBottomTypeAlert)
        {
            [_bottomView.alarmView getDayJson];
            if (!self.keyAccountView.textFeild.text.length)
            {
                [kWINDOW makeToast:[kMultiTool getMultiLanByKey:@"shoujihaobudui"]];
                return;
            }
            if (!self.keyInfoView.textFeild.text.length)
            {
                [kWINDOW makeToast:[kMultiTool getMultiLanByKey:@"qingshurubeizhu"]];
                return;
            }
            
            if (!_bottomView.alarmView.timeView.startTime ) {
                [kWINDOW makeToast:[kMultiTool getMultiLanByKey:@"shurukaishishijian"]];
                return;
            }
            if ( !_bottomView.alarmView.timeView.endTime) {
                [kWINDOW makeToast:[kMultiTool getMultiLanByKey:@"shurujieshushijian"]];
                return;
            }
            
            NSDictionary *expdic = @{@"s":_bottomView.alarmView.timeView.startTime,@"e":_bottomView.alarmView.timeView.endTime,@"d":[_bottomView.alarmView getDayJson]};
            NSArray *array = @[expdic];
            paraDic = @{
                        @"token":loginModel.retval.token,
                        @"exp":[self jsonStringWithArray:array],
                        @"tel":[_keyAccountView getText],
                        @"usetime":@"-1",
                        @"type":@"lin",
                        @"phoneMac":loginModel.retval.bluemac,
                        @"app" : @"userloginapp",
                        @"act" : @"add_key",
                        @"remark":_keyInfoView.textFeild.text?_keyInfoView.textFeild.text:loginModel.retval.n,
                        @"offline":@(_isOffline),
                        @"send":@(_isMessage),
                        @"lock_id":[dic1 objectForKey:@"lock_id"]
                        };
            
        }else if (_bottomView.currentType == tempBottomTypeCount)
        {
            
            
            if (!self.keyAccountView.textFeild.text.length)
            {
                [kWINDOW makeToast:[kMultiTool getMultiLanByKey:@"shoujihaobudui"]];
                return;
            }
            if (!self.keyInfoView.textFeild.text.length)
            {
                [kWINDOW makeToast:[kMultiTool getMultiLanByKey:@"qingshurubeizhu"]];
                return;
            }
            if (!_bottomView.countView.countTextFeild.text.length) {
                [kWINDOW makeToast:[kMultiTool getMultiLanByKey:@"shurucishu"]];
                return;
            }
            
            //  NSDictionary *expdic = @{@"s":_bottomView.alarmView.timeView.startTime?,@"e":_bottomView.alarmView.timeView.endTime,@"d":[_bottomView.alarmView getDayJson]};
            paraDic = @{
                        @"token":loginModel.retval.token,
                        @"exp":@"",
                        @"tel":[_keyAccountView getText],
                        @"usetime":_bottomView.countView.countTextFeild.text,
                        @"type":@"lin",
                        @"phoneMac":loginModel.retval.bluemac,
                        @"app" : @"userloginapp",
                        @"act" : @"add_key",
                        @"remark":_keyInfoView.textFeild.text?_keyInfoView.textFeild.text:loginModel.retval.n,
                        @"offline":@(_isOffline),
                        @"send":@(_isMessage),
                        @"lock_id":[dic1 objectForKey:@"lock_id"]
                        };
            
            
            
            
            
            
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
    [kWINDOW makeToastActivity:CSToastPositionCenter];
    [PPNetworkHelper GET:kBaseUrl parameters:paraDic success:^(id responseObject) {
        [kWINDOW hideToastActivity];
        [kWINDOW makeToast:[responseObject objectForKey:@"msg"]];
        if ([[responseObject objectForKey:@"done"] intValue]) {
            self.navigationController.navigationBar.hidden = YES;
            [self.navigationController popViewControllerAnimated:NO];
        }
        if (_isPermanent) {
            _keyAccountView.textFeild.userInteractionEnabled = NO;
        }else
        {
            _keyAccountView.textFeild.userInteractionEnabled = YES;
        }
        
        

    } failure:^(NSError *error) {
        [kWINDOW hideToastActivity];
        if (_isPermanent) {
            _keyAccountView.textFeild.userInteractionEnabled = NO;
        }else
        {
            _keyAccountView.textFeild.userInteractionEnabled = YES;
        }
        [kWINDOW makeToast:[kMultiTool getMultiLanByKey:@"tianjiashibai"]];
    }];
    
    
    
    
}

#pragma mark navigation UI

- (void)setNavigationUI
{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    
    titleLabel.textColor = [UIColor whiteColor];
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    titleLabel.text = [kMultiTool getMultiLanByKey:@"sendkey"];
    
    self.navigationItem.titleView = titleLabel;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbackimage"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem uc_backBarButtonItemWithAction:^{
        
        self.navigationController.navigationBar.hidden = YES;
        [self.navigationController popViewControllerAnimated:NO];
        
    }];
    
}

#pragma mark UI getter

- (SendKeyTextView *)keyTypeView
{
    if (!_keyTypeView) {
        
        _keyTypeView = [[SendKeyTextView alloc]init];
        [_keyTypeView setLeftText:[kMultiTool getMultiLanByKey:@"keytype"]];
        [_keyAccountView setType:SendKeyTextViewTypeTextAndButton];
    }
    _keyTypeView.permanentBlock = ^(bool isPermanent) {
        
        _isPermanent = isPermanent;
        NSString *str = isPermanent? [kMultiTool getMultiLanByKey:@"pkey"]:[kMultiTool getMultiLanByKey:@"tkey"];
        [_keyTypeView setRightText:str];
        [self makeConstrians];
        if (_isPermanent) {
            _keyAccountView.textFeild.userInteractionEnabled = NO;
        }else
        {
           _keyAccountView.textFeild.userInteractionEnabled = YES;
        }
        
    };
    [_keyTypeView setLeftIcon:nil textFeildText:@"" rightLable:@"" textFeildCanEdit:NO];
    return _keyTypeView;
    
    
}

- (SendKeyTextView *)keyAccountView
{
    
    if (!_keyAccountView) {
        _keyAccountView = [[SendKeyTextView alloc]init];
        [_keyAccountView setLeftText:[kMultiTool getMultiLanByKey:@"account"]];
        [_keyAccountView setType:SendKeyTextViewTypeTextAndButtonNoImage];
    }
    _keyAccountView.textFeild.userInteractionEnabled = NO;
    _keyAccountView.scanBlock = ^{
        UCQRCodeViewController *controller = [[UCQRCodeViewController alloc]init];
        
        controller.backBlock = ^(NSString *icon) {
            
            
            _scanDic = [self dictionaryWithJsonString:icon];
            if (_scanDic && [_scanDic objectForKey:@"n"]) {
                _keyAccountView.textFeild.text = [_scanDic objectForKey:@"n"];
            }else
            {
                
                [kWINDOW makeToast:[kMultiTool getMultiLanByKey:@"huoquyonghubiammashibai"]];
            }
            
        };
        
        [self.navigationController pushViewController:controller animated:NO];
    };
    [_keyAccountView setLeftIcon:nil textFeildText:[kMultiTool getMultiLanByKey:@"enteraccount"] rightLable:@"" textFeildCanEdit:YES];
    return _keyAccountView;
    
}
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
- (SendKeyTextView *)keyInfoView
{
    
    if (!_keyInfoView) {
        _keyInfoView = [[SendKeyTextView alloc]init];
        [_keyInfoView setLeftText:[kMultiTool getMultiLanByKey:@"info"]];
        [_keyInfoView setType:SendKeyTextViewTypeNone];
    }
    [_keyInfoView setLeftIcon:nil textFeildText:[kMultiTool getMultiLanByKey:@"entername"] rightLable:@"" textFeildCanEdit:YES];
    return _keyInfoView;
    
}

- (SendKeyTextView *)offlineView
{
    
    if (!_offlineView) {
        _offlineView = [[SendKeyTextView alloc]init];
        [_offlineView setLeftText:[kMultiTool getMultiLanByKey:@"canoffline"]];
        [_offlineView setType:SendKeyTextViewTypeCheckBox];
        _offlineView.checkBlock = ^(BOOL isChecked) {
            _isOffline = isChecked;
        };
    }
    [_keyInfoView setLeftIcon:nil textFeildText:[kMultiTool getMultiLanByKey:@"entername"] rightLable:@"" textFeildCanEdit:YES];
    return _offlineView;
    
}
//- (SendKeyTextView *)messageView
//{
//    if (!_messageView) {
//        _messageView = [[SendKeyTextView alloc]init];
//        [_messageView setLeftText:[kMultiTool getMultiLanByKey:@"cansendmessage"]];
//        [_messageView setType:SendKeyTextViewTypeCheckBox];
//        _messageView.checkBlock = ^(BOOL isChecked) {
//            _isMessage = isChecked;
//        };
//    }
//    
//    
//    return _messageView;
//}
- (UIButton *)sendButton
{
    
    if (!_sendButton) {
        _sendButton  = [[UIButton alloc]init];
        [_sendButton setBackgroundImage:[UIImage imageNamed:@"navbackimage"] forState:UIControlStateNormal];
        
        [_sendButton setTitle:[kMultiTool getMultiLanByKey:@"send"] forState:UIControlStateNormal];
        
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sendButton addTarget:self action:@selector(sendKey) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _sendButton;
}
- (SendKeyBottomView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[SendKeyBottomView alloc]init];
        
    }
    
    return _bottomView;
}
- (BOOL)isvalidBarcode:(NSDictionary *)dic
{
    
    if (dic && [dic objectForKey:@"n"] && [dic objectForKey:@"bluemac"])
    {
        return YES;
    }
    return NO;
}
- (void)sendKey
{
    if (_isPermanent) {
        if (![self isvalidBarcode:_scanDic]) {
            [kWINDOW makeToast:[kMultiTool getMultiLanByKey:@"qingsaomiaoyonghu"]];
            return;
        }
        if (!self.keyInfoView.textFeild.text.length)
        {
            [kWINDOW makeToast:[kMultiTool getMultiLanByKey:@"qingshurubeizhu"]];
            return;
        }
            [kWINDOW makeToastActivity:CSToastPositionCenter];
            [[BlueToothManager sharedManager] addKey:[_scanDic objectForKey:@"bluemac"]];
        
    }else{
        
        //临时钥匙 不用走蓝牙直接走接口
        [self success];
    }
    
    
    
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

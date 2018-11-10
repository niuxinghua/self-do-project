//
//  SettingViewController.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/2/13.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingTextView.h"
#import "Masonry.h"
#import "LockStoreManager.h"
#import "BlueToothManager.h"
#import "PowderUtil.h"
#import "Const.h"
@interface SettingViewController ()
#define kMaxATime [NSString stringWithFormat:@"maxatime%@%@",kLoginModel.retval.n,[kdicSelected objectForKey:@"key_id"]]
#define kRecordListKey [NSString stringWithFormat:@"%@%@",kLoginModel.retval.n,[kdicSelected objectForKey:@"key_id"]]
#define kRecordUpdateTime [NSString stringWithFormat:@"lastupdatetime%@%@",kLoginModel.retval.n,[kdicSelected objectForKey:@"key_id"]]
#define KMessageList  @"message_lists"
@property (nonatomic,strong)SettingTextView *textView1;
@property (nonatomic,strong)SettingTextView *textView2;
@property (nonatomic,strong)SettingTextView *textView3;
@property (nonatomic,strong)SettingTextView *textView4;
@property (nonatomic,strong)UIButton *confirmButton;
@property (nonatomic,strong)NSString *AvatarName;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [kMultiTool getMultiLanByKey:@"setting"];
    [self setNavigationUI];
    [self.view addSubview:self.textView1];
    [self.view addSubview:self.textView2];
    [self.view addSubview:self.textView3];
    [self.view addSubview:self.textView4];
    [self.view addSubview:self.confirmButton];
    [self makeConstrians];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didgetInfo:) name:@"lockinfo" object:nil];
 
//      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dodeletesuccess) name:@"deleteLockInfo" object:nil];
   // deleteLockInfofail
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteLockInfofail) name:@"deleteLockInfofail" object:nil];
}

//视图已经消失
- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"deleteLockInfo" object:nil];
    [super viewDidDisappear:animated];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dodeletesuccess) name:@"deleteLockInfo" object:nil];
    
   
    // [self.view endEditing:YES];
    // [self setupLeftMenuButton];
    
}


- (void)dodelete
{
    
    if (![PPNetworkHelper isNetwork]) {
        //无网络
        [self.view hideToastActivity];
        [kWINDOW makeToast: [kMultiTool getMultiLanByKey:@"neterror"]];
        return;
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    alert.popoverPresentationController.sourceView = self.view;
    alert.popoverPresentationController.sourceRect = CGRectMake(0, 0, 1.0, 1.0);
    alert.title = [kMultiTool getMultiLanByKey:@"shanchuguanliyuantishi"];
    [alert addAction:[UIAlertAction actionWithTitle:[kMultiTool getMultiLanByKey:@"queding"] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [kWINDOW makeToastActivity:CSToastPositionCenter];
        [[BlueToothManager sharedManager] deleteLockInfo];
//        kWINDOW.userInteractionEnabled = NO;

    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[kMultiTool getMultiLanByKey:@"cancell"] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
  
    
}
- (void)dodeletesuccess
{
    

    NSDictionary *logindic =
    [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
    
    LoginModel *loginModel = [LoginModel yy_modelWithJSON:logindic];
    NSDictionary *dicSelected = [LockStoreManager sharedManager].selectedLock;
    
    
    NSDictionary *dic = @{@"app":@"userloginapp",@"token":loginModel.retval.token,@"act":@"delete_manage",@"all":@1,
                          @"id":[dicSelected objectForKey:@"lock_id"]
                          };
    NSLog(@"%@",dic);
    [PPNetworkHelper GET:kBaseUrl parameters:dic success:^(id responseObject) {
        [self.view hideToastActivity];
        kWINDOW.userInteractionEnabled = YES;
       
       // [NSNotificationCenter defaultCenter];
        [LockStoreManager sharedManager].selectedLock = nil;
       NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"done"] integerValue]) {
             [[NSUserDefaults standardUserDefaults] removeObjectForKey:kMaxATime];
              [[NSUserDefaults standardUserDefaults] removeObjectForKey:kRecordUpdateTime];
             [[NSUserDefaults standardUserDefaults] removeObjectForKey:kRecordListKey];
            NSDictionary *logindic =
            [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
            LoginModel *loginModel = [LoginModel yy_modelWithJSON:logindic];
            NSString *messagelistkey = [NSString stringWithFormat:@"%@-%@",loginModel.retval.user_id,KMessageList];
            NSMutableArray *dataList = [[NSUserDefaults standardUserDefaults] objectForKey:messagelistkey];
            NSMutableArray * tmpArray = [NSMutableArray arrayWithArray:dataList];
            if (tmpArray&&[tmpArray count]>0) {
                for (int i = [tmpArray count] -1 ; i>=0 ; i--) {
                    NSDictionary *dic =[tmpArray objectAtIndex:i];
                    if ([[dicSelected objectForKey:@"lock_id"] integerValue]==[[dic objectForKey:@"lock_id"]integerValue]) {
                        [tmpArray removeObjectAtIndex:i];
                    }
                }
                [[NSUserDefaults standardUserDefaults] setObject:tmpArray forKey:messagelistkey];
                 
            }
            
            
             [[NSNotificationCenter defaultCenter] postNotificationName:@"deletesuccess" object:nil];
            [self.view makeToast:[kMultiTool getMultiLanByKey:@"shanchuchenggong"] ];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:NO];
            });
        }else{
            
            [kWINDOW makeToast:[responseObject objectForKey:@"msg"]];
        }
       
        
       
        
    } failure:^(NSError *error) {
        [self.view hideToastActivity];kWINDOW.userInteractionEnabled = YES;
       [self.view makeToast:[kMultiTool getMultiLanByKey:@"shanchushibai"] ];
    }];
    
    
}
- (void)deleteLockInfofail
{
    [self.view hideToastActivity];kWINDOW.userInteractionEnabled = YES;
    [self.view makeToast:[kMultiTool getMultiLanByKey:@"shanchushibai"] ];

}
- (void)getLockInfo
{
    [[BlueToothManager sharedManager] getLockInfo];
    [kWINDOW makeToastActivity:CSToastPositionCenter];
//    kWINDOW.userInteractionEnabled = NO;

    
}

- (void)didgetInfo:(NSNotification *)notification
{
   //获取到蓝牙返回的电量
    //更新到本地

    NSInteger percent = [PowderUtil percentFrom:notification.object];
    
   // NSLog(@"-------%d",percent);
    [_textView2 setMiddleText:[NSString stringWithFormat:@"%ld%%",percent]];
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%ld%%",percent] forKey:@"lockinfo"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self.view hideToastActivity];
    kWINDOW.userInteractionEnabled = YES;

}
- (void)setNavigationUI
{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    
    titleLabel.textColor = [UIColor whiteColor];
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    titleLabel.text = [kMultiTool getMultiLanByKey:@"setting"];
    
    self.navigationItem.titleView = titleLabel;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbackimage"] forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem uc_backBarButtonItemWithAction:^{
        
        // self.navigationController.navigationBar.hidden = YES;
//        kWINDOW.userInteractionEnabled = YES;
        [self.view hideToastActivity];
        [self.navigationController popViewControllerAnimated:NO];
        
    }];
    
}
- (void)makeConstrians
{
    [_textView1 mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.top.equalTo(self.view);
        make.height.equalTo(@60);
        
    }];
    [_textView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.view);
        make.height.equalTo(@60);
        make.top.equalTo(self.textView1.mas_bottom);
        
    }];
    [_textView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.view);
        make.height.equalTo(@60);
        make.top.equalTo(self.textView2.mas_bottom);
        
    }];
    [_textView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.view);
        make.height.equalTo(@60);
        make.top.equalTo(self.textView3.mas_bottom);
        
    }];
    
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view.mas_width);
        make.bottom.equalTo(self.mas_bottomLayoutGuide);
        make.height.equalTo(@40);
        
    }];
    
    
}
#pragma mark UI getters

- (SettingTextView *)textView1
{
    NSDictionary  *dic = [LockStoreManager sharedManager].selectedLock;
    if (!_textView1) {
        _textView1 = [[SettingTextView alloc]init];
        [_textView1 setLeftText:[kMultiTool getMultiLanByKey:@"code"]];
        [_textView1 setMiddleText:[dic objectForKey:@"code"]];
    }
    
    return _textView1;
}
- (SettingTextView *)textView2
{
    NSUserDefaults *uu = [NSUserDefaults standardUserDefaults];
    if (!_textView2) {
        _textView2 = [[SettingTextView alloc]init];
        [_textView2 setLeftText:[kMultiTool getMultiLanByKey:@"power"]];
      NSString *score =  [[NSUserDefaults standardUserDefaults] objectForKey:@"lockinfo"];
        if (!score) {
              [_textView2 setMiddleText:@"100%"];
        }else{
           
            [_textView2 setMiddleText:score];
        }
       
       
        [_textView2 setUpdateButtonHidden:YES];
//        _textView2.updateBlock = ^{
//          
//            [self getLockInfo];
//            
//        };
    }
    
    return _textView2;
}
- (SettingTextView *)textView3
{
    NSDictionary  *dic = [LockStoreManager sharedManager].selectedLock;
    
    if (!_textView3) {
        _textView3 = [[SettingTextView alloc]init];
        [_textView3 setLeftText:[kMultiTool getMultiLanByKey:@"mingcheng"]];
        [_textView3 setMiddleText:[dic objectForKey:@"name"]];
    }
    [_textView3 setUpdateButtonHidden:NO];
    _textView3.updateBlock = ^{
        
        [self showTextFeild];
        
    };

    return _textView3;
}
- (SettingTextView *)textView4
{
    
    if (!_textView4) {
        _textView4 = [[SettingTextView alloc]init];
        [_textView4 setLeftText:[kMultiTool getMultiLanByKey:@"lockv"]];
        
    }
    
    return _textView4;
}
- (UIButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [[UIButton alloc]init];
        [_confirmButton setBackgroundImage:[UIImage imageNamed:@"navbackimage"] forState:UIControlStateNormal];
        [_confirmButton setTitle:[kMultiTool getMultiLanByKey:@"shanchu"] forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(dodelete) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _confirmButton;
}

- (void)showTextFeild
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[kMultiTool getMultiLanByKey:@"suomingcheng"] message:nil preferredStyle:UIAlertControllerStyleAlert];
    alert.popoverPresentationController.sourceView = self.view;
    alert.popoverPresentationController.sourceRect = CGRectMake(0, 0, 1.0, 1.0);
    //按钮：从相册选择，类型：UIAlertActionStyleDefault
    UIAlertAction * takingPicAction = [UIAlertAction actionWithTitle:[kMultiTool getMultiLanByKey:@"queding"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self updateName];
        
    }];
    UIAlertAction * cancell = [UIAlertAction actionWithTitle:[kMultiTool getMultiLanByKey:@"cancell"] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
        
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = [kMultiTool getMultiLanByKey:@"shurusuomingcheng"];
        
        [textField addTarget:self action:@selector(watchTextFieldMethod:) forControlEvents:UIControlEventEditingChanged];
        
    }];
    [alert addAction:takingPicAction];
    [alert addAction:cancell];
    [self presentViewController:alert animated:YES completion:nil];
    
}
- (void)watchTextFieldMethod:(UITextField*)textFeild
{
    
    _AvatarName = textFeild.text;
    
    
}
- (void)updateName
{
    
    if (![PPNetworkHelper isNetwork]) {
        
        [kWINDOW makeToast:[kMultiTool getMultiLanByKey:@"lianwangshibai"]];
        
        return;
    }
    if (!_AvatarName) {
        [kWINDOW makeToast:[kMultiTool getMultiLanByKey:@"shurusuomingcheng"]];
        return;
    }
    [self.view makeToastActivity:CSToastPositionCenter];
    NSDictionary *logindic =
    [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
    
    LoginModel *loginModel = [LoginModel yy_modelWithJSON:logindic];
    NSDictionary *dicSelected = [LockStoreManager sharedManager].selectedLock;
    
    
    NSDictionary *dic = @{@"app":@"userloginapp",@"token":loginModel.retval.token,@"act":@"update_lock_name",@"lock_name":_AvatarName,@"lock_id":[dicSelected objectForKey:@"lock_id"]
                          };
    
    [PPNetworkHelper GET:kBaseUrl parameters:dic success:^(id responseObject) {
        [self.view hideToastActivity];
      
        if ([[responseObject objectForKey:@"done"] integerValue]) {
            [self.view makeToast:[kMultiTool getMultiLanByKey:@"xiugaichenggong"] ];
            [_textView3 setMiddleText:_AvatarName];

        }else{
            
            [kWINDOW makeToast:[responseObject objectForKey:@"msg"]];
        }
        
        
        
        
    } failure:^(NSError *error) {
        [self.view hideToastActivity];kWINDOW.userInteractionEnabled = YES;
        [self.view makeToast:[kMultiTool getMultiLanByKey:@"shanchushibai"] ];
    }];
    
    
}

- (void)dealloc
{
    
     [[BlueToothManager sharedManager] destroy];
     [self.view hideToastActivity];
    kWINDOW.userInteractionEnabled = YES;
}


@end

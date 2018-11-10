//
//  SettingCenterViewController.m
//  caxjh
//
//  Created by niuxinghua on 2017/11/29.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import "SettingCenterViewController.h"
#import "UIBarButtonItem+UC.h"
#import "Masonry.h"
#import "SocketManager.h"
#import "Const.h"
@interface SettingCenterViewController ()

@property (nonatomic,strong)UIImageView *headImageView;

@property (nonatomic,strong)UILabel *topLable;

@property (nonatomic,strong)UILabel *bottomLable;

@property (nonatomic,strong)UITextField *editNumber;

@property (nonatomic,strong)UIButton *confirmButton;

@end

@implementation SettingCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem uc_backBarButtonItemWithAction:^{
        [[NSNotificationCenter defaultCenter]removeObserver:self];
        [self.navigationController popViewControllerAnimated:NO];
    }];
    self.title = @"中心号码";
    _headImageView = [[UIImageView alloc]init];
    _headImageView.image = [UIImage imageNamed:@"center"];
    [self.view addSubview:_headImageView];
    
    _topLable = [[UILabel alloc]init];
    _topLable.font = [UIFont systemFontOfSize:23];
    _topLable.textColor = [UIColor colorWithHex:@"#14a7ed"];
    _topLable.text = @"中心号码";
    
    _bottomLable = [[UILabel alloc]init];
    _bottomLable.font = [UIFont systemFontOfSize:12];
    _bottomLable.textColor = [UIColor colorWithHex:@"#aaaaaa"];
    _bottomLable.numberOfLines = 0;
    _bottomLable.text = @"设置中心号码，通过该号码可以发送短信指令，同时终端的各警报短信会发送到该号码的手机上";
    
    [self.view addSubview:_topLable];
    [self.view addSubview:_bottomLable];
    
    _editNumber = [[UITextField alloc]init];
    _editNumber.placeholder = @"请输入手机号码";
    [self.view addSubview:_editNumber];
    _confirmButton = [[UIButton alloc]init];
    [_confirmButton addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_confirmButton setBackgroundColor:[UIColor colorWithHex:@"#ff6767"]];
    
    [self.view addSubview:_confirmButton];
    [self makeConstrains];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didsetSuccess:) name:SetCenterSuccess object:nil];
    UITapGestureRecognizer *re = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEdit)];
    
    [self.view addGestureRecognizer:re];
    
    [self getData];
    
}

- (void)didsetSuccess:(NSNotification *)notification
{
    if ([notification.object containsString:@"OK"]) {
       [self setMysqlNumber];
    }else{
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [self.view makeToast:@"手表不在线"];
    }
    
   // [self.navigationController popViewControllerAnimated:NO];
   
    
}
- (void)setMysqlNumber
{
    NSString *watchid = [[SocketManager sharedInstance].locationDic objectForKey:@"id"];
    NSDictionary *dic = @{@"table": @"Watch",
                          @"fields":@{@"centerNumber":_editNumber.text},
                          @"id":watchid
                          };
    NSLog(@"设置的手机号=======%@",_editNumber.text);
    [PPNetworkHelper POST:kAPISetUploadTimeInterval parameters:dic success:^(id responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue]==0) {
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            [self.view makeToast:@"成功"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Mapsetting" object:nil];
            //[self.navigationController popViewControllerAnimated:NO];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            [self.view makeToast:@"失败"];
            
        }
    } failure:^(NSError *error) {
         [MBProgressHUD hideHUDForView:self.view animated:NO];
         [self.view makeToast:@"失败"];
    }];
    
    
}
- (BOOL)checkTelNumber:(NSString *) telNumber
{
    NSString *pattern = @"^1+[3578]+\\d{9}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    return isMatch;
}


- (void)confirm
{
    [self endEdit];
    if(!_editNumber.text || _editNumber.text.length == 0){
        
        [self.view makeToast:@"请输入中心号码"];
        return;
        
    }
    if(![self checkTelNumber:_editNumber.text])
    {
        
        [self.view makeToast:@"您输入的手机号码不合法"];
        return;
    }
    [[SocketManager sharedInstance]setCenterNumber:_editNumber.text];
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    
}
- (void)getData
{
    NSDictionary *locationDic = [SocketManager sharedInstance].locationDic;
    NSString *watchId = [locationDic objectForKey:@"id"];
    
    NSDictionary *dic = @{
                          @"table": @"Watch",
                          @"filter": @{
                                  @"id":@{@"eq":watchId}
                                  },
                          @"columns": @[
                                  @"centerNumber"
                                  ]
                          };
    __weak SettingCenterViewController *weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [PPNetworkHelper POST:kAPIQueryWatch parameters:dic success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        if ([responseObject objectForKey:@"data"]) {
            NSDictionary *dic = [responseObject objectForKey:@"data"][0];
            if ([dic objectForKey:@"centerNumber"]) {
                weakSelf.editNumber.text = [dic objectForKey:@"centerNumber"];
            }
            
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
    }];
    
    
    
}
- (void)makeConstrains
{
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.height.equalTo(@70);
        make.top.equalTo(self.view.mas_top).offset(40);
        make.centerX.equalTo(self.view.mas_centerX);
        
    }];
    
    [_topLable mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.equalTo(@100);
        make.height.equalTo(@40);
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(_headImageView.mas_bottom);
    }];
    [_bottomLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@200);
        make.height.equalTo(@60);
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(_topLable.mas_bottom);
    }];
    
    [_editNumber mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(_bottomLable.mas_bottom).offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@200);
        make.height.equalTo(@30);
        
    }];
    
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_editNumber.mas_bottom).offset(40);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.equalTo(@50);
    }];
    
}
- (void)endEdit
{
    [self.view endEditing:YES];
    
}
-(void)dealloc
{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end

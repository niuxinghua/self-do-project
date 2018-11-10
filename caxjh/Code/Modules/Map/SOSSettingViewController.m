//
//  SOSSettingViewController.m
//  caxjh
//
//  Created by niuxinghua on 2017/11/30.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import "SOSSettingViewController.h"
#import "UIBarButtonItem+UC.h"
#import "Masonry.h"
#import "SocketManager.h"
@interface SOSSettingViewController ()

@property (nonatomic,strong)UIImageView *headImageView;

@property (nonatomic,strong)UILabel *topLable;

@property (nonatomic,strong)UILabel *bottomLable;

@property (nonatomic,strong)UITextField *editNumber1;
@property (nonatomic,strong)UITextField *editNumber2;
@property (nonatomic,strong)UITextField *editNumber3;

@property (nonatomic,strong)UIButton *confirmButton;
@end

@implementation SOSSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem uc_backBarButtonItemWithAction:^{
        [[NSNotificationCenter defaultCenter]removeObserver:self];
        [self.navigationController popViewControllerAnimated:NO];
    }];
    
    UITapGestureRecognizer *re = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEdit)];
    
    [self.view addGestureRecognizer:re];
    self.title = @"SOS号码";
    _headImageView = [[UIImageView alloc]init];
    _headImageView.image = [UIImage imageNamed:@"sos"];
    [self.view addSubview:_headImageView];
    
    _topLable = [[UILabel alloc]init];
    _topLable.font = [UIFont systemFontOfSize:23];
    _topLable.textColor = [UIColor colorWithHex:@"#14a7ed"];
    _topLable.text = @"SOS号码";
    
    _bottomLable = [[UILabel alloc]init];
    _bottomLable.font = [UIFont systemFontOfSize:12];
    _bottomLable.textColor = [UIColor colorWithHex:@"#aaaaaa"];
    _bottomLable.numberOfLines = 0;
    _bottomLable.text = @"设置SOS号码后，触发SOS警情时，终端向设置的几个号码拨打电话，一直无人接听则循环拨打两轮，接听后则不再继续拨打电话，同时发送报警短信给三个SOS号码。";
    
    [self.view addSubview:_topLable];
    [self.view addSubview:_bottomLable];
    
    _editNumber1 = [[UITextField alloc]init];
    _editNumber1.placeholder = @"手机号码一";
    [self.view addSubview:_editNumber1];
    
    
    _editNumber2 = [[UITextField alloc]init];
    _editNumber2.placeholder = @"手机号码二";
    [self.view addSubview:_editNumber2];
    
    _editNumber3 = [[UITextField alloc]init];
    _editNumber3.placeholder = @"手机号码三";
    [self.view addSubview:_editNumber3];
    _confirmButton = [[UIButton alloc]init];
    [_confirmButton addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_confirmButton setBackgroundColor:[UIColor colorWithHex:@"#ff6767"]];
    
    [self.view addSubview:_confirmButton];
    [self makeConstrains];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didset:) name:@"SOSSetting" object:nil];
    [self getData];
    
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
                    @"sos1Number",@"sos2Number",@"sos3Number"
                    ]
        };
    __weak SOSSettingViewController *weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
    [PPNetworkHelper POST:kAPIQueryWatch parameters:dic success:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        if ([responseObject objectForKey:@"data"]) {
            NSDictionary *dic = [responseObject objectForKey:@"data"][0];
            if ([dic objectForKey:@"sos1Number"] && ![[dic objectForKey:@"sos1Number"] isEqual:[NSNull null]]) {
                weakSelf.editNumber1.text = [dic objectForKey:@"sos1Number"];
            }
            if ([dic objectForKey:@"sos2Number"]&& ![[dic objectForKey:@"sos2Number"] isEqual:[NSNull null]]) {
                weakSelf.editNumber2.text = [dic objectForKey:@"sos2Number"];
            }
            if ([dic objectForKey:@"sos3Number"]&& ![[dic objectForKey:@"sos3Number"] isEqual:[NSNull null]]) {
                weakSelf.editNumber3.text = [dic objectForKey:@"sos3Number"];
            }
        }
        
    } failure:^(NSError *error) {
         [MBProgressHUD hideHUDForView:self.view animated:NO];
    }];
    
    
    
}

- (void)didset:(NSNotification *)notifacation
{
    if ([notifacation.object containsString:@"ERROR"]) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [self.view makeToast:@"手表不在线"];
    }
    
    if ([notifacation.object containsString:@"OK"]) {
        [self setMysqlNumber];
    }
    
}
- (void)endEdit
{
    [self.view endEditing:YES];
    
}
- (BOOL)checkTelNumber:(NSString *) telNumber
{
    if (!telNumber.length) {
        return true;
    }
    NSString *pattern = @"^1+[3578]+\\d{9}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:telNumber];
    return isMatch;
}
- (void)confirm
{
    [self endEdit];
    NSString *str;
    if (_editNumber1.text.length) {
        str = _editNumber1.text;
    }
    if(![self checkTelNumber:_editNumber1.text])
    {
        [self.view makeToast:@"您输入的SOS1手机号码不合法"];
        return;

        
    }
    if (_editNumber2.text.length) {
        
        str = [NSString stringWithFormat:@"%@,%@",str,_editNumber2.text];
    }
    if(![self checkTelNumber:_editNumber2.text])
    {
        [self.view makeToast:@"您输入的SOS2手机号码不合法"];
        return;
        
        
    }
    if (_editNumber3.text.length) {
        
        str = [NSString stringWithFormat:@"%@,%@",str,_editNumber3.text];
    }
    if(![self checkTelNumber:_editNumber3.text])
    {
        [self.view makeToast:@"您输入的SOS3手机号码不合法"];
        return;
        
        
    }
    
    [[SocketManager sharedInstance] setSOSNumber:str];
    [MBProgressHUD showHUDAddedTo:self.view animated:NO];
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
        
        make.width.equalTo(@250);
        make.height.equalTo(@60);
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(_topLable.mas_bottom);
    }];
    
    [_editNumber1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_bottomLable.mas_bottom).offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@200);
        make.height.equalTo(@30);
        
    }];
    [_editNumber2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_editNumber1.mas_bottom).offset(5);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@200);
        make.height.equalTo(@30);
        
    }];
    [_editNumber3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_editNumber2.mas_bottom).offset(5);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@200);
        make.height.equalTo(@30);
        
    }];
    
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_editNumber3.mas_bottom).offset(30);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.equalTo(@50);
    }];
    
}

- (void)setMysqlNumber
{
    NSString *sos1 = _editNumber1.text;
    if (!sos1.length) {
        sos1 = @"";
    }
    NSString *sos2 = _editNumber2.text;
    if (!sos2.length) {
        sos2 = @"";
    }
    NSString *sos3 = _editNumber3.text;
    if (!sos3.length) {
        sos3 = @"";
    }
   
    NSString *watchid = [[SocketManager sharedInstance].locationDic objectForKey:@"id"];
    NSDictionary *dic = @{@"table": @"Watch",
                          @"fields":@{@"sos1Number":sos1,@"sos2Number":sos2,@"sos3Number":sos3},
                          @"id":watchid
                          };
    [PPNetworkHelper POST:kAPISetUploadTimeInterval parameters:dic success:^(id responseObject) {
        if ([[responseObject objectForKey:@"code"] integerValue]==0) {
             [MBProgressHUD hideHUDForView:self.view animated:NO];
            [self.view makeToast:@"成功"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"Mapsetting" object:nil];
          //  [self.navigationController popViewControllerAnimated:NO];
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            [self.view makeToast:@"失败"];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        [self.view makeToast:@"失败"];
    }];
    
    
}


@end

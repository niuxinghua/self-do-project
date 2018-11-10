//
//  ModifyPassWordViewController.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/3/4.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "ModifyPassWordViewController.h"
#import "LoginModel.h"
@interface ModifyPassWordViewController ()

@end

@implementation ModifyPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [kMultiTool getMultiLanByKey:@"xiugaimima"];
    [self.registerButton setTitle:[kMultiTool getMultiLanByKey:@"xiugaimima"] forState:UIControlStateNormal];
    if (_ismodify) {
         [self.registerButton setTitle:[kMultiTool getMultiLanByKey:@"xiugaimima"] forState:UIControlStateNormal];
    }
    NSDictionary *logindic =
    [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
    
    LoginModel *loginModel = [LoginModel yy_modelWithJSON:logindic];
    self.introView.textFeild.text = loginModel.retval.n;
}

- (void)setNavigationUI {
    
    UILabel *titleLabel =
    [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    
    titleLabel.textColor = [UIColor whiteColor];
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    titleLabel.text = [kMultiTool getMultiLanByKey:@"xiugaimima"];
    if (_ismodify) {
      titleLabel.text = [kMultiTool getMultiLanByKey:@"wangjimima"];
    }
    
    self.navigationItem.titleView = titleLabel;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
    
    [self.navigationController.navigationBar
     setBackgroundImage:[UIImage imageNamed:@"navbackimage"]
     forBarMetrics:UIBarMetricsDefault];
    self.navigationItem.leftBarButtonItem =
    [UIBarButtonItem uc_backBarButtonItemWithAction:^{
        
        self.navigationController.navigationBar.hidden = YES;
        [self.navigationController popViewControllerAnimated:NO];
        
    }];
}
- (void)didtouchregister {
    
    if (![[self.enterPassViewAgain getText] isEqualToString:[self.enterPassView getText]]) {
        [kWINDOW makeToast:[kMultiTool getMultiLanByKey:@"mimabuyizhi"]];
        return;
    }

    NSRange addRange = [self.enterTeleView.rightLable.text rangeOfString:@"+"];
    NSMutableString *str =
    [[NSMutableString alloc] initWithString:self.enterTeleView.rightLable.text];
    [str deleteCharactersInRange:addRange];
    NSDictionary *dic = @{
                          @"uname" : [self.introView getText],
                          @"pwd" : [self.enterPassView getText],
                          @"t" : [self.enterTeleView getText],
                          @"area" : str,
                          @"code" : [self.enterVerify getText],
                          @"y" : [[self.introView getText] containsString:@"@"]?@"2":@"1",
                          @"app" : @"userapp",
                          @"act" : @"findpwd",
                          @"platform":@"iOS",
                          @"model":@""
                          };
    
    [PPNetworkHelper GET:kBaseUrl
              parameters:dic
                 success:^(id responseObject) {
//                      [kWINDOW makeToast:[responseObject valueForKey:@"msg"]];
                     if ([[responseObject valueForKey:@"done"] boolValue]) {
                         [self.view makeToast:[kMultiTool getMultiLanByKey:@"zhaohuichenggong"]];
                         [self performSelector:@selector(delayMethod) withObject:nil/*可传任意类型参数*/ afterDelay:1.0];
                         
                     }else{
                         [kWINDOW makeToast:[responseObject valueForKey:@"msg"]];
                         
                     }
                    
                     
                 }
                 failure:^(NSError *error) {
                    // [self.view makeToast:error.description];
                     
                 }];
}

- (void)delayMethod{
   [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:nil];
}
- (void)getVerifyCode {
    if (!self.introView.textFeild.text.length) {
         [kWINDOW makeToast:[kMultiTool getMultiLanByKey:@"shoujihaobudui"]];
        [self.enterVerify.getVerify stopCountDown];
        return;
    }
    [kWINDOW makeToastActivity:CSToastPositionCenter];
        NSRange addRange = [self.enterTeleView.rightLable.text rangeOfString:@"+"];
    NSMutableString *str =
    [[NSMutableString alloc] initWithString:self.enterTeleView.rightLable.text];
    [str deleteCharactersInRange:addRange];
    NSDictionary *dic = @{
                          @"t" : [self.introView getText],
                          @"a" : str,
                          @"y" : [[self.introView getText] containsString:@"@"]?@"2":@"1",
                          @"app" : @"userapp",
                          @"act" : @"authcode",
                          @"type":@"找回密码"
                          };
    
    [PPNetworkHelper GET:kBaseUrl
              parameters:dic
                 success:^(id responseObject) {
                    [kWINDOW hideToastActivity];
                     if (![[responseObject objectForKey:@"done"] boolValue]) {
//                         [self.enterVerify stopCount];
                         [self.view makeToast:[responseObject objectForKey:@"msg"]];
                     }else{
                         [self.enterVerify.getVerify startCountDown];
                     }
                     
                 }
                 failure:^(NSError *error) {
                     [kWINDOW hideToastActivity];

                   //  [self.view makeToast:error.description];
                     [self.enterVerify stopCount];
                 }];
}
@end

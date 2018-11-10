//
//  MineViewController.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/1/30.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "MineViewController.h"
#import "MineHeaderView.h"
#import "Masonry.h"
#import "loginModel.h"
#import "MineBodyView.h"
#import "ModifyPassWordViewController.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <Photos/PHPhotoLibrary.h>
#import "AFNetworking.h"
#import "BindAdminiViewController.h"
#import "UIImage+BarCode.h"
#import "LockListViewController.h"
#import "LockStoreManager.h"
#import "DestroyViewController.h"
@interface MineViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong)MineHeaderView *headerView;

@property (nonatomic,strong)LoginModel *loginModel;


@property (nonatomic,strong)MineBodyView *nameView;


@property (nonatomic,strong)MineBodyView *passWordView;

@property (nonatomic,strong)MineBodyView *lockListView;

@property (nonatomic,strong)MineBodyView *destroyView;


@property (nonatomic,strong)UIButton *logoutButton;

@property (nonatomic,strong)NSString *AvatarName;

@property (nonatomic,strong)NSData *imageData;

@property (nonatomic,strong)NSString *avatarUrl;

@property (nonatomic,strong)UIButton *backGroundView;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.view.backgroundColor = [UIColor whiteColor];
     self.navigationItem.title = [kMultiTool getMultiLanByKey:@"mine"];
 
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.nameView];
    [self.view addSubview:self.passWordView];
    [self.view addSubview:self.destroyView];
    [self.view addSubview:self.lockListView];
    [self.view addSubview:self.logoutButton];
    [self makeConstrains];
    [self getData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(plustouch:) name:@"didtapplus" object:nil];
   
}

- (void)plustouch:(NSNotification *)notification
{
    if (![notification.object isEqual:@3]) {
        return;
    }
   
    if (![self.navigationController.viewControllers.lastObject isKindOfClass:[BindAdminiViewController class]]) {
        
        BindAdminiViewController *bind = [[BindAdminiViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:bind];
        [self presentViewController:nav animated:NO completion:^{
            
        }];
        
    }
    
    
    

}
- (void)getData
{
    NSDictionary *logindic =
    [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
    _loginModel = [LoginModel yy_modelWithJSON:logindic];
    _headerView.loginModel = _loginModel;
    [_nameView setLeftText:[NSString stringWithFormat:@"%@:%@",[kMultiTool getMultiLanByKey:@"nickname"],_loginModel.retval.real_name]];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   // [self setNavigationUI];
    
     [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // [self setNavigationUI];
    
    [self.navigationController setNavigationBarHidden:NO];
}


- (void)makeConstrains

{
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.equalTo(self.view);
        
        make.top.equalTo(self.mas_topLayoutGuide);
        
        make.height.equalTo(@100);
        
    }];
    
    [_nameView mas_makeConstraints:^(MASConstraintMaker *make) {
      
        make.top.equalTo(self.headerView.mas_bottom).offset(20);
        make.right.left.equalTo(self.view);
        make.height.equalTo(@50);
        
    }];
    [_passWordView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.nameView.mas_bottom).offset(20);
        make.right.left.equalTo(self.view);
        make.height.equalTo(@50);
        
    }];
    [_lockListView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.passWordView.mas_bottom).offset(20);
        make.right.left.equalTo(self.view);
        make.height.equalTo(@50);
        
    }];
    
    [_destroyView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.lockListView.mas_bottom).offset(20);
        make.right.left.equalTo(self.view);
        make.height.equalTo(@50);
        
    }];
    
    [_logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(_destroyView.mas_bottom).offset(40);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@40);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
  
}
- (void)setNavigationUI
{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    
    titleLabel.textColor = [UIColor whiteColor];
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    titleLabel.text = [kMultiTool getMultiLanByKey:@"home"];
    
    self.navigationItem.titleView = titleLabel;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
   [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
  //  self.navigationController.navigationBar
    
}
#pragma mark - UI getters

- (MineHeaderView *)headerView

{
    if (!_headerView) {
        _headerView = [[MineHeaderView alloc]initWithFrame:CGRectZero];
        _headerView.loginModel = _loginModel;
    }
    @WeakSelf(self);
    _headerView.avatarBlock = ^{
      
        [weakSelf showAlart];
        
    };
    _headerView.barcodeBlock = ^{
      
        [weakSelf showBarcode];
        
        
    };
    return _headerView;
    
}
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


- (void)showBarcode
{
    NSDictionary *dic = @{@"bluemac":_loginModel.retval.bluemac,@"n":_loginModel.retval.n};
    if(!_backGroundView)
    {
        _backGroundView = [[UIButton alloc]initWithFrame:self.view.bounds];
        _backGroundView.alpha = 0.7;
        _backGroundView.backgroundColor = [UIColor blackColor];
        
        UIImageView *imageView =  [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
        imageView.image = [UIImage creatNonInterpolatedUIImageFormCIImage:[self dictionaryToJson:dic] withSize:200];
        [_backGroundView addSubview:imageView];
        imageView.center = kWINDOW.center;
        [_backGroundView addTarget:self action:@selector(dismissBarCode) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [kWINDOW addSubview:_backGroundView];
    
    
}
- (void)dismissBarCode
{
    [_backGroundView removeFromSuperview];
    
}
- (void)showAlart
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    alert.popoverPresentationController.sourceView = self.view;
    alert.popoverPresentationController.sourceRect = CGRectMake(0, 0, 1.0, 1.0);
    //按钮：从相册选择，类型：UIAlertActionStyleDefault
    UIAlertAction * takingPicAction = [UIAlertAction actionWithTitle:[kMultiTool getMultiLanByKey:@"xiangji"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
        
    }];
    //从手机相册中选择上传图片
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:[kMultiTool getMultiLanByKey:@"xiangce"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
            UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
        
    }];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:[kMultiTool getMultiLanByKey:@"quxiao"] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:takingPicAction];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    
   
    
}


- (MineBodyView *)nameView

{
    if (!_nameView) {
        _nameView = [[MineBodyView alloc]init];
       // _headerView.loginModel = _loginModel;
        [_nameView setLeftText:[NSString stringWithFormat:@"%@:%@",[kMultiTool getMultiLanByKey:@"nickname"],_loginModel.retval.real_name]];
        [_nameView setButtonText:[kMultiTool getMultiLanByKey:@"modify"]];
        @WeakSelf(self);
        _nameView.block = ^{
            [weakSelf showTextFeild];
        };
    }
    
    return _nameView;
    
}

- (void)showTextFeild
{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[kMultiTool getMultiLanByKey:@"nickname"] message:nil preferredStyle:UIAlertControllerStyleAlert];
    alert.popoverPresentationController.sourceView = self.view;
    alert.popoverPresentationController.sourceRect = CGRectMake(0, 0, 1.0, 1.0);
    //按钮：从相册选择，类型：UIAlertActionStyleDefault
    UIAlertAction * takingPicAction = [UIAlertAction actionWithTitle:[kMultiTool getMultiLanByKey:@"queding"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self modifyName];
        
    }];
    UIAlertAction * cancell = [UIAlertAction actionWithTitle:[kMultiTool getMultiLanByKey:@"cancell"] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
        
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = [kMultiTool getMultiLanByKey:@"shurunicheng"];
        
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
- (void)modifyName
{
    

    if (![PPNetworkHelper isNetwork]) {
        
        [kWINDOW makeToast:[kMultiTool getMultiLanByKey:@"lianwangshibai"]];
        
        return;
    }
    if (!_AvatarName) {
        [kWINDOW makeToast:[kMultiTool getMultiLanByKey:@"shurunicheng"]];
        return;
    }
    NSDictionary *dic = @{
                          @"token":_loginModel.retval.token,
                          @"app" : @"userloginapp",
                          @"act" : @"upname",
                          @"platform":@"iOS",
                          @"model":@"",
                          @"name":_AvatarName
                          };
    
    
    [PPNetworkHelper GET:kBaseUrl parameters:dic success:^(id responseObject) {
        
        NSDictionary *logindic =
        [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
        NSMutableDictionary *logindic1 = [[NSMutableDictionary alloc]initWithDictionary:logindic];
        NSLog(@"%@",logindic);
        NSDictionary *dic = [logindic objectForKey:@"retval"];
         NSMutableDictionary *dic1 = [[NSMutableDictionary alloc]initWithDictionary:dic];
        [dic1 setValue:_AvatarName forKey:@"real_name"];
        [logindic1 setValue:dic1 forKey:@"retval"];
        [[NSUserDefaults standardUserDefaults] setObject:logindic1 forKey:@"loginmodel"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self getData];
    } failure:^(NSError *error) {
        
    }];
    
    
    
    
    
    
}
- (MineBodyView *)passWordView

{
    if (!_passWordView) {
        _passWordView = [[MineBodyView alloc]init];
        // _headerView.loginModel = _loginModel;
        [_passWordView setLeftText:[kMultiTool getMultiLanByKey:@"password"]];
         @WeakSelf(self);
        _passWordView.block = ^{
            ModifyPassWordViewController *modify = [[ModifyPassWordViewController alloc]init];
            [weakSelf.navigationController pushViewController:modify animated:NO];
          
        };
    }
    
    return _passWordView;
    
}
- (MineBodyView *)lockListView

{
    if (!_lockListView) {
        _lockListView = [[MineBodyView alloc]init];
        // _headerView.loginModel = _loginModel;
        [_lockListView setLeftText:[kMultiTool getMultiLanByKey:@"locklist"]];
         @WeakSelf(self);
        _lockListView.block = ^{
            LockListViewController *list = [[LockListViewController alloc]init];
            [weakSelf.navigationController pushViewController:list animated:NO];
        };
    }
    
    return _lockListView;
    
}

- (MineBodyView *)destroyView

{
    if (!_destroyView) {
        _destroyView = [[MineBodyView alloc]init];
        // _headerView.loginModel = _loginModel;
        [_destroyView setLeftText:[kMultiTool getMultiLanByKey:@"destroyaccount"]];
         @WeakSelf(self);
        _destroyView.block = ^{
            [weakSelf showDestroyAlert];
        };
    }
    
    return _destroyView;
    
}

- (UIButton *)logoutButton
{
    if (!_logoutButton) {
        _logoutButton = [[UIButton alloc]init];
        [_logoutButton setTitle:[kMultiTool getMultiLanByKey:@"logout"] forState:UIControlStateNormal];
        [_logoutButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_logoutButton setBackgroundColor:[UIColor colorWithRed:248/255.0 green:250/255.0 blue:244/255.0 alpha:1.0]];
    }
    [_logoutButton addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    
    return _logoutButton;
}

- (void)logout
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"logout" object:nil];
    
}

#pragma mark - destroy

- (void)showDestroyAlert
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
    alert.popoverPresentationController.sourceView = self.view;
    alert.popoverPresentationController.sourceRect = CGRectMake(0, 0, 1.0, 1.0);
    alert.title = [kMultiTool getMultiLanByKey:@"zhuxiaotishi"];
    [alert addAction:[UIAlertAction actionWithTitle:[kMultiTool getMultiLanByKey:@"queding"] style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self doDestroy];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:[kMultiTool getMultiLanByKey:@"cancell"] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    }]];

    [self presentViewController:alert animated:YES completion:nil];
    
}
- (void)doDestroy
{
         DestroyViewController *destroy = [[DestroyViewController alloc]init];
    [self.navigationController pushViewController:destroy animated:NO];
    
    
    
    
    
    
    
}

#pragma mark -upload avatar
// 上传验证
- (void)upload
{
   
    NSDictionary *dic = @{
                          @"token":_loginModel.retval.token,
                          @"app" : @"userapp",
                          @"act" : @"upfile",
                          @"platform":@"iOS",
                          @"model":@""
                          };
    [kWINDOW makeToastActivity:CSToastPositionCenter];

    
    [PPNetworkHelper GET:kBaseUrl parameters:dic success:^(id responseObject) {
//        [kWINDOW hideToastActivity];

        NSDictionary *dic = [responseObject objectForKey:@"retval"];
        NSString *userId = [dic objectForKey:@"userid"]? [dic objectForKey:@"userid"]:@"";
        NSString *httpagent = [dic objectForKey:@"HTTP_USER_AGENT"]? [dic objectForKey:@"HTTP_USER_AGENT"]:@"";
        NSString *ecm = [dic objectForKey:@"ECM_ID"]? [dic objectForKey:@"ECM_ID"]:@"";
        [self uploadImage:userId Agent:httpagent ECM:ecm];
        
        
        
    } failure:^(NSError *error) {
        [kWINDOW hideToastActivity];

    }];
    
    
    
}
//上传图片
- (void)uploadImage:(NSString* )userId Agent:(NSString*)httpagent ECM:(NSString *)ecm
{
  
//    [kWINDOW makeToastActivity:CSToastPositionCenter];

    
    NSString *url = [NSString stringWithFormat:@"%@?token=%@&ECM_ID=%@&HTTP_USER_AGENT=%@&app=appupload&ajax=ajax&XDEBUG_SESSION_START=ECLIPSE_DBGP&belong=5&item_id=%@",kBaseUrl,_loginModel.retval.token,ecm,httpagent,_loginModel.retval.user_id];
   
   NSString *_dataString = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSDictionary *dic = @{
                          @"token":_loginModel.retval.token,
                          @"app" : @"appupload",
                          @"ECM_ID":ecm,
                          @"HTTP_USER_AGENT":httpagent,
                          @"ajax":@"ajax",
                          @"XDEBUG_SESSION_START":@"ECLIPSE_DBGP",
                          @"belong":@5,
                          @"item_id":_loginModel.retval.user_id
                          
                          
                          };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //发送网络请求
    [manager POST:_dataString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        dateString = [NSString stringWithFormat:@"%@.png",dateString];
      //  NSString *fileName;
        [formData appendPartWithFileData:_imageData name:@"file" fileName:dateString mimeType:@"image"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [kWINDOW hideToastActivity];
        NSDictionary *dic = [responseObject objectForKey:@"retval"];
        NSString *filePath = [dic objectForKey:@"file_path"];
//        filePath = [NSString stringWithFormat:@"http://27.223.29.134:6052/%@",filePath];
        [self modify:@"" filePath:filePath];
        _avatarUrl = filePath;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [kWINDOW hideToastActivity];
        
    }];
    
    
    
   // [PPNetworkHelper pos];
    
}

- (void)modify:(NSString *)fileId filePath:(NSString *)path
{
   
//    [kWINDOW makeToastActivity:CSToastPositionCenter];
    NSDictionary *logindic =
    [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
    
    LoginModel *loginModel = [LoginModel yy_modelWithJSON:logindic];
    NSDictionary *dic = @{@"app":@"userloginapp",@"token":loginModel.retval.token,@"headerimg":path,@"act":@"upheaderimg",@"platform":@"iOS",@"model":@""};
    
    [PPNetworkHelper GET:kBaseUrl parameters:dic success:^(id responseObject) {
        [kWINDOW hideToastActivity];
        if ([[responseObject objectForKey:@"done"] intValue]==1) {
            //上传头像 成功
            NSDictionary *logindic =
            [[NSUserDefaults standardUserDefaults] objectForKey:@"loginmodel"];
            NSMutableDictionary *logindic1 = [[NSMutableDictionary alloc]initWithDictionary:logindic];
            NSLog(@"%@",logindic);
            NSDictionary *dic = [logindic objectForKey:@"retval"];
            NSMutableDictionary *dic1 = [[NSMutableDictionary alloc]initWithDictionary:dic];
            [dic1 setValue:path forKey:@"h"];
            [logindic1 setValue:dic1 forKey:@"retval"];
            [[NSUserDefaults standardUserDefaults] setObject:logindic1 forKey:@"loginmodel"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            LoginModel *loginmodel = [LoginModel yy_modelWithJSON:logindic1];
            self.headerView.loginModel = loginmodel;
        }
    } failure:^(NSError *error) {
        [kWINDOW hideToastActivity];
    }];


    
    
    
    
    
}
#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *newImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
       
    [picker dismissViewControllerAnimated:YES completion:nil];
    _imageData =  UIImageJPEGRepresentation(newImage, 0.5);
    [self upload];
    
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}



@end

//
//  WatchBindViewController.m
//  caxjh
//
//  Created by niuxinghua on 2017/11/24.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import "WatchBindViewController.h"
#import "BindWatchTableViewCell.h"
#import "UIViewController+StatusBar.h"
#import "BindWatchTableViewCell.h"
#import "UIBarButtonItem+UC.h"
#import "UIColor+EAHexColor.h"
#import "PPNetworkHelper.h"
#import "Const.h"
#import "XJHStudentCardScanViewController.h"
#import "SocketManager.h"
#import <AVFoundation/AVCaptureDevice.h>
#import "AFNetWorking.h"
#import "UIButton+WebCache.h"


@interface WatchBindViewController ()<UITableViewDelegate,UITableViewDataSource,XJHStudentCardScanViewControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>
@property (nonatomic,strong)UITableView *settingTable;
@property (nonatomic,strong)NSMutableArray *datalist;
@property (nonatomic,strong)UIActionSheet *actionSheet;
@property (nonatomic,strong)UIButton *headBtn;
@end

@implementation WatchBindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _settingTable = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self setStatusBarDefaultColor];
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem uc_backBarButtonItemWithAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.title = @"添加设备";
    if (_isedit) {
        self.title = @"编辑设备";
    }
    self.view.backgroundColor = [UIColor whiteColor];
    _settingTable.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 30);
    [self.view addSubview:_settingTable];
    _settingTable.tableFooterView = [UIView new];
    _settingTable.dataSource = self;
    _settingTable.delegate = self;
    _datalist = [[NSMutableArray alloc]init];
    _settingTable.backgroundColor = [UIColor colorWithHex:@"#fafafa"];
    UITapGestureRecognizer *re = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEdit)];
    
    [self.view addGestureRecognizer:re];
    [_settingTable addGestureRecognizer:re];
}
- (void)endEdit{
    
    [self.view endEditing:YES];
    [_settingTable endEditing:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 160;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 160;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    bgView.backgroundColor = [UIColor clearColor];
    _headBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    _headBtn.layer.cornerRadius = 40;
    _headBtn.layer.masksToBounds = YES;
    
    [_headBtn setBackgroundImage:[UIImage imageNamed:@"uploaddevice"] forState:UIControlStateNormal];
    _headBtn.layer.cornerRadius = 40;
    _headBtn.layer.masksToBounds = YES;
    
    [_headBtn sd_setImageWithURL:[_dic objectForKey:@"image"] forState:UIControlStateNormal];
    [_headBtn addTarget:self action:@selector(startGetPhoto) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_headBtn];
    
    _headBtn.center = CGPointMake(bgView.center.x, bgView.center.y);
    
    return bgView;
                         
    
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    bgView.backgroundColor = [UIColor clearColor];
    UIButton *headBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 30, 50)];
    [headBtn setBackgroundColor:[UIColor colorWithHex:@"#ff6767"]];
    NSString *title1 = @"确认绑定";
    if (_isedit) {
        title1 = @"确认";
    }
    [headBtn setTitle:title1 forState:UIControlStateNormal];
    [headBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    headBtn.layer.cornerRadius = 3;
    headBtn.layer.masksToBounds = YES;
    
   [headBtn addTarget:self action:@selector(bindWatch) forControlEvents:UIControlEventTouchUpInside];
    
    [bgView addSubview:headBtn];
    
    headBtn.center = CGPointMake(bgView.center.x, bgView.center.y);
    
    return bgView;
    
}
#pragma mark-datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BindWatchTableViewCell *cell = [[BindWatchTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    NSDictionary *dic1 = [SocketManager sharedInstance].locationDic;
    //NSDictionary *dic = [];
    if ([indexPath row] == 0) {
        [cell setIconImage:[UIImage imageNamed:@"ficon.png"]];
        [cell setTextFieldPlaceHolder:@"点击输入/扫描二维码识别手表"];
        if (_isedit) {
            [cell setImei:[dic1 objectForKey:@"imei"]];
            [cell setTextEnable:NO];
        }else{
            [cell setbottomLineHidden];
            [cell showActionButton];
            cell.scanBlock = ^{
                [self scan];
            };
        }
        
    }
    if ([indexPath row] == 1) {
        [cell setIconImage:[UIImage imageNamed:@"sicon.png"]];
        [cell setTextFieldPlaceHolder:@"点击输入设备名称"];
        if (_isedit) {
            [cell setImei:[dic1 objectForKey:@"name"]];
        }
    }
    if ([indexPath row] == 2) {
        [cell setTopLineHidden];
        [cell setIconImage:[UIImage imageNamed:@"ticon.png"]];
        [cell setTextFieldPlaceHolder:@"点击输入设备的电话号码"];
        if (_isedit) {
            [cell setImei:[dic1 objectForKey:@"phone"]];
        }
    }
    
    return cell;
    
}

#pragma mark - api method

- (void)bindWatch
{
    //
    
    if (!_isedit) {
        
    
    
    
    
    NSLog(@"bind------");
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    BindWatchTableViewCell *cell = [_settingTable cellForRowAtIndexPath:indexPath];
    NSString *userID = [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];
    if (![[cell getImei] isEqual:[NSNull null]] && ![[cell getImei] isEqualToString:@""]) {
        NSDictionary *dic = @{@"memberId":userID,@"IMEI":[cell getImei]};
        
        [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
        [PPNetworkHelper POST:kAPIBindWatch parameters:dic success:^(id responseObject) {
            
            [self.navigationController popViewControllerAnimated:NO];
            
        } failure:^(NSError *error) {
            
        }];
    }
   
   
    }
    else{
        //编辑
//        header：https://children.xiangjianhai.com:999/app/update?token=7205589feec837eba4ae654e200daa4
//        请求参数：
//        {
//            "table": "Watch",
//            "fields":{"name":"测试手表","image":"","phone":"15705427497"},
//            "id":"ff8080815fe29647015fe29b14680000"
//        }
//        备注：
//        只是修改名字
//        { "table": "Watch","fields":{"name":"测试手表"},"id":"ff8080815fe29647015fe29b14680000"}
//        只修改手表图片
//        { "table": "Watch","fields":{"image":""},"id":"ff8080815fe29647015fe29b14680000"}
//        只修改手表上的SIM卡号
//        { "table": "Watch","fields":{"phone":"15705427497"},"id":"ff8080815fe29647015fe29b14680000"}
        
        NSDictionary *dic1 = [SocketManager sharedInstance].locationDic;
        NSIndexPath *phoneindexpath = [NSIndexPath indexPathForRow:2 inSection:0];
           NSIndexPath *nameindexpath = [NSIndexPath indexPathForRow:1 inSection:0];
        BindWatchTableViewCell *namecell = [_settingTable cellForRowAtIndexPath:nameindexpath];
        BindWatchTableViewCell *phonecell = [_settingTable cellForRowAtIndexPath:phoneindexpath];
        NSString *name = [namecell getImei];
        if (!name) {
            name = @"";
        }
        NSString *phone = [phonecell getImei];
        if (!phone) {
            phone = @"";
        }
        
        //tido  增加url
        NSDictionary *imagedic = [SocketManager sharedInstance].locationDic;
        NSDictionary * dic =  @{
                        @"table": @"Watch",
                        @"fields":@{@"name":name,@"image":[imagedic objectForKey:@"image"],@"phone":phone},
                        @"id":[dic1 objectForKey:@"id"]
                        };
        NSMutableDictionary *dic2 = [[NSMutableDictionary alloc]initWithDictionary:dic1];
        [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
        [PPNetworkHelper POST:kAPIEditFence parameters:dic success:^(id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            [dic2 setValue:name forKey:@"name"];
            [dic2 setValue:phone forKey:@"phone"];
            [SocketManager sharedInstance].locationDic = dic2.copy;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"watchname" object:nil];
            [self.navigationController popViewControllerAnimated:NO];
            
        } failure:^(NSError *error) {
           [MBProgressHUD hideHUDForView:self.view animated:NO];
            [self.view makeToast:@"失败"];
        }];
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
}



- (void)scan
{
    XJHStudentCardScanViewController *scanViewController = [[XJHStudentCardScanViewController alloc] init];
    scanViewController.isEdit = YES;
    scanViewController.delegate = self;
    [self.navigationController pushViewController:scanViewController animated:YES];
    
}
- (void)finishScanWithText:(NSString *)text
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    BindWatchTableViewCell *cell = [_settingTable cellForRowAtIndexPath:indexPath];
    cell.textFeild.text = text;
    
}




//点击更换头像时开始执行此方法
- (void)startGetPhoto
{
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                     destructiveButtonTitle:nil
                                          otherButtonTitles:@"相册", @"拍照", nil];
   // self.actionSheet.tag = ActionSheetTagAddPhoto;
    [self.actionSheet showInView:self.view];
}

#pragma mark -
#pragma mark UIActionSheetDelegate Call Back Implementation

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex)
    {
        //打开本地相册
        [self localPhoto];
    }
    else if(1 == buttonIndex)
    {
        // 开始拍照
        [self takePhoto];
    }
    
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate Call Back Implementation

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        NSString *key = nil;
        
        if (picker.allowsEditing)
        {
            key = UIImagePickerControllerEditedImage;
        }
        else
        {
            key = UIImagePickerControllerOriginalImage;
        }
        //获取图片
        UIImage *image = [info objectForKey:key];
        
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            // 固定方向
           // image = [image fixOrientation];//这个方法是UIImage+Extras.h中方法
            //压缩图片质量
            image = [self reduceImage:image percent:0.1];
            CGSize imageSize = image.size;
            imageSize.height = 320;
            imageSize.width = 320;
            //压缩图片尺寸
            image = [self imageWithImageSimple:image scaledToSize:imageSize];
        }
        //上传到服务器
        [self doAddPhoto:image];
        //关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

// 开始拍照
-(void)takePhoto
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //先检查相机可用是否
        BOOL cameraIsAvailable = [self checkCamera];
        if (YES == cameraIsAvailable) {
            [self presentViewController:picker animated:YES completion:nil];
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请在iPhone的“设置-隐私-相机”选项中，允许本应用程序访问你的相机。" delegate:self cancelButtonTitle:@"好，我知道了" otherButtonTitles:nil];
            [alert show];
        }
        
    }
}

// 打开本地相册
-(void)localPhoto
{
    //本地相册不需要检查，因为UIImagePickerController会自动检查并提醒
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    
    //这是捕获点击右上角cancel按钮所触发的事件，如果我们需要在点击cancel按钮的时候做一些其他逻辑操作。就需要实现该代理方法，如果不做任何逻辑操作，就可以不实现
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

//检查相机是否可用
- (BOOL)checkCamera
{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(AVAuthorizationStatusRestricted == authStatus ||
       AVAuthorizationStatusDenied == authStatus)
    {
        //相机不可用
        return NO;
    }
    //相机可用
    return YES;
}

//压缩图片质量
-(UIImage *)reduceImage:(UIImage *)image percent:(float)percent
{
    NSData *imageData = UIImageJPEGRepresentation(image, percent);
    UIImage *newImage = [UIImage imageWithData:imageData];
    return newImage;
}
//压缩图片尺寸
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)doAddPhoto:(UIImage *)image
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    
    NSString *fileName;
   // UIImage *image = image;
    NSData *data = nil;
    
    data = UIImageJPEGRepresentation(image, 0.3f);
    
    BOOL isJPG;
    
    if (data) {
        fileName = [NSString stringWithFormat:@"%@.jpg", dateString];
        isJPG = YES;
    } else {
        data = UIImagePNGRepresentation(image);
        fileName = [NSString stringWithFormat:@"%@.png", dateString];
        isJPG = NO;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[self manager] POST:[kAPIUploadImage stringByAppendingString:fileName] parameters:[NSDictionary new] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (!data) {
            return ;
        }
        
        if (isJPG) {
            // [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/jpg"];
            [formData appendPartWithFileData:data name:fileName fileName:fileName mimeType:@"image/jpg"];
        } else {
            // [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/png"];
            [formData appendPartWithFileData:data name:fileName fileName:fileName mimeType:@"image/png"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSString *imageURL = [responseObject objectForKey:@"url"];
        
        if ([imageURL isEqual:[NSNull null]]) {
            return ;
        }
        
        if (imageURL.length == 0) {
            return ;
        }
        NSDictionary *dic1 = [SocketManager sharedInstance].locationDic;
        NSDictionary * dic =  @{
                                @"table": @"Watch",
                                @"fields":@{@"image":imageURL},
                                @"id":[dic1 objectForKey:@"id"]
                                };
        NSMutableDictionary *dic2 = [[NSMutableDictionary alloc]initWithDictionary:dic1];
        [MBProgressHUD showHUDAddedTo:self.view animated:NO];
        [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
        [PPNetworkHelper POST:kAPIEditFence parameters:dic success:^(id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            NSDictionary *diclocate = [SocketManager sharedInstance].locationDic;
            [dic2 setValue:imageURL forKey:@"image"];
            [SocketManager sharedInstance].locationDic = dic2.copy;
            [_headBtn sd_setImageWithURL:[NSURL URLWithString:imageURL] forState:UIControlStateNormal];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"watchImage" object:imageURL];
            
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:NO];
            [self.view makeToast:@"失败"];
        }];
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
    
    

    
    


- (AFHTTPSessionManager *)manager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [[manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"] setByAddingObject:@"text/plain"];
    return manager;
}

@end

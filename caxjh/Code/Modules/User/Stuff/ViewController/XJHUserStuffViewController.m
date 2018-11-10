//
//  XJHUserStuffViewController.m
//  caxjh
//
//  Created by Yingchao Zou on 30/08/2017.
//  Copyright © 2017 Yingchao Zou. All rights reserved.
//

#import "XJHUserStuffViewController.h"
#import "XJHStuffAvatarTableViewCell.h"
#import "XJHStuffNumberTableViewCell.h"
#import "XJHStuffNickNameTableViewCell.h"
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <Photos/PHPhotoLibrary.h>
#import "AFNetworking.h"

@interface XJHUserStuffViewController ()

<
UITableViewDelegate,
UITableViewDataSource,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>

@property (nonatomic, readwrite, strong) UITableView *tableView;

@end

@implementation XJHUserStuffViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setStatusBarDefaultColor];
    
    self.title = @"我的信息";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem uc_backBarButtonItemWithAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// UITableViewDelegate
// UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 95.0;
    }
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 10;
    }
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    
    else if (section == 1) {
        return 3;
    }
    
    return 0;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 0) {
        return NO;
    }
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    
    if (section == 0) {
        if (row == 0) {
            XJHStuffAvatarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XJHStuffAvatarTableViewCell"];
            if (!cell) {
                cell = [[XJHStuffAvatarTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XJHStuffAvatarTableViewCell"];
                cell.theImageView.image = [UIImage imageNamed:@"默认头像"];
            }
            if (![self.avatar isEqual:[NSNull null]]) {
                [cell.theImageView sd_setImageWithURL:[NSURL URLWithString:self.avatar] placeholderImage:[UIImage imageNamed:@"默认头像"]];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
    }
    
    else if (section == 1) {
        if (row == 0) {
            XJHStuffNumberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XJHStuffNumberTableViewCell"];
            if (!cell) {
                cell = [[XJHStuffNumberTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XJHStuffNumberTableViewCell"];
            }
            cell.theLeftLabel.text = @"手机号";
            
            NSString *phone = [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_DATA_PHONE"];
            cell.theRightLabel.text = phone;
            
            return cell;
        }
        
        else if (row == 1) {
            XJHStuffNickNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XJHStuffNickNameTableViewCell"];
            if (!cell) {
                cell = [[XJHStuffNickNameTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XJHStuffNickNameTableViewCell"];
            }
            cell.theLeftLabel.text = @"昵称";
            if (![self.userName isEqual:[NSNull null]]) {
                cell.theRightLabel.text = self.userName;
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
        
        else if (row == 2) {
            XJHStuffNickNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XJHStuffNickNameTableViewCell"];
            if (!cell) {
                cell = [[XJHStuffNickNameTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XJHStuffNickNameTableViewCell"];
            }
            cell.theLeftLabel.text = @"收货地址";
            if (![self.address isEqual:[NSNull null]]) {
                cell.theRightLabel.text = self.address;
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
        
        
    }
    
    return [[UITableViewCell alloc] init];
}

- (void)takePhotoAction {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
        
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus ==AVAuthorizationStatusRestricted ||
            authStatus ==AVAuthorizationStatusDenied) {
            [self createAlertControllerWithType:@"相机" AndViewController:picker];
        }
    } else {
        [self.view makeToast:@"该设备无摄像头" duration:1.0 position:CSToastPositionTop];
    }
}

#pragma mark - 从相册获取 Selector

- (void)localPhotoAlbumAction {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        [self createAlertControllerWithType:@"相册" AndViewController:imagePicker];
    }
}

#pragma mark - 权限未开提示框

- (void)createAlertControllerWithType:(NSString *)type AndViewController:(UIImagePickerController *)pickerController {
    NSString *message = nil;
    if ([type isEqualToString:@"相机"]) {
        message = @"请在iPhone的“设置-隐私-相机”选项中，允许U-Care访问你的相机。";
    }
    
    else if ([type isEqualToString:@"相册"]) {
        message = @"请在iPhone的“设置-隐私-照片”选项中，允许U-Care访问你的手机相册。";
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    alert.popoverPresentationController.sourceView = self.view;
    alert.popoverPresentationController.sourceRect = CGRectMake(0, 0, 1.0, 1.0);
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:cancelAction];
    
    [pickerController presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *newImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (newImage) {
        /* 调接口上传图片 */
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        
        NSString *fileName;
        UIImage *image = newImage;
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
            
            NSString *userID = [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];
            
            NSDictionary *dictionary = @{@"fields":@{@"avatar":imageURL},@"id":userID,@"table":@"Member"};
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
            [PPNetworkHelper POST:kAPIUpdateURL parameters:dictionary success:^(id responseObject) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                XJHLoginResponse *loginResponse = [XJHLoginResponse mj_objectWithKeyValues:responseObject];
                NSLog(@"%@", loginResponse);
                
                if ([loginResponse.type isEqualToString:@"success"]) {
                    self.avatar = imageURL;
                    
                    [self performSelector:@selector(waitThenReload) withObject:nil afterDelay:2.0];
                } else {
                    [self.view makeToast:loginResponse.content duration:1.0 position:CSToastPositionTop];
                }
                
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)waitThenReload {
    [self.tableView reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NEED_REGET_USER_STUFF" object:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    
    if (section == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        alertController.popoverPresentationController.sourceView = self.view;
        alertController.popoverPresentationController.sourceRect = CGRectMake(0, 0, 1.0, 1.0);
        UIAlertAction *actionTeacher = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self takePhotoAction];
        }];
        UIAlertAction *actionStudent = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self localPhotoAlbumAction];
        }];
        [alertController addAction:actionTeacher];
        [alertController addAction:actionStudent];
        [self.navigationController presentViewController:alertController animated:YES completion:^{
            
        }];
    }
    
    else if (section == 1) {
        if (row == 1) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"编辑昵称" message:nil preferredStyle:UIAlertControllerStyleAlert];
            alertController.popoverPresentationController.sourceView = self.view;
            alertController.popoverPresentationController.sourceRect = CGRectMake(0, 0, 1.0, 1.0);
            
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UITextField *textField = alertController.textFields[0];
                NSString *nickName = textField.text;
                NSDictionary *dictionary;
                
                NSString *userID = [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];
                
                
                dictionary = @{@"fields":@{@"name":nickName},@"id":userID,@"table":@"Member"};
                
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
                [PPNetworkHelper POST:kAPIUpdateURL parameters:dictionary success:^(id responseObject) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    XJHLoginResponse *loginResponse = [XJHLoginResponse mj_objectWithKeyValues:responseObject];
                    NSLog(@"%@", loginResponse);
                    
                    if ([loginResponse.type isEqualToString:@"success"]) {
                        
                        self.userName = nickName;
                        [self.tableView reloadData];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"NEED_REGET_USER_STUFF" object:nil];
    
                    } else {
                        [self.view makeToast:loginResponse.content duration:1.0 position:CSToastPositionTop];
                    }
                    
                } failure:^(NSError *error) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }];

                
            }];
            [alertController addAction:confirm];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:cancel];
            
            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = @"请输入昵称";
                if (![self.userName isEqual:[NSNull null]]) {
                    textField.text = self.userName;
                }
                
            }];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
        //////////////////////
        
        
        else if (row == 2) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"编辑地址" message:nil preferredStyle:UIAlertControllerStyleAlert];
            alertController.popoverPresentationController.sourceView = self.view;
            alertController.popoverPresentationController.sourceRect = CGRectMake(0, 0, 1.0, 1.0);
            
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                UITextField *textField = alertController.textFields[0];
                NSString *address = textField.text;
                NSDictionary *dictionary;
                
                NSString *userID = [[NSUserDefaults standardUserDefaults] stringForKey:@"USER_ID"];
                
                dictionary = @{@"fields":@{@"address":address},@"id":userID,@"table":@"Member"};
                
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [PPNetworkHelper setRequestSerializer:PPRequestSerializerJSON];
                [PPNetworkHelper POST:kAPIUpdateURL parameters:dictionary success:^(id responseObject) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    XJHLoginResponse *loginResponse = [XJHLoginResponse mj_objectWithKeyValues:responseObject];
                    
                    if ([loginResponse.type isEqualToString:@"success"]) {
                        self.address = address;
                        [self.tableView reloadData];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"NEED_REGET_USER_STUFF" object:nil];
                    } else {
                        [self.view makeToast:loginResponse.content duration:1.0 position:CSToastPositionTop];
                    }
                } failure:^(NSError *error) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }];
                
            }];
            [alertController addAction:confirm];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:cancel];
            
            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = @"请输入地址";
                if (![self.address isEqual:[NSNull null]]) {
                    textField.text = self.address;
                }
                
            }];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (AFHTTPSessionManager *)manager {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [[manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"] setByAddingObject:@"text/plain"];
    return manager;
}

@end

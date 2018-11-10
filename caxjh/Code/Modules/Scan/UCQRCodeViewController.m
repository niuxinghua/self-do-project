//
//  UCQRCodeViewController.m
//  WuRenJi
//
//  Created by Yingchao Zou on 23/11/2016.
//  Copyright © 2016 Casey. All rights reserved.
//

#import "UCQRCodeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UCQRCodeScanView.h"
#import "UCQRCodeBackgroundView.h"
#import "ZXQRCodeDecoder.h"
#import "UIColor+UC.h"

@interface UCQRCodeViewController ()

<
AVCaptureMetadataOutputObjectsDelegate,
UINavigationControllerDelegate
>

@property (nonatomic, readwrite, strong) UCQRCodeBackgroundView *upView;
@property (nonatomic, readwrite, strong) UCQRCodeBackgroundView *downView;
@property (nonatomic, readwrite, strong) UCQRCodeBackgroundView *leftView;
@property (nonatomic, readwrite, strong) UCQRCodeBackgroundView *rightView;

@property (nonatomic, readwrite, strong) UCQRCodeScanView *scanView;
@property (nonatomic, readwrite, strong) UILabel *hintLabel;

@property (nonatomic, readwrite, strong) UIView *buttonContainer; // 容器放下面这两个按钮

@property (nonatomic, readwrite, strong) UIButton *skipButton; // 直接跳转以后帮助输入

@property (nonatomic, readwrite, strong) AVCaptureSession *session;
@property (nonatomic, readwrite, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

@property (nonatomic, readwrite, strong) UIActivityIndicatorView *indicatorView;  // 准备视图
@property (nonatomic, readwrite, strong) UILabel *readyLabel;  // 准备文字

@end

@implementation UCQRCodeViewController

#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.indicatorView = [[UIActivityIndicatorView alloc] init];
    self.indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    self.indicatorView.hidesWhenStopped = YES;
    [self.view addSubview:self.indicatorView];
    [self.indicatorView startAnimating];
    
    self.readyLabel = [[UILabel alloc] init];
    self.readyLabel.textColor = [UIColor whiteColor];
    self.readyLabel.textAlignment = NSTextAlignmentCenter;
    self.readyLabel.text = @"准备中...";
    self.readyLabel.font = [UIFont systemFontOfSize:15.0f];
    [self.view addSubview:self.readyLabel];
    
    self.navigationItem.title = self.navigationTitle;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem uc_backBarButtonItemWithAction:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem uc_barButtonItemWithAction:^{
        if (!self.session.isRunning) {
            [self.session startRunning];
            [self.scanView startAnimation];
        }
    } text:@"刷新"];
    
    self.upView = [[UCQRCodeBackgroundView alloc] init];
    [self.view addSubview:self.upView];
    self.downView = [[UCQRCodeBackgroundView alloc] init];
    [self.view addSubview:self.downView];
    self.leftView = [[UCQRCodeBackgroundView alloc] init];
    [self.view addSubview:self.leftView];
    self.rightView = [[UCQRCodeBackgroundView alloc] init];
    [self.view addSubview:self.rightView];
    
    self.scanView = [[UCQRCodeScanView alloc] init];
    [self.view addSubview:self.scanView];
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    if (!input) {
        self.view.backgroundColor = [UIColor whiteColor];
        [self.view makeToast:@"获取视频设备失败，请确保相机权限开启" duration:2.0 position:CSToastPositionTop];
    }
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    //output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
   
    
   
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    if (input) {
        [self.session addInput:input];
    }
    [self.session addOutput:output];
    
    if (input) {
        output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    }
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,//二维码
                                 //以下为条形码，如果项目只需要扫描二维码，下面都不要写
                                 AVMetadataObjectTypeEAN13Code,
                                 AVMetadataObjectTypeEAN8Code,
                                 AVMetadataObjectTypeUPCECode,
                                 AVMetadataObjectTypeCode39Code,
                                 AVMetadataObjectTypeCode39Mod43Code,
                                 AVMetadataObjectTypeCode93Code,
                                 AVMetadataObjectTypeCode128Code,
                                 AVMetadataObjectTypePDF417Code];
    
    self.videoPreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer insertSublayer:self.videoPreviewLayer atIndex:0];
    
    self.hintLabel = [[UILabel alloc] init];
    self.hintLabel.text = self.hint;
    self.hintLabel.textColor = [UIColor whiteColor];
    self.hintLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.hintLabel];
    
    self.buttonContainer = [[UIView alloc] init];
    [self.view addSubview:self.buttonContainer];
    
    self.imageButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.imageButton setTitle:@"图片识别" forState:UIControlStateNormal];
    [self.imageButton setTitleColor:[UIColor uCareGreenColor] forState:UIControlStateNormal];
    [self.imageButton bk_addEventHandler:^(id sender) {
        
    } forControlEvents:UIControlEventTouchUpInside];
    [self.buttonContainer addSubview:self.imageButton];
    
    self.skipButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.skipButton setTitle:self.skip forState:UIControlStateNormal];
    [self.skipButton setTitleColor:[UIColor uCareGreenColor] forState:UIControlStateNormal];
    [self.skipButton bk_addEventHandler:^(id sender) {
        [self willTryToSkip];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.buttonContainer addSubview:self.skipButton];
    
    [self theLayout];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.videoPreviewLayer.frame = self.view.bounds;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.indicatorView stopAnimating];
    [self.indicatorView removeFromSuperview];
    [self.readyLabel removeFromSuperview];
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.session startRunning];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Layout

- (void)theLayout {
    UIView *view = self.view;
    
    [self.scanView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@200);
        make.height.equalTo(@200);
        make.centerX.equalTo(view.mas_centerX);
        make.centerY.equalTo(view.mas_centerY);
    }];
    
    [self.indicatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.scanView.mas_centerY);
        make.centerX.equalTo(self.scanView.mas_centerX).offset(- 18.5 - 3 - 25);
    }];
    
    [self.readyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.scanView.mas_centerY);
        make.centerX.equalTo(self.scanView.mas_centerX).offset(20);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(30);
    }];
    
    [self.upView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.top.equalTo(view);
        make.bottom.equalTo(self.scanView.mas_top);
    }];
    
    [self.downView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(view);
        make.top.equalTo(self.scanView.mas_bottom);
        make.bottom.equalTo(view);
    }];
    
    [self.leftView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view);
        make.right.equalTo(self.scanView.mas_left);
        make.top.equalTo(self.upView.mas_bottom);
        make.bottom.equalTo(self.downView.mas_top);
    }];
    
    [self.rightView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scanView.mas_right);
        make.right.equalTo(view);
        make.top.equalTo(self.upView.mas_bottom);
        make.bottom.equalTo(self.downView.mas_top);
    }];
    
    [self.hintLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left);
        make.right.equalTo(view.mas_right);
        make.top.equalTo(self.scanView.mas_bottom).with.offset(20);
    }];

    [self.buttonContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(self.hintLabel.mas_bottom).with.offset(20);
        make.width.equalTo(@160);
    }];
    
    [self.imageButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.equalTo(self.buttonContainer);
    }];
    
    [self.skipButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.equalTo(self.buttonContainer);
    }];
    
    self.videoPreviewLayer.frame = view.bounds;
}

#pragma mark - 

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *metadataObject = [metadataObjects objectAtIndex:0];
        
        if ([metadataObject respondsToSelector:@selector(stringValue)]) {
            [self finishScanWithResult:metadataObject.stringValue];
        }
        
        [self.session stopRunning];
        [self.scanView stopAnimation];
    }
}

#pragma mark - 

- (void)finishScanWithResult:(NSString *)result {
    
}

- (void)willTryToSkip {

}

- (void)willTryToSkipWithImageDetectResult:(NSString *)imageDetectResult {
    
}

@end

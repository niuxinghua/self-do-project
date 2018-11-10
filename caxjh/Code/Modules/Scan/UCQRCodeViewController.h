//
//  UCQRCodeViewController.h
//  WuRenJi
//
//  Created by Yingchao Zou on 23/11/2016.
//  Copyright © 2016 Casey. All rights reserved.
//

#import "XJHBaseViewController.h"

@interface UCQRCodeViewController : XJHBaseViewController

@property (nonatomic, readwrite, copy) NSString *navigationTitle;
@property (nonatomic, readwrite, copy) NSString *hint;
@property (nonatomic, readwrite, copy) NSString *skip;

@property (nonatomic, readwrite, strong) UIButton *imageButton; // 选择图片识别以后跳转后帮助输入

- (void)finishScanWithResult:(NSString *)result;
- (void)willTryToSkip;

// 图片识别出来了
- (void)willTryToSkipWithImageDetectResult:(NSString *)imageDetectResult;

@end

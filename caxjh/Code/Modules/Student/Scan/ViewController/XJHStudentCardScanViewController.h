//
//  XJHStudentCardScanViewController.h
//  caxjh
//
//  Created by Yingchao Zou on 30/08/2017.
//  Copyright © 2017 Yingchao Zou. All rights reserved.
//

#import "UCQRCodeViewController.h"

@protocol XJHStudentCardScanViewControllerDelegate <NSObject>

- (void)finishScanWithText:(NSString *)text;

@end

@interface XJHStudentCardScanViewController : UCQRCodeViewController

@property (nonatomic, readwrite, weak) id<XJHStudentCardScanViewControllerDelegate> delegate;

@property (nonatomic,assign)BOOL isEdit;

@end

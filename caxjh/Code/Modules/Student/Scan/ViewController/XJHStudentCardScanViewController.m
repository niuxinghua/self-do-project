//
//  XJHStudentCardScanViewController.m
//  caxjh
//
//  Created by Yingchao Zou on 30/08/2017.
//  Copyright © 2017 Yingchao Zou. All rights reserved.
//

#import "XJHStudentCardScanViewController.h"

@interface XJHStudentCardScanViewController ()

@end

@implementation XJHStudentCardScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"扫描安全卡";
    if (_isEdit) {
      self.title = @"扫描条形码";
    }
    self.imageButton.hidden = YES;
    self.imageButton.enabled = NO;
    
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)finishScanWithResult:(NSString *)result {
    if (result.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(finishScanWithText:)]) {
            [self.delegate finishScanWithText:result];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

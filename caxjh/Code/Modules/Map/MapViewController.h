//
//  MapViewController.h
//  caxjh
//
//  Created by niuxinghua on 2017/11/23.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XJHBaseViewController.h"
#import "UIBarButtonItem+UC.h"
@interface MapViewController : XJHBaseViewController
@property (assign,nonatomic) BOOL isFromAlert;
@property (strong,nonatomic) NSDictionary *alertDic;
@end

//
//  XJHCommonLoginViewController.h
//  caxjh
//
//  Created by Yingchao Zou on 30/08/2017.
//  Copyright © 2017 Yingchao Zou. All rights reserved.
//

#import "XJHBaseViewController.h"

@protocol XJHCommonLoginViewControllerDelegate <NSObject>

- (void)toTab;

@end

@interface XJHCommonLoginViewController : XJHBaseViewController

@property (nonatomic, readwrite, strong) id<XJHCommonLoginViewControllerDelegate> delegate;

@end

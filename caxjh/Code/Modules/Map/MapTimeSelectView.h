//
//  MapTimeSelectView.h
//  caxjh
//
//  Created by niuxinghua on 2017/11/27.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapTimeSelectView : UIView
- (instancetype)initWithFrame:(CGRect)frame showInController:(UIViewController *)controller;
- (NSString *)getStartTime;
- (NSString *)getEndTime;
- (void)deleteSigles;
@end

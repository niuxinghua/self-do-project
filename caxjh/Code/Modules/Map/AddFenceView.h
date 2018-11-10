//
//  AddFenceView.h
//  caxjh
//
//  Created by niuxinghua on 2017/12/2.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyRadioButtonGroup.h"
typedef void (^sliderChangeBlock)(CGFloat radius);
typedef void (^confirmBlock)(NSString *name,NSString *radius,NSString *alarmType,NSString *state,NSString *locationName);
@interface AddFenceView : UIView<MyRadioButtonGroupDelegate>
- (void)setTopAddress:(NSString*)add;
- (void)setBootomAddress:(NSString*)add;
@property (nonatomic,copy)sliderChangeBlock block;
@property (nonatomic,copy)confirmBlock confirmBlock;
@property (nonatomic,strong)NSDictionary *dic;
@end

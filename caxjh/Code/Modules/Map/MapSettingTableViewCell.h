//
//  MapSettingTableViewCell.h
//  caxjh
//
//  Created by niuxinghua on 2017/11/29.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^switchChangedBlock)(BOOL isOn);
@interface MapSettingTableViewCell : UITableViewCell
- (void)setHeadImage:(UIImage *)image topLableStr:(NSString *)topStr bottomLableStr:(NSString *)bottomStr;
- (void)setRelayout;
- (void)setLayoutForMessage;
- (void)setSwithOn:(BOOL)isON;
- (void)setSettingText:(NSString *)text defaultColor:(BOOL)defaultColor;
@property (nonatomic,copy)switchChangedBlock changeBlock;
@end

//
//  BindWatchTableViewCell.h
//  caxjh
//
//  Created by niuxinghua on 2017/11/24.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^didTapScan)(void);
@interface BindWatchTableViewCell : UITableViewCell
@property (nonatomic,strong)UITextField *textFeild;
- (void)setIconImage:(UIImage *)image;
- (void)setTextFieldPlaceHolder:(NSString*)text;
- (void)setTopLineHidden;
- (void)setbottomLineHidden;
- (void)showActionButton;
- (NSString *)getImei;
- (void)setImei:(NSString *)ime;
- (void)setTextEnable:(BOOL)enable;
@property (nonatomic,copy)didTapScan scanBlock;
@end

//
//  FenceListTableViewCell.h
//  caxjh
//
//  Created by niuxinghua on 2017/12/2.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^switchChangedBlock)(BOOL isOn);

@interface FenceListTableViewCell : UITableViewCell
@property (nonatomic,strong)NSDictionary *dic;

@property (nonatomic,copy)switchChangedBlock block;

@end

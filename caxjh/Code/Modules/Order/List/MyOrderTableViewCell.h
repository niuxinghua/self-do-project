//
//  MyOrderTableViewCell.h
//  caxjh
//
//  Created by niuxinghua on 2017/9/3.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrderTableViewCell : UITableViewCell
@property (nonatomic,strong)UILabel *orderNameLable;
@property (nonatomic,strong)UILabel *orderTypeLable;
@property (nonatomic,strong)UILabel *orderOwnerLable;
@property (nonatomic,strong)UILabel *orderDateLable;
@property (nonatomic,strong)UIImageView *bgImageView;
@property (nonatomic,strong)NSDictionary *dic;
@end

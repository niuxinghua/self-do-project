//
//  MyPurchedOrderTableViewCell.h
//  caxjh
//
//  Created by niuxinghua on 2017/9/7.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyPurchedOrderTableViewCell : UITableViewCell
@property (nonatomic,strong)UIImageView *avatarImageView;
@property (nonatomic,strong)UILabel *nameLable;
@property (nonatomic,strong)UILabel *timeLable;
@property (nonatomic,strong)UILabel *valueLable;
@property (nonatomic,strong)NSDictionary *dic;
@end

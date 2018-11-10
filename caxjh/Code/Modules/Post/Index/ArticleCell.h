//
//  ArticleCell.h
//  caxjh
//
//  Created by niuxinghua on 2017/8/30.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Const.h"
@interface ArticleCell : UITableViewCell
@property (nonatomic,strong)UIImageView *avatarImageView;
@property (nonatomic,strong)UILabel *textLable1;
@property (nonatomic,strong)UILabel *timeLable;
@property (nonatomic,strong)UILabel *missingLable;
-(void)bindData:(NSDictionary *)dic;
@property (nonatomic,assign)ArticleType type;
@property (nonatomic,assign)NSDictionary *dataDic;
@end

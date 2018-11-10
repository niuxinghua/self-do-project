//
//  LiveRoomTableViewCell.h
//  caxjh
//
//  Created by niuxinghua on 2017/9/2.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveRoomTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *roomNameLable;
@property(nonatomic,strong)UIImageView *logoImageView;
@property(nonatomic,strong)UIView *lineView;
-(void)setName:(NSString*)name;
@end

//
//  MessageAlertTableViewCell.m
//  caxjh
//
//  Created by niuxinghua on 2017/12/5.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import "MessageAlertTableViewCell.h"

@interface MessageAlertTableViewCell()

@property (nonatomic,strong)UIImageView *headImageView;


@end


@implementation MessageAlertTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    }
    
    return self;
}


@end

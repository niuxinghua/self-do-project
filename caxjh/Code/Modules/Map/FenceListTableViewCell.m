//
//  FenceListTableViewCell.m
//  caxjh
//
//  Created by niuxinghua on 2017/12/2.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import "FenceListTableViewCell.h"
#import "UIColor+HexString.h"
#import "Masonry.h"

@interface FenceListTableViewCell()

@property (nonatomic,strong)UIImageView *avatarImageView;

@property (nonatomic,strong)UILabel *topLable;

@property (nonatomic,strong)UILabel *bottomLable;

@property (nonatomic,strong)UISwitch *fenceSwitch;


@end

@implementation FenceListTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _avatarImageView = [[UIImageView alloc]init];
        _avatarImageView.layer.cornerRadius = 20;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.image = [UIImage imageNamed:@"Fence"];
        [self addSubview:_avatarImageView];
        
        _topLable = [[UILabel alloc]init];
        _topLable.font = [UIFont systemFontOfSize:16];
        _topLable.textColor = [UIColor colorwithHexString:@"#333333"];
        [self addSubview:_topLable];
        
        
        _bottomLable = [[UILabel alloc]init];
        _bottomLable.font = [UIFont systemFontOfSize:12];
        _bottomLable.textColor = [UIColor colorwithHexString:@"#aaaaaa"];
        [self addSubview:_bottomLable];
        
        _fenceSwitch = [[UISwitch alloc]init];
        
        [self addSubview:_fenceSwitch];
        
        [_fenceSwitch addTarget:self action:@selector(stateChanged:) forControlEvents:UIControlEventValueChanged];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    }
    
    return self;
}

- (void)stateChanged:(UISwitch *)sender
{
    if (self.block) {
        self.block(sender.isOn);
    }
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@40);
        make.left.equalTo(self.mas_left).offset(15);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [_topLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avatarImageView.mas_right).offset(10);
        make.top.equalTo(self.mas_top).offset(5);
        make.width.equalTo(@200);
        make.height.equalTo(@30);
        
    }];
    [_bottomLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avatarImageView.mas_right).offset(10);
        make.top.equalTo(_topLable.mas_bottom);
        make.width.equalTo(@200);
        make.height.equalTo(@30);
        
    }];
    
    [_fenceSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.equalTo(@40);
        make.height.equalTo(@30);
        make.right.equalTo(self.mas_right).offset(-20);
        make.centerY.equalTo(self.mas_centerY);
        
    }];
}

- (void)setDic:(NSDictionary *)dic
{
    _dic = dic;
    
    _topLable.text = [dic objectForKey:@"name"];
    
    if ([[dic objectForKey:@"state"] isEqualToString:@"yes"]) {
        [_fenceSwitch setOn:YES];
    }else
    {
        
        [_fenceSwitch setOn:NO]; 
        
        
    }
    if (![[dic objectForKey:@"location"] isEqual:[NSNull null]]) {
        
        _bottomLable.text = [dic objectForKey:@"location"];
    }
    
    
    
}

@end

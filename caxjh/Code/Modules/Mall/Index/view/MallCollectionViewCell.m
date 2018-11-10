//
//  MallCollectionViewCell.m
//  caxjh
//
//  Created by niuxinghua on 2017/10/28.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import "MallCollectionViewCell.h"
#import "Masonry.h"
#import "UIColor+UC.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
@implementation MallCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _avatarImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:_avatarImageView];
        _avatarImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(tapDetil)];
        [self.avatarImageView addGestureRecognizer:singleFingerTap];

        _firstHeadLable = [[UILabel alloc]init];
        [self.contentView addSubview:_firstHeadLable];
        _firstHeadLable.textColor = [UIColor colorWithRed:74/255.0 green:75/255.0 blue:74/255.0 alpha:1.0];
        _firstHeadLable.textAlignment = NSTextAlignmentCenter;
        _secondHeadLable = [[UILabel alloc]init];
        _secondHeadLable.textColor = [UIColor colorWithRed:164/255.0 green:164/255.0 blue:164/255.0 alpha:164/255.0];
        _secondHeadLable.numberOfLines = 0;
        [self.contentView addSubview:_secondHeadLable];
        
        _thirdHeadLable = [[UILabel alloc]init];
        [self.contentView addSubview:_thirdHeadLable];
        _thirdHeadLable.textColor = [UIColor colorWithRed:255/255.0 green:129/255.0 blue:56/255.0 alpha:1.0];
        // self.backgroundColor = [UIColor greenColor];
        _detilBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:_detilBtn];
     //   [_detilBtn setTitle:@"详情" forState:UIControlStateNormal];
        [_detilBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_detilBtn setBackgroundImage:[UIImage imageNamed:@"moredetil.png"] forState:UIControlStateNormal];
        [_detilBtn addTarget:self action:@selector(tapDetil) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}
- (void)tapDetil
{
    if (self.tapDetilBlock) {
        if(_dic) {
        self.tapDetilBlock(_dic);
        }
    }
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.left.equalTo(self.mas_left).offset(5);
        make.right.equalTo(self.mas_right).offset(-5);
        make.height.equalTo(@150);
    }];
    [_firstHeadLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_avatarImageView);
        make.top.equalTo(_avatarImageView.mas_bottom).offset(5);
        make.height.equalTo(@20);
    }];
    [_secondHeadLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_avatarImageView);
        make.top.equalTo(_firstHeadLable.mas_bottom).offset(2);
        make.height.greaterThanOrEqualTo(@20);
    }];
    [_thirdHeadLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(_avatarImageView);
        make.top.equalTo(_secondHeadLable.mas_bottom).offset(2);
        make.height.equalTo(@20);
    }];
    
    [_detilBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_thirdHeadLable.mas_top).offset(2);
        make.right.equalTo(_avatarImageView).offset(-40);
        make.height.equalTo(_thirdHeadLable.mas_height);
        make.width.equalTo(@20);
    }];
}
- (void)setDic:(NSDictionary *)dic
{
    _dic = [dic copy];
    _firstHeadLable.text = [dic objectForKey:@"name"];
    _secondHeadLable.text = [dic objectForKey:@"resume"];
    CGFloat p = [[dic objectForKey:@"price"] doubleValue];
    NSString *price = [NSString stringWithFormat:@"¥:%0.2f",p];
    _thirdHeadLable.text = price;
    
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"thumb"]] placeholderImage:[UIImage imageNamed:@"productplaceholder.png"]];
    
}
@end

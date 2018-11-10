//
//  CustomMapLocationView.m
//  caxjh
//
//  Created by niuxinghua on 2018/1/10.
//  Copyright © 2018年 Yingchao Zou. All rights reserved.
//

#import "CustomMapLocationView.h"
#import "Masonry.h"
@implementation CustomMapLocationView

-(instancetype)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier])
    {
        
        _backImageView = [[UIImageView alloc]init];
        
        [self addSubview:_backImageView];
        
        
        _headImageView = [[UIImageView alloc]init];
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.cornerRadius = 20;
        
        
        
        [self addSubview:_headImageView];
        
        [_backImageView setImage:[UIImage imageNamed:@"datouzhen"]];
        
        
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.right.top.bottom.equalTo(self);
    }];
    
    
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self).offset(1);
        make.centerX.equalTo(self);
        make.width.height.equalTo(@42);
        
    }];
}

- (void)setHeadImage:(UIImage *)img
{
    [_headImageView setImage:img];
    
}

@end

//
//  MapLeftButton.m
//  caxjh
//
//  Created by niuxinghua on 2018/1/10.
//  Copyright © 2018年 Yingchao Zou. All rights reserved.
//

#import "MapLeftButton.h"
#import "Masonry.h"
@implementation MapLeftButton

- (instancetype)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
        
        _changeIconView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        
        [self addSubview:_changeIconView];
        
        [_changeIconView setImage:[UIImage imageNamed:@"changeuser"]];
        
    }
    
    
    return self;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
   
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.width.height.equalTo(@40);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [_changeIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.imageView.mas_right).offset(-16);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@15);
        make.width.equalTo(@30);
        
        
    }];
}

@end

//
//  MainIconCollectionViewCell.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/1/30.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "MainIconCollectionViewCell.h"
#import "Masonry.h"

@interface MainIconCollectionViewCell()

@property (nonatomic,strong)UIImageView *iconImageView;

@property (nonatomic,strong)UILabel *lableView;

@end
@implementation MainIconCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.iconImageView = [[UIImageView alloc]init];
        self.iconImageView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:_iconImageView];
        
        _lableView = [[UILabel alloc] init];
        [self.contentView addSubview:_lableView];
        _lableView.textColor = [UIColor grayColor];
        _lableView.font = [UIFont systemFontOfSize:12];
        _lableView.textAlignment = NSTextAlignmentCenter;
        _iconImageView.userInteractionEnabled = NO;
        _lableView.userInteractionEnabled = NO;
    }
    
    return self;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
       // make.top.equalTo(self);
        make.height.equalTo(@30);
        make.width.equalTo(@35);
        make.centerY.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.mas_centerX);
       
        
    }];
    [_lableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self);
        make.top.equalTo(_iconImageView.mas_bottom).offset(5);
        make.height.equalTo(@20);
    }];
    
    
    
}

- (void)setImage:(UIImage *)iconImage Text:(NSString *)lableText
{
    
    [_iconImageView setImage:iconImage];
    _lableView.text = lableText;
    
}
@end

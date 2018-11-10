//
//  MineBodyView.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/2/24.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "MineBodyView.h"
#import "Masonry.h"
#import "Const.h"
@interface MineBodyView()


@property (nonatomic,strong)UILabel  *leftLable;

@property (nonatomic,strong)UIButton  *rightButton;

@end


@implementation MineBodyView

- (instancetype)init
{
    if (self = [super init]) {
      
        _leftLable = [[UILabel alloc]init];
        
        _leftLable.textColor = [UIColor colorWithRed:67/255.0 green:80/255.0 blue:38/255.0 alpha:1.0];
        
        
        [self addSubview:_leftLable];
        
        _rightButton = [[UIButton alloc]init];
        _rightButton.hidden = YES;
    
        [self addSubview:_rightButton];
        self.backgroundColor = [UIColor colorWithRed:248/255.0 green:250/255.0 blue:244/255.0 alpha:1.0];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didtap)];
       
        [self addGestureRecognizer:tap];

    }
    
    return  self;
}

- (void)layoutSubviews
{
    
    [super layoutSubviews];
    
    [_leftLable mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.mas_left).offset(20);
        make.centerY.equalTo(self);
        make.width.equalTo(@200);
        make.height.equalTo(@30);
        
    }];
    
    
    [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
      
        make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(self);
        make.width.equalTo(@100);
        make.height.equalTo(@30);
        
        
    }];
    
    _rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
}


- (void)setLeftText:(NSString *)lefttext

{
    
    _leftLable.text = lefttext;
    
}
- (void)setButtonText:(NSString *)text
{
    
    [_rightButton setTitle:text forState:UIControlStateNormal];
    _rightButton.hidden = NO;
    [_rightButton setTitleColor:UICOLOR_HEX(0x7e9b7b) forState:UIControlStateNormal];
    _rightButton.hidden = NO;
    [_rightButton addTarget:self action:@selector(didtap) forControlEvents:UIControlEventTouchUpInside];
}
- (void)didtap
{
    if (self.block) {
        self.block();
    }
    
}
@end

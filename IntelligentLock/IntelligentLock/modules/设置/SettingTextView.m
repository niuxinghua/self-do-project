//
//  SettingTextView.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/2/22.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "SettingTextView.h"
#import "Masonry.h"
#import "Const.h"
@interface SettingTextView()

@property (nonatomic,strong)UILabel *leftLable;

@property (nonatomic,strong)UILabel *middleLable;

@property (nonatomic,strong)UILabel *rightLable;

@property (nonatomic,strong)UIButton *updateButton;

@property (nonatomic,strong)UIView *lineView;

@end

@implementation SettingTextView

- (instancetype)init
{
    if (self = [super init]) {
        _leftLable = [[UILabel alloc]init];
        [self addSubview:_leftLable];
        _leftLable.textColor = UICOLOR_HEX(0x336130);
        _middleLable = [[UILabel alloc]init];
        _middleLable.textColor = [UIColor grayColor];
        _middleLable.textAlignment = NSTextAlignmentRight;
        [self addSubview:_middleLable];
        
        _rightLable = [[UILabel alloc]init];
        [self addSubview:_rightLable];
        _rightLable.textAlignment = NSTextAlignmentRight;
        _rightLable.textColor = [UIColor grayColor];
        self.backgroundColor = [UIColor colorWithRed:242/255.0 green:247/255.0 blue:236/255.0 alpha:1.0];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didtaprightButton)];
        [self addGestureRecognizer:tap];
        
        _updateButton = [[UIButton alloc]init];
        [self addSubview:_updateButton];
        [_updateButton setTitle:[kMultiTool getMultiLanByKey:@"gengxin"] forState:UIControlStateNormal];
        [_updateButton setTitleColor:[UIColor colorWithRed:99/255.0 green:122/255.0 blue:83/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_updateButton addTarget:self action:@selector(updatePowder) forControlEvents:UIControlEventTouchUpInside];
        _updateButton.hidden = YES;
        _lineView = [[UIView alloc]init];
        [self addSubview:_lineView];
        
    }
    return self;
    
    
}
- (void)updatePowder
{
  
    if (self.updateBlock) {
        self.updateBlock();
    }
    
}
- (void)setUpdateButtonHidden:(BOOL)hidden
{
    _updateButton.hidden = hidden;
    
    
}
- (void)layoutSubviews
{
    
    [super layoutSubviews];
    
    [_leftLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.centerY.equalTo(self);
        make.height.equalTo(@40);
        make.width.equalTo(@150);
    }];
    [_middleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftLable.mas_right).offset(-30);
        make.centerY.equalTo(self);
        make.height.equalTo(@30);
        make.width.equalTo(@150);
    }];
    [_rightLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftLable.mas_right).offset(-30);
        make.centerY.equalTo(self);
        make.height.equalTo(@30);
        make.width.equalTo(@100);
    }];
    [_updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right).offset(-20);
        make.width.equalTo(@60);
        make.height.equalTo(@30);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right);
        make.width.equalTo(self);
        make.height.equalTo(@0.5);
    }];
    _lineView.backgroundColor = UICOLOR_HEX(0xdee0dd);
}
- (void)setLeftText:(NSString *)text
{
    
    _leftLable.text = text;
    
}
- (void)setMiddleText:(NSString *)text
{
    
    _middleLable.text = text;
    
}
- (void)didtaprightButton
{
    
    if (self.touchBlock) {
        self.touchBlock();
    }
    
}

@end

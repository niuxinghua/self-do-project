//
//  AddUserTextView.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/2/22.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "AddUserTextView.h"
#import "Masonry.h"
#import "Const.h"
@interface AddUserTextView()

@property (nonatomic,strong)UILabel *leftLable;

@property (nonatomic,strong)UITextField *textFeid;

@property (nonatomic,strong)UIView *lineView;

@end

@implementation AddUserTextView
- (instancetype)init
{
    if (self = [super init]) {
        _leftLable = [[UILabel alloc]init];
        [self addSubview:_leftLable];
        _leftLable.textColor = [UIColor colorWithRed:99/255.0 green:122/255.0 blue:83/255.0 alpha:1.0];
        _textFeid = [[UITextField alloc]init];
        [self addSubview:_textFeid];
        _lineView = [[UIView alloc]init];
        [self addSubview:_lineView];
        self.backgroundColor = [UIColor colorWithRed:242/255.0 green:247/255.0 blue:236/255.0 alpha:1.0];
    }
    return self;
    
    
}

- (void)layoutSubviews
{
    
    [super layoutSubviews];
    
    [_leftLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.centerY.equalTo(self);
        make.height.equalTo(@40);
        make.width.equalTo(@100);
    }];
    [_textFeid mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftLable.mas_right);
        make.centerY.equalTo(self);
        make.height.equalTo(@30);
       // make.width.equalTo(@00);
        make.right.equalTo(self.mas_right);
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
- (NSString *)getText
{
    return _textFeid.text;
    
}
@end

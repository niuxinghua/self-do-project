//
//  MapSettingTableViewCell.m
//  caxjh
//
//  Created by niuxinghua on 2017/11/29.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import "MapSettingTableViewCell.h"
#import "TimeSelectButton.h"
#import "Masonry.h"
#import "UIColor+HexString.h"
@interface MapSettingTableViewCell()

@property(nonatomic,strong)UIImageView *headImageView;

@property(nonatomic,strong)UILabel *topLable;

@property(nonatomic,strong)UILabel *bottomLable;

@property(nonatomic,strong)TimeSelectButton *selectButton;

@property(nonatomic,strong)UISwitch *openswitch;

@property(nonatomic,strong)UILabel *isSettingLable;
@end
@implementation MapSettingTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _headImageView = [[UIImageView alloc]init];
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.cornerRadius = 45/2.0;
        [self addSubview:_headImageView];
        
        
        _topLable = [[UILabel alloc]init];
        _topLable.font = [UIFont systemFontOfSize:16];
        _topLable.textColor = [UIColor colorwithHexString:@"#333333"];
        [self addSubview:_topLable];
        
        
        _bottomLable = [[UILabel alloc]init];
        _bottomLable.font = [UIFont systemFontOfSize:13];
        _bottomLable.textColor = [UIColor colorwithHexString:@"#aaaaaa"];
        _bottomLable.numberOfLines = 0;
        
        [self addSubview:_bottomLable];
        
        
        _selectButton = [[TimeSelectButton alloc]init];
        
        [self addSubview:_selectButton];
        
        _openswitch = [[UISwitch alloc]init];
        
        [self addSubview:_openswitch];
        _openswitch.hidden = YES;
        
        _isSettingLable = [[UILabel alloc]init];
        _isSettingLable.font = [UIFont systemFontOfSize:12];
        _isSettingLable.textColor = [UIColor colorWithRed:119/255.0 green:225/255.0 blue:198/255.0 alpha:1.0];
        _isSettingLable.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_isSettingLable];
        
        [_openswitch addTarget:self action:@selector(openChange:) forControlEvents:UIControlEventValueChanged];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    }
    
    return self;
}
- (void)openChange:(UISwitch *)sender
{
    if (self.changeBlock) {
        self.changeBlock(sender.isOn);
    }
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@45);
        make.left.equalTo(self.mas_left).offset(15);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [_topLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImageView.mas_right).offset(10);
        make.top.equalTo(self.mas_top).offset(5);
        make.width.equalTo(@150);
       // make.height.equalTo(@30);
    }];
    [_bottomLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImageView.mas_right).offset(10);
        make.top.equalTo(_topLable.mas_bottom);
        make.width.equalTo(@200);
        make.height.equalTo(@50);
    }];
    
    [_selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.width.equalTo(@60);
        make.height.equalTo(@30);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [_openswitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.width.equalTo(@40);
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-20);
    }];
    
    [_isSettingLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@20);
        make.width.equalTo(@80);
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-20);
    }];
}
#pragma mark - methods

- (void)setHeadImage:(UIImage *)image topLableStr:(NSString *)topStr bottomLableStr:(NSString *)bottomStr
{
    [_headImageView setImage:image];
    _topLable.text = topStr;
    _bottomLable.text = bottomStr;

}
- (void)setSwithOn:(BOOL)isON
{
    [_openswitch setOn:isON];
    
}
- (void)setRelayout
{
    
    _bottomLable.hidden = YES;
    
    [_topLable mas_remakeConstraints:^(MASConstraintMaker *make) {
        
  
        make.centerY.equalTo(self.mas_centerY);
        
    }];
    
}
- (void)setLayoutForMessage
{
    
    [_topLable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.mas_top).offset(5);
        make.width.equalTo(@150);
        make.height.equalTo(@30);
    }];
    [_bottomLable mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(_topLable.mas_bottom);
        make.width.equalTo(@250);
        make.height.equalTo(@50);
    }];
    _openswitch.hidden = NO;
}
- (void)setSettingText:(NSString *)text defaultColor:(BOOL)defaultColor
{
    _isSettingLable.text = text;
    if (!defaultColor) {
        _isSettingLable.textColor = _bottomLable.textColor;
    }
}
@end

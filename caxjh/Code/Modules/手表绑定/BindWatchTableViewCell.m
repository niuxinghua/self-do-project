//
//  BindWatchTableViewCell.m
//  caxjh
//
//  Created by niuxinghua on 2017/11/24.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import "BindWatchTableViewCell.h"
#import "Masonry.h"
#import "UIColor+EAHexColor.h"
@interface BindWatchTableViewCell()
@property (nonatomic,strong)UIImageView *iconView;
@property (nonatomic,strong)UIButton *actionButton;
@property (nonatomic,strong)UIView *topLine;
@property (nonatomic,strong)UIView *bottomLine;
@end
@implementation BindWatchTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _iconView = [[UIImageView alloc]init];
        [self.contentView addSubview:_iconView];
        
        _textFeild = [[UITextField alloc]init];
        [self.contentView addSubview:_textFeild];
        
        _actionButton = [[UIButton alloc]init];
        [self.contentView addSubview:_actionButton];
        [_actionButton setBackgroundImage:[UIImage imageNamed:@"扫描"] forState:UIControlStateNormal];
        _actionButton.hidden = YES;
        
        [_actionButton addTarget:self action:@selector(scan) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        _topLine = [[UIView alloc]init];
        [self.contentView addSubview:_topLine];
        
        _bottomLine = [[UIView alloc]init];
        [self.contentView addSubview:_bottomLine];
        
        _topLine.backgroundColor = [UIColor colorWithHex:@"#e1e1e1"];
        _bottomLine.backgroundColor = [UIColor colorWithHex:@"#e1e1e1"];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(void)layoutSubviews
{
    [_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.equalTo(@0.5);
        make.top.equalTo(self);
    }];
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@30);
        make.top.equalTo(self.mas_top).offset(5);
        make.left.equalTo(self.mas_left).offset(20);
    }];
    
    [_textFeild mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconView.mas_right).offset(10);
        make.width.equalTo(@250);
        make.height.equalTo(@25);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [_actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_textFeild.mas_right).offset(5);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(self);
    }];
}
- (void)setIconImage:(UIImage *)image
{
    _iconView.image = image;
    
}
- (void)setTextFieldPlaceHolder:(NSString*)text
{
    _textFeild.placeholder = text;
}
- (void)setTopLineHidden
{
    _topLine.hidden = YES;
}
- (void)setbottomLineHidden
{
    _bottomLine.hidden = YES;
}
- (NSString *)getImei
{
    
    return _textFeild.text;
    
}
- (void)setImei:(NSString *)ime
{
    
    _textFeild.text = ime;
   
    
}
- (void)showActionButton
{
    _actionButton.hidden = NO;
    
}

- (void)scan
{
    if (self.scanBlock) {
        self.scanBlock();
    }
    
    
}
- (void)setTextEnable:(BOOL)enable
{
    _textFeild.enabled = enable;
    
}
@end

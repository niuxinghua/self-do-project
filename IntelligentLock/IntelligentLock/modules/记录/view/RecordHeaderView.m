//
//  RecordHeaderView.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/3/14.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "RecordHeaderView.h"
#import "Masonry.h"
#import "Const.h"
@interface RecordHeaderView()

@property (nonatomic,strong)UIButton *getButton;

@property (nonatomic,strong)UIButton *clearButton;

@property (nonatomic,strong)UILabel *syncLable;


@property (nonatomic,strong)UIView *lineView;

@end
@implementation RecordHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _getButton = [[UIButton alloc]init];
        [self addSubview:_getButton];
        [_getButton setTitleColor:[UIColor colorWithRed:67/255.0 green:80/255.0 blue:38/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_getButton setTitle:[kMultiTool getMultiLanByKey:@"clicktogetrecords"] forState:UIControlStateNormal];
        _getButton.titleLabel.textAlignment = NSTextAlignmentLeft;
        _getButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_getButton addTarget:self action:@selector(sync) forControlEvents:UIControlEventTouchUpInside];
        
        
        _clearButton = [[UIButton alloc]init];
        [self addSubview:_clearButton];
         [_clearButton setTitleColor:[UIColor colorWithRed:67/255.0 green:80/255.0 blue:38/255.0 alpha:1.0] forState:UIControlStateNormal];
        _clearButton.titleLabel.textAlignment = NSTextAlignmentRight;
          [_clearButton addTarget:self action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];
        _clearButton.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [_clearButton setTitle:[kMultiTool getMultiLanByKey:@"clearrecords"] forState:UIControlStateNormal];
        
        
        _syncLable = [[UILabel alloc]init];
        _syncLable.textColor = UICOLOR_HEX(0x919191);
        [self addSubview:_syncLable];
        
        [_getButton setTitleColor:UICOLOR_HEX(0x336130) forState:UIControlStateNormal];
        [_clearButton setTitleColor:UICOLOR_HEX(0x336130) forState:UIControlStateNormal];
        _lineView = [[UIView alloc]init];
        [self addSubview:_lineView];
        
    }
    return self;
    
}
- (void)sync{
    if (self.synckBlock) {
        self.synckBlock();
    }
    
}
- (void)clear{
    if (self.clearBlock) {
        self.clearBlock();
    }
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [_getButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0);
        make.width.equalTo(@200);
        make.height.equalTo(@40);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [_clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(5);
        make.right.equalTo(self.mas_right).offset(0);
        make.height.equalTo(@40);
        make.width.equalTo(@150);
    }];
    [_syncLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-5);
        make.right.equalTo(self.mas_right).offset(-5);
        make.height.equalTo(@20);
        make.width.equalTo(@200);
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right);
        make.width.equalTo(self);
        make.height.equalTo(@0.5);
    }];
    _lineView.backgroundColor = UICOLOR_HEX(0xdee0dd);
}
- (void)setLableText:(NSString *)text
{
    _syncLable.text = text;
    _syncLable.font = [UIFont systemFontOfSize:12];
    _syncLable.textAlignment = NSTextAlignmentRight;
    
}
@end

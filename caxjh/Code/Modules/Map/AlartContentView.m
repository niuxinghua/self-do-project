//
//  AlartContentView.m
//  caxjh
//
//  Created by niuxinghua on 2017/12/4.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import "AlartContentView.h"
#import "Masonry.h"
#import "UIColor+HexString.h"
#import "SocketManager.h"
#import "PPNetworkHelper.h"
#import "MBProgressHUD.h"
@interface AlartContentView（）



@end
@implementation AlartContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _selectedTimeStr = @"30";
        _topButton = [[UIButton alloc]init];
        [_topButton setTitle:@"30秒" forState:UIControlStateNormal];
        [_topButton setTitleColor:[UIColor colorwithHexString:@"#ff6767"] forState:UIControlStateSelected];
        [_topButton setTitleColor:[UIColor colorwithHexString:@"#6b6b6b"] forState:UIControlStateNormal];
        
        [_topButton addTarget:self action:@selector(didtapButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_topButton];
        
        _middleButton = [[UIButton alloc]init];
        [_middleButton setTitle:@"1分钟" forState:UIControlStateNormal];
        [_middleButton setTitleColor:[UIColor colorwithHexString:@"#ff6767"] forState:UIControlStateSelected];
        [_middleButton setTitleColor:[UIColor colorwithHexString:@"#6b6b6b"] forState:UIControlStateNormal];
        [_middleButton addTarget:self action:@selector(didtapButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_middleButton];
        
        _bottomButton = [[UIButton alloc]init];
        
        _bottomButton = [[UIButton alloc]init];
        [_bottomButton setTitle:@"5分钟" forState:UIControlStateNormal];
        [_bottomButton setTitleColor:[UIColor colorwithHexString:@"#ff6767"] forState:UIControlStateSelected];
        [_bottomButton setTitleColor:[UIColor colorwithHexString:@"#6b6b6b"] forState:UIControlStateNormal];
        [_bottomButton addTarget:self action:@selector(didtapButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_bottomButton];
        _buttonList = [[NSMutableArray alloc]init];
        
        [_buttonList addObject:_topButton];
        [_buttonList addObject:_middleButton];
        [_buttonList addObject:_bottomButton];
        // self.backgroundColor = [UIColor blackColor];
        
    }
    return  self;
}
- (void)setTimeinterval:(CGFloat)timeinterval
{
    
    _timeinterval = timeinterval;
    
    if (timeinterval == 30) {
        _selectedTimeStr = @"30";
        [_topButton setSelected:YES];
    }else if (timeinterval == 60)
    {
        [_middleButton setSelected:YES];
        _selectedTimeStr = @"60";
    }else{
        
        [_bottomButton setSelected:YES];
        _selectedTimeStr = @"300";
    }
    
}
- (void)didtapButton:(UIButton *)sender
{
    if (sender) {
        sender.selected = !sender.selected;
       // [sender setTitleColor:[UIColor colorwithHexString:@"#ff6767"] forState:UIControlStateNormal];
    }
    for (UIButton *button in _buttonList) {
        if (button == sender) {
            
        }else{
            button.selected = NO;
            
        }
    }
    
    if (sender.selected) {
        if (sender == _topButton) {
            _selectedTimeStr = @"30";
        }else if (sender == _middleButton){
            _selectedTimeStr = @"60";
            
        }else
        {
            _selectedTimeStr = @"300";
            
        }
    }
    
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_topButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset(10);
        make.width.equalTo(@100);
        make.height.equalTo(@20);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [_middleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_topButton.mas_bottom).offset(15);
        make.width.equalTo(@100);
        make.height.equalTo(@20);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [_bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_middleButton.mas_bottom).offset(15);
        make.width.equalTo(@100);
        make.height.equalTo(@20);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
}

#pragma mark - methods

- (NSString *)getselectedTime
{
    return _selectedTimeStr;
    
}

@end

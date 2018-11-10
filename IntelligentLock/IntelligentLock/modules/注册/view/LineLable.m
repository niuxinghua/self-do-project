//
//  LineLable.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/3/17.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "LineLable.h"
#import "Const.h"
@implementation LineLable

- (instancetype)init
{
    if (self = [super init]) {
        _lineView = [[UIView alloc]init];
        
        _lineView.backgroundColor = UICOLOR_HEX(0x9fa0a0);
    }
    self.textColor = _lineView.backgroundColor;
    [self addSubview:_lineView];
    self.font = [UIFont systemFontOfSize:12];
    
    self.userInteractionEnabled = YES;
    
      UIGestureRecognizer *rec =
          [[UITapGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(tapgesture)];
      [self addGestureRecognizer:rec];
    return self;
}


- (void)tapgesture
{
    if (self.tapBlock) {
        self.tapBlock();
    }
    
    
}


- (void)layoutSubviews
{
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self);
        make.height.equalTo(@0.5);
        make.left.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
}
@end

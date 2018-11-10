//
//  SendKeyBottomCountView.m
//  IntelligentLock
//
//  Created by niuxinghua on 2018/3/10.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "SendKeyBottomCountView.h"
#import "Masonry.h"
#import "Const.h"
@interface SendKeyBottomCountView()<UITextFieldDelegate>



@end

@implementation SendKeyBottomCountView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
    
        _countTextFeild = [[UITextField alloc]init];
        [self addSubview:_countTextFeild];
        _countTextFeild.placeholder = [kMultiTool getMultiLanByKey:@"shurucishu"];
        _countTextFeild.delegate = self;
        _countTextFeild.keyboardType = UIKeyboardTypeDecimalPad;
    }
    
    
    return self;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return [self validateNumber:string];
}

- (BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [_countTextFeild mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@30);
        make.top.equalTo(self.mas_top).offset(20);
    }];
}

@end

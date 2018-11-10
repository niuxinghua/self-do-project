//
//  RegisterItemView.h
//  IntelligentLock
//
//  Created by niuxinghua on 2018/2/7.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "LoginTextView.h"
#import "JKCountDownButton.h"
typedef void(^touchGetVerifyBlock)(void);

typedef void(^touchRightLable)(void);

typedef void(^touchView)(void);

@interface RegisterItemView : LoginTextView
- (void)setLeftIcon:(UIImage *)lefticon textFeildText:(NSString *)text rightLable:(NSString *)rightText textFeildCanEdit:(BOOL)canedit;
- (void)showButton:(BOOL)show;
- (void)stopCount;

@property (copy,nonatomic)touchGetVerifyBlock getVerifyblock;


@property (copy,nonatomic)touchGetVerifyBlock didtapRightLableBlcok;

@property (copy,nonatomic)touchView didtapViewBlcok;

@property(nonatomic,strong)JKCountDownButton *getVerify;

@end

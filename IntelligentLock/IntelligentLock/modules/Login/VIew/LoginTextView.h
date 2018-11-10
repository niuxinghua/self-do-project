//
//  LoginTextView.h
//  IntelligentLock
//
//  Created by niuxinghua on 2018/2/6.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^didTapTextField)(void);

@interface LoginTextView : UIView

@property (nonatomic,strong)UIImageView *leftIcon;


@property (nonatomic,strong)UITextField *textFeild;


@property (nonatomic,strong)UILabel *rightLable;


@property (nonatomic,strong)UIView *lineView;


@property (nonatomic,copy)didTapTextField didtapBlock;

- (void)setLeftIcon:(UIImage *)lefticon textFeildText:(NSString *)text rightLable:(NSString *)rightText textFeildCanEdit:(BOOL)canedit;

- (NSString *)getText;


- (void)setTexfieldPassWordStyle;

@end

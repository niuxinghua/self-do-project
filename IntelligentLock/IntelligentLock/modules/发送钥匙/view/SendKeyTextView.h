//
//  SendKeyTextView.h
//  IntelligentLock
//
//  Created by niuxinghua on 2018/2/8.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "LoginTextView.h"

typedef enum : NSUInteger {
    SendKeyTextViewTypeTextAndButton,
    SendKeyTextViewTypeOnlyButton,
    SendKeyTextViewTypeNone,
    SendKeyTextViewTypeCheckBox,
    SendKeyTextViewTypeTextAndButtonNoImage
} SendKeyTextViewType;

typedef void(^selectTypeBlock)(NSString *type);
typedef void(^isCheckBlock)(BOOL isChecked);
typedef void(^scanBlock)(void);
typedef void(^selectPermanentTypeBlock)(bool isPermanent);
@interface SendKeyTextView : LoginTextView


- (void)setLeftText:(NSString *)leftText;

@property (nonatomic,assign)SendKeyTextViewType type;

@property (nonatomic,copy)selectTypeBlock selectBlock;

@property (nonatomic,copy)scanBlock scanBlock;

@property (nonatomic,copy)selectPermanentTypeBlock permanentBlock;

@property (nonatomic,copy)isCheckBlock checkBlock;

- (void)setRightText:(NSString *)text;

@end

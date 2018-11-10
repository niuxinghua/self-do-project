//
//  SettingTextView.h
//  IntelligentLock
//
//  Created by niuxinghua on 2018/2/22.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^didtouchView)(void);
typedef void(^didupdate)(void);
@interface SettingTextView : UIView


- (void)setLeftText:(NSString *)text;
- (void)setMiddleText:(NSString *)text;

- (void)setUpdateButtonHidden:(BOOL)hidden;

@property (nonatomic,copy)didtouchView touchBlock;

@property (nonatomic,copy)didupdate updateBlock;
@end

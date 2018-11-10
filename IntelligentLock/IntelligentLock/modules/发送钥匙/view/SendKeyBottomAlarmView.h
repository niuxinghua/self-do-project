//
//  SendKeyBottomAlarmView.h
//  IntelligentLock
//
//  Created by niuxinghua on 2018/3/9.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendKeyBottomTimeSelectView.h"
@interface SendKeyBottomAlarmView : UIView
@property (nonatomic,strong)SendKeyBottomTimeSelectView *timeView;
- (NSString *)getDayJson;
@end

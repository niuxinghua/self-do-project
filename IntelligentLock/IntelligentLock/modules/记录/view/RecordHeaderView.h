//
//  RecordHeaderView.h
//  IntelligentLock
//
//  Created by niuxinghua on 2018/3/14.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SyncBlock)(void);

typedef void(^ClearBlock)(void);

@interface RecordHeaderView : UIView


- (void)setLableText:(NSString *)text;


@property (nonatomic,copy)SyncBlock synckBlock;

@property (nonatomic,copy)ClearBlock clearBlock;

@end

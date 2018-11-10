//
//  UserMangeMentTableViewCell.h
//  IntelligentLock
//
//  Created by niuxinghua on 2018/3/26.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^tapDelete)(NSString *tagId);
typedef void(^tapModify)(NSString *tagId);
@interface UserMangeMentTableViewCell : UITableViewCell



@property (nonatomic,strong)NSDictionary *dic;

@property (nonatomic,assign)BOOL isSub;

@property (nonatomic,copy)tapDelete deleteBlock;

@property (nonatomic,copy)tapModify modifyBlock;

@end

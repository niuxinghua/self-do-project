//
//  XJHLiveRoomViewController.h
//  caxjh
//
//  Created by niuxinghua on 2017/9/2.
//  Copyright © 2017年 Yingchao Zou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMNodeObject.h"
typedef void(^didTapRoomSn)(HMNodeObject* node);
typedef void(^didSelectStudent)(NSString *stuName,NSString *stuId,NSArray *ids);
@interface XJHLiveRoomViewController : UIViewController
@property (nonatomic,strong)NSMutableArray *datalist;
@property (nonatomic,copy)didTapRoomSn tapRoomBlock;
@property (nonatomic,copy)didSelectStudent selectStuBlock;
- (void)filterStudentId:(NSString *)stuId;
@end

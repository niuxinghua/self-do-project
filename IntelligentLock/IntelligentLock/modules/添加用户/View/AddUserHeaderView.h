//
//  AddUserHeaderView.h
//  IntelligentLock
//
//  Created by niuxinghua on 2018/2/22.
//  Copyright © 2018年 com.haier. All rights reserved.
//

#import "KeyManageMentHeaderView.h"

@interface AddUserHeaderView : KeyManageMentHeaderView

@property (nonatomic,strong)NSMutableArray *enableList;


@property (nonatomic,strong)NSMutableArray *selectArray;

@property (nonatomic,assign)int currentIndex;

@property (nonatomic,strong)UILabel *flable;

@property (nonatomic,strong)UILabel *slable;

@property (nonatomic,strong)UILabel *tlable;

@property (nonatomic,strong)UILabel *folable;


@end

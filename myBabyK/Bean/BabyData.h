//
//  BabyData.h
//  iHealthS
//
//  Created by Apple on 2019/3/27.
//  Copyright © 2019 whitelok.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DATA
@end

@interface DATA : JSONModel
@property NSString *id;
@property NSString *problem;

@end

@implementation DATA
@end

@interface BabyData : JSONModel

@property NSString *status;
@property NSString *msg;
@property NSArray<DATA> *data;
//@property NSArray *data;
@end

@implementation BabyData
@end

NS_ASSUME_NONNULL_END

//
//  AnswerData.h
//  iHealthS
//
//  Created by Apple on 2019/3/28.
//  Copyright © 2019 whitelok.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol Answer
@end

@interface Answer : JSONModel
@property NSString * answer;
@property NSString * des;

@end

@implementation Answer
@end

@interface AnswerData : JSONModel

@property NSString *status;
@property NSString *msg;
@property NSArray<Answer> *data;

@end

@implementation AnswerData
@end

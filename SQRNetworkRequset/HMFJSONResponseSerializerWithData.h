//
//  HMFJSONResponseSerializerWithData.h
//  CommunityPeople
//
//  Created by 黄坤 on 2018/5/9.
//  Copyright © 2018年 PR. All rights reserved.
//

#import "AFURLResponseSerialization.h"

/// NSError userInfo keys that will contain response data
static NSString * const JSONResponseSerializerWithDataKey = @"body";
static NSString * const JSONResponseSerializerWithBodyKey = @"statusCode";

@interface HMFJSONResponseSerializerWithData : AFHTTPResponseSerializer

@end

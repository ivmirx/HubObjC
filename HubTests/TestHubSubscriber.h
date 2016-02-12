//
//  TestHubSubscriber.h
//  Qbserve
//
//  Created by Ivan Mir on 23-02-15.
//  Copyright (c) 2015 QotoQot. All rights reserved.
//

#import "BaseHubMessage.h"

@interface TestHubSubscriber : NSObject

@property (readonly, nonatomic) BOOL gotMessage;

- (void) test:(BaseHubMessage*)msg;

@end

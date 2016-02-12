//
//  TestHubSubscriber.m
//  Qbserve
//
//  Created by Ivan Mir on 23-02-15.
//  Copyright (c) 2015 QotoQot. All rights reserved.
//

#import "TestHubSubscriber.h"

@implementation TestHubSubscriber

- (void) test:(BaseHubMessage*)msg
{
	_gotMessage = YES;
}

@end

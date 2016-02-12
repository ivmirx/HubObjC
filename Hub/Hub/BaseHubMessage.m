//
//  BaseHubMessage.m
//
//  Copyright (c) 2015 Ivan Mir. All rights reserved.
//

#import "BaseHubMessage.h"

@implementation BaseHubMessage

+ (instancetype)message
{
	return [[self alloc] init];
}

- (id)copyWithZone:(NSZone *)zone
{
	return [[BaseHubMessage alloc] init];
}

@end

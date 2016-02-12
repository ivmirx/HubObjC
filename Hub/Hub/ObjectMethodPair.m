//
//  ObjectMethodPair.m
//
//  Copyright (c) 2015 Ivan Mir. All rights reserved.
//

#import "ObjectMethodPair.h"

@implementation ObjectMethodPair

- (instancetype)initWithObject:(id)object andMethod:(NSValue *)method
{
	if (self = [super init])
	{
		_object = object;
		_method = method;
	}
	return self;
}

@end

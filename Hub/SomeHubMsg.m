//
//  SomeHubMsg.m
//  Hub
//

#import "SomeHubMsg.h"

@implementation SomeHubMsg

+ (instancetype)messageWithValue:(NSInteger)value
{
	return [[self alloc] initWithValue:value];
}

- (instancetype)initWithValue:(NSInteger)value
{
	if (self = [super init])
	{
		_value = value;
	}
	return self;
}

@end

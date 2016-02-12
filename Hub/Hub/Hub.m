//
//  Hub.m
//
//  Copyright (c) 2015 Ivan Mir. All rights reserved.
//

#import "Hub.h"
#import "ObjectMethodPair.h"

@interface Hub ()
{
	NSMutableDictionary *_subscribers;
}
@end

@implementation Hub
Hub *_sharedInstance;

+ (instancetype)shared
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_sharedInstance = [[Hub alloc] init];
	});
	
	return _sharedInstance;
}

- (instancetype)init
{
	if (self = [super init])
		_subscribers = [[NSMutableDictionary alloc] init];
	return self;
}

- (BOOL)subscribeMethod:(SEL)method atObject:(id)object forMessage:(Class)messageType
{
	if (object == nil)
	{
		NSLog(@"Got nil for subscription! (%@)", messageType);
		return NO;
	}
	
	NSMethodSignature *signature = [object methodSignatureForSelector:method];
	if ([signature numberOfArguments] != 3)
	{
		NSLog(@"Subscribing %@ for %@ with incorrect method!", object, messageType);
		return NO;
	}
	
	if ([messageType isSubclassOfClass:[BaseHubMessage class]] == NO)
	{
		NSLog(@"Can't subscribe - wrong message type: %@", messageType);
		return NO;
	}
	
	id<NSCopying> key = (id<NSCopying>)messageType;
	
	if (_subscribers[key] == nil)
	{
		_subscribers[key] = [NSMutableArray array];
	}
	else
	{
		NSUInteger index = [self findObject:object inPairArray:_subscribers[key]];
		if (index != NSNotFound)
		{
			NSLog(@"Can't subscribe - %@ is already subscribed for %@", object, messageType);
			return NO;
		}
	}
	
	ObjectMethodPair *pair = [[ObjectMethodPair alloc] initWithObject:object
															andMethod:[NSValue valueWithPointer:method]];
	[_subscribers[key] addObject:pair];
	
	return YES;
}

- (BOOL)unsubscribeMethod:(SEL)method atObject:(id)object fromMessage:(Class)messageType
{
	if (object == nil)
	{
		NSLog(@"Got nil for unsubscription! (%@)", messageType);
		return NO;
	}
	
	NSMethodSignature *signature = [object methodSignatureForSelector:method];
	if ([signature numberOfArguments] != 3)
	{
		NSLog(@"Unsubscribing %@ from %@ with incorrect method!", object, messageType);
		return NO;
	}
	
	if ([messageType isSubclassOfClass:[BaseHubMessage class]] == NO)
	{
		NSLog(@"Can't unsubscribe - wrong request type: %@", messageType);
		return NO;
	}
	
	id<NSCopying> key = (id<NSCopying>)messageType;
	NSUInteger index = [self findObject:object inPairArray:_subscribers[key]];
	if (_subscribers[key] == nil || index == NSNotFound)
	{
		NSLog(@"Can't unsubscribe - %@ is not subscribed for %@", object, messageType);
		return NO;
	}
	
	if ([[_subscribers[key][index] method] pointerValue] != [[NSValue valueWithPointer:method] pointerValue])
	{
		NSLog(@"Unsubscribing method of %@ that do not match method for %@", object, messageType);
		return NO;
	}

	[_subscribers[key] removeObjectAtIndex:index];
	
	return YES;
}

- (BOOL)send:(BaseHubMessage*)msg
{
	if (msg == nil)
	{
		NSLog(@"Message is nil!");
		return NO;
	}
	
	id<NSCopying> key = (id<NSCopying>)[msg class];
	if (_subscribers[key] == nil || [_subscribers[key] count] == 0)
	{
		NSLog(@"Can't send message - no subscribers for %@", [msg class]);
		return NO;
	}
	
	for (ObjectMethodPair *pair in _subscribers[key])
	{
		SEL selector = [pair.method pointerValue];
		IMP imp = [pair.object methodForSelector:selector];
		void (*func)(id, SEL, BaseHubMessage*) = (void (*)(id, SEL, BaseHubMessage*))imp;
		func(pair.object, selector, msg);
	}
	return YES;
}

- (NSUInteger)findObject:(id)object inPairArray:(NSArray*)pairs
{
	__block NSUInteger index = NSNotFound;
	__block id blockObject = object;
	
	[pairs enumerateObjectsUsingBlock: ^(id p, NSUInteger i, BOOL *stop) {
		if (((ObjectMethodPair*)p).object == blockObject)
		{
			index = i;
			*stop = YES;
		}
	}];
	
	return index;
}

- (NSUInteger)logSubscribed
{
	int count = 0;
	NSLog(@"====================");
	NSLog(@"[Subscribed Objects]");
	NSLog(@"====================");
	for (id key in _subscribers)
	{
		NSLog(@"[%@] subscribers:", key);
		NSArray *all = _subscribers[key];
		for (id sub in all)
		{
			count++;
			NSLog(@"    %@", ((ObjectMethodPair*)sub).object);
		}
	}
	NSLog(@"====================");
	
	return count;
}

@end
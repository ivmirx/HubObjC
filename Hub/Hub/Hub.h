//
//  Hub.h
//
//  Copyright (c) 2015 Ivan Mir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseHubMessage.h"

@interface Hub : NSObject

+ (instancetype)shared;

- (BOOL)subscribeMethod:(SEL)method atObject:(id)object forMessage:(Class)messageType;
- (BOOL)unsubscribeMethod:(SEL)method atObject:(id)object fromMessage:(Class)messageType;
- (BOOL)send:(BaseHubMessage *)msg;
- (NSUInteger)logSubscribed;

@end

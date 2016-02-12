//
//  ObjectMethodPair.h
//
//  Copyright (c) 2015 Ivan Mir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ObjectMethodPair : NSObject

@property (readonly, nonatomic) id object;
@property (readonly, nonatomic) NSValue *method;

- (instancetype) initWithObject:(id)object andMethod:(NSValue *)method;

@end

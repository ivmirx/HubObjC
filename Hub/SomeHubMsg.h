//
//  SomeHubMsg.h
//  Hub
//

#import "BaseHubMessage.h"

@interface SomeHubMsg : BaseHubMessage

@property (readonly,nonatomic) NSInteger value;

+ (instancetype)messageWithValue:(NSInteger)value;

@end

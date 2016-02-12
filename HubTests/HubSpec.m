//
//  HubSpec.m
//  Qbserve
//
//  Created by Ivan Mir on 22-02-15.
//  Copyright 2015 QotoQot. All rights reserved.
//

#import "Specta.h"
#define EXP_SHORTHAND
#import "Expecta.h"

#import "Hub.h"
#import "TestHubMessage.h"
#import "TestHubSubscriber.h"

SpecBegin(Hub)

describe(@"Hub", ^{

	__block TestHubSubscriber *subscriber;
	
	beforeEach(^{
		subscriber = [[TestHubSubscriber alloc] init];
	});
	
	it(@"Should create shared instance", ^{
		expect([Hub shared]).notTo.beNil();
	});
	
	context(@"Trying to send message or unsubscribe without anything ever subscribed", ^{
		
		it(@"should be NO for correct message when nothing subscribed", ^{
			expect([[Hub shared] send:[TestHubMessage message]]).to.beFalsy();
		});
		
		it(@"should decline correct unsubscribing", ^{
			expect([[Hub shared] unsubscribeMethod:@selector(test:) atObject:subscriber fromMessage:[TestHubMessage class]]).to.beFalsy();
		});
		
	});
	
	context(@"Trying to subscribe", ^{
		
		it(@"should decline subscribing nil object", ^{
			expect([[Hub shared] subscribeMethod:@selector(test:) atObject:nil forMessage:[TestHubMessage class]]).to.beFalsy();
		});
		
		it(@"should decline subscribing incorrect method signature", ^{
			expect([[Hub shared] subscribeMethod:@selector(test) atObject:subscriber forMessage:[TestHubMessage class]]).to.beFalsy();
		});
		
		it(@"should decline subscribing with incorrect message type", ^{
			expect([[Hub shared] subscribeMethod:@selector(test:) atObject:subscriber forMessage:[NSString class]]).to.beFalsy();
		});
	});
	
	it(@"Should subscribe and unsubscribe correctly", ^{
		expect([[Hub shared] subscribeMethod:@selector(test:) atObject:subscriber forMessage:[TestHubMessage class]]).to.beTruthy();
		expect([[Hub shared] unsubscribeMethod:@selector(test:) atObject:subscriber fromMessage:[TestHubMessage class]]).to.beTruthy();
	});
	
	context(@"After subscription", ^{
		
		beforeEach(^{
			[[Hub shared] subscribeMethod:@selector(test:) atObject:subscriber forMessage:[TestHubMessage class]];
		});
		
		it(@"should decline second subscription", ^{
			expect([[Hub shared] subscribeMethod:@selector(test:) atObject:subscriber forMessage:[TestHubMessage class]]).to.beFalsy();
		});
		
		it(@"should fail for nil message", ^{
			expect([[Hub shared] send:nil]).to.beFalsy();
		});
		
		it(@"should fail on base message with no subscriptions", ^{
			expect([[Hub shared] send:[BaseHubMessage message]]).to.beFalsy();
		});
		
		it(@"should deliver message", ^{
			expect([[Hub shared] send:[TestHubMessage message]]).to.beTruthy();
			expect(subscriber.gotMessage).to.beTruthy();
		});
		
		it(@"should decline unsubscribing incorrect method signature", ^{
			expect([[Hub shared] unsubscribeMethod:@selector(test) atObject:subscriber fromMessage:[TestHubMessage class]]).to.beFalsy();
		});
		
		it(@"should decline unsubscribing when type not inherited from BaseHubMessage", ^{
			expect([[Hub shared] unsubscribeMethod:@selector(test:) atObject:subscriber fromMessage:[NSString class]]).to.beFalsy();
		});
		
		it(@"should decline unsubscribing not subscribed", ^{
			expect([[Hub shared] unsubscribeMethod:@selector(test:) atObject:subscriber fromMessage:[BaseHubMessage class]]).to.beFalsy();
		});
		
		it(@"should decline unsubscribing nil object", ^{
			expect([[Hub shared] unsubscribeMethod:@selector(test:) atObject:nil fromMessage:[TestHubMessage class]]).to.beFalsy();
		});
		
		afterEach(^{
			[[Hub shared] unsubscribeMethod:@selector(test:) atObject:subscriber fromMessage:[TestHubMessage class]];
		});
	});
	
	it(@"Should be empty after all tests", ^{
		expect([[Hub shared] logSubscribed]).to.equal(0);
	});
	
	afterEach(^{
		subscriber = nil;
	});
});

SpecEnd

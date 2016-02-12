//
//  ViewController.m
//  Hub
//

#import "ViewController.h"
#import "Hub.h"
#import "SomeHubMsg.h"

@interface ViewController ()
{
	NSInteger _counter;
}
@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	_counter = 0;
	[[Hub shared] subscribeMethod:@selector(onSomeTestMsg:) atObject:self forMessage:[SomeHubMsg class]];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[[Hub shared] unsubscribeMethod:@selector(onSomeTestMsg:) atObject:self fromMessage:[SomeHubMsg class]];
}

- (IBAction)onSendMessageBtn:(UIButton *)sender
{
	SomeHubMsg *msg = [SomeHubMsg messageWithValue:_counter];
	[[Hub shared] send:msg];
	_counter++;
}

- (void)onSomeTestMsg:(SomeHubMsg *)msg
{
	self.resultText.text = [NSString stringWithFormat:@"Received value: %li", msg.value];
}

@end

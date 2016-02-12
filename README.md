## Hub
This is a strongly-typed message hub for Objective-C that I used for a while instead of `NSNotificationCenter`. It's now kind of deprecated because of iOS 9 `NSNotification` improvements.


#### Subscribing
```objective-c
[[Hub shared] subscribeMethod:@selector(onSomeTestMsg:)
					 atObject:self
				   forMessage:[SomeHubMsg class]];
```

#### Unsubscribing
You must unsubscribe in `-viewWillDisappear:` or `-dealloc`.

```objective-c
[[Hub shared] unsubscribeMethod:@selector(onSomeTestMsg:)
					   atObject:self
					fromMessage:[SomeHubMsg class]];
```

#### Sending Messages
```objective-c
SomeHubMsg *msg = [SomeHubMsg messageWithValue:12345];
[[Hub shared] send:msg];
```

#### Receiving Messages
```objective-c
- (void)onSomeTestMsg:(SomeHubMsg *)msg
{
	self.resultText.text = [NSString stringWithFormat:@"Received value: %li", msg.value];
}
```

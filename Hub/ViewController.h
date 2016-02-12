//
//  ViewController.h
//  Hub
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *resultText;

- (IBAction)onSendMessageBtn:(UIButton *)sender;

@end


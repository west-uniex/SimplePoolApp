//
//  SPAUserChoiceViewController.m
//  SimplePollApp
//
//  Created by Developer on 1/11/16.
//  Copyright © 2016 Developer. All rights reserved.
//

#import "SPAUserChoiceViewController.h"
#import "SPACurrentModel.h"
#import "SPAREflectingView.h"
#import "SPAPoolResultsViewController.h"
#import "SPAUserSelection.h"

#define BARBUTTON(TITLE, SELECTOR) [[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR]
#define SYSBARBUTTON(ITEM, SELECTOR) [[UIBarButtonItem alloc] initWithBarButtonSystemItem:ITEM target:self action:SELECTOR]

@interface SPAUserChoiceViewController () <UITextFieldDelegate>

{
	UIToolbar   * _tb;
	UITextField * _editedTextField;
	
}
//
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIImageView       *backgroundImageView;

@property (weak, nonatomic) IBOutlet SPAReflectingView *bassReflectingView;
@property (weak, nonatomic) IBOutlet SPAReflectingView *electricReflectingView;
@property (weak, nonatomic) IBOutlet SPAReflectingView *guitarReflectingView;
@property (weak, nonatomic) IBOutlet SPAReflectingView *banjoReflectingView;

@property (weak, nonatomic) IBOutlet UIView            *textFieldContentView;
@property (weak, nonatomic) IBOutlet UITextField       *userNameTextFiled;

@property (assign, nonatomic, getter=isUserNameSet) BOOL userNameSet;

// actions

- (IBAction) bassButtonDidTap:    (id) sender;
- (IBAction)electricButtonDidTap: (id) sender;
- (IBAction)guitarButtonDidTap:(id)sender;
- (IBAction)banjoButtobDidTap:(id)sender;


@end

@implementation SPAUserChoiceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.navigationController.navigationBarHidden = YES;

	[self setNeedsStatusBarAppearanceUpdate];
	
	CGRect mainScreenFrame         = [[UIScreen mainScreen] bounds];
	
	DLog(@"mainScreenFrame : %@ \n\n", [NSValue valueWithCGRect: mainScreenFrame]);
	
	self.view.frame                = [[UIScreen mainScreen] applicationFrame];
	self.backgroundImageView.frame = mainScreenFrame;
	
	// make more dark the background view
	
	UIView *darkView         = [[UIView alloc] initWithFrame: mainScreenFrame];
	darkView.backgroundColor = [UIColor blackColor];
	darkView.alpha           = 0.6;
	[self.backgroundImageView addSubview: darkView];
	
	
	if (YES == [SPACurrentModel sharedManager].isiPhone4)
	{
		
	}
	
	if (YES == [SPACurrentModel sharedManager].isiPhone6)
	{
		
	}
	
	[self.bassReflectingView     setupReflectionWithShrinkFactor: 1.0 ];
	[self.electricReflectingView setupReflectionWithShrinkFactor: 1.0 ];
	[self.guitarReflectingView   setupReflectionWithShrinkFactor: 1.0 ];
	[self.banjoReflectingView    setupReflectionWithShrinkFactor: 1.0 ];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark accesory view

- (UIToolbar *) accessoryView
{
	_tb           = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 44.0f)];
	_tb.tintColor = [UIColor darkGrayColor];
	
	NSMutableArray *items = [NSMutableArray array];
	[items addObject:BARBUTTON(@"Clear", @selector(clearText))];
	[items addObject:SYSBARBUTTON(UIBarButtonSystemItemFlexibleSpace, nil)];
	[items addObject:BARBUTTON(@"Done", @selector(leaveKeyboardMode))];
	_tb.items = items;
	
	return _tb;
}

- (void) clearText
{
	[_editedTextField setText:@""];
}

- (void) leaveKeyboardMode
{
	[_editedTextField resignFirstResponder];
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(UIStatusBarStyle)preferredStatusBarStyle
{
	return UIStatusBarStyleLightContent;
}




- (BOOL) isUserNameSet
{
	//Type your name here
	if ( (self.userNameTextFiled.text.length > 0) && (![self.userNameTextFiled.text isEqualToString: @" "]) && (![self.userNameTextFiled.text isEqualToString: @"Type your name here"])) // need description forbidden names
	{
		return YES;
	}
	
	return NO;
}

#pragma mark internal methods for button senders

-(void) xxxHandlingTapButtonForGenreSelection: (SPASelectionState) genreSelection
{
	if ( self.isUserNameSet == NO)
	{
		//DLog(@"please set name \n\n");
		
		UIAlertController* alert = [UIAlertController alertControllerWithTitle: @"user name is mandatory"
																	   message: @"please fill correct name"
																preferredStyle: UIAlertControllerStyleAlert];
		
		UIAlertAction* defaultAction = [UIAlertAction actionWithTitle: @"OK"
																style: UIAlertActionStyleDefault
															  handler: ^(UIAlertAction * action) {}];
		
		[alert addAction:defaultAction];
		[self presentViewController:alert animated:YES completion:nil];
		
		return;
	}
	
	SPAUserSelection *currentUserSelection = [[SPAUserSelection alloc] initWithName: self.userNameTextFiled.text
																  andGenreSelection: genreSelection];
	
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main"
														 bundle: nil];
	SPAPoolResultsViewController *viewController   = (SPAPoolResultsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SPAPoolResultsViewControllerId"];
	viewController.currentUserSelection = currentUserSelection;
	
	UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController: viewController];
	[self presentViewController: nc
					   animated: YES
					 completion: nil];
	

}


#pragma mark  IB Actions

- (IBAction)bassButtonDidTap:(id)sender
{
	if ( self.isUserNameSet == NO)
	{
		//DLog(@"please set name \n\n");
		
		UIAlertController* alert = [UIAlertController alertControllerWithTitle: @"user name is mandatory"
																	   message: @"please fill correct name"
																preferredStyle: UIAlertControllerStyleAlert];
		
		UIAlertAction* defaultAction = [UIAlertAction actionWithTitle: @"OK"
																style: UIAlertActionStyleDefault
															  handler: ^(UIAlertAction * action) {}];
		
		[alert addAction:defaultAction];
		[self presentViewController:alert animated:YES completion:nil];
		
		return;
	}
	
	SPAUserSelection *currentUserSelection = [[SPAUserSelection alloc] initWithName: self.userNameTextFiled.text
																  andGenreSelection: SPASelectionStateBassSelected];
	
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main"
														 bundle: nil];
	SPAPoolResultsViewController *viewController   = (SPAPoolResultsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SPAPoolResultsViewControllerId"];
	viewController.currentUserSelection = currentUserSelection;

	UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController: viewController];
	[self presentViewController: nc
					   animated: YES
					 completion: nil];

}

- (IBAction) electricButtonDidTap: (id) sender
{
	[self xxxHandlingTapButtonForGenreSelection: SPASelectionStateElectricGuitarSelected];
}

- (IBAction) guitarButtonDidTap: (id) sender
{
	[self xxxHandlingTapButtonForGenreSelection: SPASelectionStateGuitarSelected];
}

- (IBAction) banjoButtobDidTap: (id) sender
{
	[self xxxHandlingTapButtonForGenreSelection: SPASelectionStateBanjoSelected];
}

#pragma mark
#pragma mark  UITextFieldDelegate conforming

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	// Catch returns to resign first responder for the text field
	[textField resignFirstResponder];
	return YES;
}


// became first responder
- (void)textFieldDidBeginEditing:(UITextField *) textField
{
	DLog(@" \n\n");
	
	if ( YES ==[[SPACurrentModel sharedManager] isiPhone4])
	{
		if (textField == self.userNameTextFiled)
		{
			self.scrollView.contentOffset = CGPointMake(0, 320);
		}
		self.scrollView.contentSize = CGSizeMake(320, 750);
	}
	
	if ( YES ==[[SPACurrentModel sharedManager] isiPhone5])
	{
		if (textField == self.userNameTextFiled)
		{
			self.scrollView.contentOffset = CGPointMake(0, 280);
		}
		
		self.scrollView.contentSize = CGSizeMake(320, 750);
	}
	
	if ( YES ==[[SPACurrentModel sharedManager] isiPhone6])
	{
		self.scrollView.contentSize = CGSizeMake(320, 849);
	}
	
	_editedTextField                    = textField;
	_editedTextField.inputAccessoryView = [self accessoryView];
	
	[self clearText];
	
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	//DLog(@" \n\n");
	
	self.scrollView.contentOffset = CGPointMake(0, -70);
	
	if ( YES ==[[SPACurrentModel sharedManager] isiPhone4])
	{
		self.scrollView.contentSize = CGSizeMake(320, 414);
	}
	
	if ( YES ==[[SPACurrentModel sharedManager] isiPhone5])
	{
		self.scrollView.contentSize = CGSizeMake(320, 504);
	}
	
	if ( YES ==[[SPACurrentModel sharedManager] isiPhone6])
	{
		self.scrollView.contentSize = CGSizeMake(320, 603);
	}
	
	_editedTextField = nil;
}



@end

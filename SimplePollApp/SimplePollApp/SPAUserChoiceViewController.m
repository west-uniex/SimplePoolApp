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
#import "SPAUser.h"

@interface SPAUserChoiceViewController ()

@property (weak, nonatomic) IBOutlet UIImageView       *backgroundImageView;

@property (weak, nonatomic) IBOutlet SPAReflectingView *bassReflectingView;


@property (assign, nonatomic, getter=isUserNameSet) BOOL userNameSet;

// actions

- (IBAction)bassButtonDidTap:(id)sender;


@end

@implementation SPAUserChoiceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.navigationController.navigationBarHidden = YES;

	[self setNeedsStatusBarAppearanceUpdate];
	
	//CGSize screenSize = [[UIScreen mainScreen] bounds].size;

	
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
	
	[self.bassReflectingView setupReflectionWithShrinkFactor: 1.0 ];
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark  IB Actions


- (IBAction)bassButtonDidTap:(id)sender
{
	if ( self.isUserNameSet == NO)
	{
		DLog(@"please set name \n\n");
		return;
	}
	
	SPAUser *currentUser = [[SPAUser alloc] initWithName: @"Vasya"];
	
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main"
														 bundle: nil];
	SPAPoolResultsViewController *viewController   = (SPAPoolResultsViewController *)[storyboard instantiateViewControllerWithIdentifier:@"SPAPoolResultsViewControllerId"];
	viewController.currentUser = currentUser;

	UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController: viewController];
	[self presentViewController: nc
					   animated: YES
					 completion: nil];

}

@end

//
//  SPAPoolResultsViewController.m
//  SimplePollApp
//
//  Created by Developer on 1/12/16.
//  Copyright © 2016 Developer. All rights reserved.
//

#import "SPAPoolResultsViewController.h"
#import "SPACurrentModel.h"
#import "SPAUserSelection.h"
#import "SPAWebServiceAPI.h"
#import "SPAWebServiceManager.h"


typedef void (^CompletionHandlerType)();

@interface SPAPoolResultsViewController ()


@property (nonatomic, strong) UIAlertController    *alertNetworkActivity;

// UI

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (weak, nonatomic) IBOutlet UILabel     *resultsLabel;

@property (weak, nonatomic) IBOutlet UIView      *guitarConrentView;
@property (weak, nonatomic) IBOutlet UILabel     *guitarPercentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *guitarBackgroundView;

@property (weak, nonatomic) IBOutlet UIView      *electricContentView;
@property (weak, nonatomic) IBOutlet UILabel     *electricPercentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *electricBackgroundView;

@property (weak, nonatomic) IBOutlet UIView      *bassContentView;
@property (weak, nonatomic) IBOutlet UILabel     *bassPercentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bassBackgrounfView;

@property (weak, nonatomic) IBOutlet UIView      *banjoContentView;
@property (weak, nonatomic) IBOutlet UILabel     *banjoPercentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *banjoBackgroundView;


@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

- (IBAction)longPreesGestureDidDone:(id)sender;

@end

@implementation SPAPoolResultsViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	
	if (self)
	{

	}
	
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.navigationController.navigationBarHidden = YES;
	
	CGRect mainScreenFrame         = [[UIScreen mainScreen] bounds];
	
	DLog(@"mainScreenFrame : %@ \n\n", [NSValue valueWithCGRect: mainScreenFrame]);
	
	self.view.frame                = [[UIScreen mainScreen] applicationFrame];
	self.backgroundImageView.frame = mainScreenFrame;
	
	// make more dark the background view
	
	
	//mainScreenFrame          = CGRectMake(0, 20, mainScreenFrame.size.width, mainScreenFrame.size.height - 20);
	UIView *darkView         = [[UIView alloc] initWithFrame: mainScreenFrame];
	darkView.backgroundColor = [UIColor blackColor];
	darkView.alpha           = 0.6;
	[self.backgroundImageView addSubview: darkView];
	
	if (YES == [SPACurrentModel sharedManager].isiPhone4)
	{
		self.infoLabel.frame = CGRectMake( 30, 400, 260, 44);
	}
	
	if (YES == [SPACurrentModel sharedManager].isiPhone6)
	{
		self.resultsLabel.center = CGPointMake( 188, 100 );
		self.infoLabel.center    = CGPointMake( 188, 550);
		
		self.guitarConrentView.center   = CGPointMake( 188, 180);
		self.electricContentView.center = CGPointMake( 188, 270);
		self.bassContentView.center     = CGPointMake( 188, 360);
		self.banjoContentView.center    = CGPointMake( 188, 450);
	}
	
	if (YES == [SPACurrentModel sharedManager].isiPhone6Plus)
	{
		self.resultsLabel.center = CGPointMake( 207, 100 );
		self.infoLabel.center    = CGPointMake( 207, 600);
		
		self.guitarConrentView.center   = CGPointMake( 207, 200);
		self.electricContentView.center = CGPointMake( 207, 300);
		self.bassContentView.center     = CGPointMake( 207, 400);
		self.banjoContentView.center    = CGPointMake( 207, 500);
	}
	
	self.guitarBackgroundView.alpha   = 0.6;
	self.electricBackgroundView.alpha = 0.6;
	self.bassBackgrounfView.alpha     = 0.6;
	self.banjoBackgroundView.alpha    = 0.6;
	
	
	DLog(@"\ncurrent user name: %@ \nuser selection: %lul\n\n", self.currentUserSelection.name, (unsigned long)self.currentUserSelection.genreSelection);
	
	//
	[self xxxHandleSelection];
}


-(void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	// modeling get good response from server
	//{	"banjo": 10, 	"bass": 25, "electric": 40, "guitar": 25, "status": "ok"}
	//NSDictionary *response = @{ @"banjo": @10, @"bass": @25, @"electric": @40, @"guitar": @25, @"status": @"ok"}
	//[self xxxUpdadeUIFromResponseDictionary: response];
	
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
	
	DLog(@" ");
}

#pragma mark set needed status bar style

-(UIStatusBarStyle)preferredStatusBarStyle
{
	return UIStatusBarStyleLightContent;
}

#pragma mark  internal methods


- (void) xxxHandleSelection
{
	NSURLRequest *selectionRequest = [[SPAWebServiceAPI requestPOSTUserSelection: self.currentUserSelection.genreSelection
																    withUserName: self.currentUserSelection.name] copy];
	__weak __typeof__ (self) weakSelf = self;
	__weak UIViewController  *weakPVC = self.presentingViewController;
	
	self.alertNetworkActivity = [UIAlertController alertControllerWithTitle: @"Message from Application"
																	message: @"Your Selection  have sent to server\n"
															 preferredStyle: UIAlertControllerStyleAlert];
	
	[self presentViewController: self.alertNetworkActivity animated: NO completion: nil];
	
	[[SPAWebServiceManager sharedManager] POSTUserSelectionWithRequest: selectionRequest
												 withCompletionHandler: ^ (NSDictionary *responce, NSError *error)
	{
		__strong __typeof__(self) strongSelf = weakSelf;
		UIViewController * strongPVC = weakPVC;
		
		if (!error)
		{
			[strongSelf xxxGetPoolResultsFromSelf: weakSelf  isWeakSelf: YES];
			
			__weak __typeof__ (self) weakSelf2 = strongSelf;
			[strongSelf dismissViewControllerAnimated: YES
									 completion: ^(void)
			{
				__strong __typeof__(self) strongSelf2 = weakSelf2;
				if (!strongSelf2)
				{
					DLog(@"\nLook HERE !!!\n\n");
					sleep(0);
				}
				
				strongSelf2.alertNetworkActivity = [UIAlertController alertControllerWithTitle: @"Message from Server"
																		      message: @"Your Selection successfully updated on server"
																	 preferredStyle: UIAlertControllerStyleAlert];
				[strongSelf2 presentViewController: strongSelf2.alertNetworkActivity
										  animated: YES
										completion: nil];
			}];
		}
		else
		{
			dispatch_async(dispatch_get_main_queue(), ^
			{
				__strong __typeof__(self) strongSelf = weakSelf;
				DLog(@"\nerror: %@\n\n", error);
				//strongSelf.alertNetworkActivity = nil;
				
				UIAlertController* alert = [UIAlertController alertControllerWithTitle: @"Network error"
																			   message: error.localizedDescription
																		preferredStyle: UIAlertControllerStyleAlert];
				
				UIAlertAction* defaultAction = [UIAlertAction actionWithTitle: @"OK"
																		style: UIAlertActionStyleDefault
																	  handler: ^(UIAlertAction * action) {}];
				
				[alert addAction:defaultAction];

				[strongSelf dismissViewControllerAnimated: YES
											   completion: ^(void)
				 {
					__strong __typeof__(self) strongSelf2 = weakSelf;
					 [strongSelf2 dismissViewControllerAnimated: YES
													 completion: ^(void)
					 {
						 [strongPVC presentViewController:alert animated:YES completion:nil];
													 }];
				 }];
				
				return;
			});
		}
	}];
}

- (void) xxxGetPoolResultsFromSelf: (SPAPoolResultsViewController *) prvc  isWeakSelf: (BOOL) flagSelf
{
	if (flagSelf == YES)
	{
		__strong typeof(self)self = prvc;
		[self xxxGetPoolResults];
	}
	else
	{
		[self xxxGetPoolResults];
	}
	
}

- (void) xxxGetPoolResults
{
	NSURLRequest *poolRequest = [[SPAWebServiceAPI requestGetPoolResults] copy];
	__weak __typeof__ (self) weakSelf = self;
	__weak UIViewController  *weakPVC = self.presentingViewController;
	
	[[SPAWebServiceManager sharedManager] GETPoolResultsWithRequest: poolRequest
 											 withCompletionHandler: ^ (NSDictionary *responce, NSError *error)
	 {
		 __strong __typeof__(weakSelf) strongSelf = weakSelf;
		 UIViewController * strongPVC = weakPVC;
		 
		 if (!error)
		 {
			 [self xxxUpdadeUIFromPoolResponseDictionary: responce];
		 }
		 else
		 {
			 dispatch_async(dispatch_get_main_queue(), ^
							{
								DLog(@"%@\n\n", error);
								[strongSelf dismissViewControllerAnimated: YES
															   completion: ^(void)
								 {
									 //UIViewController * strongPVC = weakPVC;
									 UIAlertController* alert = [UIAlertController alertControllerWithTitle: @"Network error"
																									message: error.localizedDescription
																							 preferredStyle: UIAlertControllerStyleAlert];
									 
									 UIAlertAction* defaultAction = [UIAlertAction actionWithTitle: @"OK"
																							 style: UIAlertActionStyleDefault
																						   handler: ^(UIAlertAction * action) {}];
									 
									 [alert addAction:defaultAction];
									 [strongPVC presentViewController:alert animated:YES completion:nil];
								 }];
								
								return;
							});
		 }
	 }];
}


- (void) xxxUpdadeUIFromPoolResponseDictionary: (NSDictionary *) response
{

	float sum = [(NSNumber *) response[@"banjo"]  floatValue] + [(NSNumber *) response[@"bass"]  floatValue] + [(NSNumber *) response[@"electric"]  floatValue] + [(NSNumber *) response[@"guitar"]  floatValue];
	
	BOOL flag = (sum >= 99.0) && (sum <=101.0);
	
	if ( !flag )
	{
		DLog(@"bad data");
		return;
	}
	
	CGFloat temp = 0.0;
	CGFloat etalon_100 = self.guitarBackgroundView.frame.size.width;
	CGRect etalonRect = self.guitarBackgroundView.frame;
	
	//   guitar
	temp = ([(NSNumber *) response[@"guitar"]  floatValue] * etalon_100)/100.0;
	self.guitarBackgroundView.frame = CGRectIntegral ( CGRectMake(etalonRect.origin.x,
												       etalonRect.origin.y,
												       temp,
													   etalonRect.size.height) );
	self.guitarPercentLabel.text = [NSString stringWithFormat:@"%@%@", response[@"guitar"], @"%"];
	
	//  electric
	etalonRect = self.electricBackgroundView.frame;
	temp = ([(NSNumber *) response[@"electric"]  floatValue] * etalon_100)/100.0;
	self.electricBackgroundView.frame = CGRectIntegral( CGRectMake( etalonRect.origin.x, etalonRect.origin.y, temp, etalonRect.size.height) );
	self.electricPercentLabel.text = [NSString stringWithFormat:@"%@%@", response[@"electric"], @"%"];
	
	//  bass
	etalonRect = self.bassBackgrounfView.frame;
	temp = ([(NSNumber *) response[@"bass"]  floatValue] * etalon_100)/100.0;
	self.bassBackgrounfView.frame = CGRectIntegral( CGRectMake( etalonRect.origin.x, etalonRect.origin.y, temp, etalonRect.size.height) );
	self.bassPercentLabel.text    = [NSString stringWithFormat:@"%@%@", response[@"bass"], @"%"];
	
	//  banjo
	etalonRect = self.banjoBackgroundView.frame;
	temp = ([(NSNumber *) response[@"banjo"]  floatValue] * etalon_100)/100.0;
	self.banjoBackgroundView.frame = CGRectIntegral( CGRectMake( etalonRect.origin.x, etalonRect.origin.y, temp, etalonRect.size.height) );
	self.banjoPercentLabel.text    = [NSString stringWithFormat:@"%@%@", response[@"banjo"], @"%"];
	
	switch (self.currentUserSelection.genreSelection)
	{
		case SPASelectionStateGuitarSelected:
			self.infoLabel.text = [NSString stringWithFormat: @"%@\n%@ %@ also like the blue one!",self.currentUserSelection.name, response[@"guitar"], @"%" ];
			break;
		case SPASelectionStateElectricGuitarSelected:
			self.infoLabel.text = [NSString stringWithFormat: @"%@\n%@ %@ also like the pink one!",self.currentUserSelection.name, response[@"electric"], @"%" ];
			break;
			
		case SPASelectionStateBassSelected:
			self.infoLabel.text = [NSString stringWithFormat: @"%@\n%@ %@ also like the red one!",self.currentUserSelection.name, response[@"bass"], @"%" ];
			break;
			
		case SPASelectionStateBanjoSelected:
			self.infoLabel.text = [NSString stringWithFormat: @"%@\n%@ %@ also like the green one!",self.currentUserSelection.name, response[@"bass"], @"%" ];
			break;
			
	default:
			break;
	}
	
	UIAlertAction* defaultAction = [UIAlertAction actionWithTitle: @"OK"
															style: UIAlertActionStyleDefault
														  handler: ^(UIAlertAction * action) {}];
	[self.alertNetworkActivity setTitle: @"Message from Application"];
	[self.alertNetworkActivity setMessage: @"Results Pool successfully get From Server"];
	[self.alertNetworkActivity addAction: defaultAction];
	
}



#pragma mark IB Actions


- (IBAction)longPreesGestureDidDone:(id)sender
{
	 [self dismissViewControllerAnimated: YES
							  completion: nil];
}


@end

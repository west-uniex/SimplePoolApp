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


typedef void (^CompletionHandlerType)();

@interface SPAPoolResultsViewController () <NSURLSessionDelegate>

@property (nonatomic, strong) NSURLSession         *defaultSession;
@property (nonatomic, strong) NSURLProtectionSpace *trustSpace;

// UI

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;


@property (weak, nonatomic) IBOutlet UIView *guitarConrentView;
@property (weak, nonatomic) IBOutlet UILabel *guitarPercentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *guitarBackgroundView;

@property (weak, nonatomic) IBOutlet UIView *electricContentView;
@property (weak, nonatomic) IBOutlet UILabel *electricPercentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *electricBackgroundView;

@property (weak, nonatomic) IBOutlet UIView *bassContentView;
@property (weak, nonatomic) IBOutlet UILabel *bassPercentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bassBackgrounfView;

@property (weak, nonatomic) IBOutlet UIView *banjoContentView;
@property (weak, nonatomic) IBOutlet UILabel *banjoPercentLabel;
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
		NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
	
		_trustSpace = [[NSURLProtectionSpace alloc] initWithHost: @"https://demo7130406.mockable.io"
															port: 443
														protocol: NSURLProtectionSpaceHTTPS
														   realm: @"mobile"
											authenticationMethod: NSURLAuthenticationMethodServerTrust];
		
		//defaultConfigObject.URLCredentialStorage = [NSURLCredentialStorage sharedCredentialStorage];
		
		_defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject
														delegate: self
												   delegateQueue: [NSOperationQueue mainQueue]];;
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
		
	}
	
	self.guitarBackgroundView.alpha   = 0.6;
	self.electricBackgroundView.alpha = 0.6;
	self.bassBackgrounfView.alpha     = 0.6;
	self.banjoBackgroundView.alpha    = 0.6;
	
	
	DLog(@"\ncurrent user name: %@ \nuser selection: %ul\n\n", self.currentUserSelection.name, self.currentUserSelection.genreSelection);
	
	//
	//    POST selection through session task
	//
	
	//NSMutableURLRequest *requestGenreChoice = [SPAWebServiceAPI requestPOSTUserSelection: self.currentUserSelection.genreSelection
	//																 withUserName: self.currentUserSelection.name ];
	NSMutableURLRequest *requestGenreChoice = [SPAWebServiceAPI requestGetPoolResults];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	NSURLSessionDataTask *postUserChoiceTask = [_defaultSession dataTaskWithRequest: requestGenreChoice
																  completionHandler: ^(NSData * __nullable data, NSURLResponse * __nullable response,
																					   NSError * __nullable error)
	{
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		
		DLog(@"%@", @"here");
		if (error)
		{
			NSLog(@"%@", error);
			
			return;
		}
		
		NSInteger status = [(NSHTTPURLResponse*)response statusCode];
		DLog(@"response status: %i", status);
		
		if (status != 200 )
		{
			DLog(@"%@", @"oh well");
			
			if (status == 403 )
			{
				__weak UIViewController *pvc =  self.presentingViewController;
				/*
				[self dismissViewControllerAnimated: YES
										 completion: ^(void)
				 {
					 UIAlertController* alert = [UIAlertController alertControllerWithTitle: @"we does not have permission to get URL"
																			   message: @"please be patient"
																		preferredStyle: UIAlertControllerStyleAlert];
				
					 UIAlertAction* defaultAction = [UIAlertAction actionWithTitle: @"OK"
																		style: UIAlertActionStyleDefault
																	  handler: ^(UIAlertAction * action) {}];
				
					 [alert addAction:defaultAction];
					 [pvc presentViewController:alert animated:YES completion:nil];
				
				 }];
				 */
				return;
			}
		}
		

		dispatch_async(dispatch_get_main_queue(), ^
        {
			[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
			//self.textView.text = text;

			DLog(@"%@\n\n", @"done");
		});

	}];
	
	[postUserChoiceTask resume];
	
}


-(void) viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	// modeling get good response from server
	
	//{	"banjo": 10, 	"bass": 25, "electric": 40, "guitar": 25, "status": "ok"}
	NSDictionary *response = @{ @"banjo": @10, @"bass": @25, @"electric": @40, @"guitar": @25, @"status": @"ok"};
	
	[self xxxUpdadeUIFromResponseDictionary: response];
	
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
	
	DLog(@" ");
}

#pragma mark  internal methods


- (void) xxxUpdadeUIFromResponseDictionary: (NSDictionary *) response
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
	
}



#pragma mark  NSURLSessionDelegate conforming

- (void)               URLSession:(NSURLSession     *)session
        didBecomeInvalidWithError:(nullable NSError *)error
{
	DLog(@"challenge: %@  \n\n", error);
	sleep(0);
}

- (void) URLSession: (NSURLSession                 *) session
didReceiveChallenge: (NSURLAuthenticationChallenge *) challenge
  completionHandler: (void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential)) completionHandler
{
	DLog(@"challenge: %@\n \n\n", challenge);
	sleep(0);
	/*
	NSURLCredentialPersistence persistence = NSURLCredentialPersistenceForSession;
	NSURLCredential *credential = [NSURLCredential credentialWithUser: @" "
															 password: @" "
														  persistence:persistence];
	completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
	
	return;
	*/
	
	if ([challenge.protectionSpace.authenticationMethod isEqualToString: NSURLAuthenticationMethodServerTrust])
	{
		SecTrustResultType result;
		OSStatus status = SecTrustEvaluate (challenge.protectionSpace.serverTrust,  &result);
		BOOL isTrustValid = status == noErr && (result == kSecTrustResultUnspecified || result == kSecTrustResultProceed);
		
		if (isTrustValid)
		{
			NSURLCredential *credential = [NSURLCredential credentialForTrust: challenge.protectionSpace.serverTrust];
			
			[[challenge sender] useCredential:credential forAuthenticationChallenge: challenge];
			completionHandler ( NSURLSessionAuthChallengePerformDefaultHandling, credential );
			
		}
		else
		{
			[[challenge sender] cancelAuthenticationChallenge: challenge];
		}
	}
	else
	{
		if ([challenge previousFailureCount] == 0)
		{
			/*
			if (self.credential)
			{
				[[challenge sender] useCredential: self.credential
					   forAuthenticationChallenge: challenge];
			} else
			{
				[[challenge sender]  continueWithoutCredentialForAuthenticationChallenge: challenge];
			}
			 */
		}
		else
		{	// if nothing catches this challenge, attempt to connect without credentials
			[[challenge sender] continueWithoutCredentialForAuthenticationChallenge: challenge];
		}
	}

}



#pragma mark NSURLSessionTaskDelegate 

- (void)         URLSession: (NSURLSession                 *)session
					   task: (NSURLSessionTask             *)task
        didReceiveChallenge: (NSURLAuthenticationChallenge *)challenge
		  completionHandler: (void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential))completionHandler
{
	DLog(@"challenge: %@  \n\n", challenge);
	sleep(0);
}



#pragma mark NSURLConnectionDelegate
- (void)                                connection: (NSURLConnection              *) connection
         willSendRequestForAuthenticationChallenge: (NSURLAuthenticationChallenge *) challenge
{
	DLog(@"challenge: %@  \n\n", challenge);
	sleep(0);
}


#pragma mark IB Actions


- (IBAction)longPreesGestureDidDone:(id)sender
{
	 [self dismissViewControllerAnimated: YES
							  completion: nil];
}


@end

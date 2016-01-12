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

@interface SPAPoolResultsViewController ()

@property (nonatomic, strong) NSURLSession *session;


@end

@implementation SPAPoolResultsViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		// 1
		NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
		
		// 2
		
		// 3
		_session = [NSURLSession sessionWithConfiguration:config];
	}
	return self;
}




- (void)viewDidLoad
{
    [super viewDidLoad];
	
	DLog(@"current user name: %@ \n\n", self.currentUserSelection.name);
	
	//NSURLRequest *requestGenreChoice = [SPAWebServiceAPI requestPOSTUserSelection: self.currentUserSelection.genreSelection
	//													  withUserName: self.currentUserSelection.name ];
	
	
	//NSString* s = @"https://demo7130406.mockable.io/submit-poll";
	
	NSString* s = @"https://demo7130406.mockable.io/poll-results";
	NSURL* url = [NSURL URLWithString:s];
	
	NSMutableURLRequest *requestGenreChoice = [[NSMutableURLRequest alloc] initWithURL: url];
	
	[requestGenreChoice setHTTPMethod:@"GET"];

	
	NSURLSession* session = [NSURLSession sharedSession];
	
	//NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	NSURLSessionDataTask *postUserChoiceTask = [session dataTaskWithRequest: requestGenreChoice
														  completionHandler: ^(NSData * __nullable data, NSURLResponse * __nullable response, NSError * __nullable error)
	{
		DLog(@"%@", @"here");
		if (error)
		{
			NSLog(@"%@", error);
			
			return;
		}
		
		NSInteger status = [(NSHTTPURLResponse*)response statusCode];
		DLog(@"response status: %i", status);
		
		if (status != 200)
		{
			DLog(@"%@", @"oh well");
			return;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
	
	DLog(@" ");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

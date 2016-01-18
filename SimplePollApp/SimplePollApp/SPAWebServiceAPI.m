//
//  SPAWebServiceAPI.m
//  SimplePollApp
//
//  Created by Developer on 1/11/16.
//  Copyright © 2016 Developer. All rights reserved.
//

#import "SPAWebServiceAPI.h"

@implementation SPAWebServiceAPI

// https://demo7130406.mockable.io/submit-poll
// /submit-poll
// https://demo7130406.mockable.io/poll-results
// /poll-results

static NSString *SERVER_URL = @"https://demo7130406.mockable.io";

//   create submit-poll request

+ (NSMutableURLRequest *) requestPOSTUserSelection: (SPASelectionState) selection
									  withUserName: (NSString        *) theUserName
{
	if (!theUserName)
	{
		NSLog(@"User name did not set");
		return nil;
	}
	
	NSString *queryString         = [NSString stringWithFormat:@"?userName=%@", theUserName];
	NSString *selectionPartString = nil;
	switch (selection)
	{
		case SPASelectionStateBanjoSelected:
			selectionPartString = [NSString stringWithFormat:@"&selection=banjo"];
			break;
			
		case SPASelectionStateBassSelected:
			selectionPartString = [NSString stringWithFormat:@"&selection=bass"];
			break;
			
		case SPASelectionStateElectricGuitarSelected:
			selectionPartString = [NSString stringWithFormat:@"&selection=electricguitar"];
			break;
			
		case SPASelectionStateGuitarSelected:
			selectionPartString = [NSString stringWithFormat:@"&selection=guitar"];
			break;
			
		case SPASelectionStateNotSelected:
			
			NSLog(@"selection did not set");
			return nil;
	}
	
	queryString = [queryString stringByAppendingString: selectionPartString];
	NSLog(@"queryString = %@\n\n", queryString);
	
	NSURL *urlSubmitPool = [NSURL URLWithString:[NSString stringWithFormat:@"%@/submit-poll%@", SERVER_URL, queryString]];
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: urlSubmitPool];
	request.HTTPMethod           = @"POST";
	//[request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	//[request addValue:@"*/*" forHTTPHeaderField:@"Accept"];
	//[request addValue:@"0"  forHTTPHeaderField:@"Content-Length"];
	
	return request;
}


// create poll-results

+ (NSMutableURLRequest *) requestGetPoolResults

{
	NSURL *urlSubmitPool = [NSURL URLWithString:[NSString stringWithFormat:@"%@/poll-results", SERVER_URL]];
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: urlSubmitPool];
	request.HTTPMethod           = @"GET";
	//[request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	//[request addValue:@"*/*" forHTTPHeaderField:@"Accept"];
	//[request addValue:@"0"  forHTTPHeaderField:@"Content-Length"];
	
	return request;
}


@end

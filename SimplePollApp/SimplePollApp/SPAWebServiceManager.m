//
//  SPAWebServiceManager.m
//  SimplePollApp
//
//  Created by Developer on 1/17/16.
//  Copyright © 2016 Developer. All rights reserved.
//

#import "SPAWebServiceManager.h"


@interface SPAWebServiceManager () <NSURLSessionDelegate >

@property (nonatomic, strong)  NSURLSessionConfiguration *defaultSessionConfiguration;

@end

@implementation SPAWebServiceManager

#pragma mark - Initialization

- (instancetype) init
{
	self = [super init];
	
	if (self)
	{
		_defaultSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
	}
	
	return self;
}


+ (SPAWebServiceManager *) sharedManager
{
	static dispatch_once_t once;
	static SPAWebServiceManager *__instance;
	dispatch_once(&once, ^()
				  {
					  __instance = [[SPAWebServiceManager alloc] init];
				  });
	
	return __instance;
}



- (void) POSTUserSelectionWithRequest: (NSURLRequest *) selectionRequest
				withCompletionHandler: (void (^)( NSDictionary *responce, NSError *error)) completionHandler
{
	NSURLSession *session = [NSURLSession sessionWithConfiguration: _defaultSessionConfiguration
														  delegate: self
													 delegateQueue: [NSOperationQueue mainQueue]];
	
	NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest: selectionRequest
													completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error)
	{
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		
		if(error == nil)
		{
			id jsonObject = [NSJSONSerialization JSONObjectWithData: data
															options: NSJSONReadingAllowFragments
															error: &error];
			if (jsonObject != nil && error == nil)
			{
				if ([jsonObject isKindOfClass:[NSDictionary class]])
				{
					// our case
					NSDictionary * responceDictionary = (NSDictionary *) jsonObject;
					if ([responceDictionary[@"status"] isEqualToString: @"OK"])
					{
						DLog(@"\nresponceDictionary: %@\n\n", responceDictionary);
						completionHandler (responceDictionary, nil);
					}
					else
					{
						error = [NSError errorWithDomain: @"BAD SERVER RESPONCE AT SELECTION"
													code: 5001
												userInfo: nil];
						completionHandler ( nil, error);
					}
				}
				else
				{
					error = [NSError errorWithDomain: @"BAD JSON TYPE OF RESPONCE AT SELECTION"
												code: 5002
											userInfo: nil];
					completionHandler ( nil, error);
				}
			}
			else if (error != nil)
			{
				completionHandler (nil, error);
			}
			
		}
		else
		{
			completionHandler( nil, error);
		}
	}];
	
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	[postDataTask resume];
}


- (void) GETPoolResultsWithRequest: (NSURLRequest *) poolRequest
			 withCompletionHandler: (void (^)( NSDictionary *responce, NSError *error)) completionHandler
{
	NSURLSession *session = [NSURLSession sessionWithConfiguration: _defaultSessionConfiguration
														  delegate: self
													 delegateQueue: [NSOperationQueue mainQueue]];
	
	NSURLSessionDataTask *poolDataTask = [session dataTaskWithRequest: poolRequest
													completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error)
	{
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		
		if(error == nil)
		{
			id jsonObject = [NSJSONSerialization JSONObjectWithData: data
															options: NSJSONReadingAllowFragments
															error: &error];
			if (jsonObject != nil && error == nil)
			{
				if ([jsonObject isKindOfClass:[NSDictionary class]])
				{
					// our case
					NSDictionary * responceDictionary = (NSDictionary *) jsonObject;
					if ([responceDictionary[@"status"] isEqualToString: @"ok"])
					{
						DLog(@"\nresponceDictionary: %@\n\n", responceDictionary);
						completionHandler (responceDictionary, nil);
					}
					else
					{
						error = [NSError errorWithDomain: @"BAD SERVER RESPONCE AT SELECTION"
													code: 5001
												userInfo: nil];
						completionHandler ( nil, error);
					}
				}
				else
				{
					error = [NSError errorWithDomain: @"BAD JSON TYPE OF RESPONCE AT SELECTION"
												code: 5002
											userInfo: nil];
					completionHandler ( nil, error);
				}
			}
			else if (error != nil)
			{
				completionHandler (nil, error);
			}
		}
		else
		{
			completionHandler( nil, error);
		}
	}];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	[poolDataTask resume];
}


#pragma mark NSURLSessionDelegare

//  in our case (NSURLAuthenticationMethodServerTrust) enough NSURLSessionDelegare conforming

- (void)                URLSession: (NSURLSession *) session
		 didBecomeInvalidWithError: (NSError      *) error
{
	DLog(@"\nerror: %@\n\n", error);
}

- (void) URLSession: (NSURLSession                 *) session
didReceiveChallenge: (NSURLAuthenticationChallenge *) challenge
  completionHandler: (void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential)) completionHandler
{
	//DLog(@"\nchallenge: %@\n challenge.sender: %@\n\n", challenge, challenge.sender);
	//DLog(@"\nsession.configuration.HTTPAdditionalHeaders:  %@\n\n", session.configuration.HTTPAdditionalHeaders);
	
	if ([challenge.protectionSpace.authenticationMethod isEqualToString: NSURLAuthenticationMethodServerTrust])
	{
		SecTrustResultType result;
		OSStatus status = SecTrustEvaluate (challenge.protectionSpace.serverTrust,  &result);
		BOOL isTrustValid = status == noErr && (result == kSecTrustResultUnspecified || result == kSecTrustResultProceed);
		
		if (isTrustValid)
		{
			NSURLCredential *credential = [NSURLCredential credentialForTrust: challenge.protectionSpace.serverTrust];
			
			[[challenge sender] useCredential:credential forAuthenticationChallenge: challenge];
			completionHandler (  NSURLSessionAuthChallengeRejectProtectionSpace, credential );
			
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
				[[challenge sender] useCredential: self.credential forAuthenticationChallenge: challenge];
			}
			else
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


#pragma mark  NSURLSessionTaskDelegate

- (void)          URLSession: (NSURLSession     *) session
		          	    task: (NSURLSessionTask *) task
        didCompleteWithError: (nullable NSError *) error
{
	DLog(@"\nerror: %@\n\n", error);
}

- (void)                 URLSession: (NSURLSession      *) session
							   task: (NSURLSessionTask  *) task
		 willPerformHTTPRedirection: (NSHTTPURLResponse *) response
						 newRequest: (NSURLRequest      *) theNewRequest
				  completionHandler: (void (^)(NSURLRequest * __nullable))completionHandler
{
	
	DLog(@"\nsession: %@\task.originalRequest: %@\n\n", session, task.originalRequest);
	DLog(@"\nresponse.allHeaderFields:  %@\n\n", response.allHeaderFields);
	
	if (theNewRequest)
	{
		completionHandler ( theNewRequest);
	}
	
}


- (void)          URLSession: (NSURLSession *)session
						task: (NSURLSessionTask *)task
		 didReceiveChallenge: (NSURLAuthenticationChallenge *)challenge
		   completionHandler: (void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential))completionHandler

{
	DLog(@"challenge: %@\n challenge.sender: %@\n\n", challenge, challenge.sender);
	DLog(@"session.configuration.HTTPAdditionalHeaders:  %@\n\n", session.configuration.HTTPAdditionalHeaders);
	
	completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
}


@end

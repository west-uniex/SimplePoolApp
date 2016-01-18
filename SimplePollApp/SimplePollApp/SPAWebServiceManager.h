//
//  SPAWebServiceManager.h
//  SimplePollApp
//
//  Created by Developer on 1/17/16.
//  Copyright © 2016 Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPAWebServiceManager : NSObject


+ (SPAWebServiceManager *) sharedManager;

- (void) POSTUserSelectionWithRequest: (NSURLRequest *) selectionRequest
				withCompletionHandler: (void (^)( NSDictionary *responce, NSError *error)) completionHandler;

- (void) GETPoolResultsWithRequest: (NSURLRequest *) poolRequest
			 withCompletionHandler: (void (^)( NSDictionary *responce, NSError *error)) completionHandler;

@end

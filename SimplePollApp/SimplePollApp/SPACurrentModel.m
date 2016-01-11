//
//  SPACurrentModel.m
//  SimplePollApp
//
//  Created by Developer on 1/11/16.
//  Copyright © 2016 Developer. All rights reserved.
//

#import "SPACurrentModel.h"

@import UIKit;

@interface SPACurrentModel ()

@property (nonatomic, assign) BOOL isiPhone4;
@property (nonatomic, assign) BOOL isiPhone5;
@property (nonatomic, assign) BOOL isiPhone6;
@property (nonatomic, assign) BOOL isiPhone6Plus;


@end

@implementation SPACurrentModel

#pragma mark - Initialization

- (instancetype)init
{
	self = [super init];
	
	if (self)
	{
		CGSize screenSize = [[UIScreen mainScreen] bounds].size;
		
		if (screenSize.width == 320  && screenSize.height == 480)
		{
			self.isiPhone4 = YES;
			DLog(@"\ncurrent model iPhone4 \n\n\n");
		}
		else if (screenSize.width == 320  && screenSize.height == 568)
		{
			self.isiPhone5 = YES;
			DLog(@"\ncurrent model iPhone5 \n\n\n");
		}
		else if (screenSize.width == 375 && screenSize.height == 667)
		{
			self.isiPhone6 = YES;
			DLog(@"\ncurrent model iPhone6 \n\n\n");
		}
		else if (screenSize.width == 414 && screenSize.height == 736)
		{
			self.isiPhone6Plus = YES;
			DLog(@"\ncurrent model iPhone6Plus \n\n\n");
		}
		else
		{
			//DLog(@"We have NEW model of iPhone?\n\n\n");
		}
	}
	
	return self;
}


+ (SPACurrentModel *) sharedManager
{
	static dispatch_once_t once;
	static SPACurrentModel *__instance;
	dispatch_once(&once, ^()
	  {
		  __instance = [[SPACurrentModel alloc] init];
	  });
	
	return __instance;
}





@end

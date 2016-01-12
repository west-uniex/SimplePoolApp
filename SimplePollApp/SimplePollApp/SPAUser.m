//
//  SPAUser.m
//  SimplePollApp
//
//  Created by Developer on 1/12/16.
//  Copyright © 2016 Developer. All rights reserved.
//

#import "SPAUser.h"

@implementation SPAUser

#pragma	mark	Designated initializer

- (instancetype) initWithName: (NSString *) name
{
	if ((self = [super init]))
	{
		_name = name;
	}
	return self;
}

#pragma	mark	Superclass's designated initializer

- (instancetype) init
{
	@throw [NSException  exceptionWithName: NSInternalInconsistencyException
									reason: @"Must use initWithName: instead."
								  userInfo: nil];
}

#pragma	mark	Initializer from NSCoding

- (id)initWithCoder:(NSCoder*)decoder
{
	// Call through to super's designated initializer
	if ((self = [super init]))
	{
		_name = [decoder decodeObjectForKey :@"name"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
	[coder encodeObject: self.name forKey:@"name"];
}


- (id)copyWithZone:(NSZone *)zone
{
	SPAUser *newUser = [[[self class] allocWithZone: zone] init];
	
	if(newUser)
	{
		newUser->_name = [self name];
	}
	
	return newUser;
}


- (NSString *) description
{
	return [NSString stringWithFormat:@"Name:%@", self.name];
}


@end

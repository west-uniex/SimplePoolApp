//
//  SPAUserSelection.m
//  SimplePollApp
//
//  Created by Developer on 1/12/16.
//  Copyright © 2016 Developer. All rights reserved.
//

#import "SPAUserSelection.h"

@implementation SPAUserSelection

#pragma	mark	Designated initializer

- (instancetype)     initWithName: (NSString         *) name
				andGenreSelection: (SPASelectionState ) selection
{
	if ((self = [super init]))
	{
		_name           = name;
		_genreSelection = selection;
	}
	
	return self;
}

#pragma	mark	Superclass's designated initializer

- (instancetype) init
{
	@throw [NSException  exceptionWithName: NSInternalInconsistencyException
									reason: @"Must use initWithName: andGenreSelection: instead."
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
	SPAUserSelection *newUserSelecrion = [[[self class] allocWithZone: zone] init];
	
	if(newUserSelecrion)
	{
		newUserSelecrion->_name           = [self name];
		newUserSelecrion->_genreSelection = [self genreSelection];
	}
	
	return newUserSelecrion;
}


- (NSString *) description
{
	return [NSString stringWithFormat:@"Name:%@\nDenre Selection = %ul", self.name, self.genreSelection];
}



@end

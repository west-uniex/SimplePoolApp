//
//  SPAUserSelection.h
//  SimplePollApp
//
//  Created by Developer on 1/12/16.
//  Copyright © 2016 Developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPAWebServiceAPI.h"

@interface SPAUserSelection : NSObject <NSCoding>

@property (strong, readonly, nonatomic) NSString          *name;
@property (assign, readonly, nonatomic) SPASelectionState genreSelection;

- (instancetype)     initWithName: (NSString         *) name
			    andGenreSelection: (SPASelectionState ) selection;

@end

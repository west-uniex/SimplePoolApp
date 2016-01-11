//
//  SPAWebServiceAPI.h
//  SimplePollApp
//
//  Created by Developer on 1/11/16.
//  Copyright © 2016 Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSUInteger, SPASelectionState)
{
	SPASelectionStateNotSelected,
	SPASelectionStateBanjoSelected,
	SPASelectionStateBassSelected,
	SPASelectionStateElectricGuitarSelected,
	SPASelectionStateGuitarSelected
};


@interface SPAWebServiceAPI : NSObject

+ (NSMutableURLRequest *) requestPOSTUserSelection: (SPASelectionState) selection
									  withUserName: (NSString        *) theUserName;

+ (NSMutableURLRequest *) requestGetPoolResults;


@end

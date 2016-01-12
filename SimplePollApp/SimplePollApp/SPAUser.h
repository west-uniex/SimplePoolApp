//
//  SPAUser.h
//  SimplePollApp
//
//  Created by Developer on 1/12/16.
//  Copyright © 2016 Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPAUser : NSObject <NSCopying>

@property (strong, readonly, nonatomic) NSString *name;

- (instancetype) initWithName: (NSString *) name;


@end

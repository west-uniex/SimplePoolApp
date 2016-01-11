//
//  SPACurrentModel.h
//  SimplePollApp
//
//  Created by Developer on 1/11/16.
//  Copyright © 2016 Developer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPACurrentModel : NSObject

@property (nonatomic, readonly) BOOL isiPhone4;
@property (nonatomic, readonly) BOOL isiPhone5;
@property (nonatomic, readonly) BOOL isiPhone6;
@property (nonatomic, readonly) BOOL isiPhone6Plus;


+ (SPACurrentModel *) sharedManager;

@end

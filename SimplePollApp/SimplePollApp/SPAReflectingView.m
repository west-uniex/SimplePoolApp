//
//  SPAReflectingView.m
//  SimplePollApp
//
//  Created by Developer on 1/9/16.
//  Copyright © 2016 Developer. All rights reserved.
//

#import "SPAReflectingView.h"

@implementation SPAReflectingView

// Always use a replicator as the base layer

+ (Class) layerClass
{
	return [CAReplicatorLayer class];
}


- (void) setupReflectionWithShrinkFactor: (float) shrinkFactor
{
	CGFloat height       = self.bounds.size.height;
	
	CATransform3D t = CATransform3DMakeScale(1.0, -shrinkFactor, 1.0);
	
	// scaling centers the shadow in the view. translate in shrunken terms
	float offsetFromBottom = height * ((1.0f - shrinkFactor) / 2.0f);
	float inverse          = 1.0 / shrinkFactor;
	float desiredGap       = 0.0f;
	t = CATransform3DTranslate(t, 0.0, -offsetFromBottom * inverse - height - inverse * desiredGap, 0.0f);
	
	CAReplicatorLayer *replicatorLayer = (CAReplicatorLayer*)self.layer;
	replicatorLayer.instanceTransform  = t;
	replicatorLayer.instanceCount      = 2;
	
	// Darken the reflection when not using a gradient
	replicatorLayer.instanceRedOffset   = -0.75;
	replicatorLayer.instanceGreenOffset = -0.75;
	replicatorLayer.instanceBlueOffset  = -0.75;
	
	replicatorLayer.instanceRedOffset   = -0.65;
	replicatorLayer.instanceGreenOffset = -0.65;
	replicatorLayer.instanceBlueOffset  = -0.65;

}

@end

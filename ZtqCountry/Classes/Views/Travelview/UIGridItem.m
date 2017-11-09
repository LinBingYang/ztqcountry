//
//  UIGridItem.m
//  Ztq_public
//
//  Created by linxg on 12-2-29.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "UIGridItem.h"


@implementation UIGridItem
@synthesize _identifier = _identifier;

- (id)initWithIdentifier:(NSString *)t_identifier
{
	self = [super initWithFrame:CGRectZero];
	if (self)
	{
//		_identifier = [t_identifier retain];
        self._identifier = t_identifier;
	}
	return self;
}

//- (void)dealloc {
//	[_identifier release];
//    [super dealloc];
//}

@end

//
//  UIGridItem.h
//  Ztq_public
//
//  Created by linxg on 12-2-29.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIGridItem : UIView {
	NSString *_identifier;
}

@property (nonatomic, retain)NSString *_identifier;

- (id)initWithIdentifier:(NSString *)t_identifier;

@end

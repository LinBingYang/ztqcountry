//
//  PlaceMark.h
//  Miller
//
//  Created by kadir pekel on 2/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Place.h"

@interface PlaceMark : NSObject <MKAnnotation> {

	CLLocationCoordinate2D coordinate;
	Place* place;
	NSInteger mTag;
	NSInteger fl,ftime;
    NSString *time;
    NSString *name;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) Place* place;
@property(strong,nonatomic)NSString *name;
@property (nonatomic, assign) NSInteger mTag;
@property (nonatomic, assign) NSInteger fl,ftime;
@property(nonatomic,strong)NSString *time;

-(id) initWithPlace: (Place*) p;

@end

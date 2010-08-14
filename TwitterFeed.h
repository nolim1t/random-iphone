//
//  TwitterFeed.h
//
//  Created by nolim1t on 7/05/09.
//  Copyright 2009 PerceptionZ.Net. All rights reserved.
//



@interface TwitterFeed : NSObject {
	NSMutableString *tweet;
}

@property (nonatomic,retain) NSMutableString *tweet;

-(void) ParseXML;

@end

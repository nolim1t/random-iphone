//
//  TwitterFeed.m

//  Created by nolim1t on 7/05/09.
//  Copyright 2009 PerceptionZ.Net. All rights reserved.
//

#import "TwitterFeed.h"


@implementation TwitterFeed

@synthesize tweet;

-(void) ParseXML {
	NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://search.twitter.com/search.rss?q=from%3Anolim1t"]];
	[xmlParser setDelegate:self];
	[xmlParser setShouldProcessNamespaces:NO];
	[xmlParser setShouldReportNamespacePrefixes:NO];
	[xmlParser setShouldResolveExternalEntities:NO];
	[xmlParser parse];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
	NSLog(@"BEGIN Parsing");
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	NSLog(@"END Parsing");
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	// If certain elements are found initialize the object
	if ([elementName isEqualToString:@"title"]) {
		self.tweet = [NSMutableString string];
	}
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if ([elementName isEqualToString:@"title"]) {
		self.tweet = nil; // Reset it Bitches
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (self.tweet) {
        [tweet appendString:string];
		NSLog(@"Item: %@", string);
    }
}
@end

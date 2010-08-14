//
//  JiraIssues.h
//  SimpleRSSParser
//
//  Created by Barry Teoh on 5/8/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JiraIssues : NSObject {
	BOOL hasStartedParsingItem;
	NSInteger itemsProcessed;
	NSMutableString *jiraIssueTitle;
	NSMutableString *jiraIssueLink;
	NSMutableString *jiraVersion;
	NSMutableString *jiraFixVersion;
}

@property (nonatomic, retain) NSMutableString *jiraIssueTitle;
@property (nonatomic, retain) NSMutableString *jiraIssueLink;
@property (nonatomic, retain) NSMutableString *jiraVersion;
@property (nonatomic, retain) NSMutableString *jiraFixVersion;

-(void) ParseXML;

@end

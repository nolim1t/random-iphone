//
//  JiraIssues.m
//  SimpleRSSParser
//
//  Created by Barry Teoh on 5/8/09.
//

#import "JiraIssues.h"

#define JIRA_HOSTNAME @"jira"
#define JIRA_USERNAME @"YOURUSERNAMEHERE"
#define JIRA_PASSWORD @"YOURPASSWORDHERE"
#define	JIRA_RESOLVED_FILTER 5

@implementation JiraIssues

@synthesize jiraIssueTitle, jiraIssueLink, jiraVersion, jiraFixVersion;

-(void) ParseXML {
	NSString *url = [[NSString alloc] initWithFormat:@"http://%@//sr/jira.issueviews:searchrequest-xml/temp/SearchRequest.xml?&status=%d&sorter/field=issuekey&os_username=%@&os_password=%@", JIRA_HOSTNAME, JIRA_RESOLVED_FILTER, JIRA_USERNAME, JIRA_PASSWORD];
	NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
	[xmlParser setDelegate:self];
	[xmlParser setShouldProcessNamespaces:NO];
	[xmlParser setShouldReportNamespacePrefixes:NO];
	[xmlParser setShouldResolveExternalEntities:NO];
	[xmlParser parse];
	itemsProcessed = 0;
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
	NSLog(@"BEGIN Parsing");
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	NSLog(@"END Parsing (Total records: %d)", itemsProcessed);
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	if ([elementName isEqualToString:@"item"]) {
		NSLog(@"NEW RECORD to parse BEGIN");
		hasStartedParsingItem = YES;
	} else if (hasStartedParsingItem && [elementName isEqualToString:@"link"]) {
		[self setJiraIssueLink:[NSMutableString string]];
	} else if (hasStartedParsingItem && [elementName isEqualToString:@"title"]) {
		[self setJiraIssueTitle:[NSMutableString string]];
	} else if (hasStartedParsingItem && [elementName isEqualToString:@"version"]) {
		[self setJiraVersion:[NSMutableString string]];
	} else if (hasStartedParsingItem && [elementName isEqualToString:@"fixVersion"]) {
		[self setJiraFixVersion:[NSMutableString string]];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if ([elementName isEqualToString:@"item"]) {
		NSLog(@"NEW RECORD to parse END");
		itemsProcessed++;
		hasStartedParsingItem = NO;
	} else if (hasStartedParsingItem && [elementName isEqualToString:@"link"]) {
		NSLog(@"LINK: %@", jiraIssueLink);
		self.jiraIssueLink = nil;
	} else if (hasStartedParsingItem && [elementName isEqualToString:@"title"]) {
		NSLog(@"TITLE: %@", jiraIssueTitle);
		self.jiraIssueTitle = nil;
	} else if (hasStartedParsingItem && [elementName isEqualToString:@"version"]) {
		NSLog(@"Version raised: %@", jiraVersion);
		self.jiraVersion = nil;
	} else if (hasStartedParsingItem && [elementName isEqualToString:@"fixVersion"]) {
		NSLog(@"Version Fixed: %@", jiraFixVersion);
		self.jiraFixVersion = nil;
	}
}

// Grab element name within <ITEM></ITEM>
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if (hasStartedParsingItem) {
		if (self.jiraIssueLink ) {
			[jiraIssueLink appendString:string];
			//NSLog(@"JIRA LINK: %@", string);
		} else if (self.jiraIssueTitle) {
			[jiraIssueTitle appendString:string];
			//NSLog(@"JIRA Title: %@", string);
		} else if (self.jiraVersion) {
			[jiraVersion appendString:string];
		} else if (self.jiraFixVersion) {
			[jiraFixVersion appendString:string];
		}
	}

}

@end

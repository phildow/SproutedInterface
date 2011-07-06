//
//  PDPrintTextView.m
//  SproutedInterface
//
//  Created by Philip Dow on xx.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <SproutedInterface/PDPrintTextView.h>

@implementation PDPrintTextView

- (id)initWithFrame:(NSRect)frameRect textContainer:(NSTextContainer *)aTextContainer {
	if ( self = [super initWithFrame:frameRect textContainer:aTextContainer] ) {
		printTitle = [[NSString alloc] init];
		printDate = [[NSString alloc] init];
		
	}
	return self;
}

- (void) dealloc {
	[printTitle release];
		printTitle = nil;
	[printDate release];
		printDate = nil;
	[super dealloc];
}

#pragma mark -

- (BOOL) printHeader { return printHeader; }

- (void) setPrintHeader:(BOOL)print {
	printHeader = print;
}

- (BOOL) printFooter { return printFooter; }

- (void) setPrintFooter:(BOOL)print {
	printFooter = print;
}

- (NSString*) printTitle { return ( printTitle ? printTitle : [NSString string] ); }

- (void) setPrintTitle:(NSString*)title {
	if ( printTitle != title ) {
		[printTitle release];
		printTitle = [title copyWithZone:[self zone]];
	}
}

- (NSString*) printDate { return ( printDate ? printDate : [NSString string] ); }

- (void) setPrintDate:(NSString*)date {
	if ( printDate != date ) {
		[printDate release];
		printDate = [date copyWithZone:[self zone]];
	}
}

#pragma mark -

- (NSString *)printJobTitle {
	
	return [self printTitle];
	
}

- (NSAttributedString *)pageHeader {
	
	//
	// For now returns a string including the journal title and the date
	// Will very likely allow for customization later
	//
	
	NSAttributedString *theHeader = nil;
	
	if ( [self printHeader] ) {
		
		// format the title and date appropriately
		/*
		NSMutableDictionary		*attributes;
		NSMutableParagraphStyle *paragraph;
		NSAttributedString		*supersReturn;
		NSAttributedString		*attributedHeader;
		NSString				*plainText;
		
		supersReturn = [super pageHeader];
		paragraph = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
		attributes = [[supersReturn attributesAtIndex:0 effectiveRange:nil] mutableCopy];
		plainText = [NSString stringWithFormat:@"%@\n%@", [self printJobTitle], [self printDate]];
		
		[paragraph setAlignment:NSRightTextAlignment];
		[attributes setObject:paragraph forKey:NSParagraphStyleAttributeName];
		
		attributedHeader = [[NSAttributedString alloc] initWithString:plainText attributes:attributes];
		
		// clean up those mutable copies
		[attributes release];
		[paragraph release];
		
		return [attributedHeader autorelease];
		*/
		
		theHeader = [super pageHeader];
		
	}
	else {
		
		theHeader = [[[NSAttributedString alloc] initWithString:[NSString string]] autorelease];
		
	}
	
	return theHeader;
}

- (NSAttributedString *)pageFooter {
	
	//
	// Use super's implementation
	// - I'm not sure how to figure out which page is being queried
	//
	
	NSAttributedString *theFooter = nil;
	
	if ( [self printFooter] )
		theFooter = [super pageFooter];
	else
		theFooter = [[[NSAttributedString alloc] initWithString:[NSString string]] autorelease];

	return theFooter;
}

@end

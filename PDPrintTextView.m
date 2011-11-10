//
//  PDPrintTextView.m
//  SproutedInterface
//
//  Created by Philip Dow on xx.
//  Copyright Philip Dow / Sprouted. All rights reserved.
//

/*
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

Neither the name of the organization nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*/

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

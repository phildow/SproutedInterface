//
//  PDPrintTextView.h
//  SproutedInterface
//
//  Created by Philip Dow on xx.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

//
// This class overrides two methods to provide custom header
// and footers during printing:
// - (NSAttributedString *)pageHeader;
// - (NSAttributedString *)pageFooter;
//
//

#import <Cocoa/Cocoa.h>

@interface PDPrintTextView : NSTextView
{
	BOOL printHeader;
	BOOL printFooter;
	
	NSString *printTitle;
	NSString *printDate;
}

- (BOOL) printHeader;
- (void) setPrintHeader:(BOOL)print;

- (BOOL) printFooter;
- (void) setPrintFooter:(BOOL)print;

- (NSString*) printTitle;
- (void) setPrintTitle:(NSString*)title;

- (NSString*) printDate;
- (void) setPrintDate:(NSString*)date;

@end

//
//  StatsController.h
//  SproutedInterface
//
//  Created by Philip Dow on xx.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <Cocoa/Cocoa.h>

@interface StatsController : NSWindowController
{
    IBOutlet NSTextField *charsField;
    IBOutlet NSTextField *parsField;
    IBOutlet NSTextField *wordsField;
}

- (int) runAsSheetForWindow:(NSWindow*)window 
		attached:(BOOL)sheet
		chars:(int)charNum 
		words:(int)wordNum 
		pars:(int)parNum;

- (IBAction)genericStop:(id)sender;

@end

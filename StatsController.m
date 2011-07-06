
//
//  StatsController.m
//  SproutedInterface
//
//  Created by Philip Dow on xx.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//


#import <SproutedInterface/StatsController.h>

@implementation StatsController

- (id)init {
	if ( self = [self initWithWindowNibName:@"Stats"] ) {
		[self window];
    }
    return self;
}

- (void) dealloc {
	[super dealloc];
}

- (void)windowWillClose:(NSNotification *)aNotification {
	
}

- (int) runAsSheetForWindow:(NSWindow*)window 
		attached:(BOOL)sheet
		chars:(int)charNum 
		words:(int)wordNum 
		pars:(int)parNum {
	
	int result;
	
	[charsField setIntValue:charNum];
	[wordsField setIntValue:wordNum];
	[parsField setIntValue:parNum];
	
	if ( sheet ) {
		
		[[self window] setAlphaValue:0.99];
		[[self window] setBackgroundColor:[NSColor whiteColor]];
		
		[NSApp beginSheet: [self window] modalForWindow: window modalDelegate: nil
				didEndSelector: nil contextInfo: nil];
	
	}
	
    result = [NSApp runModalForWindow: [self window]];
	
	if ( sheet )
		[NSApp endSheet: [self window]];
	
    [self close];
	
	return result;
	
}

- (IBAction)genericStop:(id)sender
{
	[NSApp stopModal];
}

@end

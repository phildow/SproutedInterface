//
//  PDAutoCompleteTextField.m
//  SproutedInterface
//
//  Created by Philip Dow on 7/10/05.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <SproutedInterface/PDAutoCompleteTextField.h>

@implementation PDAutoCompleteTextField

- (void) awakeFromNib 
{
	autoCompleteOptions = [[NSArray alloc] init];
}

- (NSArray*) autoCompleteOptions 
{ 
	return autoCompleteOptions; 
}

- (void) setAutoCompleteOptions:(NSArray*)options 
{
	if ( autoCompleteOptions != options ) 
	{
		[autoCompleteOptions release];
		autoCompleteOptions = [options copyWithZone:[self zone]];
	}
}

#pragma mark -

- (void)textDidChange:(NSNotification *)aNotification 
{
	[[[aNotification userInfo] objectForKey:@"NSFieldEditor"] complete:self];
	[super textDidChange:aNotification];
}

- (NSArray *)textView:(NSTextView *)textView completions:(NSArray *)words 
		forPartialWordRange:(NSRange)charRange indexOfSelectedItem:(int *)index 
{
			
	//
	// Textview delegate method that responds to the field editor
	// When this text view is being edited
	//
	
	// dunno if this is the correct way to do this at all
	
	NSMutableArray *hits = [[NSMutableArray alloc] init];
	
	// grab the view's string
	NSString *text = [textView string];
	
	int i;
	for ( i = 0; i < [autoCompleteOptions count]; i++ ) 
	{
		if ( [[autoCompleteOptions objectAtIndex:i] rangeOfString:text options:NSLiteralSearch].location != NSNotFound )
			[hits addObject:[autoCompleteOptions objectAtIndex:i]];
	}
	
	return [hits autorelease];
}

@end

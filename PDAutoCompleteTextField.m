//
//  PDAutoCompleteTextField.m
//  SproutedInterface
//
//  Created by Philip Dow on 7/10/05.
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

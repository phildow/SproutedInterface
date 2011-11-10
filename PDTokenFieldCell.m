//
//  PDTokenFieldCell.m
//  SproutedInterface
//
//  Created by Philip Dow on 7/16/07.
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

//	Note that PDTokenFieldCell does not require PDTokenField
//

#import <SproutedInterface/PDTokenFieldCell.h>


@implementation PDTokenFieldCell

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	//NSLog(@"%@ %s view is a %@",[self className],_cmd,[controlView className]);
	
	[self setControlSize:NSSmallControlSize];
	[super drawWithFrame:cellFrame inView:controlView];
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	//NSLog(@"%@ %s view is a %@",[self className],_cmd,[controlView className]);
	
	// a small adjustment if we're running 10.4 but not 10.5
	if ( ![self respondsToSelector:@selector(scriptingValueForSpecifier:)] )
		cellFrame.origin.y -= 1;
	
	[self setControlSize:NSSmallControlSize];
	[super drawInteriorWithFrame:cellFrame inView:controlView];
}

#pragma mark -
#pragma mark Fixes for Bindings Problem with Dragging & Copy/Paste

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    if ([super performDragOperation:sender])
    {
        //NSLog(@"perform custom drag operation");
		
        if ( [self delegate] != nil && [[self delegate] respondsToSelector:@selector(tokenFieldCell:didReadTokens:fromPasteboard:)] )
			[[self delegate] tokenFieldCell:self didReadTokens:[self objectValue] fromPasteboard:[sender draggingPasteboard]];
			
        return YES;
    }
	else
	{
		return NO;
	}
}

- (id) _tokensFromPasteboard:(id)fp8
{
	id tokens = [super _tokensFromPasteboard:fp8];
	
	if ( [self delegate] != nil && [[self delegate] respondsToSelector:@selector(tokenFieldCell:didReadTokens:fromPasteboard:)] )
		[[self delegate] tokenFieldCell:self didReadTokens:tokens fromPasteboard:fp8];
		
	return tokens;
}

@end

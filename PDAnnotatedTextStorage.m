//
//  PDAnnotatedTextStorage.m
//  SproutedInterface
//
//  Created by Philip Dow on 5/24/07.
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

#import <SproutedInterface/PDAnnotatedTextStorage.h>

#define MarkerAttributeName NSToolTipAttributeName

@implementation PDAnnotatedTextStorage

-(BOOL)hasBookmarkAtIndex:(unsigned)index inTextView:(NSTextView*)textView
{
	//NSRange paragraphRange = 
	//[textView selectionRangeForProposedRange:NSMakeRange(index, 1) granularity:NSSelectByParagraph];
	
	//NSLog(@"%@ %s - %i, %i", [self className], _cmd, NSMaxRange(paragraphRange) -1);
	
	//id attribute = [self attribute:MarkerAttributeName atIndex:NSMaxRange(paragraphRange) -1 effectiveRange:NULL];
	id attribute = [self attribute:MarkerAttributeName atIndex:index effectiveRange:NULL];
	if( attribute != NULL )
		return YES;
	else
		return NO;
}

-(BOOL)hasBookmarkAtIndex:(unsigned)index inTextView:(NSTextView*)textView effectiveRange:(NSRangePointer)aRange
{
	//NSRange paragraphRange = 
	//[textView selectionRangeForProposedRange:NSMakeRange(index, 1) granularity:NSSelectByParagraph];
	
	//NSLog(@"%@ %s - %i, %i", [self className], _cmd, NSMaxRange(paragraphRange) -1);
	
	id attribute = [self attribute:MarkerAttributeName atIndex:index effectiveRange:aRange];
	if( attribute != NULL )
		return YES;
	else
		return NO;
}

-(void)setBookmarkAtIndex:(unsigned)index flag:(BOOL)flag  inTextView:(NSTextView*)textView
{
	NSRange paragraphRange = 
	[textView selectionRangeForProposedRange:NSMakeRange(index, 1) granularity:NSSelectByParagraph];
	
	[self addAttribute:MarkerAttributeName value:@"My Comment" range:NSMakeRange(NSMaxRange(paragraphRange)-1,1)];
}

@end

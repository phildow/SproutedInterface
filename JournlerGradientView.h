//
//  JournlerGradientView.h
//  SproutedInterface
//
//  Created by Philip Dow on 10/20/06.
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

#import <Cocoa/Cocoa.h>
#import <QuartzCore/CoreImage.h> // needed for Core Image

@interface JournlerGradientView : NSView {
	
	NSColor *gradientStartColor;
    NSColor *gradientEndColor;
    NSColor *backgroundColor;
	
	int	borders[4];
	BOOL bordered;
	
	BOOL usesBezierPath;
	BOOL drawsGradient;
	
	NSColor		*fillColor;
	NSColor		*borderColor;
	
	NSControlTint controlTint;
}

+ (void) drawGradientInView:(NSView*)aView rect:(NSRect)aRect highlight:(BOOL)highlight shadow:(float)shadowLevel;

- (int*) borders;
- (void) setBorders:(int*)sides;

- (BOOL) bordered;
- (void) setBordered:(BOOL)flag;

- (BOOL) drawsGradient;
- (void) setDrawsGradient:(BOOL)draws;

- (BOOL) usesBezierPath;
- (void) setUsesBezierPath:(BOOL)bezier;

- (NSColor*) fillColor;
- (void) setFillColor:(NSColor*)aColor;

- (NSColor*) borderColor;
- (void) setBorderColor:(NSColor*)aColor;

- (NSControlTint) controlTint;
- (void) setControlTint:(NSControlTint)aTint;

- (NSColor *)gradientStartColor;
- (void)setGradientStartColor:(NSColor *)newGradientStartColor;
- (NSColor *)gradientEndColor;
- (void)setGradientEndColor:(NSColor *)newGradientEndColor;
- (NSColor *)backgroundColor;
- (void)setBackgroundColor:(NSColor *)newBackgroundColor;

- (void) resetGradient;

@end

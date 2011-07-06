//
//  PDURLTextField.h
//  SproutedInterface
//
//  Created by Philip Dow on 5/28/06.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//

#import <Cocoa/Cocoa.h>


@interface PDURLTextField : NSTextField {
	
	NSString *_url_title;
}

+ (NSImage*) defaultImage;

- (NSString*)URLTitle;
- (void) setURLTitle:(NSString*)aTitle;

- (NSImage*) image;
- (void) setImage:(NSImage*)anImage;

- (double) estimatedProgress;
- (void) setEstimatedProgress:(double)estimate;

@end

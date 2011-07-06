//
//  MUPhotoCell.h
//  SproutedInterface
//
//  Created by Philip Dow on 1/19/07.
//  Copyright Sprouted. All rights reserved.
//	Inquiries should be directed to developer@journler.com
//
//	Or was this originally part of the MUPhotoView package?
//	I subclassed to PDPhotoView and don't recall if I added this as well

#import <Cocoa/Cocoa.h>


@interface MUPhotoCell : NSImageCell <NSCopying> {
	
	NSString *imageTitle;
}

- (NSString*) title;
- (void) setTitle:(NSString*)aString;

@end

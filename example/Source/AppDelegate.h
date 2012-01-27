/*
 * AppDelegate.h
 * GPhoto2.framework Information
 * 
 * Copyright (C) 2010-2012 Andreas Steinel
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 */

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
    IBOutlet id lb_gphoto;
    IBOutlet id lb_gphotoport;
}

@property (assign) IBOutlet NSWindow *window;

// General Actions
- (IBAction)closeApplication:(id)sender;
- (IBAction)visitHomepage:(id)sender;

// Help Menu Homepage Actions
- (IBAction)visitGPhotoHomepage:(id)sender;
- (IBAction)visitJPEGHomepage:(id)sender;
- (IBAction)visitLibtoolHomepage:(id)sender;
- (IBAction)visitLibusbHomepage:(id)sender;

// Help Menu License Actions
- (IBAction)visitLicenseLesser:(id)sender;
- (IBAction)visitLicenseLesser21:(id)sender;
- (IBAction)visitJPEGLicense:(id)sender;


@end

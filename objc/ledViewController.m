//
//  ledViewController.m
//
//  Created by Barry Teoh on 8/8/10.

//  Copyright PerceptionZ.Net / Barryteoh.com 2010. All rights reserved.
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "ledViewController.h"

@implementation ledViewController
@synthesize captureSession, onoffbutton;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[onoffbutton setEnabled:YES];
	NSLog(@"viewDidLoad");
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
    [self toggleTorch];
	NSLog(@"viewWillDisappear");
}

#pragma mark - 
#pragma mark UI to manipulate flashlight
-(IBAction )powerButton:(id)sender {
	if (onoffbutton.on) {
		onoffbutton.on = NO;
	} else {
		onoffbutton.on = YES;
	}

	[onoffbutton setOn:YES];
	[self toggleTorch];
}

#pragma mark -
#pragma mark Flashlight
- (void) toggleTorch {
	AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
	if ([device hasTorch] && [device hasFlash]) {
		NSLog(@"Device has flash and torch");
		if (device.torchMode == AVCaptureTorchModeOff) {
			AVCaptureDeviceInput *flashInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
			AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
			captureSession = [[AVCaptureSession alloc] init];
			[captureSession beginConfiguration];
			[device lockForConfiguration:nil];
			[device setTorchMode:AVCaptureTorchModeOn];
			[device setFlashMode:AVCaptureFlashModeOn];
			[captureSession addInput:flashInput];
			[captureSession addOutput:output];
			[output release];
			[device unlockForConfiguration];
			[captureSession commitConfiguration];
			[captureSession startRunning];
			[self setCaptureSession:captureSession];
		} else {
			[captureSession stopRunning];
		}

	} else {
		[onoffbutton setEnabled:NO];
		NSLog(@"Device has no torch/flash :(");
	}

	
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[onoffbutton release];
	[captureSession release];
    [super dealloc];
}

@end

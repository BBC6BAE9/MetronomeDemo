//
//  ViewController.m
//  Metronome
//
//  Created by huang on 2022/6/19.
//

#import "ViewController.h"
#import "Metronome.h"
#import "Metronome-Swift.h"

@interface ViewController ()
@property(nonatomic, strong)Metronome *metronome;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *highUrl = [[NSBundle mainBundle] URLForResource:@"High" withExtension:@"wav"];
    NSURL *lowUrl = [[NSBundle mainBundle] URLForResource:@"Low" withExtension:@"wav"];

    
//    MetronomeSwift *metronome = [[MetronomeSwift alloc] initWithMainClickFile:lowUrl accentedClickFile:highUrl];
//    [metronome playWithBpm:100];
    Metronome *metronome = [[Metronome alloc] initWith:lowUrl accentedClickFile:highUrl];
    self.metronome = metronome;
    [metronome play:2000];
    
    // Do any additional setup after loading the view.
}


@end

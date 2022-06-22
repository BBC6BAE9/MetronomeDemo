//
//  Metronome.m
//  Metronome
//
//  Created by huang on 2022/6/19.
//

#import "Metronome.h"
#import <AVFoundation/AVFoundation.h>

@interface Metronome()

@property(nonatomic, strong)AVAudioPlayerNode *audioPlayerNode;
@property(nonatomic, strong)AVAudioEngine *audioEngine;
@property(nonatomic, strong)AVAudioFile *audioFileMainClick;
@property(nonatomic, strong)AVAudioFile *audioFileAccentedClick;
@property(nonatomic, assign)BOOL isPlaying;


@end
@implementation Metronome

- (instancetype)initWith:(NSURL *)mainClickFile accentedClickFile:(NSURL *)accentedClickFile{
    if (self == [super init]) {
        self.audioFileMainClick = [[AVAudioFile alloc] initForReading:mainClickFile error:nil];
        self.audioFileAccentedClick = [[AVAudioFile alloc] initForReading:accentedClickFile error:nil];
        self.audioPlayerNode = [[AVAudioPlayerNode alloc] init];
        self.audioEngine = [[AVAudioEngine alloc] init];
        [self.audioEngine attachNode:self.audioPlayerNode];
        [self.audioEngine connect:self.audioPlayerNode to:self.audioEngine.mainMixerNode format:self.audioFileMainClick.processingFormat];
        [self.audioEngine startAndReturnError:nil];
    }
    return self;
}

- (AVAudioPCMBuffer *)generateBuffer:(double)bpm{
    
    self.audioFileMainClick.framePosition = 0;
    self.audioFileAccentedClick.framePosition = 0;
    
    AVAudioFrameCount beatLength = self.audioFileMainClick.processingFormat.sampleRate * 60 / bpm;
    
    AVAudioPCMBuffer *bufferMainClick = [[AVAudioPCMBuffer alloc] initWithPCMFormat:self.audioFileMainClick.processingFormat frameCapacity:beatLength];
    [self.audioFileMainClick readIntoBuffer:bufferMainClick error:nil];
    bufferMainClick.frameLength = beatLength;

    AVAudioPCMBuffer *bufferAccentedClick = [[AVAudioPCMBuffer alloc] initWithPCMFormat:self.audioFileMainClick.processingFormat frameCapacity:beatLength];
    [self.audioFileAccentedClick readIntoBuffer:bufferAccentedClick error:nil];
    bufferAccentedClick.frameLength = beatLength;

    AVAudioPCMBuffer *bufferBar = [[AVAudioPCMBuffer alloc] initWithPCMFormat:self.audioFileMainClick.processingFormat frameCapacity:4 * beatLength];
    bufferBar.frameLength = 4 * beatLength;
    
    int channelCount = (int)self.audioFileMainClick.processingFormat.channelCount;
    
    NSMutableArray *accentedClickArray = [[NSMutableArray alloc]init];
    NSMutableArray *mainClickArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < channelCount * (int)beatLength; i++) {
        double temp = *(bufferAccentedClick.floatChannelData[0]+i);
        double tempMain = *(bufferMainClick.floatChannelData[0]+i);
        [accentedClickArray addObject:@(temp)];
        [mainClickArray addObject:@(tempMain)];
    }
    
    NSMutableArray *barArray = [[NSMutableArray alloc]init];
    
    [barArray addObjectsFromArray:accentedClickArray];
    
    for (int i = 0; i < 3; i++) {
        [barArray addObjectsFromArray:mainClickArray];
    }
    for (NSInteger i = 0; i < channelCount * bufferBar.frameLength; i++) {
        double temp = 0;
        if (i < barArray.count) {
            temp = [barArray[i] doubleValue];
        }
        *(bufferBar.floatChannelData[0]+i) = temp;
    }

    return bufferBar;
}

- (void)play:(double)bpm{
    AVAudioPCMBuffer *buffer = [self generateBuffer:bpm];
    if (self.audioPlayerNode.isPlaying) {
        [self.audioPlayerNode scheduleBuffer:buffer atTime:nil options:AVAudioPlayerNodeBufferLoops completionHandler:nil];
    }else{
        [self.audioPlayerNode play];
    }
    
    [self.audioPlayerNode scheduleBuffer:buffer atTime:nil options:AVAudioPlayerNodeBufferLoops completionHandler:nil];
    
}

- (void)stop{
    [self.audioPlayerNode stop];
}

/// 判断当前是否正在播放
- (BOOL)isPlaying{
    return self.audioPlayerNode.isPlaying;
}
@end

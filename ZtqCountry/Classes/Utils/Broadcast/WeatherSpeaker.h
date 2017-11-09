//
//  WeatherSpeaker.h
//  HttpTest
//
//  Created by on 11-12-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol WeatherSpeakerDelegate <NSObject>

- (void) didPlayFinish;
@end



@interface WeatherSpeaker : NSObject <AVAudioPlayerDelegate> {
	
//	 id <WeatherSpeakerDelegate> delegate;
    __weak id<WeatherSpeakerDelegate> delegate;
	AVAudioPlayer *m_player;
	AVAudioPlayer *m_playerBg;
	NSMutableArray *textLib;//语音库
	NSMutableArray *textArray;//文本按语音库切成分词数组
	int idx;//当前播放的分词索引
	bool speaking;
}

@property (nonatomic, weak)id delegate;
@property (readonly)bool speaking;

+ (id) shareWeatherSpeaker;
- (void) speakWeather:(NSString *)text;
- (void) speakTextWithIndex:(NSInteger) t_idx;
- (void) stopSpeaking;
@end


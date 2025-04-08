import React, {useEffect} from 'react';
import {Button, Platform, SafeAreaView, View} from 'react-native';
import {Text} from 'react-native';
import {Jukerstone} from 'jukerstone-react-native-macos';

// TypeScript declaration for the global bridge
declare global {
  var JukerstoneBridge: {
    load: (params: any) => void;
    pause: () => void;
    resume?: () => void;
    seek?: (seconds: number) => void;
  };
}

const JukerstoneControls = ({player}: {player: any}) => {
  return (
    <View style={{padding: 16}}>
      <Button
        title="Load Penny Lane by the Beatles"
        onPress={() => player?.load({isrc: 'GBAYE0601641'})}
      />
      <Button title="▶️ Play" onPress={player?.pause} />
      <Button title="⏸ Pause" onPress={player?.pause} />
    </View>
  );
};

const App = () => {
  const player = Jukerstone.useJukerstone();

  useEffect(() => {
    global.JukerstoneBridge = {
      load: params => {
        console.log('🎧 JS Load called with', params);
        player?.load(params);
      },
      pause: () => {
        console.log('⏸ JS Pause called');
        player?.pause();
      },
      resume: () => {
        console.log('▶️ JS Resume called');
        // player?.resume?.();
      },
      seek: seconds => {
        console.log('⏩ JS Seek called to', seconds);
        player?.seek?.(seconds);
      },
    };
  }, [player]);

  // mute logs
  console.log = () => {};
  console.error = () => {};
  console.warn = () => {};

  return (
    <SafeAreaView style={{flex: 1}}>
      <Jukerstone.Provider
        developerToken="sk_ud7C9uUlpeyjedomEsmRDIPB4757922WDyVE"
        jukerstoneId="TvauQsMtXJSeZyLhRHj3RV8FjjH2">
        <JukerstoneControls player={player} />
      </Jukerstone.Provider>
    </SafeAreaView>
  );
};

export default App;

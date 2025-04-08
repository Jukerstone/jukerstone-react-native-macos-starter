import React, {useEffect} from 'react';
import {Button, Platform, SafeAreaView, View} from 'react-native';

import {Text} from 'react-native';

import {Jukerstone} from 'jukerstone-react-native-macos';

const JukerstoneControls = () => {
  const {load, pause} = Jukerstone.useJukerstone();

  return (
    <View style={{padding: 16}}>
      <Button
        title="Load Penny Lane by the beatles"
        onPress={() => load({isrc: 'GBAYE0601641'})}
      />
      <Button title="▶️ Play" onPress={pause} /> 
      <Button title="⏸ Pause" onPress={pause} />
    </View>
  );
};

const App = () => {
  console.log = function () {};
  console.error = function () {};
  console.warn = function () {};
  return (
    <SafeAreaView style={{flex: 1}}>
      <Jukerstone.Provider
        developerToken="sk_ud7C9uUlpeyjedomEsmRDIPB4757922WDyVE"
        jukerstoneId="TvauQsMtXJSeZyLhRHj3RV8FjjH2">
        <JukerstoneControls />
      </Jukerstone.Provider>
    </SafeAreaView>
  );
};

export default App;

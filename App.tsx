/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * Generated with the TypeScript template
 * https://github.com/react-native-community/react-native-template-typescript
 *
 * @format
 */

import React from 'react';
import {SafeAreaView, StyleSheet, View, Text, StatusBar} from 'react-native';

import {
  Colors,
  DebugInstructions,
  ReloadInstructions,
} from 'react-native/Libraries/NewAppScreen';
import MapView from './src/components/MapView';

declare const global: {HermesInternal: null | {}};

const App = () => {
  const defaultPosition = {
    latitude: 37.491187,
    longitude: 126.924878,
    title: '제이윈연구소',
  };
  const markers = [
    {
      latitude: 37.492762,
      longitude: 126.919852,
      pinColor: 'image',
      markerImage: 'park',
      title: '보라매공원',
    },
    {
      latitude: 37.490504,
      longitude: 126.925007,
      pinColor: 'yellow',
      title: '롯데백화점',
    },
  ];

  console.log('APP render');

  return (
    <>
      <StatusBar barStyle="dark-content" />
      <SafeAreaView style={{flex: 1}}>
        <View style={{flex: 1, backgroundColor: 'white'}}>
          <MapView defaultLocation={defaultPosition} markers={markers} />
        </View>
        <View style={styles.sectionContainer}>
          <Text style={styles.sectionTitle}>This is other React Elements</Text>
          <Text style={styles.sectionDescription}>
            <ReloadInstructions />
          </Text>
        </View>
        <View style={styles.sectionContainer}>
          <Text style={styles.sectionTitle}>Flex size testing</Text>
          <Text style={styles.sectionTitle}>Flex size testing</Text>
          <Text style={styles.sectionTitle}>Flex size testing</Text>
        </View>
      </SafeAreaView>
    </>
  );
};

const styles = StyleSheet.create({
  scrollView: {
    backgroundColor: Colors.lighter,
    flex: 1,
  },
  body: {
    backgroundColor: Colors.white,
  },
  mapContainer: {
    marginTop: 32,
    paddingHorizontal: 24,
  },
  sectionContainer: {
    backgroundColor: 'gray',
    marginTop: 32,
    paddingHorizontal: 24,
  },
  sectionTitle: {
    fontSize: 24,
    fontWeight: '600',
    color: Colors.black,
  },
  sectionDescription: {
    flex: 1,
    marginTop: 8,
    fontSize: 18,
    fontWeight: '400',
    color: Colors.dark,
  },
  highlight: {
    fontWeight: '700',
  },
  footer: {
    color: Colors.dark,
    fontSize: 12,
    fontWeight: '600',
    padding: 4,
    paddingRight: 12,
    textAlign: 'right',
  },
});

export default App;

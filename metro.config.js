const {getDefaultConfig, mergeConfig} = require('@react-native/metro-config');
const fs = require('fs');
const path = require('path');
const exclusionList = require('metro-config/src/defaults/exclusionList');

// Detect platform
const isWindows = process.platform === 'win32';

const baseConfig = {
  transformer: {
    getTransformOptions: async () => ({
      transform: {
        experimentalImportSupport: false,
        inlineRequires: true,
      },
    }),
  },
};

// Additional settings for Windows
if (isWindows) {
  const rnwPath = fs.realpathSync(
    path.resolve(require.resolve('react-native-windows/package.json'), '..'),
  );

  baseConfig.resolver = {
    blockList: exclusionList([
      new RegExp(
        `${path.resolve(__dirname, 'windows').replace(/[/\\]/g, '/')}.*`,
      ),
      new RegExp(`${rnwPath}/build/.*`),
      new RegExp(`${rnwPath}/target/.*`),
      /.*\.ProjectImports\.zip/,
    ]),
  };
}

module.exports = mergeConfig(getDefaultConfig(__dirname), baseConfig);

var glob = require('glob');
var ignoreFolders = {
  ignore: ['node_modules/**', '**/build/**', '**/Build/**', '**/DerivedData/**', '**/*-tvOS*/**'],
};

exports.mainActivityJava = glob.sync('**/MainActivity.java', ignoreFolders)[0];
exports.mainActivityKotlin = glob.sync('**/MainActivity.kt', ignoreFolders)[0];
var mainApplicationJava = glob.sync('**/MainApplication.kt', ignoreFolders)[0];
exports.mainApplicationJava = mainApplicationJava;
exports.rootGradle = mainApplicationJava.replace(/android\/app\/.*\.kt/, 'android/build.gradle');

var reactNativeVersion = require('../../node_modules/react-native/package.json').version;
exports.appDelegate = glob.sync(
  reactNativeVersion < '0.68.0' ? '**/AppDelegate.m' : '**/AppDelegate.mm',
  ignoreFolders
)[0];
exports.appDelegateHeader = glob.sync('**/AppDelegate.h', ignoreFolders)[0];
exports.podFile = glob.sync('**/Podfile', ignoreFolders)[0];
exports.plist = glob.sync('**/info.plist', ignoreFolders)[0];

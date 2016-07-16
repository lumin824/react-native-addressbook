import {
  NativeModules,
  requireNativeComponent
} from 'react-native';

let { AddressBookModule } = NativeModules;

export var test = AddressBookModule.test;

export var AddressBook = requireNativeComponent('AddressBook');

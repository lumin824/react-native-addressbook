import {
  NativeModules,
  requireNativeComponent
} from 'react-native';

let { AddressBookModule } = NativeModules;

export var list = AddressBookModule.list;

export var AddressBook = requireNativeComponent('AddressBook');

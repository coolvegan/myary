import 'dart:convert';
import 'package:encrypt/encrypt.dart';

String encrypt(String plaintext, String key) {
  final _key = Key.fromUtf8(key);
  final encrypter = Encrypter(AES(_key, mode: AESMode.cfb64));
  final encryptedBytes = encrypter.encrypt(plaintext, iv: IV.fromLength(16));
  return encryptedBytes.base64;
}

String decrypt(String ciphertext, String key) {
  final _key = Key.fromUtf8(key);
  final encrypter = Encrypter(AES(_key, mode: AESMode.cfb64));
  final decryptedBytes = encrypter.decrypt64(ciphertext, iv: IV.fromLength(16));
  return decryptedBytes;
}

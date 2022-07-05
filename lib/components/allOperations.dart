import 'dart:io';

import 'package:firebase_core/firebase_core.dart';

import 'services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> uploadJadwalDokter(
    String codeDokter,
    String _nama,
    String _spesialis,
    String _hariKerja,
    String _jam,
    String _kontak,
    String deskripsi) async {
  List<String> caseSearchList = [];
  String temp = "";
  for (int i = 0; i < _nama.length; i++) {
    temp = temp + _nama[i];
    caseSearchList.add(temp);
  }
  await FirebaseFirestore.instance.collection("doctors").add({
    'noDokter': codeDokter,
    'nama': _nama,
    'spesialis': _spesialis,
    'hariKerja': _hariKerja,
    'jamKerja': _jam,
    'noHp': _kontak,
    'deskripsi': deskripsi,
    'caseSearch': caseSearchList,
  });
}

Future<void> editDokter(
    String codeDokter,
    String _id,
    String _nama,
    String _spesialis,
    String _hariKerja,
    String _jam,
    String _kontak,
    String deskripsi) async {
  List<String> caseSearchList = [];
  String temp = "";
  for (int i = 0; i < _nama.length; i++) {
    temp = temp + _nama[i];
    caseSearchList.add(temp);
  }
  await FirebaseFirestore.instance.collection("doctors").doc(_id).set({
    'noDokter': codeDokter,
    'nama': _nama,
    'spesialis': _spesialis,
    'hariKerja': _hariKerja,
    'jamKerja': _jam,
    'noHp': _kontak,
    'deskripsi': deskripsi,
    'caseSearch': caseSearchList,
  });
}

Future<void> deleteJadwalDokter(String id) async {
  await FirebaseFirestore.instance.collection("doctors").doc(id).delete();
}

Future<void> deletePasien(String id) async {
  await FirebaseFirestore.instance.collection("users").doc(id).delete();
}

Future<void> deleteAppointment(String id) async {
  await FirebaseFirestore.instance.collection("appointments").doc(id).delete();
}

Future<void> accAppointment(
  String id,
  bool status,
  String namaLengkap,
  String namaDokter,
  String jamOperasional,
  String spesialis,
  String statusDesc,
  String tglJanji,
  String email,
  String noHp,
) async {
  await FirebaseFirestore.instance.collection("appointments").doc(id).set({
    "namaLengkap": namaLengkap,
    "namaDokter": namaDokter,
    "jamOperasional": jamOperasional,
    "spesialis": spesialis,
    "statusDesc": statusDesc,
    "tglJanji": tglJanji,
    "email": email,
    "noHp": noHp,
    "status": status,
  });
}



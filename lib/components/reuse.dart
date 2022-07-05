import 'package:flutter/material.dart';
import 'package:frontdesk_kliniku/color.dart';

class Dokter {
  final String nama;
  final String spesialis;
  final String tanggal;
  final String jam;
  final String kontak;

  Dokter(this.nama, this.spesialis, this.tanggal, this.jam, this.kontak);
}

class Pasien {
  final String nama;
  final String tanggal;
  final String jam;
  final String status;
  final bool isComplate;

  Pasien(this.nama, this.tanggal, this.jam, this.status, this.isComplate);
}

class PasienKarepmu {
  final String? firstName;
  final String? lastName;
  final String? address;
  final String? email;
  final String? phoneNum;
  final String? tokenUser;
  PasienKarepmu(
    this.firstName,
    this.lastName,
    this.address,
    this.email,
    this.phoneNum,
    this.tokenUser,
  );

  factory PasienKarepmu.fromMap(Map<String, dynamic> rawData) => PasienKarepmu(
        rawData["firstName"],
        rawData["lastName"],
        rawData["address"],
        rawData["email"],
        rawData["phoneNum"],
        rawData["tokenUser"],
      );
}

TextFormField formTextField(
  String label,
  TextEditingController controller,
) {
  return TextFormField(
    autofocus: false,
    controller: controller,
    // validator: (){},
    onSaved: (value) {
      controller.text = value!;
    },
    textInputAction: TextInputAction.next,
    decoration: InputDecoration(
      labelText: label,
      contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}

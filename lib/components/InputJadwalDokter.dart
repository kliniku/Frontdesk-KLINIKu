import 'package:flutter/material.dart';
import 'package:frontdesk_kliniku/color.dart';
import 'package:frontdesk_kliniku/components/allOperations.dart';
import 'package:frontdesk_kliniku/components/home.dart';
import 'package:frontdesk_kliniku/components/reuse.dart';
import 'services.dart';

class InputJadwalDokter extends StatefulWidget {
  const InputJadwalDokter({
    Key? key,
    this.id,
    this.codeDokter,
    this.name,
    this.spesialis,
    this.hariKerja,
    this.jamKerja,
    this.kontak,
    this.deskripsi,
  }) : super(key: key);
  final String? id;
  final String? codeDokter;
  final String? name;
  final String? spesialis;
  final String? hariKerja;
  final String? jamKerja;
  final String? kontak;
  final String? deskripsi;

  @override
  State<InputJadwalDokter> createState() => Input_JadwalDokterState();
}

class Input_JadwalDokterState extends State<InputJadwalDokter> {
  final _formKey = GlobalKey<FormState>();

  //controller
  late TextEditingController _codeDokterController;
  late TextEditingController _nameController;
  late TextEditingController _spesialisController;
  late TextEditingController _hariKerja;
  late TextEditingController _jamKerja;
  late TextEditingController _kontak;
  late TextEditingController _deskripsi;

  @override
  void initState() {
    super.initState();
    _codeDokterController = TextEditingController(text: widget.codeDokter);
    _nameController = TextEditingController(text: widget.name);
    _spesialisController = TextEditingController(text: widget.spesialis);
    _hariKerja = TextEditingController(text: widget.hariKerja);
    _jamKerja = TextEditingController(text: widget.jamKerja);
    _kontak = TextEditingController(text: widget.kontak);
    _deskripsi = TextEditingController(text: widget.deskripsi);
  }

  @override
  Widget build(BuildContext context) {
    final submitBtn = ElevatedButton(
      onPressed: () {
        if (widget.id == null) {
          uploadJadwalDokter(
              _codeDokterController.text,
              _nameController.text,
              _spesialisController.text,
              _hariKerja.text,
              _jamKerja.text,
              _kontak.text,
              _deskripsi.text);
          Navigator.of(context).pop();
        } else {
          editDokter(
              _codeDokterController.text,
              widget.id!,
              _nameController.text,
              _spesialisController.text,
              _hariKerja.text,
              _jamKerja.text,
              _kontak.text,
              _deskripsi.text);
          Navigator.of(context).pop();
        }
      },
      child: Text(
        'Submit',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
      ),
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(darkerColor),
        backgroundColor: MaterialStateProperty.all(primaryColor),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        minimumSize: MaterialStateProperty.all(const Size(200, 40)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );

    final cancleBtn = ElevatedButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Home(),
            ));
      },
      child: Text(
        'Cancel',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
      ),
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(Colors.red[900]),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        backgroundColor: MaterialStateProperty.all(Colors.red[400]),
        minimumSize: MaterialStateProperty.all(const Size(200, 40)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: secondaryColor,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(36),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Text(
                      "Input Jadwal Dokter",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 6, 59, 8),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Silahkan Input Jadwal Dokter Dibawah Ini",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 6, 59, 8),
                      ),
                    ),
                    SizedBox(height: 20),
                    formTextField("ID Dokter", _codeDokterController),
                    SizedBox(height: 20),
                    formTextField("Nama", _nameController),
                    SizedBox(height: 20),
                    formTextField("Spesialis", _spesialisController),
                    SizedBox(height: 20),
                    formTextField("Hari Kerja", _hariKerja),
                    SizedBox(height: 20),
                    formTextField("Jam Kerja", _jamKerja),
                    SizedBox(height: 20),
                    formTextField("Kontak", _kontak),
                    SizedBox(height: 20),
                    formTextField("Deskripsi", _deskripsi),
                    SizedBox(height: 20),
                    submitBtn,
                    SizedBox(height: 10),
                    cancleBtn,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

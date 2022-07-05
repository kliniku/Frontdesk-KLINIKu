part of 'services.dart';

class JadwalDokter extends StatefulWidget {
  const JadwalDokter({Key? key}) : super(key: key);

  @override
  State<JadwalDokter> createState() => _JadwalDokterState();
}

class _JadwalDokterState extends State<JadwalDokter> {
  String _searchText = "";
  List<Dokter> _dokter = [];

  List<Dokter> _foundDokter = [];
  void initState() {
    super.initState();
    setState(() {
      _foundDokter = _dokter;
    });
  }

  onSearch(String value) {
    print(value);
    setState(() {
      _searchText = value.trim();
      // _foundDokter = _dokter
      //     .where((dokter) =>
      //         dokter.nama.toLowerCase().contains(value.toLowerCase()))
      //     .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        elevation: 0, //menghilangkan shadow pada elevation
        title: Container(
          height: 38,
          child: TextField(
            onChanged: (value) => onSearch(value),
            decoration: InputDecoration(
              filled: true,
              fillColor: primaryColor,
              contentPadding: EdgeInsets.all(0),
              prefixIcon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              hintStyle: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
              hintText: 'cari dokter',
            ),
          ),
        ),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.only(right: 20, left: 20),
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            builder: ((context, snapshot) {
              return !snapshot.hasData
                  ? const CircularProgressIndicator()
                  : snapshot.data!.docs.isEmpty
                      ? Text("Dokter tidak ditemukan")
                      : ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot<Map<String, dynamic>> doctor =
                                snapshot.data!.docs[index];
                            return DokterComponent(
                              id: doctor.id,
                              name: doctor["nama"],
                              spesialis: doctor["spesialis"],
                              tanggal: doctor["hariKerja"],
                              jam: doctor["jamKerja"],
                              codeDokter: doctor["noDokter"],
                              kontak: doctor["noHp"],
                              deskripsi: doctor["deskripsi"],
                            );
                          },
                        );
            }),
            stream: _searchText.isEmpty
                ? FirebaseFirestore.instance.collection("doctors").snapshots()
                : FirebaseFirestore.instance
                    .collection("doctors")
                    .where("caseSearch", arrayContains: _searchText)
                    .snapshots(),
          ),
        ),
      ),
    );
  }
}

class DokterComponent extends StatelessWidget {
  const DokterComponent(
      {Key? key,
      required this.id,
      required this.codeDokter,
      required this.name,
      required this.spesialis,
      required this.tanggal,
      required this.jam,
      required this.kontak,
      required this.deskripsi})
      : super(key: key);

  final String id;
  final String codeDokter;
  final String name;
  final String spesialis;
  final String tanggal;
  final String jam;
  final String kontak;
  final String deskripsi;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white60,
      ),
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 20),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    spesialis,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    tanggal,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    jam,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    codeDokter,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    kontak,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    deskripsi,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.red,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.delete,
                        ),
                        onPressed: () {
                          deleteJadwalDokter(id);
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.blue,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.edit,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InputJadwalDokter(
                                  id: id,
                                  name: name,
                                  hariKerja: tanggal,
                                  jamKerja: jam,
                                  kontak: kontak,
                                  spesialis: spesialis,
                                ),
                              ));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

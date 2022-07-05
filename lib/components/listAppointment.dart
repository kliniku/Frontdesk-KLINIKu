part of 'services.dart';

class ListAppoinment extends StatefulWidget {
  const ListAppoinment({Key? key}) : super(key: key);

  @override
  State<ListAppoinment> createState() => _ListAppoinmentState();
}

class _ListAppoinmentState extends State<ListAppoinment> {
  String _searchText = "";
  final List<ListAppoinment> _appoinment = [];
  List<ListAppoinment> _foundAppoinment = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _fcmIntance = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    setState(() {
      _foundAppoinment = _appoinment;
    });
  }

  onSearch(String value) {
    print(value);
    setState(() {
      _searchText = value.trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        elevation: 0, //menghilangkan shadow pada elevation
        title: SizedBox(
          height: 38,
          child: TextField(
            onChanged: (value) => onSearch(value),
            decoration: InputDecoration(
              filled: true,
              fillColor: primaryColor,
              contentPadding: const EdgeInsets.all(0),
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              hintStyle: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
              hintText: 'cari daftar janji',
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
                      ? Text("Empty Data")
                      : ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot<Map<String, dynamic>> appointment =
                                snapshot.data!.docs[index];
                            return AppointmentComponent(
                              id: appointment.id,
                              namaLengkap: appointment["namaLengkap"],
                              namaDokter: appointment["namaDokter"],
                              jamOperasional: appointment["jamOperasional"],
                              spesialis: appointment["spesialis"],
                              status: appointment["status"],
                              statusDesc: appointment["statusDesc"],
                              tglJanji: appointment["tglJanji"],
                              email: appointment["email"],
                              noHp: appointment["noHp"],
                              firestore: _firestore,
                              fcmInstance: _fcmIntance,
                            );
                          },
                        );
            }),
            stream: _searchText.isEmpty
                ? FirebaseFirestore.instance
                    .collection("appointments")
                    .where("statusDesc", isEqualTo: "pending")
                    .snapshots()
                : FirebaseFirestore.instance
                    .collection("appointments")
                    .where("statusDesc", isEqualTo: "pending")
                    .where("caseSearch", arrayContains: _searchText)
                    .snapshots()),
      )),
    );
  }
}

class AppointmentComponent extends StatefulWidget {
  AppointmentComponent({
    Key? key,
    required this.id,
    required this.namaLengkap,
    required this.namaDokter,
    required this.jamOperasional,
    required this.spesialis,
    required this.status,
    required this.statusDesc,
    required this.tglJanji,
    required this.email,
    required this.noHp,
    required this.firestore,
    required this.fcmInstance,
  }) : super(key: key);

  final String id;
  final String namaLengkap;
  final String namaDokter;
  final String jamOperasional;
  final String spesialis;
  final bool status;
  final String statusDesc;
  final String tglJanji;
  final String email;
  final String noHp;
  final FirebaseFirestore firestore;
  final FirebaseMessaging? fcmInstance;

  @override
  State<AppointmentComponent> createState() => _AppointmentComponentState();
}

class _AppointmentComponentState extends State<AppointmentComponent> {
  PasienKarepmu? _pasien;

  void getUser(String email) async {
    await widget.firestore
        .collection("appointments")
        .where("email", isEqualTo: email)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        _pasien = PasienKarepmu.fromMap(doc.data());
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getUser(widget.email);
  }

  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white60,
      ),
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 20),
      child: Row(
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.namaLengkap,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.namaDokter,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    widget.tglJanji,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    widget.jamOperasional,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    widget.statusDesc,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50),
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
                  deleteAppointment(widget.id);
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
                color: Colors.yellow,
              ),
              child: IconButton(
                icon: Icon(Icons.add_alert),
                onPressed: () async {
                  bool newStatus = !widget.status;
                  accAppointment(
                    widget.id,
                    newStatus,
                    widget.namaLengkap,
                    widget.namaDokter,
                    widget.jamOperasional,
                    widget.spesialis,
                    widget.statusDesc,
                    widget.tglJanji,
                    widget.email,
                    widget.noHp,
                  );
                  // await widget.fcmInstance?.sendMessage(
                  //   to: _pasien?.tokenUser,
                  //   data: {
                  //     "title": "Reservasi Diterima",
                  //     "body":
                  //         "silahkan mengunjungi klinik sesuai tanggal yang disesuaikan",
                  //   },
                  // );
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
                color: Colors.green,
              ),
              child: IconButton(
                icon: Icon(Icons.check),
                onPressed: () {
                  String newStatusDesc = "Complete";
                  accAppointment(
                    widget.id,
                    widget.status,
                    widget.namaLengkap,
                    widget.namaDokter,
                    widget.jamOperasional,
                    widget.spesialis,
                    newStatusDesc,
                    widget.tglJanji,
                    widget.email,
                    widget.noHp,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

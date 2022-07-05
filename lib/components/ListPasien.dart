part of 'services.dart';

class ListPasien extends StatefulWidget {
  const ListPasien({Key? key}) : super(key: key);

  @override
  State<ListPasien> createState() => _ListPasienState();
}

class _ListPasienState extends State<ListPasien> {
  String _searchText = "";
  List<Pasien> _pasien = [];

  List<Pasien> _foundPasien = [];
  void initState() {
    super.initState();
    setState(() {
      _foundPasien = _pasien;
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
              hintText: 'cari pasien',
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
                      ? Text("Pasien tidak ditemukan")
                      : ListView.builder(
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot<Map<String, dynamic>> pasien =
                                snapshot.data!.docs[index];
                            return PasienComponent(
                              id: pasien.id,
                              firstName: pasien["firstName"],
                              lastName: pasien["lastName"],
                              address: pasien["address"],
                              email: pasien["email"],
                              phoneNum: pasien["phoneNum"],
                            );
                          },
                        );
            }),
            stream: _searchText.isEmpty
                ? FirebaseFirestore.instance.collection("users").snapshots()
                : FirebaseFirestore.instance
                    .collection("users")
                    .where("caseSearch", arrayContains: _searchText)
                    .snapshots()),
      )),
    );
  }
}

class PasienComponent extends StatelessWidget {
  const PasienComponent(
      {Key? key,
      required this.id,
      required this.firstName,
      required this.lastName,
      required this.address,
      required this.email,
      required this.phoneNum})
      : super(key: key);

  final String id;
  final String firstName;
  final String lastName;
  final String address;
  final String email;
  final String phoneNum;

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
                    firstName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    lastName,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    address,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    email,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    phoneNum,
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
                          deletePasien(id);
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

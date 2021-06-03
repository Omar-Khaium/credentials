import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:credentials/src/model/credential.dart';
import 'package:credentials/src/utils/constants.dart';
import 'package:credentials/src/utils/services/api_service.dart';
import 'package:credentials/src/utils/services/auth_service.dart';
import 'package:credentials/src/view/routes/route_archive.dart';
import 'package:credentials/src/view/routes/route_auth.dart';
import 'package:credentials/src/view/widgets/widget_add_credential.dart';
import 'package:credentials/src/view/widgets/widget_credential_details.dart';
import 'package:credentials/src/view/widgets/widget_edit_credential.dart';
import 'package:flutter/material.dart';

class DashboardRoute extends StatelessWidget {
  final String route = "/dashboard";
  final AuthService _authService = AuthService();
  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: Tooltip(
          message: 'Profile',
          child: IconButton(
            icon: CircleAvatar(
              child: Icon(Icons.person_outline_rounded, color: Colors.white),
              backgroundColor: Colors.blue.shade600,
            ),
            onPressed: () {},
          ),
        ),
        title: Text("Dashboard"),
        actions: [
          Tooltip(
            message: 'Archives',
            child: IconButton(
              icon: Icon(Icons.archive_outlined),
              onPressed: () async {
                Navigator.of(context).pushNamed(ArchiveRoute().route);
              },
            ),
          ),
          Tooltip(
            message: 'Sign out',
            child: IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text("Confirmation"),
                          content: Text("Are you sure ?"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("Cancel")),
                            ElevatedButton(
                                onPressed: () async {
                                  showDialog(context: context, builder: (context) => Center(child: CircularProgressIndicator()), barrierDismissible: false);
                                  bool status = await _authService.signOut();
                                  Navigator.of(context).pop();
                                  if (status) {
                                    Navigator.of(context).pushReplacementNamed(AuthRoute().route);
                                  }
                                },
                                child: Text("Logout")),
                          ],
                        ));
              },
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            _apiService.instance.collection(credentialCollection).where("createdBy", isEqualTo: _authService.currentUser?.uid ?? "").where("isActive", isEqualTo: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Icon(Icons.error));
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          return snapshot.data.docs.isEmpty
              ? Center(child: Icon(Icons.grid_off))
              : ListView.builder(
                  padding: EdgeInsets.all(0),
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    final Credential credential = Credential.fromSnapshot(snapshot.data.docs[index]);
                    return ListTile(
                      leading: Tooltip(
                        message: 'Logo',
                        child: Image.network(
                          "${credential.url?.startsWith("http") ?? "" ? "" : "http://"}${credential.url}/favicon.ico",
                          fit: BoxFit.cover,
                          errorBuilder: (_,__,___)=>Icon(Icons.public),
                          width: 24,
                          height: 24,
                        ),
                      ),
                      horizontalTitleGap: 0,
                      title: Tooltip(message: 'URL', child: Text(credential.url, maxLines: 1, overflow: TextOverflow.ellipsis)),
                      subtitle: Tooltip(message: 'Username', child: Text(credential.username, maxLines: 1, overflow: TextOverflow.ellipsis)),
                      trailing: Tooltip(
                        message: 'Edit',
                        child: IconButton(
                          icon: Icon(Icons.edit_outlined, color: Colors.blue),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditCredentialWidget(credential),
                            ));
                          },
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                      onTap: () {
                        showDialog(context: context, builder: (context) => CredentialDetailsWidget(credential));
                      },
                    );
                  },
                  itemCount: snapshot.data.docs.length,
                );
        },
      ),
      floatingActionButton: Tooltip(
        message: 'Add new credential',
        child: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddCredentialWidget(),
            ));
          },
        ),
      ),
    );
  }
}

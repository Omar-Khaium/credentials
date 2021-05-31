import 'package:cached_network_image/cached_network_image.dart';
import 'package:credentials/src/model/credential.dart';
import 'package:credentials/src/utils/services/api_service.dart';
import 'package:credentials/src/view/widgets/widget_edit_credential.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CredentialDetailsWidget extends StatelessWidget {
  final Credential credential;
  final ApiService _apiService = ApiService();

  CredentialDetailsWidget(this.credential);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.symmetric(vertical: 8),
      content: Container(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
          maxWidth: MediaQuery.of(context).size.width,
          minHeight: 0,
          maxHeight: MediaQuery.of(context).size.width,
        ),
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 8),
          physics: ScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: [
            Container(
              alignment: Alignment.center,
              child: CachedNetworkImage(
                imageUrl: "https://www.google.com/s2/favicons?domain=${credential.url}",
                placeholder: (context, url) => Icon(Icons.image_outlined, color: Colors.blue),
                errorWidget: (context, url, error) => Icon(Icons.public, color: Colors.blue),
                fit: BoxFit.cover,
                filterQuality: FilterQuality.low,
                width: 42,
                height: 42,
              ),
            ),
            ListTile(
              dense: true,
              visualDensity: VisualDensity.compact,
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
              horizontalTitleGap: 0,
              leading: Icon(Icons.person_outline_rounded, color: Colors.blue),
              title: Text(credential.username, style: TextStyle(color: Colors.blue)),
              onTap: () {
                Clipboard.setData(ClipboardData(text: credential.username));
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("username copied"), duration: Duration(seconds: 1)));
              },
            ),
            Divider(height: 1),
            ListTile(
              dense: true,
              visualDensity: VisualDensity.compact,
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
              horizontalTitleGap: 0,
              leading: Icon(Icons.lock_outline_rounded, color: Colors.blue),
              title: Text(credential.password, style: TextStyle(color: Colors.blue)),
              onTap: () {
                Clipboard.setData(ClipboardData(text: credential.password));
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("password copied"), duration: Duration(seconds: 1)));
              },
            ),
            Divider(height: 1),
            ListTile(
              dense: true,
              visualDensity: VisualDensity.compact,
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
              horizontalTitleGap: 0,
              leading: Icon(Icons.event_note_outlined),
              title: Text(DateFormat("h:mma d MMM, yy").format(DateTime.fromMillisecondsSinceEpoch(credential.lastUpdatedAt).add(DateTime.now().timeZoneOffset))),
              onTap: () {
                Clipboard.setData(ClipboardData(text: credential.password));
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("password copied"), duration: Duration(seconds: 1)));
              },
            ),
            Visibility(visible: credential.remarks.isNotEmpty, child: Divider(height: 1)),
            Visibility(
              visible: credential.remarks.isNotEmpty,
              child: ListTile(
                dense: true,
                visualDensity: VisualDensity.compact,
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                horizontalTitleGap: 0,
                leading: Icon(Icons.notes),
                title: Text(credential.remarks),
              ),
            ),
            Divider(height: 1),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ActionChip(
                    avatar: Icon(Icons.edit_outlined, color: Colors.white, size: 16),
                    label: Text("Edit", style: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.blue,
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => EditCredentialWidget(credential),
                      ));
                    },
                  ),
                  SizedBox(width: 24),
                  ActionChip(
                    avatar: Icon(Icons.archive_outlined, color: Colors.white, size: 16),
                    label: Text("Archive", style: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.black,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (confirmationContext) => AlertDialog(
                          title: Text("Confirmation", style: TextStyle(color: Colors.black, fontSize: 16)),
                          content: Text("Are you sure?", style: TextStyle(color: Colors.black, fontSize: 14)),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: TextButton.styleFrom(primary: Colors.black),
                              child: Text("Cancel"),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                showDialog(context: context, builder: (deleteContext) => Center(child: CircularProgressIndicator()), barrierDismissible: false);
                                credential.isActive = false;
                                bool status = await _apiService.editCredential(credential);
                                Navigator.of(context).pop();
                                if (status) {
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Successfully archived"), backgroundColor: Colors.black));
                                }
                              },
                              style: ElevatedButton.styleFrom(primary: Colors.black),
                              child: Text("Archive", style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      );
                    },
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

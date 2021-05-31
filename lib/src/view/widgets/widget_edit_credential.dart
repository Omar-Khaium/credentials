import 'package:credentials/src/model/credential.dart';
import 'package:credentials/src/utils/services/api_service.dart';
import 'package:flutter/material.dart';

class EditCredentialWidget extends StatefulWidget {
  final Credential credential;

  EditCredentialWidget(this.credential);

  @override
  _EditCredentialWidgetState createState() => _EditCredentialWidgetState();
}

class _EditCredentialWidgetState extends State<EditCredentialWidget> {
  final ApiService _apiService = ApiService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  bool _isObscure = true;
  bool _isActive = true;

  @override
  void initState() {
    _urlController.text = widget.credential.url;
    _usernameController.text = widget.credential.username;
    _passwordController.text = widget.credential.password;
    _remarksController.text = widget.credential.remarks;
    _isActive = widget.credential.isActive;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Edit credential"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded),
            onPressed: () {
              setState(() {
                _urlController.text = widget.credential.url;
                _usernameController.text = widget.credential.username;
                _passwordController.text = widget.credential.password;
                _remarksController.text = widget.credential.remarks;
                _isActive = widget.credential.isActive;
                _isObscure = true;
                _formKey.currentState.reset();
              });
            },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          physics: ScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: [
            Text("Url *"),
            SizedBox(height: 4),
            TextFormField(
              controller: _urlController,
              keyboardType: TextInputType.url,
              validator: (val) => val.isEmpty ? "required" : null,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: Colors.grey.shade50,
                contentPadding: EdgeInsets.all(12),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(width: .5, color: Colors.blue)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(width: .5, color: Colors.blue)),
                errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(width: .5, color: Colors.red)),
                focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(width: .5, color: Colors.red)),
                errorStyle: TextStyle(fontSize: 9, height: .5),
              ),
            ),
            SizedBox(height: 16),
            Text("Username *"),
            SizedBox(height: 4),
            TextFormField(
              controller: _usernameController,
              keyboardType: TextInputType.emailAddress,
              validator: (val) => val.isEmpty ? "required" : null,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: Colors.grey.shade50,
                contentPadding: EdgeInsets.all(12),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(width: .5, color: Colors.blue)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(width: .5, color: Colors.blue)),
                errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(width: .5, color: Colors.red)),
                focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(width: .5, color: Colors.red)),
                errorStyle: TextStyle(fontSize: 9, height: .5),
              ),
            ),
            SizedBox(height: 16),
            Text("Password *"),
            SizedBox(height: 4),
            TextFormField(
              controller: _passwordController,
              keyboardType: TextInputType.text,
              validator: (val) => val.isEmpty ? "required" : null,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: Colors.grey.shade50,
                contentPadding: EdgeInsets.all(12),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(width: .5, color: Colors.blue)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(width: .5, color: Colors.blue)),
                errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(width: .5, color: Colors.red)),
                focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(width: .5, color: Colors.red)),
                errorStyle: TextStyle(fontSize: 9, height: .5),
                suffixIcon: IconButton(
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  splashRadius: 24,
                  icon: Icon(_isObscure ? Icons.visibility_rounded : Icons.visibility_off_rounded),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                ),
              ),
              obscureText: _isObscure,
            ),
            SizedBox(height: 16),
            Text("Remarks"),
            SizedBox(height: 4),
            TextFormField(
              controller: _remarksController,
              keyboardType: TextInputType.multiline,
              minLines: 3,
              maxLines: 8,
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: Colors.grey.shade50,
                contentPadding: EdgeInsets.all(12),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(width: .5, color: Colors.blue)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide(width: .5, color: Colors.blue)),
              ),
            ),
            SizedBox(height: 4),
            CheckboxListTile(
              value: _isActive,
              onChanged: (flag) {
                setState(() {
                  _isActive = flag;
                });
              },
              title: Text("Active"),
              controlAffinity: ListTileControlAffinity.trailing,
              contentPadding: EdgeInsets.zero,
            ),
            SizedBox(height: 4),
            ElevatedButton.icon(
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  final Credential _credential = Credential(
                    id: widget.credential.id,
                    username: _usernameController.text,
                    password: _passwordController.text,
                    url: _urlController.text,
                    remarks: _remarksController.text,
                    createdAt: widget.credential.createdAt,
                    createdBy: widget.credential.createdBy,
                    lastUpdatedAt: DateTime.now().subtract(DateTime.now().timeZoneOffset).millisecondsSinceEpoch,
                    isActive: _isActive,
                  );
                  showDialog(context: context, builder: (context) => Center(child: CircularProgressIndicator()), barrierDismissible: false);
                  bool status = await _apiService.editCredential(_credential);
                  Navigator.of(context).pop();
                  if (status) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Successfully updated"), backgroundColor: Colors.deepOrange));
                  }
                }
              },
              icon: Icon(Icons.save_outlined),
              label: Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}

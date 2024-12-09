import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:paint/providers/drawing_provider.dart';
import 'package:paint/services/firestore_service.dart';
import 'package:provider/provider.dart';

class CreatePairPage extends StatefulWidget {
  const CreatePairPage({super.key});

  @override
  _CreatePairPageState createState() => _CreatePairPageState();
}

class _CreatePairPageState extends State<CreatePairPage> {
  final TextEditingController _controller = TextEditingController();
  String _userCode = '';
  bool _isPairing = false;

  @override
  void initState() {
    super.initState();
    _getUserCode();
  }

  Future<void> _getUserCode() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    String? code = await FirestoreService().getUserCode(userId);
    setState(() {
      _userCode = code ?? '';
    });
  }

  Future<void> _pairUser() async {
    String userCodeToPair = _controller.text.trim();

    if (userCodeToPair.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid code')));
      return;
    }

    setState(() {
      _isPairing = true;
    });

    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      await FirestoreService().pairUsers(userCodeToPair, userId);

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Successfully paired!')));
      
      // Retrieve the pairId and set it in the DrawingProvider
      String? pairId = await FirestoreService().getPairedUserId(userId);
      if (pairId != null) {
        Provider.of<DrawingProvider>(context, listen: false).setPairId(pairId);
      }
      
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      setState(() {
        _isPairing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error pairing: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Pair')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Your Code: $_userCode', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 50),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter code to pair',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isPairing ? null : _pairUser,
              child: _isPairing
                  ? const CircularProgressIndicator()
                  : const Text('Pair'),
            ),
          ],
        ),
      ),
    );
  }
}

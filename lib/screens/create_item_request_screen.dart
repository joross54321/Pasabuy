import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../theme/app_theme.dart';
import '../widgets/app_text_field.dart';
import '../widgets/app_buttons.dart';

/// Extracted from RequesterHomeScreen's inline "Create Item Request" card.
/// Backend logic (Firestore write) is unchanged from the original.
class CreateItemRequestScreen extends StatefulWidget {
  const CreateItemRequestScreen({super.key});

  @override
  State<CreateItemRequestScreen> createState() => _CreateItemRequestScreenState();
}

class _CreateItemRequestScreenState extends State<CreateItemRequestScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _itemNameController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _estCostController = TextEditingController();

  bool _isSubmitting = false;

  Future<void> _submitItemRequest() async {
    User? user = _auth.currentUser;
    if (user == null) return;

    if (_itemNameController.text.isEmpty || _qtyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in required fields!')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await _db.collection('item_requests').add({
        'requesterId': user.uid,
        'itemName': _itemNameController.text.trim(),
        'quantity': int.tryParse(_qtyController.text) ?? 1,
        'estimatedCost': double.tryParse(_estCostController.text) ?? 0.0,
        'status': 'PENDING',
        'createdAt': FieldValue.serverTimestamp(),
      });

      _itemNameController.clear();
      _qtyController.clear();
      _estCostController.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item Request Submitted!')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _qtyController.dispose();
    _estCostController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgApp,
      appBar: AppBar(
        backgroundColor: AppColors.bgApp,
        title: const Text(
          'Create Item Request',
          style: TextStyle(color: AppColors.textDark, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: AppColors.textDark),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Pasabuy Details',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textDark),
              ),
              const SizedBox(height: 16),
              AppTextField(
                hint: 'Item Name (e.g., Fresh Milk 1L)',
                icon: Icons.shopping_bag_outlined,
                controller: _itemNameController,
              ),
              const SizedBox(height: 14),
              AppTextField(
                hint: 'Quantity',
                icon: Icons.numbers,
                keyboardType: TextInputType.number,
                controller: _qtyController,
              ),
              const SizedBox(height: 14),
              AppTextField(
                hint: 'Est. Cost (₱)',
                icon: Icons.payments_outlined,
                keyboardType: TextInputType.number,
                controller: _estCostController,
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                label: _isSubmitting ? 'Submitting...' : 'Submit Request',
                onPressed: _isSubmitting ? null : _submitItemRequest,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import 'custom_text_field.dart';
import 'custom_button.dart';

class CrowdLevelForm extends StatefulWidget {
  final Function(int) onSubmitted;
  final bool isSubmitted;
  final int? submittedCrowdNumber;

  const CrowdLevelForm({
    super.key,
    required this.onSubmitted,
    this.isSubmitted = false,
    this.submittedCrowdNumber,
  });

  @override
  State<CrowdLevelForm> createState() => _CrowdLevelFormState();
}

class _CrowdLevelFormState extends State<CrowdLevelForm> {
  final TextEditingController _crowdNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isSubmitted && widget.submittedCrowdNumber != null) {
      _crowdNumberController.text = widget.submittedCrowdNumber.toString();
    }
  }

  @override
  void dispose() {
    _crowdNumberController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final int? crowdNumber = int.tryParse(_crowdNumberController.text);
    if (crowdNumber != null && crowdNumber > 0) {
      widget.onSubmitted(crowdNumber);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid crowd number.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool disabled = widget.isSubmitted;

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Enter Crowd Status',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          AbsorbPointer(
            absorbing: disabled,
            child: CustomTextField(
              hint: 'Crowd number...',
              controller: _crowdNumberController,
              keyboardType: TextInputType.number,
              obscure: false,
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.center,
            child: AbsorbPointer(
              absorbing: disabled,
              child: Opacity(
                opacity: disabled ? 0.6 : 1,
                child: CustomButton(
                  text: 'Submit',
                  onPressed: _handleSubmit,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}




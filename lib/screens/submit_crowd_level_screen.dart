import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../core/app_theme.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/crowd_level_form.dart';

enum CrowdSubmissionState { prompt, input, submitted }

class SubmitCrowdLevelScreen extends StatefulWidget {
  final String name;
  final String website;
  final String address;
  final String hours;

  final double latitude;
  final double longitude;

  const SubmitCrowdLevelScreen({
    super.key,
    required this.name,
    required this.website,
    required this.address,
    required this.hours,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<SubmitCrowdLevelScreen> createState() => _SubmitCrowdLevelScreenState();
}

class _SubmitCrowdLevelScreenState extends State<SubmitCrowdLevelScreen> {
  CrowdSubmissionState _currentState = CrowdSubmissionState.prompt;
  int? _submittedCrowdCount;
  int _selectedIndex = 1;

  // SAVE crowd data + calculate average
  Future<void> _saveCrowdToFirestore(int crowdNumber) async {
    final String documentId = "${widget.latitude}_${widget.longitude}";
    final ref = FirebaseFirestore.instance.collection("crowdLevel").doc(documentId);

    final doc = await ref.get();

    if (doc.exists) {
      // READ previous values
      final data = doc.data()!;
      final int oldCount = data["submissionCount"] ?? 0;
      final int oldAverage = data["crowdLevelAverage"] ?? 0;

      // NEW average
      final int newCount = oldCount + 1;
      final int newAverage = ((oldAverage * oldCount) + crowdNumber) ~/ newCount;

      await ref.update({
        "crowdLevelLast": crowdNumber,
        "crowdLevelAverage": newAverage,
        "submissionCount": newCount,
        "lastUpdated": FieldValue.serverTimestamp(),
      });
    } else {
      // FIRST SUBMISSION
      await ref.set({
        "id": documentId,
        "hospitalName": widget.name,
        "location": GeoPoint(widget.latitude, widget.longitude),

        "crowdLevelLast": crowdNumber,
        "crowdLevelAverage": crowdNumber,
        "submissionCount": 1,

        "lastUpdated": FieldValue.serverTimestamp(),
      });
    }
  }

  void _submitCrowdLevel(int crowdNumber) async {
    await _saveCrowdToFirestore(crowdNumber);

    setState(() {
      _submittedCrowdCount = crowdNumber;
      _currentState = CrowdSubmissionState.submitted;
    });
  }

  void _showInputForm() {
    setState(() => _currentState = CrowdSubmissionState.input);
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);

    if (index == 0) Get.toNamed('/map');
    if (index == 1) Get.toNamed('/home');
    if (index == 2) Get.toNamed('/account');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        title: Text(widget.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHospitalInfoCard(),
            const SizedBox(height: 20),
            if (_currentState == CrowdSubmissionState.prompt)
              _buildPromptCard(),
            if (_currentState == CrowdSubmissionState.input)
              CrowdLevelForm(onSubmitted: _submitCrowdLevel),
            if (_currentState == CrowdSubmissionState.submitted)
              _buildSubmittedView(),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildHospitalInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.name,
              style: const TextStyle(
                  color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(widget.address,
              style: const TextStyle(color: Colors.white70, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildPromptCard() {
    return InkWell(
      onTap: _showInputForm,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: const [
            Icon(Icons.people, color: Colors.white, size: 32),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                "Tell us the crowd level to help other patients!",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSubmittedView() {
    return Column(
      children: [
        CrowdLevelForm(
          onSubmitted: (_) {},
          isSubmitted: true,
          submittedCrowdNumber: _submittedCrowdCount,
        ),
        const SizedBox(height: 10),
        const Text(
          "Submitted Successfully!",
          style: TextStyle(color: Colors.green, fontSize: 18),
        ),
      ],
    );
  }
}

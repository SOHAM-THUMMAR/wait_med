import 'package:flutter/material.dart';
import '../core/app_theme.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../widgets/crowd_level_form.dart';

// Enum for submission states
enum CrowdSubmissionState { prompt, input, submitted }

class SubmitCrowdLevelScreen extends StatefulWidget {
  final String name;
  final String website;
  final String address;
  final String hours;

  const SubmitCrowdLevelScreen({
    super.key,
    required this.name,
    required this.website,
    required this.address,
    required this.hours,
  });

  @override
  State<SubmitCrowdLevelScreen> createState() => _SubmitCrowdLevelScreenState();
}

class _SubmitCrowdLevelScreenState extends State<SubmitCrowdLevelScreen> {
  CrowdSubmissionState _currentState = CrowdSubmissionState.prompt;
  int? _submittedCrowdCount;

  void _submitCrowdLevel(int crowdNumber) {
    setState(() {
      _submittedCrowdCount = crowdNumber;
      _currentState = CrowdSubmissionState.submitted;
    });
  }

  void _showInputForm() {
    setState(() {
      _currentState = CrowdSubmissionState.input;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildHospitalInfoCard() {
    // Dynamic crowd status text based on submitted data
    String crowdStatus;
    if (_submittedCrowdCount == null) {
      crowdStatus = 'Not reported yet';
    } else if (_submittedCrowdCount! > 50) {
      crowdStatus = 'High';
    } else if (_submittedCrowdCount! > 20) {
      crowdStatus = 'Medium';
    } else {
      crowdStatus = 'Low';
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.location_city, color: AppTheme.primaryColor),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Dynamic hospital name
                    Text(
                      widget.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    //Dynamic website (with fallback)
                    Text(
                      widget.website.isNotEmpty
                          ? widget.website
                          : 'No website available',
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(color: Colors.white54),
          const SizedBox(height: 10),

          //Dynamic address
          Text(
            widget.address,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 10),

          //Dynamic hours info
          Row(
            children: [
              const Icon(Icons.access_time, color: Colors.white),
              const SizedBox(width: 5),
              Text(
                widget.hours.isNotEmpty ? widget.hours : 'Hours not available',
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 10),

          //Dynamic crowd info
          Row(
            children: [
              const Icon(Icons.people, color: Colors.yellow),
              const SizedBox(width: 10),
              Text(
                'Crowd level: $crowdStatus',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (_submittedCrowdCount != null) ...[
            const SizedBox(height: 5),
            Text(
              '${_submittedCrowdCount!} people currently reported',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPromptCard() {
    return InkWell(
      onTap: _showInputForm,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.9),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.accentColor, width: 2),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.notifications_active,
              color: AppTheme.accentColor,
              size: 30,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'WaitMed | Crowd Status!',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Can you tell us how many visitors are there, to help others in need?',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            const Icon(Icons.close, color: Colors.white),
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
          'Submitted Successfully!!',
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

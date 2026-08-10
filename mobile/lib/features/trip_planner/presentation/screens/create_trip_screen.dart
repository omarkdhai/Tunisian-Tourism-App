import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class CreateTripScreen extends StatefulWidget {
  const CreateTripScreen({super.key});

  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  int _currentStep = 0;
  String _selectedRegion = '';
  int _duration = 3;
  double _budget = 1000.0;

  void _nextStep() {
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
    } else {
      // Navigate to loading/generating screen
      context.push('/generating-trip');
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: _currentStep == 0 ? () => context.pop() : _prevStep,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Indicator
              Row(
                children: List.generate(
                  3,
                  (index) => Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 4,
                      decoration: BoxDecoration(
                        color: index <= _currentStep ? const Color(0xFF1E1E1E) : Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _buildCurrentStep(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _nextStep,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      backgroundColor: const Color(0xFF1E1E1E),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Text(
                      _currentStep == 2 ? 'Generate AI Itinerary' : 'Continue',
                      style: GoogleFonts.inter(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildDestinationStep();
      case 1:
        return _buildDurationStep();
      case 2:
        return _buildBudgetStep();
      default:
        return const SizedBox();
    }
  }

  Widget _buildDestinationStep() {
    final regions = ['Tunis', 'Hammamet', 'Djerba', 'Tozeur', 'Sousse'];
    return Column(
      key: const ValueKey(0),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Where do you want to go?',
          style: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.bold, height: 1.2),
        ),
        const SizedBox(height: 16),
        Text(
          'Select a region in Tunisia to focus your trip on.',
          style: GoogleFonts.inter(fontSize: 16, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 32),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: regions.map((region) {
            final isSelected = _selectedRegion == region;
            return GestureDetector(
              onTap: () => setState(() => _selectedRegion = region),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: isSelected ? null : Border.all(color: Colors.grey.shade300),
                ),
                child: Text(
                  region,
                  style: GoogleFonts.inter(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.white : Colors.black87,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          }).toList(),
        )
      ],
    );
  }

  Widget _buildDurationStep() {
    return Column(
      key: const ValueKey(1),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How long is your trip?',
          style: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.bold, height: 1.2),
        ),
        const SizedBox(height: 48),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline, size: 48),
                onPressed: () {
                  if (_duration > 1) setState(() => _duration--);
                },
              ),
              const SizedBox(width: 24),
              Text(
                '$_duration',
                style: GoogleFonts.inter(fontSize: 64, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Text(
                'Days',
                style: GoogleFonts.inter(fontSize: 24, color: Colors.grey.shade600),
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, size: 48),
                onPressed: () => setState(() => _duration++),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBudgetStep() {
    return Column(
      key: const ValueKey(2),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What is your budget?',
          style: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.bold, height: 1.2),
        ),
        const SizedBox(height: 16),
        Text(
          'This helps us recommend the right places and hotels.',
          style: GoogleFonts.inter(fontSize: 16, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 48),
        Center(
          child: Text(
            '\$${_budget.toInt()}',
            style: GoogleFonts.inter(fontSize: 64, fontWeight: FontWeight.bold, color: const Color(0xFF1B6A45)),
          ),
        ),
        const SizedBox(height: 32),
        Slider(
          value: _budget,
          min: 100,
          max: 5000,
          divisions: 49,
          activeColor: const Color(0xFF1E1E1E),
          inactiveColor: Colors.grey.shade300,
          onChanged: (val) {
            setState(() {
              _budget = val;
            });
          },
        )
      ],
    );
  }
}

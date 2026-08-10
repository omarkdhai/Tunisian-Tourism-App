import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class WriteReviewScreen extends ConsumerStatefulWidget {
  final String placeId;
  final String placeName;

  const WriteReviewScreen({super.key, required this.placeId, required this.placeName});

  @override
  ConsumerState<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends ConsumerState<WriteReviewScreen> {
  final TextEditingController _commentCtrl = TextEditingController();
  double _overallRating = 0;
  double _foodRating = 0;
  double _cleanlinessRating = 0;
  double _valueRating = 0;
  double _experienceRating = 0;
  bool _isSubmitting = false;

  Future<void> _submitReview() async {
    if (_overallRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide an overall rating')),
      );
      return;
    }
    setState(() => _isSubmitting = true);

    // POST /api/reviews with { placeId, rating, comment, foodRating, cleanlinessRating, ... }
    await Future.delayed(const Duration(seconds: 1)); // simulate API call

    setState(() => _isSubmitting = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review submitted! Thank you 🎉'), backgroundColor: Colors.green),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F4F6),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new), onPressed: () => context.pop()),
        title: Text('Write a Review', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Place name
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  const Icon(Icons.place, color: Color(0xFF1E1E1E)),
                  const SizedBox(width: 10),
                  Text(widget.placeName, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Overall Rating (large stars)
            Text('Overall Rating', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Tap to rate', style: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 13)),
            const SizedBox(height: 12),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  return GestureDetector(
                    onTap: () => setState(() => _overallRating = i + 1.0),
                    child: Icon(
                      i < _overallRating ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: Colors.amber,
                      size: 48,
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 28),

            // Dimensional Ratings
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Rate by Category', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                  _buildDimensionRating('🍴  Food Quality', _foodRating, (v) => setState(() => _foodRating = v)),
                  _buildDimensionRating('🧹  Cleanliness', _cleanlinessRating, (v) => setState(() => _cleanlinessRating = v)),
                  _buildDimensionRating('💰  Value for Money', _valueRating, (v) => setState(() => _valueRating = v)),
                  _buildDimensionRating('🌟  Overall Experience', _experienceRating, (v) => setState(() => _experienceRating = v)),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Comment
            Text('Your Review', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(
              controller: _commentCtrl,
              maxLines: 5,
              maxLength: 1000,
              decoration: InputDecoration(
                hintText: 'Share your experience, tips, and opinions...',
                hintStyle: GoogleFonts.inter(color: Colors.grey.shade400),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitReview,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E1E1E),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                    : Text('Submit Review', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildDimensionRating(String label, double value, ValueChanged<double> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Expanded(child: Text(label, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500))),
          Row(
            children: List.generate(5, (i) => GestureDetector(
              onTap: () => onChanged(i + 1.0),
              child: Icon(
                i < value ? Icons.star_rounded : Icons.star_outline_rounded,
                color: Colors.amber,
                size: 22,
              ),
            )),
          ),
        ],
      ),
    );
  }
}

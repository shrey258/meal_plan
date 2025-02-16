import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../providers/meal_provider.dart';
import 'package:provider/provider.dart';
import '../services/image_cache_service.dart';

class MealItemCard extends StatefulWidget {
  final MealItem meal;
  final String day;
  final bool isDraggable;

  const MealItemCard({
    super.key,
    required this.meal,
    required this.day,
    this.isDraggable = false,
  });

  @override
  State<MealItemCard> createState() => _MealItemCardState();
}

class _MealItemCardState extends State<MealItemCard> {
  ImageProvider? _cachedImage;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    try {
      if (!mounted) return;
      final image = await ImageCacheService.getImage(widget.meal.imageUrl);
      if (!mounted) return;
      setState(() {
        _cachedImage = image;
        _isLoading = false;
        _hasError = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  Widget _buildImage() {
    if (_isLoading) {
      return Container(
        color: Colors.grey[100],
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.grey[400],
            strokeWidth: 2,
          ),
        ),
      );
    }

    if (_hasError || _cachedImage == null) {
      return Container(
        color: Colors.grey[200],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant,
              color: Colors.grey[400],
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              'Image not available',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    return Image(
      image: _cachedImage!,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey[200],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.grey[400],
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                'Error loading image',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('MealItemCard: Building card for ${widget.meal.name} (ID: ${widget.meal.id}) on ${widget.day}');
    
    Widget mainCard = Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              height: 150,
              width: double.infinity,
              child: _buildImage(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.meal.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.meal.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.local_fire_department_outlined, 
                         size: 16, 
                         color: Colors.orange[700]),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.meal.calories} cal',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.orange[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.meal.ingredients.map((ingredient) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.grey[300]!,
                        ),
                      ),
                      child: Text(
                        ingredient,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[800],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (!widget.isDraggable) {
      return DragTarget<Map<String, String>>(
        onWillAccept: (data) {
          return data != null && data['day'] != widget.day;
        },
        onAccept: (data) {
          final provider = Provider.of<MealProvider>(context, listen: false);
          provider.moveMeal(
            sourceDay: data['day']!,
            mealId: data['id']!,
            targetDay: widget.day,
          );
        },
        builder: (context, candidateData, rejectedData) {
          return mainCard;
        },
      );
    }

    return LongPressDraggable<Map<String, String>>(
      data: {
        'day': widget.day,
        'id': widget.meal.id,
      },
      feedback: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: mainCard,
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: mainCard,
      ),
      delay: const Duration(milliseconds: 300),
      child: mainCard,
    );
  }
}

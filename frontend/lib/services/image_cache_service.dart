import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;

class ImageCacheService {
  static final Map<String, ImageProvider> _cache = {};
  static const int _maxCacheSize = 20; // Maximum number of images to cache

  static Future<ImageProvider> getImage(String url) async {
    // Check if image is in cache
    if (_cache.containsKey(url)) {
      return _cache[url]!;
    }

    // If cache is full, remove oldest entry
    if (_cache.length >= _maxCacheSize) {
      _cache.remove(_cache.keys.first);
    }

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // Create memory efficient image provider
        final provider = MemoryImage(response.bodyBytes);
        _cache[url] = provider;
        return provider;
      }
    } catch (e) {
      print('Error loading image: $e');
    }

    throw Exception('Failed to load image');
  }

  static void clearCache() {
    _cache.clear();
  }
}

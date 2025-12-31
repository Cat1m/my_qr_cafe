// lib/features/custom_qr/data/repositories/bank_repository.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/bank_model.dart'; // Make sure to import your model correctly

class BankRepository {
  static const String _baseUrl = 'https://api.vietqr.io/v2/banks';

  /// Fetches the list of banks from VietQR API
  Future<List<Bank>> getBanks() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        // Decode the UTF8 response
        final Map<String, dynamic> jsonBody = json.decode(
          utf8.decode(response.bodyBytes),
        );

        // Parse into our response model
        final bankResponse = BankResponse.fromJson(jsonBody);

        // Check if the business code is "00" (Success)
        if (bankResponse.code == "00") {
          return bankResponse.data;
        } else {
          throw Exception('API Error: ${bankResponse.desc}');
        }
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load banks: $e');
    }
  }
}

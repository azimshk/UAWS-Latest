import 'dart:convert';
import 'package:flutter/services.dart';
import '../shared/models/models.dart';

/// Test service to verify all models work correctly with dummy data
class ModelTestService {
  /// Test bite case model with dummy data
  static Future<void> testBiteCaseModel() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'dummyData/biteCases.json',
      );
      final List<dynamic> jsonList = json.decode(jsonString);

      final biteCases = jsonList
          .map((json) => BiteCaseModel.fromJson(json))
          .toList();

      print('✅ Successfully loaded ${biteCases.length} bite cases');
      if (biteCases.isNotEmpty) {
        print('   First case: ${biteCases.first.victimDetails.name}');
      }
    } catch (e) {
      print('❌ Error testing bite case model: $e');
    }
  }

  /// Test quarantine model with dummy data
  static Future<void> testQuarantineModel() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'dummyData/quarantineRecords.json',
      );
      final List<dynamic> jsonList = json.decode(jsonString);

      final quarantineRecords = jsonList
          .map((json) => QuarantineRecordModel.fromJson(json))
          .toList();

      print(
        '✅ Successfully loaded ${quarantineRecords.length} quarantine records',
      );
      if (quarantineRecords.isNotEmpty) {
        final first = quarantineRecords.first;
        print(
          '   First record: ${first.animalInfo.species.name} - Day ${first.currentObservationDay}',
        );
      }
    } catch (e) {
      print('❌ Error testing quarantine model: $e');
    }
  }

  /// Test education campaign model with dummy data
  static Future<void> testEducationModel() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'dummyData/educationCampaigns.json',
      );
      final List<dynamic> jsonList = json.decode(jsonString);

      final campaigns = jsonList
          .map((json) => EducationCampaignModel.fromJson(json))
          .toList();

      print('✅ Successfully loaded ${campaigns.length} education campaigns');
      if (campaigns.isNotEmpty) {
        final first = campaigns.first;
        print(
          '   First campaign: ${first.campaignTypeDisplayName} - ${first.participantsReached} participants',
        );
      }
    } catch (e) {
      print('❌ Error testing education model: $e');
    }
  }

  /// Test rabies case model with dummy data
  static Future<void> testRabiesModel() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'dummyData/rabiesCases.json',
      );
      final List<dynamic> jsonList = json.decode(jsonString);

      final rabiesCases = jsonList
          .map((json) => RabiesCaseModel.fromJson(json))
          .toList();

      print('✅ Successfully loaded ${rabiesCases.length} rabies cases');
      if (rabiesCases.isNotEmpty) {
        final first = rabiesCases.first;
        print(
          '   First case: ${first.suspicionLevelDisplayName} risk - ${first.statusSummary}',
        );
      }
    } catch (e) {
      print('❌ Error testing rabies model: $e');
    }
  }

  /// Test ward model with dummy data
  static Future<void> testWardModel() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'dummyData/wards.json',
      );
      final List<dynamic> jsonList = json.decode(jsonString);

      final wards = jsonList.map((json) => WardModel.fromJson(json)).toList();

      print('✅ Successfully loaded ${wards.length} wards');
      if (wards.isNotEmpty) {
        final first = wards.first;
        print('   First ward: ${first.displayName} - ${first.formattedArea}');
      }
    } catch (e) {
      print('❌ Error testing ward model: $e');
    }
  }

  /// Test ward boundaries model with dummy data
  static Future<void> testWardBoundariesModel() async {
    try {
      final String jsonString = await rootBundle.loadString(
        'dummyData/wardBoundaries.json',
      );
      final Map<String, dynamic> jsonMap = json.decode(jsonString);

      final boundaries = WardBoundariesCollection.fromJson(jsonMap);

      print(
        '✅ Successfully loaded ward boundaries with ${boundaries.features.length} features',
      );
      print('   Ward IDs: ${boundaries.allWardIds.join(', ')}');
    } catch (e) {
      print('❌ Error testing ward boundaries model: $e');
    }
  }

  /// Run all model tests
  static Future<void> runAllTests() async {
    print('🧪 Testing all models with dummy data...\n');

    await testBiteCaseModel();
    await testQuarantineModel();
    await testEducationModel();
    await testRabiesModel();
    await testWardModel();
    await testWardBoundariesModel();

    print('\n✅ Model testing completed!');
  }
}

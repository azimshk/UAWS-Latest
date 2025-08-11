// Common animal information model used across multiple modules

// Enum for animal species
enum AnimalSpecies { dog, cat, other }

// Enum for animal sex
enum AnimalSex { male, female, unknown }

// Enum for animal age category
enum AnimalAge {
  puppy, // 0-6 months
  young, // 6-18 months
  adult, // 18 months - 8 years
  senior, // 8+ years
  unknown,
}

// Enum for animal size
enum AnimalSize { small, medium, large, extraLarge }

// Animal information model
class AnimalInfo {
  final AnimalSpecies species;
  final AnimalSex sex;
  final AnimalAge age;
  final String color;
  final AnimalSize size;
  final String? identificationMarks;
  final String? tagNumber;
  final String? cageNumber;
  final bool isPregnant;
  final String? healthCondition;
  final String? breed;
  final double? weight;
  final bool isVaccinated;
  final String? microchipNumber;

  AnimalInfo({
    required this.species,
    required this.sex,
    required this.age,
    required this.color,
    required this.size,
    this.identificationMarks,
    this.tagNumber,
    this.cageNumber,
    this.isPregnant = false,
    this.healthCondition,
    this.breed,
    this.weight,
    this.isVaccinated = false,
    this.microchipNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'species': species.name,
      'sex': sex.name,
      'age': age.name,
      'color': color,
      'size': size.name,
      'identificationMarks': identificationMarks,
      'tagNumber': tagNumber,
      'cageNumber': cageNumber,
      'isPregnant': isPregnant,
      'healthCondition': healthCondition,
      'breed': breed,
      'weight': weight,
      'isVaccinated': isVaccinated,
      'microchipNumber': microchipNumber,
    };
  }

  factory AnimalInfo.fromJson(Map<String, dynamic> json) {
    return AnimalInfo(
      species: AnimalSpecies.values.firstWhere(
        (e) => e.name == json['species'],
        orElse: () => AnimalSpecies.other,
      ),
      sex: AnimalSex.values.firstWhere(
        (e) => e.name == json['sex'],
        orElse: () => AnimalSex.unknown,
      ),
      age: AnimalAge.values.firstWhere(
        (e) => e.name == json['age'],
        orElse: () => AnimalAge.unknown,
      ),
      color: json['color'] ?? '',
      size: AnimalSize.values.firstWhere(
        (e) => e.name == json['size'],
        orElse: () => AnimalSize.medium,
      ),
      identificationMarks: json['identificationMarks'],
      tagNumber: json['tagNumber'],
      cageNumber: json['cageNumber'],
      isPregnant: json['isPregnant'] ?? false,
      healthCondition: json['healthCondition'],
      breed: json['breed'],
      weight: json['weight']?.toDouble(),
      isVaccinated: json['isVaccinated'] ?? false,
      microchipNumber: json['microchipNumber'],
    );
  }

  AnimalInfo copyWith({
    AnimalSpecies? species,
    AnimalSex? sex,
    AnimalAge? age,
    String? color,
    AnimalSize? size,
    String? identificationMarks,
    String? tagNumber,
    String? cageNumber,
    bool? isPregnant,
    String? healthCondition,
    String? breed,
    double? weight,
    bool? isVaccinated,
    String? microchipNumber,
  }) {
    return AnimalInfo(
      species: species ?? this.species,
      sex: sex ?? this.sex,
      age: age ?? this.age,
      color: color ?? this.color,
      size: size ?? this.size,
      identificationMarks: identificationMarks ?? this.identificationMarks,
      tagNumber: tagNumber ?? this.tagNumber,
      cageNumber: cageNumber ?? this.cageNumber,
      isPregnant: isPregnant ?? this.isPregnant,
      healthCondition: healthCondition ?? this.healthCondition,
      breed: breed ?? this.breed,
      weight: weight ?? this.weight,
      isVaccinated: isVaccinated ?? this.isVaccinated,
      microchipNumber: microchipNumber ?? this.microchipNumber,
    );
  }

  @override
  String toString() {
    return 'AnimalInfo{species: $species, sex: $sex, age: $age, color: $color, tagNumber: $tagNumber}';
  }

  // Helper methods
  String get displayName {
    final speciesName = species.name.replaceFirst(
      species.name[0],
      species.name[0].toUpperCase(),
    );
    final sexName = sex.name.replaceFirst(
      sex.name[0],
      sex.name[0].toUpperCase(),
    );
    return '$speciesName ($sexName)';
  }

  String get ageDisplayName {
    switch (age) {
      case AnimalAge.puppy:
        return 'Puppy (0-6 months)';
      case AnimalAge.young:
        return 'Young (6-18 months)';
      case AnimalAge.adult:
        return 'Adult (18 months - 8 years)';
      case AnimalAge.senior:
        return 'Senior (8+ years)';
      case AnimalAge.unknown:
        return 'Unknown age';
    }
  }

  String get sizeDisplayName {
    switch (size) {
      case AnimalSize.small:
        return 'Small';
      case AnimalSize.medium:
        return 'Medium';
      case AnimalSize.large:
        return 'Large';
      case AnimalSize.extraLarge:
        return 'Extra Large';
    }
  }
}

# UAWS Field Mobile App - Technical Specification

## 📱 **Application Overview**

**App Name:** UAWS Field Tracker  
**Target Users:** Layer 1 (Field Staff - Catchers, Vaccinators, LSS)  
**Platform:** Cross-platform (Android & iOS)  
**Primary Purpose:** Offline-first data collection for field operations

---

## 🎯 **Core Features**

### **1. Authentication & User Management**

-   **Firebase Authentication** with email/phone
-   **Role-based access** (Layer 1 only)
-   **Offline authentication** caching
-   **Auto-logout** after inactivity

### **2. Sterilization Tracker (Pickup Stage Only)**

-   **Animal Details Form:**

    -   Species (Dog/Cat) - Radio buttons
    -   Sex (Male/Female/Unnoticed) - Radio buttons
    -   Age Group (Puppy/Juvenile/Adult/Senior) - Dropdown
    -   Ward/Zone - Dropdown (cached from server)
    -   Tag Number - Manual text input
    -   Cage Number - Manual text input
    -   Identification Marks - Text area

-   **Mandatory Data Capture:**
    -   **GPS Location** (auto-captured)
    -   **Photo Upload** (camera integration)
    -   **Pickup Date/Time** (auto-timestamp)
    -   **Picked By** (auto-filled from user profile)

### **3. Vaccination Tracker (Full Access)**

-   **Animal Details:** Same as sterilization
-   **Vaccination Details:**
    -   Vaccine Type (Rabies/DHPP/Others) - Dropdown
    -   Vaccination Date - Date picker
    -   Next Due Date - Auto-calculated + manual override
    -   Batch Number - Text input
    -   Veterinarian - Dropdown (pre-loaded list)
    -   Location Address - Text input
    -   GPS - Auto-captured
    -   Photo - Camera integration
    -   Notes - Text area

### **4. Offline Capabilities**

-   **SQLite local database** for offline storage
-   **Auto-sync** when internet available
-   **Conflict resolution** for data sync
-   **Offline photo storage** with compression
-   **Background sync** service

### **5. Camera & GPS Integration**

-   **Native camera** with photo compression
-   **GPS tracking** with accuracy validation
-   **Location services** permission handling
-   **Photo metadata** (GPS coordinates, timestamp)

---

## 🛠️ **Technical Stack**

### **Frontend Framework**

```
Flutter 3.19+
- Cross-platform development (Android & iOS)
- Native performance with Dart compilation
- Hot reload for fast development
- Excellent Firebase integration
- Rich widget ecosystem
```

### **State Management**

```
Riverpod 2.4+
- Modern reactive state management
- Compile-time safety
- Easy testing
- Provider pattern with auto-disposal
```

### **Database**

```
SQLite (Local) + Cloud Firestore (Remote)
- Offline-first architecture with sqflite
- Real-time synchronization with Firestore
- Conflict resolution (server wins strategy)
- Local caching with Hive for user preferences

Firestore Collections (Sync Target):
- sterilizations (pickup stage only)
- vaccination_tracker (full access)
- users (auth and profile data)
```

### **Key Dependencies**

```yaml
# pubspec.yaml
dependencies:
    flutter:
        sdk: flutter

    # State Management
    flutter_riverpod: ^2.4.9
    riverpod_annotation: ^2.3.3

    # Firebase
    firebase_core: ^2.24.2
    firebase_auth: ^4.15.3
    firebase_firestore: ^4.13.6
    firebase_storage: ^11.5.6

    # Local Database
    sqflite: ^2.3.0
    hive: ^2.2.3
    hive_flutter: ^1.1.0

    # Location & Camera
    geolocator: ^10.1.0
    permission_handler: ^11.1.0
    image_picker: ^1.0.4
    image: ^4.1.3

    # UI Components
    material_design_icons_flutter: ^7.0.7296
    cached_network_image: ^3.3.0
    flutter_spinkit: ^5.2.0

    # Forms & Validation
    flutter_form_builder: ^9.1.1
    form_builder_validators: ^9.1.0

    # Internationalization
    flutter_localizations:
        sdk: flutter
    intl: ^0.18.1

    # Utilities
    connectivity_plus: ^5.0.2
    shared_preferences: ^2.2.2
    path_provider: ^2.1.1
    uuid: ^4.2.1

dev_dependencies:
    flutter_test:
        sdk: flutter
    build_runner: ^2.4.7
    riverpod_generator: ^2.3.9
    hive_generator: ^2.0.1
    json_annotation: ^4.8.1
    json_serializable: ^6.7.1
```

---

## 📁 **App Architecture**

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/
│   │   ├── app_constants.dart
│   │   ├── api_constants.dart
│   │   └── database_constants.dart
│   ├── theme/
│   │   ├── app_theme.dart
│   │   ├── colors.dart
│   │   └── text_styles.dart
│   ├── utils/
│   │   ├── validators.dart
│   │   ├── date_utils.dart
│   │   ├── image_utils.dart
│   │   └── extensions.dart
│   ├── errors/
│   │   ├── exceptions.dart
│   │   └── failures.dart
│   └── network/
│       ├── network_info.dart
│       └── api_client.dart
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository_impl.dart
│   │   │   └── datasources/
│   │   │       ├── auth_remote_datasource.dart
│   │   │       └── auth_local_datasource.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── login_user.dart
│   │   │       ├── logout_user.dart
│   │   │       └── get_current_user.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── auth_provider.dart
│   │       ├── pages/
│   │       │   ├── login_page.dart
│   │       │   └── profile_page.dart
│   │       └── widgets/
│   │           ├── login_form.dart
│   │           └── profile_avatar.dart
│   ├── sterilization/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── sterilization_model.dart
│   │   │   ├── repositories/
│   │   │   │   └── sterilization_repository_impl.dart
│   │   │   └── datasources/
│   │   │       ├── sterilization_remote_datasource.dart
│   │   │       └── sterilization_local_datasource.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── sterilization.dart
│   │   │   ├── repositories/
│   │   │   │   └── sterilization_repository.dart
│   │   │   └── usecases/
│   │   │       ├── create_sterilization.dart
│   │   │       ├── get_sterilizations.dart
│   │   │       └── sync_sterilizations.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── sterilization_provider.dart
│   │       ├── pages/
│   │       │   ├── sterilization_list_page.dart
│   │       │   ├── add_sterilization_page.dart
│   │       │   └── sterilization_detail_page.dart
│   │       └── widgets/
│   │           ├── sterilization_form.dart
│   │           ├── sterilization_card.dart
│   │           └── animal_details_form.dart
│   ├── vaccination/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── vaccination_model.dart
│   │   │   ├── repositories/
│   │   │   │   └── vaccination_repository_impl.dart
│   │   │   └── datasources/
│   │   │       ├── vaccination_remote_datasource.dart
│   │   │       └── vaccination_local_datasource.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── vaccination.dart
│   │   │   ├── repositories/
│   │   │   │   └── vaccination_repository.dart
│   │   │   └── usecases/
│   │   │       ├── create_vaccination.dart
│   │   │       ├── get_vaccinations.dart
│   │   │       └── sync_vaccinations.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── vaccination_provider.dart
│   │       ├── pages/
│   │       │   ├── vaccination_list_page.dart
│   │       │   ├── add_vaccination_page.dart
│   │       │   └── vaccination_detail_page.dart
│   │       └── widgets/
│   │           ├── vaccination_form.dart
│   │           ├── vaccination_card.dart
│   │           └── vaccine_type_selector.dart
│   └── shared/
│       ├── widgets/
│       │   ├── custom_button.dart
│       │   ├── custom_text_field.dart
│       │   ├── camera_widget.dart
│       │   ├── gps_capture_widget.dart
│       │   ├── offline_indicator.dart
│       │   └── loading_widget.dart
│       ├── services/
│       │   ├── database_service.dart
│       │   ├── location_service.dart
│       │   ├── camera_service.dart
│       │   ├── sync_service.dart
│       │   └── storage_service.dart
│       └── models/
│           ├── gps_location.dart
│           └── api_response.dart
├── l10n/
│   ├── app_en.arb
│   ├── app_mr.arb
│   └── l10n.dart
└── generated/
    ├── l10n/
    └── assets.dart
```

---

## 🔄 **Data Flow & Sync Strategy**

### **Cross-Platform Database Consistency**

```dart
// Field Value Standards (Must Match Web Dashboard)
enum Species { dog, cat }
enum Sex { male, female, unnoticed }
enum AgeGroup { puppyKitten, young, adult, senior }
enum VaccineType { rabies, dhpp, others }
enum AnimalCondition { healthy, injured, sick }

// Firestore Collection Names (Shared with Web Dashboard)
const Collections = {
  sterilizations: 'sterilizations',
  vaccinations: 'vaccination_tracker',
  users: 'users',
  cities: 'cities',
  hospitals: 'hospitals'
};
```

### **Mobile App Access Restrictions**

```dart
// Layer 1 (Field Staff) - Mobile App Permissions
- sterilizations: CREATE (pickup stage only), READ (own records)
- vaccination_tracker: CREATE, READ, UPDATE, DELETE (full access)
- users: READ (own profile only)
- biteCases: NO ACCESS (Web Dashboard only - Layer 2+)
- quarantineRecords: NO ACCESS (Web Dashboard only - Layer 2+)
- rabiesCases: NO ACCESS (Web Dashboard only - Layer 2+)
- educationCampaigns: NO ACCESS (Web Dashboard only - Layer 2+)
```

### **Offline-First Architecture**

```dart
// Sync Strategy using Riverpod
1. User creates entry → Save to SQLite via Repository
2. SyncService checks internet connectivity
3. If online → Sync to Firestore
4. Mark local record as synced
5. Download updates from server
6. Resolve conflicts (server wins)
```

### **SQLite Schema (using sqflite)**

```sql
-- Sterilizations Table (Pickup Stage Only)
CREATE TABLE sterilizations (
    id TEXT PRIMARY KEY,
    species TEXT NOT NULL, -- 'Dog' | 'Cat'
    sex TEXT NOT NULL, -- 'Male' | 'Female' | 'Unnoticed'
    age_group TEXT NOT NULL, -- 'Puppy/Kitten' | 'Young' | 'Adult' | 'Senior'
    ward TEXT NOT NULL,
    zone TEXT,
    tag_number TEXT NOT NULL,
    cage_number TEXT,
    identification_marks TEXT,
    pickup_date_time INTEGER NOT NULL,
    pickup_photo_url TEXT NOT NULL,
    pickup_lat REAL NOT NULL,
    pickup_lng REAL NOT NULL,
    picked_by TEXT NOT NULL,
    pickup_vehicle_used TEXT,
    pickup_condition TEXT, -- 'Healthy' | 'Injured' | 'Sick'
    pickup_notes TEXT,
    pickup_complications TEXT,
    created_at INTEGER NOT NULL,
    created_by TEXT NOT NULL,
    synced INTEGER DEFAULT 0,
    last_modified INTEGER NOT NULL
);

-- Vaccinations Table (Full Module Access)
CREATE TABLE vaccinations (
    id TEXT PRIMARY KEY,
    species TEXT NOT NULL, -- 'Dog' | 'Cat'
    sex TEXT NOT NULL, -- 'Male' | 'Female' | 'Unnoticed'
    age_group TEXT NOT NULL, -- 'Puppy/Kitten' | 'Young' | 'Adult' | 'Senior'
    ward TEXT NOT NULL,
    zone TEXT,
    tag_number TEXT,
    identification_marks TEXT,
    vaccine_type TEXT NOT NULL, -- 'Rabies' | 'DHPP' | 'Others'
    vaccination_date INTEGER NOT NULL,
    next_due_date INTEGER,
    batch_number TEXT,
    veterinarian_id TEXT,
    location_address TEXT,
    location_lat REAL NOT NULL,
    location_lng REAL NOT NULL,
    photo_url TEXT,
    notes TEXT,
    created_at INTEGER NOT NULL,
    created_by TEXT NOT NULL,
    synced INTEGER DEFAULT 0,
    last_modified INTEGER NOT NULL
);

-- Sync Queue Table
CREATE TABLE sync_queue (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    table_name TEXT NOT NULL,
    record_id TEXT NOT NULL,
    action TEXT NOT NULL, -- 'INSERT', 'UPDATE', 'DELETE'
    data TEXT, -- JSON data
    created_at INTEGER NOT NULL,
    attempts INTEGER DEFAULT 0,
    last_error TEXT
);
```

### **Riverpod State Management Example**

```dart
// Data Models
@freezed
class Sterilization with _$Sterilization {
  const factory Sterilization({
    required String id,
    required Species species,
    required Sex sex,
    required AgeGroup ageGroup,
    required String ward,
    String? zone,
    required String tagNumber,
    String? cageNumber,
    String? identificationMarks,
    required DateTime pickupDateTime,
    required String pickupPhotoUrl,
    required GpsLocation pickupGps,
    required String pickedBy,
    required DateTime createdAt,
    required String createdBy,
    @Default(false) bool synced,
    required DateTime lastModified,
  }) = _Sterilization;

  factory Sterilization.fromJson(Map<String, dynamic> json) =>
      _$SterilizationFromJson(json);
}

// Repository Provider
@riverpod
SterilizationRepository sterilizationRepository(SterilizationRepositoryRef ref) {
  final localDb = ref.watch(localDatabaseProvider);
  final firestore = ref.watch(firestoreProvider);
  return SterilizationRepositoryImpl(localDb, firestore);
}

// State Provider
@riverpod
class SterilizationNotifier extends _$SterilizationNotifier {
  @override
  Future<List<Sterilization>> build() async {
    final repository = ref.read(sterilizationRepositoryProvider);
    return repository.getAllSterilizations();
  }

  Future<void> addSterilization(Sterilization sterilization) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(sterilizationRepositoryProvider);
      await repository.createSterilization(sterilization);

      // Trigger sync if online
      ref.read(syncServiceProvider).syncSterilizations();

      return repository.getAllSterilizations();
    });
  }
}
```

---

## 🔐 **Security Implementation**

### **Firebase Authentication**

```dart
// Firebase Auth with custom claims
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  Future<User?> build() async {
    final auth = FirebaseAuth.instance;
    return auth.currentUser;
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Get custom claims
      final token = await credential.user?.getIdTokenResult();
      final userRole = token?.claims?['role'] as String?; // 'field_staff'
      final userLayer = token?.claims?['layer'] as String?; // 'Layer1'

      return credential.user;
    });
  }
}
```

### **Data Validation with Form Builder**

```dart
// Form validation using flutter_form_builder
class SterilizationForm extends ConsumerWidget {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          FormBuilderDropdown<Species>(
            name: 'species',
            decoration: const InputDecoration(labelText: 'Species'),
            validator: FormBuilderValidators.required(),
            items: Species.values
                .map((species) => DropdownMenuItem(
                      value: species,
                      child: Text(species.name),
                    ))
                .toList(),
          ),
          FormBuilderDropdown<Sex>(
            name: 'sex',
            decoration: const InputDecoration(labelText: 'Sex'),
            validator: FormBuilderValidators.required(),
            items: Sex.values
                .map((sex) => DropdownMenuItem(
                      value: sex,
                      child: Text(sex.name),
                    ))
                .toList(),
          ),
          FormBuilderTextField(
            name: 'tagNumber',
            decoration: const InputDecoration(labelText: 'Tag Number'),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.maxLength(20),
            ]),
          ),
          // Photo capture widget (mandatory)
          FormBuilderField<String>(
            name: 'pickupPhoto',
            validator: (value) => value?.isEmpty ?? true
                ? 'Photo is mandatory'
                : null,
            builder: (field) => CameraWidget(
              onPhotoTaken: (photoPath) => field.didChange(photoPath),
              errorText: field.errorText,
            ),
          ),
          // GPS location (mandatory)
          FormBuilderField<GpsLocation>(
            name: 'gpsLocation',
            validator: (value) => value == null
                ? 'GPS location is required'
                : null,
            builder: (field) => GpsCaptureWidget(
              onLocationCaptured: (location) => field.didChange(location),
              errorText: field.errorText,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom validators
class AppValidators {
  static String? tagNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tag number is required';
    }
    if (value.length > 20) {
      return 'Tag number must be less than 20 characters';
    }
    return null;
  }

  static String? identificationMarks(String? value) {
    if (value != null && value.length > 500) {
      return 'Identification marks must be less than 500 characters';
    }
    return null;
  }
}
```

---

## 🌐 **Localization (Marathi + English)**

### **ARB Files (Application Resource Bundle)**

```json
// l10n/app_en.arb
{
  "@@locale": "en",
  "appTitle": "UAWS Field Tracker",
  "sterilizationTitle": "Sterilization Tracker",
  "species": "Species",
  "sex": "Sex",
  "ageGroup": "Age Group",
  "ward": "Ward",
  "tagNumber": "Tag Number",
  "takePhoto": "Take Photo",
  "photoRequired": "Photo is mandatory",
  "gpsRequired": "GPS location is required",
  "dog": "Dog",
  "cat": "Cat",
  "male": "Male",
  "female": "Female",
  "unnoticed": "Unnoticed",
  "puppy": "Puppy",
  "juvenile": "Juvenile",
  "adult": "Adult",
  "senior": "Senior",
  "save": "Save",
  "cancel": "Cancel",
  "submit": "Submit",
  "login": "Login",
  "logout": "Logout",
  "offline": "Offline",
  "syncing": "Syncing...",
  "syncComplete": "Sync Complete"
}

// l10n/app_mr.arb
{
  "@@locale": "mr",
  "appTitle": "UAWS फील्ड ट्रॅकर",
  "sterilizationTitle": "नसबंदी ट्रॅकर",
  "species": "प्रजाती",
  "sex": "लिंग",
  "ageGroup": "वयोगट",
  "ward": "प्रभाग",
  "tagNumber": "टॅग क्रमांक",
  "takePhoto": "फोटो घ्या",
  "photoRequired": "फोटो आवश्यक आहे",
  "gpsRequired": "GPS स्थान आवश्यक आहे",
  "dog": "कुत्रा",
  "cat": "मांजर",
  "male": "नर",
  "female": "मादी",
  "unnoticed": "लक्षात न आलेले",
  "puppy": "पिल्लू",
  "juvenile": "तरुण",
  "adult": "प्रौढ",
  "senior": "वृद्ध",
  "save": "सेव्ह करा",
  "cancel": "रद्द करा",
  "submit": "सबमिट करा",
  "login": "लॉगिन",
  "logout": "लॉगआउट",
  "offline": "ऑफलाइन",
  "syncing": "सिंक होत आहे...",
  "syncComplete": "सिंक पूर्ण झाले"
}
```

### **Usage in Widgets**

```dart
// Using localization in widgets
class SterilizationPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.sterilizationTitle),
      ),
      body: Column(
        children: [
          Text(l10n.species),
          Text(l10n.sex),
          Text(l10n.ageGroup),
          ElevatedButton(
            onPressed: () => _takePhoto(),
            child: Text(l10n.takePhoto),
          ),
        ],
      ),
    );
  }
}

// Language selection provider
@riverpod
class LocaleNotifier extends _$LocaleNotifier {
  @override
  Locale build() {
    // Load saved locale from SharedPreferences
    final savedLocale = ref.read(sharedPreferencesProvider)
        .getString('locale') ?? 'en';
    return Locale(savedLocale);
  }

  void changeLocale(String languageCode) {
    state = Locale(languageCode);
    // Save to SharedPreferences
    ref.read(sharedPreferencesProvider)
        .setString('locale', languageCode);
  }
}
```

---

## 📊 **Performance Optimizations**

### **Image Handling**

```dart
// Image compression and optimization
import 'package:image/image.dart' as img;

class ImageService {
  static Future<File> compressImage(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) throw Exception('Invalid image format');

    // Resize to max 1024x1024 while maintaining aspect ratio
    final resized = img.copyResize(
      image,
      width: image.width > 1024 ? 1024 : null,
      height: image.height > 1024 ? 1024 : null,
    );

    // Compress to JPEG with 70% quality
    final compressedBytes = img.encodeJpg(resized, quality: 70);

    // Save compressed image
    final directory = await getTemporaryDirectory();
    final compressedFile = File('${directory.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg');
    await compressedFile.writeAsBytes(compressedBytes);

    return compressedFile;
  }
}

// Camera widget with compression
class CameraWidget extends ConsumerWidget {
  final Function(String) onPhotoTaken;
  final String? errorText;

  const CameraWidget({
    required this.onPhotoTaken,
    this.errorText,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () => _takePicture(ref),
          icon: const Icon(Icons.camera_alt),
          label: Text(AppLocalizations.of(context)!.takePhoto),
        ),
        if (errorText != null)
          Text(
            errorText!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
      ],
    );
  }

  Future<void> _takePicture(WidgetRef ref) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );

    if (image != null) {
      final compressedImage = await ImageService.compressImage(File(image.path));
      onPhotoTaken(compressedImage.path);
    }
  }
}
```

### **GPS Optimization**

```dart
// GPS service with battery optimization
class LocationService {
  static const LocationSettings _locationSettings = LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 1, // Only update if moved 1 meter
  );

  static Future<Position?> getCurrentLocation() async {
    try {
      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      // Get current position with timeout
      return await Geolocator.getCurrentPosition(
        locationSettings: _locationSettings,
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw TimeoutException('GPS timeout'),
      );
    } catch (e) {
      debugPrint('Location error: $e');
      return null;
    }
  }
}

// GPS capture widget
class GpsCaptureWidget extends ConsumerWidget {
  final Function(GpsLocation) onLocationCaptured;
  final String? errorText;

  const GpsCaptureWidget({
    required this.onLocationCaptured,
    this.errorText,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationState = ref.watch(locationProvider);

    return locationState.when(
      data: (position) => Card(
        child: ListTile(
          leading: const Icon(Icons.location_on, color: Colors.green),
          title: const Text('GPS Location Captured'),
          subtitle: Text('Lat: ${position.latitude.toStringAsFixed(6)}\n'
                        'Lng: ${position.longitude.toStringAsFixed(6)}'),
          trailing: IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _refreshLocation(ref),
          ),
        ),
      ),
      loading: () => const Card(
        child: ListTile(
          leading: CircularProgressIndicator(),
          title: Text('Getting GPS location...'),
        ),
      ),
      error: (error, _) => Card(
        child: ListTile(
          leading: const Icon(Icons.location_off, color: Colors.red),
          title: const Text('GPS Error'),
          subtitle: Text(error.toString()),
          trailing: IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _refreshLocation(ref),
          ),
        ),
      ),
    );
  }

  void _refreshLocation(WidgetRef ref) {
    ref.invalidate(locationProvider);
  }
}

// Location provider
@riverpod
Future<Position> location(LocationRef ref) async {
  final position = await LocationService.getCurrentLocation();
  if (position == null) {
    throw Exception('Could not get location');
  }
  return position;
}
```

### **Data Sync Optimization**

```dart
// Batch sync with exponential backoff
class SyncService {
  static const int _maxRetries = 3;
  static const int _batchSize = 50;
  static const Duration _baseDelay = Duration(seconds: 1);

  static Future<void> syncWithRetry() async {
    for (int attempt = 0; attempt < _maxRetries; attempt++) {
      try {
        await _performSync();
        break; // Success, exit retry loop
      } catch (e) {
        if (attempt == _maxRetries - 1) {
          // Last attempt failed
          throw e;
        }

        // Exponential backoff
        final delay = _baseDelay * math.pow(2, attempt);
        await Future.delayed(delay);
      }
    }
  }

  static Future<void> _performSync() async {
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      throw Exception('No internet connection');
    }

    // Sync sterilizations in batches
    await _syncTable('sterilizations', _batchSize);
    await _syncTable('vaccinations', _batchSize);
  }

  static Future<void> _syncTable(String tableName, int batchSize) async {
    final db = await DatabaseService.database;
    final unsyncedRecords = await db.query(
      tableName,
      where: 'synced = ?',
      whereArgs: [0],
      limit: batchSize,
    );

    for (final record in unsyncedRecords) {
      try {
        // Upload to Firestore
        await FirebaseFirestore.instance
            .collection(tableName)
            .doc(record['id'] as String)
            .set(record);

        // Mark as synced
        await db.update(
          tableName,
          {'synced': 1},
          where: 'id = ?',
          whereArgs: [record['id']],
        );
      } catch (e) {
        debugPrint('Sync error for ${record['id']}: $e');
        // Continue with next record
      }
    }
  }
}
```

---

## 🧪 **Testing Strategy**

### **Testing Dependencies**

```yaml
dev_dependencies:
    flutter_test:
        sdk: flutter
    integration_test:
        sdk: flutter
    mockito: ^5.4.2
    build_runner: ^2.4.7
    fake_cloud_firestore: ^2.4.1+1
    firebase_auth_mocks: ^0.11.0
    geolocator_mocks: ^0.1.0
```

### **Unit Tests**

```dart
// test/features/sterilization/domain/usecases/create_sterilization_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([SterilizationRepository])
import 'create_sterilization_test.mocks.dart';

void main() {
  late CreateSterilization useCase;
  late MockSterilizationRepository mockRepository;

  setUp(() {
    mockRepository = MockSterilizationRepository();
    useCase = CreateSterilization(mockRepository);
  });

  group('CreateSterilization', () {
    final tSterilization = Sterilization(
      id: '1',
      species: Species.dog,
      sex: Sex.male,
      ageGroup: AgeGroup.adult,
      ward: 'Ward 1',
      tagNumber: 'DOG001',
      pickupDateTime: DateTime.now(),
      pickupPhotoUrl: '/path/to/photo.jpg',
      pickupGps: const GpsLocation(lat: 18.5204, lng: 73.8567),
      pickedBy: 'user123',
      createdAt: DateTime.now(),
      createdBy: 'user123',
      lastModified: DateTime.now(),
    );

    test('should create sterilization successfully', () async {
      // Arrange
      when(mockRepository.createSterilization(any))
          .thenAnswer((_) async => tSterilization);

      // Act
      final result = await useCase(tSterilization);

      // Assert
      expect(result, equals(tSterilization));
      verify(mockRepository.createSterilization(tSterilization));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should throw exception when repository fails', () async {
      // Arrange
      when(mockRepository.createSterilization(any))
          .thenThrow(Exception('Database error'));

      // Act & Assert
      expect(() => useCase(tSterilization), throwsException);
    });
  });
}
```

### **Widget Tests**

```dart
// test/features/sterilization/presentation/widgets/sterilization_form_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('SterilizationForm validates required fields', (tester) async {
    // Build the widget
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: SterilizationForm(),
          ),
        ),
      ),
    );

    // Find the submit button and tap it without filling the form
    final submitButton = find.byType(ElevatedButton);
    await tester.tap(submitButton);
    await tester.pump();

    // Verify validation errors appear
    expect(find.text('Species is required'), findsOneWidget);
    expect(find.text('Sex is required'), findsOneWidget);
    expect(find.text('Tag number is required'), findsOneWidget);
    expect(find.text('Photo is mandatory'), findsOneWidget);
  });

  testWidgets('SterilizationForm submits with valid data', (tester) async {
    bool formSubmitted = false;

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: SterilizationForm(
              onSubmit: (data) => formSubmitted = true,
            ),
          ),
        ),
      ),
    );

    // Fill the form fields
    await tester.tap(find.byKey(const Key('species_dropdown')));
    await tester.pump();
    await tester.tap(find.text('Dog'));
    await tester.pump();

    await tester.tap(find.byKey(const Key('sex_dropdown')));
    await tester.pump();
    await tester.tap(find.text('Male'));
    await tester.pump();

    await tester.enterText(
      find.byKey(const Key('tag_number_field')),
      'DOG001',
    );

    // Mock photo and GPS capture
    // (In real tests, you'd mock these services)

    // Submit the form
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Verify form was submitted
    expect(formSubmitted, isTrue);
  });
}
```

### **Integration Tests**

```dart
// integration_test/app_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:uaws_field_tracker/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    testWidgets('Complete sterilization flow', (tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Login
      await tester.enterText(
        find.byKey(const Key('email_field')),
        'test@uaws.org',
      );
      await tester.enterText(
        find.byKey(const Key('password_field')),
        'password123',
      );
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle();

      // Navigate to sterilization
      await tester.tap(find.byIcon(Icons.medical_services));
      await tester.pumpAndSettle();

      // Add new sterilization
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Fill sterilization form
      await tester.tap(find.byKey(const Key('species_dropdown')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Dog'));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('sex_dropdown')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Male'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('tag_number_field')),
        'TEST001',
      );

      // Take photo (mocked in test environment)
      await tester.tap(find.byKey(const Key('camera_button')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Capture GPS (mocked in test environment)
      await tester.tap(find.byKey(const Key('gps_button')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Submit form
      await tester.tap(find.byKey(const Key('submit_button')));
      await tester.pumpAndSettle();

      // Verify success message
      expect(find.text('Sterilization saved successfully'), findsOneWidget);

      // Verify record appears in list
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
      expect(find.text('TEST001'), findsOneWidget);
    });

    testWidgets('Offline functionality', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Simulate offline mode
      // (This would require mocking connectivity)

      // Create sterilization record while offline
      // Verify it's saved locally
      // Simulate going online
      // Verify sync occurs
    });
  });
}
```

### **Performance Tests**

```dart
// test/performance/image_compression_test.dart
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  group('Image Compression Performance', () {
    test('should compress large image within acceptable time', () async {
      // Create a test image file
      final directory = await getTemporaryDirectory();
      final testImageFile = File('${directory.path}/test_large_image.jpg');

      // Measure compression time
      final stopwatch = Stopwatch()..start();
      final compressedFile = await ImageService.compressImage(testImageFile);
      stopwatch.stop();

      // Verify compression completed within 5 seconds
      expect(stopwatch.elapsedMilliseconds, lessThan(5000));

      // Verify file size reduction
      final originalSize = await testImageFile.length();
      final compressedSize = await compressedFile.length();
      expect(compressedSize, lessThan(originalSize));
    });
  });
}
```

---

## 🚀 **Deployment & Distribution**

### **Build Configuration**

```yaml
# pubspec.yaml
name: uaws_field_tracker
description: UAWS Animal Welfare Field Data Collection App
publish_to: "none"
version: 1.0.0+1

environment:
    sdk: ">=3.0.0 <4.0.0"
    flutter: ">=3.19.0"

flutter:
    uses-material-design: true
    generate: true # Enable l10n generation

    assets:
        - assets/images/
        - assets/icons/

    fonts:
        - family: Roboto
          fonts:
              - asset: fonts/Roboto-Regular.ttf
              - asset: fonts/Roboto-Bold.ttf
                weight: 700
```

### **Android Configuration**

```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.CAMERA" />
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />

    <application
        android:label="UAWS Field Tracker"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher"
        android:theme="@style/LaunchTheme"
        android:exported="true"
        android:usesCleartextTraffic="false"
        android:requestLegacyExternalStorage="true">

        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">

            <intent-filter android:autoVerify="true">
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
    </application>
</manifest>
```

```gradle
// android/app/build.gradle
android {
    namespace "org.uaws.field_tracker"
    compileSdkVersion 34
    ndkVersion flutter.ndkVersion

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }

    defaultConfig {
        applicationId "org.uaws.field_tracker"
        minSdkVersion 23  // Android 6.0+
        targetSdkVersion 34
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
        multiDexEnabled true
    }

    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}
```

### **iOS Configuration**

```xml
<!-- ios/Runner/Info.plist -->
<dict>
    <key>CFBundleName</key>
    <string>UAWS Field Tracker</string>
    <key>CFBundleDisplayName</key>
    <string>UAWS Field Tracker</string>
    <key>CFBundleVersion</key>
    <string>$(FLUTTER_BUILD_NUMBER)</string>
    <key>CFBundleShortVersionString</key>
    <string>$(FLUTTER_BUILD_NAME)</string>

    <!-- Camera Permission -->
    <key>NSCameraUsageDescription</key>
    <string>This app needs camera access to capture photos of animals for sterilization tracking.</string>

    <!-- Location Permission -->
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>This app needs location access to record GPS coordinates for sterilization activities.</string>
    <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
    <string>This app needs location access to record GPS coordinates for sterilization activities.</string>

    <!-- Photo Library Permission -->
    <key>NSPhotoLibraryUsageDescription</key>
    <string>This app needs photo library access to save animal photos.</string>

    <key>UILaunchStoryboardName</key>
    <string>LaunchScreen</string>
    <key>UIMainStoryboardFile</key>
    <string>Main</string>
    <key>UISupportedInterfaceOrientations</key>
    <array>
        <string>UIInterfaceOrientationPortrait</string>
        <string>UIInterfaceOrientationLandscapeLeft</string>
        <string>UIInterfaceOrientationLandscapeRight</string>
    </array>
</dict>
```

### **Build Scripts**

```bash
#!/bin/bash
# scripts/build_android.sh

echo "Building Android APK..."

# Clean previous builds
flutter clean
flutter pub get

# Generate code (for build_runner, l10n, etc.)
flutter packages pub run build_runner build --delete-conflicting-outputs

# Build APK
flutter build apk --release --split-per-abi

echo "✅ Android build complete!"
echo "APK files location: build/app/outputs/flutter-apk/"
```

```bash
#!/bin/bash
# scripts/build_ios.sh

echo "Building iOS IPA..."

# Clean previous builds
flutter clean
flutter pub get

# Generate code
flutter packages pub run build_runner build --delete-conflicting-outputs

# Build iOS
flutter build ios --release --no-codesign

echo "✅ iOS build complete!"
echo "Open ios/Runner.xcworkspace in Xcode to archive and distribute"
```

### **Release Strategy**

```yaml
# .github/workflows/release.yml
name: Release

on:
    push:
        tags:
            - "v*"

jobs:
    build-android:
        runs-on: ubuntu-latest
        steps:
            - uses: actions/checkout@v3
            - uses: actions/setup-java@v3
              with:
                  distribution: "zulu"
                  java-version: "11"
            - uses: subosito/flutter-action@v2
              with:
                  flutter-version: "3.19.0"

            - name: Get dependencies
              run: flutter pub get

            - name: Generate code
              run: flutter packages pub run build_runner build --delete-conflicting-outputs

            - name: Build APK
              run: flutter build apk --release --split-per-abi

            - name: Upload artifacts
              uses: actions/upload-artifact@v3
              with:
                  name: android-apks
                  path: build/app/outputs/flutter-apk/

    build-ios:
        runs-on: macos-latest
        steps:
            - uses: actions/checkout@v3
            - uses: subosito/flutter-action@v2
              with:
                  flutter-version: "3.19.0"

            - name: Get dependencies
              run: flutter pub get

            - name: Generate code
              run: flutter packages pub run build_runner build --delete-conflicting-outputs

            - name: Build iOS
              run: flutter build ios --release --no-codesign
```

### **App Store Deployment**

```markdown
## Google Play Store

1. **Prepare Release**:

    - Generate signed APK/AAB
    - Prepare store listing (descriptions, screenshots)
    - Set up app signing key

2. **Upload to Play Console**:

    - Create app bundle (AAB) for optimal delivery
    - Fill in store listing details
    - Set up content rating and pricing

3. **Beta Testing**:
    - Internal testing with UAWS team
    - Closed testing with field staff
    - Open testing for broader feedback

## Apple App Store

1. **Prepare Release**:

    - Archive app in Xcode
    - Upload to App Store Connect
    - Fill in app information

2. **Review Process**:

    - Provide app description and keywords
    - Upload screenshots and metadata
    - Submit for review (typically 24-48 hours)

3. **Distribution**:
    - TestFlight for beta testing
    - Production release after approval
```

---

## 📋 **Development Timeline**

### **Phase 1 - Core Infrastructure (6 weeks)**

**Weeks 1-2: Project Setup & Architecture**

-   Flutter project initialization with clean architecture
-   Firebase integration and authentication setup
-   Riverpod state management implementation
-   Local database (SQLite) setup with migration system
-   Basic app navigation and routing

**Weeks 3-4: Core Features Implementation**

-   User authentication (login/logout)
-   Basic sterilization form with validation
-   Camera integration with image compression
-   GPS location capture with permission handling
-   Offline storage implementation

**Weeks 5-6: Data Synchronization**

-   Firestore integration for cloud storage
-   Offline-first sync mechanism
-   Conflict resolution for data sync
-   Background sync service implementation
-   Network connectivity monitoring

### **Phase 2 - Feature Completion (4 weeks)**

**Weeks 7-8: Vaccination Tracker**

-   Vaccination form implementation
-   Vaccine type management
-   Due date calculations and reminders
-   Photo capture for vaccination records
-   Integration with sterilization workflow

**Weeks 9-10: Advanced Features**

-   Marathi localization implementation
-   Advanced form validation and error handling
-   Image optimization and compression
-   GPS accuracy improvements
-   Batch sync optimization

### **Phase 3 - Polish & Testing (3 weeks)**

**Weeks 11-12: UI/UX Polish**

-   Material Design 3 implementation
-   Dark mode support
-   Accessibility improvements
-   Performance optimization
-   Memory management improvements

**Week 13: Testing & Bug Fixes**

-   Comprehensive unit testing
-   Widget testing for all forms
-   Integration testing for complete flows
-   Performance testing
-   Bug fixes and optimization

### **Phase 4 - Deployment (1 week)**

**Week 14: Release Preparation**

-   App store assets preparation (icons, screenshots)
-   Beta testing with field staff
-   Final testing on multiple devices
-   Play Store and App Store submission
-   Documentation and user guides

### **Development Milestones**

```dart
// Milestone tracking
enum DevelopmentMilestone {
  projectSetup,           // Week 2
  coreFeatures,          // Week 4
  dataSynchronization,   // Week 6
  vaccinationTracker,    // Week 8
  advancedFeatures,      // Week 10
  uiPolish,             // Week 12
  testing,              // Week 13
  deployment,           // Week 14
}

class MilestoneTracker {
  static const Map<DevelopmentMilestone, List<String>> deliverables = {
    DevelopmentMilestone.projectSetup: [
      'Flutter project with clean architecture',
      'Firebase authentication integration',
      'Riverpod state management setup',
      'SQLite database with migrations',
      'Basic navigation structure'
    ],
    DevelopmentMilestone.coreFeatures: [
      'User login/logout functionality',
      'Sterilization form with validation',
      'Camera integration',
      'GPS location capture',
      'Offline data storage'
    ],
    DevelopmentMilestone.dataSynchronization: [
      'Firestore cloud integration',
      'Offline-first sync mechanism',
      'Conflict resolution system',
      'Background sync service',
      'Network monitoring'
    ],
    DevelopmentMilestone.vaccinationTracker: [
      'Complete vaccination workflow',
      'Vaccine type management',
      'Due date calculations',
      'Photo capture integration',
      'Data relationship management'
    ],
    DevelopmentMilestone.advancedFeatures: [
      'Marathi language support',
      'Advanced form validation',
      'Image compression optimization',
      'Enhanced GPS accuracy',
      'Batch sync performance'
    ],
    DevelopmentMilestone.uiPolish: [
      'Material Design 3 theming',
      'Dark mode implementation',
      'Accessibility compliance',
      'Performance optimization',
      'Memory management'
    ],
    DevelopmentMilestone.testing: [
      'Unit test coverage >90%',
      'Widget test suite',
      'Integration test scenarios',
      'Performance benchmarks',
      'Cross-device compatibility'
    ],
    DevelopmentMilestone.deployment: [
      'App store assets',
      'Beta testing completion',
      'Multi-device testing',
      'Store submissions',
      'User documentation'
    ]
  };
}
```

### **Risk Mitigation**

**Technical Risks:**

-   **GPS Accuracy Issues**: Implement fallback location methods and user manual override
-   **Image Storage**: Implement progressive image compression and cleanup routines
-   **Sync Conflicts**: Server-wins strategy with user notification for important changes
-   **Battery Drain**: Optimize location services and background processes

**Timeline Risks:**

-   **Buffer Time**: 20% buffer built into each phase
-   **Parallel Development**: UI design can proceed alongside backend development
-   **Incremental Testing**: Continuous testing throughout development phases
-   **Staged Rollout**: Beta release to identify issues before production

### **Resource Requirements**

**Development Team:**

-   1 Senior Flutter Developer (Lead)
-   1 Flutter Developer (Forms/UI)
-   1 Firebase/Backend Developer
-   1 QA Engineer (Testing)
-   1 UI/UX Designer (Part-time)

**Hardware Requirements:**

-   Android devices for testing (various screen sizes)
-   iOS devices for testing (iPhone/iPad)
-   GPS-enabled devices for location testing
-   High-resolution cameras for photo testing

**Software Requirements:**

-   Flutter SDK 3.19+
-   Firebase project setup
-   Google Play Console account
-   Apple Developer account
-   CI/CD pipeline (GitHub Actions)

**Total Development Time: 14 weeks (3.5 months)**

This timeline provides a realistic development schedule with built-in buffers for testing and iteration, ensuring a robust, production-ready mobile application that meets all UAWS requirements for field data collection.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/vaccination_controller.dart';
import '../../../shared/models/models.dart';
import '../../../shared/utils/responsive_utils.dart';

class VaccinationDetailScreen extends GetView<VaccinationController> {
  final String vaccinationId;

  const VaccinationDetailScreen({super.key, required this.vaccinationId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('vaccination_details'.tr),
        backgroundColor: const Color(0xFF7B1FA2),
        foregroundColor: Colors.white,
        centerTitle: true,
        toolbarHeight: ResponsiveUtils.getAppBarHeight(context),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuAction(context, value),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(
                      Icons.edit,
                      size: ResponsiveUtils.getIconSize(context, 20),
                    ),
                    SizedBox(
                      width: ResponsiveUtils.getResponsiveSpacing(context, 8),
                    ),
                    Text('edit'.tr),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(
                      Icons.delete,
                      size: ResponsiveUtils.getIconSize(context, 20),
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: ResponsiveUtils.getResponsiveSpacing(context, 8),
                    ),
                    Text(
                      'delete'.tr,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(
                      Icons.share,
                      size: ResponsiveUtils.getIconSize(context, 20),
                    ),
                    SizedBox(
                      width: ResponsiveUtils.getResponsiveSpacing(context, 8),
                    ),
                    Text('share'.tr),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return _buildLoadingView(context);
        }

        final vaccination = controller.getVaccinationById(vaccinationId);
        if (vaccination == null) {
          return _buildNotFoundView(context);
        }

        return _buildDetailView(context, vaccination);
      }),
    );
  }

  Widget _buildLoadingView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7B1FA2)),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
          Text(
            'loading_vaccination_details'.tr,
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotFoundView(BuildContext context) {
    return Center(
      child: Padding(
        padding: ResponsiveUtils.getResponsivePadding(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: ResponsiveUtils.getIconSize(context, 64),
              color: Colors.grey,
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
            Text(
              'vaccination_not_found'.tr,
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 8)),
            Text(
              'vaccination_not_found_message'.tr,
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 24)),
            ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7B1FA2),
                foregroundColor: Colors.white,
              ),
              child: Text('go_back'.tr),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailView(BuildContext context, VaccinationModel vaccination) {
    return SingleChildScrollView(
      padding: ResponsiveUtils.getResponsivePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status Header Card
          _buildStatusHeaderCard(context, vaccination),

          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),

          // Vaccination Information
          _buildVaccinationInfoCard(context, vaccination),

          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),

          // Animal Information
          _buildAnimalInfoCard(context, vaccination),

          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),

          // Location Information
          _buildLocationInfoCard(context, vaccination),

          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),

          // Veterinarian Information
          _buildVeterinarianInfoCard(context, vaccination),

          if (vaccination.notes?.isNotEmpty == true) ...[
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
            _buildNotesCard(context, vaccination),
          ],

          // Photos Section - Combined
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
          _buildPhotosCard(context, vaccination),

          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 24)),

          // Action Buttons
          _buildActionButtons(context, vaccination),

          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 32)),
        ],
      ),
    );
  }

  Widget _buildStatusHeaderCard(
    BuildContext context,
    VaccinationModel vaccination,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: double.infinity,
        padding: ResponsiveUtils.getResponsivePadding(context),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              _getStatusColor(vaccination.status),
              _getStatusColor(vaccination.status).withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(
                    ResponsiveUtils.getResponsiveSpacing(context, 12),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.vaccines,
                    color: Colors.white,
                    size: ResponsiveUtils.getIconSize(context, 32),
                  ),
                ),
                SizedBox(
                  width: ResponsiveUtils.getResponsiveSpacing(context, 16),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vaccination.animalId,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: ResponsiveUtils.getResponsiveFontSize(
                            context,
                            24,
                          ),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        vaccination.vaccineType,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: ResponsiveUtils.getResponsiveFontSize(
                            context,
                            16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.getResponsiveSpacing(context, 12),
                vertical: ResponsiveUtils.getResponsiveSpacing(context, 6),
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                vaccination.status.name.toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVaccinationInfoCard(
    BuildContext context,
    VaccinationModel vaccination,
  ) {
    return _buildInfoCard(
      context,
      title: 'vaccination_information'.tr,
      icon: Icons.vaccines,
      children: [
        _buildInfoItem(
          context,
          label: 'vaccination_date'.tr,
          value: _formatDate(vaccination.vaccinationDate),
          icon: Icons.calendar_today,
        ),
        if (vaccination.nextDueDate != null)
          _buildInfoItem(
            context,
            label: 'next_due_date'.tr,
            value: _formatDate(vaccination.nextDueDate!),
            icon: Icons.schedule,
            valueColor: _isOverdue(vaccination.nextDueDate!)
                ? Colors.red
                : null,
          ),
        _buildInfoItem(
          context,
          label: 'vaccine_type'.tr,
          value: vaccination.vaccineType,
          icon: Icons.medical_services,
        ),
        if (vaccination.batchNumber.isNotEmpty)
          _buildInfoItem(
            context,
            label: 'batch_number'.tr,
            value: vaccination.batchNumber,
            icon: Icons.qr_code,
          ),
        _buildInfoItem(
          context,
          label: 'vaccine_type'.tr,
          value: vaccination.vaccineType,
          icon: Icons.medical_services,
        ),
      ],
    );
  }

  Widget _buildAnimalInfoCard(
    BuildContext context,
    VaccinationModel vaccination,
  ) {
    final animal = vaccination.animalInfo;
    return _buildInfoCard(
      context,
      title: 'animal_information'.tr,
      icon: Icons.pets,
      children: [
        _buildInfoItem(
          context,
          label: 'species'.tr,
          value: animal.species.name,
          icon: Icons.category,
        ),
        if (animal.breed?.isNotEmpty == true)
          _buildInfoItem(
            context,
            label: 'breed'.tr,
            value: animal.breed!,
            icon: Icons.pets,
          ),
        _buildInfoItem(
          context,
          label: 'age_category'.tr,
          value: animal.age.name,
          icon: Icons.cake,
        ),
        _buildInfoItem(
          context,
          label: 'sex'.tr,
          value: animal.sex.name,
          icon: Icons.info,
        ),
        if (animal.weight != null)
          _buildInfoItem(
            context,
            label: 'weight'.tr,
            value: '${animal.weight} kg',
            icon: Icons.monitor_weight,
          ),
        _buildInfoItem(
          context,
          label: 'color'.tr,
          value: animal.color,
          icon: Icons.color_lens,
        ),
      ],
    );
  }

  Widget _buildLocationInfoCard(
    BuildContext context,
    VaccinationModel vaccination,
  ) {
    final location = vaccination.location;
    return _buildInfoCard(
      context,
      title: 'location_information'.tr,
      icon: Icons.location_on,
      children: [
        _buildInfoItem(
          context,
          label: 'ward'.tr,
          value: vaccination.wardName,
          icon: Icons.map,
        ),
        if (location.address?.isNotEmpty == true)
          _buildInfoItem(
            context,
            label: 'address'.tr,
            value: location.address!,
            icon: Icons.home,
          ),
        _buildInfoItem(
          context,
          label: 'coordinates'.tr,
          value:
              '${location.lat.toStringAsFixed(6)}, ${location.lng.toStringAsFixed(6)}',
          icon: Icons.gps_fixed,
        ),
      ],
    );
  }

  Widget _buildVeterinarianInfoCard(
    BuildContext context,
    VaccinationModel vaccination,
  ) {
    return _buildInfoCard(
      context,
      title: 'veterinarian_information'.tr,
      icon: Icons.person,
      children: [
        _buildInfoItem(
          context,
          label: 'name'.tr,
          value: vaccination.veterinarianName,
          icon: Icons.person,
        ),
        _buildInfoItem(
          context,
          label: 'license'.tr,
          value: vaccination.veterinarianLicense,
          icon: Icons.badge,
        ),
        _buildInfoItem(
          context,
          label: 'reported_by'.tr,
          value: vaccination.reportedBy,
          icon: Icons.edit,
        ),
        _buildInfoItem(
          context,
          label: 'created_date'.tr,
          value: _formatDateTime(vaccination.createdAt),
          icon: Icons.access_time,
        ),
      ],
    );
  }

  Widget _buildNotesCard(BuildContext context, VaccinationModel vaccination) {
    return _buildInfoCard(
      context,
      title: 'notes'.tr,
      icon: Icons.note,
      children: [
        Container(
          width: double.infinity,
          padding: ResponsiveUtils.getResponsivePadding(context),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Theme.of(context).dividerColor, width: 1),
          ),
          child: Text(
            vaccination.notes!,
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotosCard(BuildContext context, VaccinationModel vaccination) {
    final allPhotos = [
      ...vaccination.beforePhotos,
      ...vaccination.afterPhotos,
      ...vaccination.certificatePhotos,
    ];

    if (allPhotos.isEmpty) {
      return const SizedBox.shrink();
    }

    return _buildInfoCard(
      context,
      title: 'photos'.tr,
      icon: Icons.photo_library,
      children: [
        SizedBox(
          height: ResponsiveUtils.getResponsiveSpacing(context, 120),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: allPhotos.length,
            itemBuilder: (context, index) {
              final photo = allPhotos[index];
              return Container(
                margin: EdgeInsets.only(
                  right: ResponsiveUtils.getResponsiveSpacing(context, 12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    photo.url ?? '',
                    width: ResponsiveUtils.getResponsiveSpacing(context, 100),
                    height: ResponsiveUtils.getResponsiveSpacing(context, 100),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: ResponsiveUtils.getResponsiveSpacing(
                          context,
                          100,
                        ),
                        height: ResponsiveUtils.getResponsiveSpacing(
                          context,
                          100,
                        ),
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.broken_image,
                          color: Colors.grey[500],
                          size: ResponsiveUtils.getIconSize(context, 32),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: ResponsiveUtils.getResponsivePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(
                    ResponsiveUtils.getResponsiveSpacing(context, 8),
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7B1FA2).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: const Color(0xFF7B1FA2),
                    size: ResponsiveUtils.getIconSize(context, 20),
                  ),
                ),
                SizedBox(
                  width: ResponsiveUtils.getResponsiveSpacing(context, 12),
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: ResponsiveUtils.getResponsiveFontSize(
                      context,
                      18,
                    ),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    Color? valueColor,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: ResponsiveUtils.getResponsiveSpacing(context, 12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: ResponsiveUtils.getIconSize(context, 16),
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
          SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 12)),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                fontWeight: FontWeight.w500,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    VaccinationModel vaccination,
  ) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _handleEditVaccination(vaccination),
            icon: Icon(
              Icons.edit,
              size: ResponsiveUtils.getIconSize(context, 20),
            ),
            label: Text('edit'.tr),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7B1FA2),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                vertical: ResponsiveUtils.getResponsiveSpacing(context, 12),
              ),
            ),
          ),
        ),
        SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 12)),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _handleShareVaccination(vaccination),
            icon: Icon(
              Icons.share,
              size: ResponsiveUtils.getIconSize(context, 20),
            ),
            label: Text('share'.tr),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF7B1FA2),
              side: const BorderSide(color: Color(0xFF7B1FA2)),
              padding: EdgeInsets.symmetric(
                vertical: ResponsiveUtils.getResponsiveSpacing(context, 12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Helper methods
  void _handleMenuAction(BuildContext context, String action) {
    final vaccination = controller.getVaccinationById(vaccinationId);
    if (vaccination == null) return;

    switch (action) {
      case 'edit':
        _handleEditVaccination(vaccination);
        break;
      case 'delete':
        _handleDeleteVaccination(context, vaccination);
        break;
      case 'share':
        _handleShareVaccination(vaccination);
        break;
    }
  }

  void _handleEditVaccination(VaccinationModel vaccination) {
    // Navigate to edit screen
    Get.toNamed('/vaccination/edit', arguments: vaccination);
  }

  void _handleDeleteVaccination(
    BuildContext context,
    VaccinationModel vaccination,
  ) {
    Get.dialog(
      AlertDialog(
        title: Text('delete_vaccination'.tr),
        content: Text('delete_vaccination_confirmation'.tr),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('cancel'.tr)),
          TextButton(
            onPressed: () {
              // Handle delete logic here
              Get.back();
              Get.back();
              Get.snackbar(
                'success'.tr,
                'vaccination_deleted'.tr,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('delete'.tr),
          ),
        ],
      ),
    );
  }

  void _handleShareVaccination(VaccinationModel vaccination) {
    // Handle share logic here
    Get.snackbar(
      'info'.tr,
      'share_functionality_coming_soon'.tr,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  Color _getStatusColor(VaccinationStatus status) {
    switch (status) {
      case VaccinationStatus.completed:
        return const Color(0xFF4CAF50);
      case VaccinationStatus.scheduled:
        return const Color(0xFF2196F3);
      case VaccinationStatus.cancelled:
        return const Color(0xFFD32F2F);
      case VaccinationStatus.inProgress:
        return const Color(0xFFF57C00);
      case VaccinationStatus.pending:
        return const Color(0xFF9E9E9E);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatDateTime(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  bool _isOverdue(DateTime date) {
    return date.isBefore(DateTime.now());
  }
}

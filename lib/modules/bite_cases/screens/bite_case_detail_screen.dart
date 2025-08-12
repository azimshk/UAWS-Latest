import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../shared/models/models.dart';
import '../../../shared/utils/responsive_utils.dart';

class BiteCaseDetailScreen extends StatelessWidget {
  final BiteCaseModel biteCase;

  const BiteCaseDetailScreen({super.key, required this.biteCase});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Case #${biteCase.id}'),
        backgroundColor: const Color(0xFF7B1FA2),
        foregroundColor: Colors.white,
        centerTitle: true,
        toolbarHeight: ResponsiveUtils.getAppBarHeight(context),
        actions: [
          IconButton(
            onPressed: () => _editBiteCase(context),
            icon: Icon(
              Icons.edit,
              size: ResponsiveUtils.getIconSize(context, 24),
            ),
            tooltip: 'Edit Case',
          ),
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuAction(context, value),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'update_status',
                child: Row(
                  children: [
                    Icon(Icons.update),
                    SizedBox(width: 8),
                    Text('Update Status'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete Case', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: ResponsiveUtils.getResponsivePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status and Priority Card
            _buildStatusCard(context),

            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),

            // Victim Details Card
            _buildVictimDetailsCard(context),

            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),

            // Animal Details Card
            _buildAnimalDetailsCard(context),

            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),

            // Incident Details Card
            _buildIncidentDetailsCard(context),

            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),

            // Medical Details Card
            _buildMedicalDetailsCard(context),

            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),

            // Location Card
            _buildLocationCard(context),

            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),

            // Case Management Card
            _buildCaseManagementCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: ResponsiveUtils.getResponsivePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Case Status',
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18),
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleMedium?.color,
              ),
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 12)),
            Row(
              children: [
                Expanded(
                  child: _buildInfoTile(
                    context,
                    'Status',
                    biteCase.status.name,
                    Icons.info,
                  ),
                ),
                Expanded(
                  child: _buildInfoTile(
                    context,
                    'Priority',
                    biteCase.priority.name,
                    Icons.priority_high,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVictimDetailsCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: ResponsiveUtils.getResponsivePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Victim Details',
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18),
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleMedium?.color,
              ),
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 12)),
            _buildInfoTile(
              context,
              'Name',
              biteCase.victimDetails.name,
              Icons.person,
            ),
            _buildInfoTile(
              context,
              'Age',
              '${biteCase.victimDetails.age} years',
              Icons.cake,
            ),
            _buildInfoTile(
              context,
              'Gender',
              biteCase.victimDetails.gender,
              Icons.wc,
            ),
            _buildInfoTile(
              context,
              'Contact',
              biteCase.victimDetails.contact,
              Icons.phone,
            ),
            _buildInfoTile(
              context,
              'Address',
              biteCase.victimDetails.address,
              Icons.home,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimalDetailsCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: ResponsiveUtils.getResponsivePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Animal Details',
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18),
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleMedium?.color,
              ),
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 12)),
            _buildInfoTile(
              context,
              'Species',
              biteCase.animalDetails.species,
              Icons.pets,
            ),
            _buildInfoTile(
              context,
              'Sex',
              biteCase.animalDetails.sex,
              Icons.male,
            ),
            _buildInfoTile(
              context,
              'Size',
              biteCase.animalDetails.size,
              Icons.straighten,
            ),
            _buildInfoTile(
              context,
              'Color',
              biteCase.animalDetails.color,
              Icons.palette,
            ),
            _buildInfoTile(
              context,
              'Behavior',
              biteCase.animalDetails.behavior.name,
              Icons.psychology,
            ),
            _buildInfoTile(
              context,
              'Ownership',
              biteCase.animalDetails.ownershipStatus.name,
              Icons.home_outlined,
            ),
            _buildInfoTile(
              context,
              'Vaccination Status',
              biteCase.animalDetails.vaccinationStatus.name,
              Icons.vaccines,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncidentDetailsCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: ResponsiveUtils.getResponsivePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Incident Details',
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18),
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleMedium?.color,
              ),
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 12)),
            _buildInfoTile(
              context,
              'Incident Date',
              _formatDate(biteCase.incidentDate),
              Icons.calendar_today,
            ),
            _buildInfoTile(
              context,
              'Reported Date',
              _formatDate(biteCase.reportedDate),
              Icons.report,
            ),
            _buildInfoTile(
              context,
              'Severity',
              biteCase.incidentDetails.severity.name,
              Icons.warning,
            ),
            _buildInfoTile(
              context,
              'Body Part',
              biteCase.incidentDetails.bodyPart,
              Icons.healing,
            ),
            _buildInfoTile(
              context,
              'Circumstances',
              biteCase.incidentDetails.circumstances,
              Icons.description,
            ),
            _buildInfoTile(
              context,
              'Witnesses',
              biteCase.incidentDetails.witnesses.join(', '),
              Icons.group,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicalDetailsCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: ResponsiveUtils.getResponsivePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Medical Details',
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18),
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleMedium?.color,
              ),
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 12)),
            _buildInfoTile(
              context,
              'First Aid Given',
              biteCase.medicalDetails.firstAidGiven ? 'Yes' : 'No',
              Icons.healing,
            ),
            _buildInfoTile(
              context,
              'Hospital Visit',
              biteCase.medicalDetails.hospitalVisit ? 'Yes' : 'No',
              Icons.local_hospital,
            ),
            if (biteCase.medicalDetails.hospitalName != null)
              _buildInfoTile(
                context,
                'Hospital Name',
                biteCase.medicalDetails.hospitalName!,
                Icons.business,
              ),
            if (biteCase.medicalDetails.doctorName != null)
              _buildInfoTile(
                context,
                'Doctor Name',
                biteCase.medicalDetails.doctorName!,
                Icons.person_outline,
              ),
            if (biteCase.medicalDetails.treatmentReceived != null)
              _buildInfoTile(
                context,
                'Treatment',
                biteCase.medicalDetails.treatmentReceived!,
                Icons.medical_services,
              ),
            _buildInfoTile(
              context,
              'Anti-Rabies Vaccine',
              biteCase.medicalDetails.antiRabiesVaccineStatus,
              Icons.vaccines,
            ),
            _buildInfoTile(
              context,
              'Follow-up Required',
              biteCase.medicalDetails.followUpRequired ? 'Yes' : 'No',
              Icons.follow_the_signs,
            ),
            if (biteCase.medicalDetails.nextAppointment != null)
              _buildInfoTile(
                context,
                'Next Appointment',
                _formatDate(biteCase.medicalDetails.nextAppointment!),
                Icons.event,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: ResponsiveUtils.getResponsivePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Location',
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18),
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleMedium?.color,
              ),
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 12)),
            _buildInfoTile(
              context,
              'Address',
              biteCase.location.address ?? 'Not specified',
              Icons.location_on,
            ),
            _buildInfoTile(
              context,
              'Ward',
              biteCase.location.ward ?? 'Not specified',
              Icons.map,
            ),
            _buildInfoTile(
              context,
              'GPS Coordinates',
              '${biteCase.location.lat}, ${biteCase.location.lng}',
              Icons.gps_fixed,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCaseManagementCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: ResponsiveUtils.getResponsivePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Case Management',
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18),
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.titleMedium?.color,
              ),
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 12)),
            _buildInfoTile(
              context,
              'Source',
              biteCase.source.name,
              Icons.source,
            ),
            _buildInfoTile(
              context,
              'Investigation Status',
              biteCase.investigationStatus,
              Icons.search,
            ),
            if (biteCase.assignedOfficer != null)
              _buildInfoTile(
                context,
                'Assigned Officer',
                biteCase.assignedOfficer!,
                Icons.person_pin,
              ),
            _buildInfoTile(
              context,
              'Quarantine Required',
              biteCase.quarantine.quarantineRequired ? 'Yes' : 'No',
              Icons.security,
            ),
            if (biteCase.quarantine.quarantineId != null)
              _buildInfoTile(
                context,
                'Quarantine ID',
                biteCase.quarantine.quarantineId!,
                Icons.badge,
              ),
            _buildInfoTile(
              context,
              'Created By',
              biteCase.createdBy,
              Icons.person,
            ),
            _buildInfoTile(
              context,
              'Created At',
              _formatDateTime(biteCase.createdAt),
              Icons.access_time,
            ),
            _buildInfoTile(
              context,
              'Last Updated',
              _formatDateTime(biteCase.lastUpdated),
              Icons.update,
            ),
            if (biteCase.notes != null && biteCase.notes!.isNotEmpty)
              _buildInfoTile(context, 'Notes', biteCase.notes!, Icons.note),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: ResponsiveUtils.getResponsiveSpacing(context, 8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: ResponsiveUtils.getIconSize(context, 20),
            color: const Color(0xFF7B1FA2),
          ),
          SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 8)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: ResponsiveUtils.getResponsiveFontSize(
                      context,
                      12,
                    ),
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
                SizedBox(
                  height: ResponsiveUtils.getResponsiveSpacing(context, 2),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: ResponsiveUtils.getResponsiveFontSize(
                      context,
                      14,
                    ),
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _editBiteCase(BuildContext context) {
    Get.snackbar(
      'Info',
      'Edit bite case functionality not implemented yet',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _handleMenuAction(BuildContext context, String action) {
    switch (action) {
      case 'update_status':
        Get.snackbar(
          'Info',
          'Update status functionality not implemented yet',
          snackPosition: SnackPosition.BOTTOM,
        );
        break;
      case 'delete':
        _showDeleteConfirmation(context);
        break;
    }
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Case'),
          content: const Text(
            'Are you sure you want to delete this bite case? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Get.back();
                Get.snackbar(
                  'Info',
                  'Delete functionality not implemented yet',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

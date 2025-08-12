import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/vaccination_controller.dart';
import '../../../shared/models/models.dart';
import '../../../shared/utils/responsive_utils.dart';

class VaccinationListScreen extends GetView<VaccinationController> {
  const VaccinationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('vaccination_tracker'.tr),
        backgroundColor: const Color(0xFF7B1FA2),
        foregroundColor: Colors.white,
        centerTitle: true,
        toolbarHeight: ResponsiveUtils.getAppBarHeight(context),
        actions: [
          IconButton(
            onPressed: controller.refreshVaccinations,
            icon: Icon(
              Icons.refresh,
              size: ResponsiveUtils.getIconSize(context, 24),
            ),
            tooltip: 'refresh'.tr,
          ),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'filter',
                child: Row(
                  children: [
                    Icon(
                      Icons.filter_list,
                      size: ResponsiveUtils.getIconSize(context, 20),
                    ),
                    SizedBox(
                      width: ResponsiveUtils.getResponsiveSpacing(context, 8),
                    ),
                    Text('filter'.tr),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(
                      Icons.download,
                      size: ResponsiveUtils.getIconSize(context, 20),
                    ),
                    SizedBox(
                      width: ResponsiveUtils.getResponsiveSpacing(context, 8),
                    ),
                    Text('export'.tr),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshVaccinations,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                // Search and Filter Section
                _buildSearchAndFilterSection(context),

                // Vaccination List
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading) {
                      return _buildLoadingView(context);
                    }

                    if (controller.filteredVaccinations.isEmpty) {
                      return _buildEmptyView(context);
                    }

                    return _buildVaccinationList(context);
                  }),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.navigateToAddVaccination,
        backgroundColor: const Color(0xFF7B1FA2),
        tooltip: 'add_vaccination'.tr,
        child: Icon(Icons.add, size: ResponsiveUtils.getIconSize(context, 24)),
      ),
    );
  }

  Widget _buildSearchAndFilterSection(BuildContext context) {
    return Container(
      padding: ResponsiveUtils.getResponsivePadding(context),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search Bar
          TextField(
            onChanged: controller.updateSearchQuery,
            decoration: InputDecoration(
              hintText: 'search_vaccinations'.tr,
              prefixIcon: Icon(
                Icons.search,
                size: ResponsiveUtils.getIconSize(context, 20),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Theme.of(context).scaffoldBackgroundColor,
              contentPadding: ResponsiveUtils.getResponsivePadding(context)
                  .copyWith(
                    top: ResponsiveUtils.getResponsiveSpacing(context, 12),
                    bottom: ResponsiveUtils.getResponsiveSpacing(context, 12),
                  ),
            ),
          ),

          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 12)),

          // Filter Chips
          _buildFilterChips(context),
        ],
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context) {
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // Status Filter
            _buildFilterChip(
              context,
              label: 'status'.tr,
              selected: controller.selectedStatus.isNotEmpty,
              onTap: () => _showStatusFilterDialog(context),
            ),
            SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 8)),

            // Vaccine Type Filter
            _buildFilterChip(
              context,
              label: 'vaccine_type'.tr,
              selected: controller.selectedVaccineType.isNotEmpty,
              onTap: () => _showVaccineTypeFilterDialog(context),
            ),
            SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 8)),

            // Ward Filter
            _buildFilterChip(
              context,
              label: 'ward'.tr,
              selected: controller.selectedWard.isNotEmpty,
              onTap: () => _showWardFilterDialog(context),
            ),
            SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 8)),

            // Clear Filters
            if (controller.selectedStatus.isNotEmpty ||
                controller.selectedVaccineType.isNotEmpty ||
                controller.selectedWard.isNotEmpty)
              _buildFilterChip(
                context,
                label: 'clear_all'.tr,
                selected: false,
                color: const Color(0xFFD32F2F),
                onTap: controller.clearFilters,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context, {
    required String label,
    required bool selected,
    required VoidCallback onTap,
    Color? color,
  }) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12),
          color: selected
              ? Colors.white
              : Theme.of(context).textTheme.bodyMedium?.color,
        ),
      ),
      selected: selected,
      onSelected: (_) => onTap(),
      backgroundColor: color?.withValues(alpha: 0.1),
      selectedColor: color ?? const Color(0xFF7B1FA2),
      checkmarkColor: Colors.white,
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
            'loading_vaccinations'.tr,
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView(BuildContext context) {
    return Center(
      child: Padding(
        padding: ResponsiveUtils.getResponsivePadding(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.vaccines_outlined,
              size: ResponsiveUtils.getIconSize(context, 64),
              color: Colors.grey,
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
            Text(
              'no_vaccinations_found'.tr,
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 8)),
            Text(
              'no_vaccinations_message'.tr,
              style: TextStyle(
                fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 24)),
            ElevatedButton.icon(
              onPressed: controller.navigateToAddVaccination,
              icon: Icon(
                Icons.add,
                size: ResponsiveUtils.getIconSize(context, 20),
              ),
              label: Text('add_vaccination'.tr),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7B1FA2),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVaccinationList(BuildContext context) {
    return ResponsiveUtils.isMobile(context)
        ? _buildMobileList(context)
        : _buildGridList(context);
  }

  Widget _buildMobileList(BuildContext context) {
    return ListView.builder(
      padding: ResponsiveUtils.getResponsivePadding(context),
      itemCount: controller.filteredVaccinations.length,
      itemBuilder: (context, index) {
        final vaccination = controller.filteredVaccinations[index];
        return _buildVaccinationCard(context, vaccination);
      },
    );
  }

  Widget _buildGridList(BuildContext context) {
    return GridView.builder(
      padding: ResponsiveUtils.getResponsivePadding(context),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveUtils.getGridColumns(context),
        crossAxisSpacing: ResponsiveUtils.getResponsiveSpacing(context, 16),
        mainAxisSpacing: ResponsiveUtils.getResponsiveSpacing(context, 16),
        childAspectRatio: ResponsiveUtils.isTablet(context) ? 1.1 : 0.9,
      ),
      itemCount: controller.filteredVaccinations.length,
      itemBuilder: (context, index) {
        final vaccination = controller.filteredVaccinations[index];
        return _buildVaccinationCard(context, vaccination);
      },
    );
  }

  Widget _buildVaccinationCard(
    BuildContext context,
    VaccinationModel vaccination,
  ) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => controller.navigateToVaccinationDetails(vaccination.id),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: ResponsiveUtils.getResponsivePadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(
                      ResponsiveUtils.getResponsiveSpacing(context, 8),
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(
                        vaccination.status,
                      ).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.vaccines,
                      color: _getStatusColor(vaccination.status),
                      size: ResponsiveUtils.getIconSize(context, 20),
                    ),
                  ),
                  SizedBox(
                    width: ResponsiveUtils.getResponsiveSpacing(context, 12),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vaccination.animalId,
                          style: TextStyle(
                            fontSize: ResponsiveUtils.getResponsiveFontSize(
                              context,
                              14,
                            ),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          vaccination.vaccineType,
                          style: TextStyle(
                            fontSize: ResponsiveUtils.getResponsiveFontSize(
                              context,
                              12,
                            ),
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveUtils.getResponsiveSpacing(
                        context,
                        8,
                      ),
                      vertical: ResponsiveUtils.getResponsiveSpacing(
                        context,
                        4,
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(vaccination.status),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      vaccination.status.name.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ResponsiveUtils.getResponsiveFontSize(
                          context,
                          10,
                        ),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: ResponsiveUtils.getResponsiveSpacing(context, 12),
              ),

              // Animal Details
              _buildInfoRow(
                context,
                icon: Icons.pets,
                label: vaccination.animalInfo.species.name,
                value: vaccination.animalInfo.breed ?? 'Unknown',
              ),

              SizedBox(
                height: ResponsiveUtils.getResponsiveSpacing(context, 6),
              ),

              // Location
              _buildInfoRow(
                context,
                icon: Icons.location_on,
                label: 'ward'.tr,
                value: vaccination.wardName,
              ),

              SizedBox(
                height: ResponsiveUtils.getResponsiveSpacing(context, 6),
              ),

              // Vaccination Date
              _buildInfoRow(
                context,
                icon: Icons.calendar_today,
                label: 'date'.tr,
                value: _formatDate(vaccination.vaccinationDate),
              ),

              SizedBox(
                height: ResponsiveUtils.getResponsiveSpacing(context, 6),
              ),

              // Veterinarian
              _buildInfoRow(
                context,
                icon: Icons.person,
                label: 'veterinarian'.tr,
                value: vaccination.veterinarianName,
              ),

              if (vaccination.nextDueDate != null) ...[
                SizedBox(
                  height: ResponsiveUtils.getResponsiveSpacing(context, 6),
                ),
                _buildInfoRow(
                  context,
                  icon: Icons.schedule,
                  label: 'next_due'.tr,
                  value: _formatDate(vaccination.nextDueDate!),
                  valueColor: _isOverdue(vaccination.nextDueDate!)
                      ? Colors.red
                      : null,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: ResponsiveUtils.getIconSize(context, 14),
          color: Theme.of(context).textTheme.bodySmall?.color,
        ),
        SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 8)),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12),
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12),
              fontWeight: FontWeight.w500,
              color: valueColor,
            ),
          ),
        ),
      ],
    );
  }

  // Helper methods
  void _handleMenuAction(String action) {
    switch (action) {
      case 'filter':
        _showFilterDialog();
        break;
      case 'export':
        controller.exportVaccinations();
        break;
    }
  }

  void _showFilterDialog() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'filter_options'.tr,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Filter options would go here
            ElevatedButton(
              onPressed: () => Get.back(),
              child: Text('close'.tr),
            ),
          ],
        ),
      ),
    );
  }

  void _showStatusFilterDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Text('filter_by_status'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: VaccinationStatus.values.map((status) {
            return ListTile(
              title: Text(status.name),
              onTap: () {
                controller.filterByStatus(status.name);
                Get.back();
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('cancel'.tr)),
        ],
      ),
    );
  }

  void _showVaccineTypeFilterDialog(BuildContext context) {
    final vaccineTypes = controller.getUniqueVaccineTypes();

    Get.dialog(
      AlertDialog(
        title: Text('filter_by_vaccine_type'.tr),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: vaccineTypes.length,
            itemBuilder: (context, index) {
              final type = vaccineTypes[index];
              return ListTile(
                title: Text(type),
                onTap: () {
                  controller.filterByVaccineType(type);
                  Get.back();
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('cancel'.tr)),
        ],
      ),
    );
  }

  void _showWardFilterDialog(BuildContext context) {
    final wards = controller.getUniqueWards();

    Get.dialog(
      AlertDialog(
        title: Text('filter_by_ward'.tr),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: wards.length,
            itemBuilder: (context, index) {
              final ward = wards[index];
              return ListTile(
                title: Text(ward),
                onTap: () {
                  controller.filterByWard(ward);
                  Get.back();
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('cancel'.tr)),
        ],
      ),
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

  bool _isOverdue(DateTime date) {
    return date.isBefore(DateTime.now());
  }
}

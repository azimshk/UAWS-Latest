import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/bite_case_controller.dart';
import '../../../shared/models/models.dart';
import '../../../shared/utils/responsive_utils.dart';
import 'bite_case_detail_screen.dart';

class BiteCaseListScreen extends GetView<BiteCaseController> {
  const BiteCaseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Bite Cases'),
        backgroundColor: const Color(0xFF7B1FA2),
        foregroundColor: Colors.white,
        centerTitle: true,
        toolbarHeight: ResponsiveUtils.getAppBarHeight(context),
        actions: [
          IconButton(
            onPressed: controller.refreshBiteCases,
            icon: Icon(
              Icons.refresh,
              size: ResponsiveUtils.getIconSize(context, 24),
            ),
            tooltip: 'Refresh',
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
                    const Text('Filter'),
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
                    const Text('Export'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshBiteCases,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                // Search and Filter Section
                _buildSearchAndFilterSection(context),

                // Bite Case List
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading) {
                      return _buildLoadingView(context);
                    }

                    if (controller.filteredBiteCases.isEmpty) {
                      return _buildEmptyView(context);
                    }

                    return _buildBiteCaseList(context);
                  }),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddBiteCaseDialog(context),
        backgroundColor: const Color(0xFF7B1FA2),
        tooltip: 'Report New Case',
        child: Icon(Icons.add, size: ResponsiveUtils.getIconSize(context, 24)),
      ),
    );
  }

  void _handleMenuAction(String value) {
    switch (value) {
      case 'filter':
        _showFilterDialog();
        break;
      case 'export':
        _exportBiteCases();
        break;
    }
  }

  Widget _buildSearchAndFilterSection(BuildContext context) {
    return Container(
      padding: ResponsiveUtils.getResponsivePadding(context),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor, width: 1),
        ),
      ),
      child: Column(
        children: [
          // Search Bar
          TextField(
            onChanged: controller.updateSearchQuery,
            decoration: InputDecoration(
              hintText: 'Search bite cases...',
              prefixIcon: Icon(
                Icons.search,
                size: ResponsiveUtils.getIconSize(context, 20),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Theme.of(context).dividerColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF7B1FA2)),
              ),
              contentPadding: ResponsiveUtils.getResponsivePadding(context),
              filled: true,
              fillColor: Theme.of(context).inputDecorationTheme.fillColor,
            ),
          ),

          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 12)),

          // Filter Chips
          Obx(
            () => Wrap(
              spacing: ResponsiveUtils.getResponsiveSpacing(context, 8),
              runSpacing: ResponsiveUtils.getResponsiveSpacing(context, 4),
              children: [
                _buildFilterChip(
                  context,
                  'All',
                  controller.selectedStatus.isEmpty,
                  () => controller.updateStatusFilter(''),
                ),
                ...BiteCaseStatus.values.map(
                  (status) => _buildFilterChip(
                    context,
                    status.name,
                    controller.selectedStatus == status.name,
                    () => controller.updateStatusFilter(status.name),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12),
          color: isSelected
              ? Colors.white
              : Theme.of(context).textTheme.bodyMedium?.color,
        ),
      ),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: const Color(0xFF7B1FA2),
      backgroundColor: Theme.of(context).chipTheme.backgroundColor,
      showCheckmark: false,
    );
  }

  Widget _buildLoadingView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF7B1FA2)),
            strokeWidth: ResponsiveUtils.getResponsiveSpacing(context, 3),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
          Text(
            'Loading bite cases...',
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.pets_outlined,
            size: ResponsiveUtils.getIconSize(context, 64),
            color: Theme.of(context).disabledColor,
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 16)),
          Text(
            'No bite cases found',
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18),
              fontWeight: FontWeight.w500,
              color: Theme.of(context).textTheme.titleMedium?.color,
            ),
          ),
          SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 8)),
          Text(
            'Tap the + button to report a new case',
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14),
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBiteCaseList(BuildContext context) {
    return ListView.builder(
      padding: ResponsiveUtils.getResponsivePadding(context),
      itemCount: controller.filteredBiteCases.length,
      itemBuilder: (context, index) {
        final biteCase = controller.filteredBiteCases[index];
        return _buildBiteCaseCard(context, biteCase);
      },
    );
  }

  Widget _buildBiteCaseCard(BuildContext context, BiteCaseModel biteCase) {
    return Card(
      margin: EdgeInsets.only(
        bottom: ResponsiveUtils.getResponsiveSpacing(context, 12),
      ),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _navigateToBiteCaseDetail(biteCase),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: ResponsiveUtils.getResponsivePadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Case #${biteCase.id}',
                          style: TextStyle(
                            fontSize: ResponsiveUtils.getResponsiveFontSize(
                              context,
                              16,
                            ),
                            fontWeight: FontWeight.bold,
                            color: Theme.of(
                              context,
                            ).textTheme.titleMedium?.color,
                          ),
                        ),
                        SizedBox(
                          height: ResponsiveUtils.getResponsiveSpacing(
                            context,
                            4,
                          ),
                        ),
                        Text(
                          biteCase.victimDetails.name,
                          style: TextStyle(
                            fontSize: ResponsiveUtils.getResponsiveFontSize(
                              context,
                              14,
                            ),
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(context, biteCase.status),
                ],
              ),

              SizedBox(
                height: ResponsiveUtils.getResponsiveSpacing(context, 12),
              ),

              // Details Row
              Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      context,
                      Icons.location_on,
                      biteCase.location.ward ?? 'Unknown Ward',
                    ),
                  ),
                  Expanded(
                    child: _buildInfoItem(
                      context,
                      Icons.pets,
                      biteCase.animalDetails.species,
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: ResponsiveUtils.getResponsiveSpacing(context, 8),
              ),

              Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      context,
                      Icons.calendar_today,
                      _formatDate(biteCase.incidentDate),
                    ),
                  ),
                  Expanded(
                    child: _buildPriorityItem(context, biteCase.priority),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, BiteCaseStatus status) {
    Color backgroundColor;
    Color textColor;

    switch (status) {
      case BiteCaseStatus.open:
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade800;
        break;
      case BiteCaseStatus.underInvestigation:
        backgroundColor = Colors.blue.shade100;
        textColor = Colors.blue.shade800;
        break;
      case BiteCaseStatus.closed:
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade800;
        break;
      case BiteCaseStatus.referred:
        backgroundColor = Colors.purple.shade100;
        textColor = Colors.purple.shade800;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.getResponsiveSpacing(context, 8),
        vertical: ResponsiveUtils.getResponsiveSpacing(context, 4),
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(
          fontSize: ResponsiveUtils.getResponsiveFontSize(context, 10),
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: ResponsiveUtils.getIconSize(context, 16),
          color: Theme.of(context).textTheme.bodySmall?.color,
        ),
        SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 4)),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12),
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildPriorityItem(BuildContext context, BiteCasePriority priority) {
    Color color;
    switch (priority) {
      case BiteCasePriority.critical:
        color = Colors.red;
        break;
      case BiteCasePriority.high:
        color = Colors.orange;
        break;
      case BiteCasePriority.medium:
        color = Colors.yellow.shade700;
        break;
      case BiteCasePriority.low:
        color = Colors.green;
        break;
    }

    return Row(
      children: [
        Icon(
          Icons.priority_high,
          size: ResponsiveUtils.getIconSize(context, 16),
          color: color,
        ),
        SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 4)),
        Expanded(
          child: Text(
            priority.name.toUpperCase(),
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12),
              color: color,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _navigateToBiteCaseDetail(BiteCaseModel biteCase) {
    Get.to(() => BiteCaseDetailScreen(biteCase: biteCase));
  }

  void _showAddBiteCaseDialog(BuildContext context) {
    // TODO: Navigate to add bite case screen
    Get.snackbar(
      'Info',
      'Add bite case screen not implemented yet',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _showFilterDialog() {
    // TODO: Implement filter dialog
    Get.snackbar(
      'Info',
      'Filter dialog not implemented yet',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _exportBiteCases() {
    // TODO: Implement export functionality
    Get.snackbar(
      'Info',
      'Export functionality not implemented yet',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/vaccination_controller.dart';
import '../../../shared/models/models.dart';
import '../../../shared/utils/responsive_utils.dart';

class AddVaccinationScreen extends GetView<VaccinationController> {
  const AddVaccinationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('add_vaccination'.tr),
        backgroundColor: const Color(0xFF7B1FA2),
        foregroundColor: Colors.white,
        centerTitle: true,
        toolbarHeight: ResponsiveUtils.getAppBarHeight(context),
      ),
      body: Obx(
        () => controller.isLoading
            ? _buildLoadingView(context)
            : _buildFormView(context),
      ),
      bottomNavigationBar: _buildBottomBar(context),
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
            'saving_vaccination'.tr,
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormView(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: SingleChildScrollView(
        padding: ResponsiveUtils.getResponsivePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Animal Information Section
            _buildSectionCard(
              context,
              title: 'animal_information'.tr,
              icon: Icons.pets,
              children: [
                _buildAnimalIdField(context),
                SizedBox(
                  height: ResponsiveUtils.getResponsiveSpacing(context, 16),
                ),
                _buildSpeciesDropdown(context),
                SizedBox(
                  height: ResponsiveUtils.getResponsiveSpacing(context, 16),
                ),
                _buildBreedField(context),
                SizedBox(
                  height: ResponsiveUtils.getResponsiveSpacing(context, 16),
                ),
                _buildSexDropdown(context),
                SizedBox(
                  height: ResponsiveUtils.getResponsiveSpacing(context, 16),
                ),
                _buildAgeDropdown(context),
                SizedBox(
                  height: ResponsiveUtils.getResponsiveSpacing(context, 16),
                ),
                _buildColorField(context),
                SizedBox(
                  height: ResponsiveUtils.getResponsiveSpacing(context, 16),
                ),
                _buildWeightField(context),
              ],
            ),

            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 20)),

            // Vaccination Details Section
            _buildSectionCard(
              context,
              title: 'vaccination_details'.tr,
              icon: Icons.vaccines,
              children: [
                _buildVaccineTypeDropdown(context),
                SizedBox(
                  height: ResponsiveUtils.getResponsiveSpacing(context, 16),
                ),
                _buildBatchNumberField(context),
                SizedBox(
                  height: ResponsiveUtils.getResponsiveSpacing(context, 16),
                ),
                _buildVaccinationDateField(context),
                SizedBox(
                  height: ResponsiveUtils.getResponsiveSpacing(context, 16),
                ),
                _buildNextDueDateField(context),
                SizedBox(
                  height: ResponsiveUtils.getResponsiveSpacing(context, 16),
                ),
                _buildStatusDropdown(context),
              ],
            ),

            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 20)),

            // Location Information Section
            _buildSectionCard(
              context,
              title: 'location_information'.tr,
              icon: Icons.location_on,
              children: [
                _buildWardDropdown(context),
                SizedBox(
                  height: ResponsiveUtils.getResponsiveSpacing(context, 16),
                ),
                _buildAddressField(context),
                SizedBox(
                  height: ResponsiveUtils.getResponsiveSpacing(context, 16),
                ),
                _buildLocationButton(context),
              ],
            ),

            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 20)),

            // Veterinarian Information Section
            _buildSectionCard(
              context,
              title: 'veterinarian_information'.tr,
              icon: Icons.person,
              children: [
                _buildVeterinarianNameField(context),
                SizedBox(
                  height: ResponsiveUtils.getResponsiveSpacing(context, 16),
                ),
                _buildVeterinarianLicenseField(context),
              ],
            ),

            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 20)),

            // Additional Information Section
            _buildSectionCard(
              context,
              title: 'additional_information'.tr,
              icon: Icons.note,
              children: [
                _buildNotesField(context),
                SizedBox(
                  height: ResponsiveUtils.getResponsiveSpacing(context, 16),
                ),
                _buildCostField(context),
                SizedBox(
                  height: ResponsiveUtils.getResponsiveSpacing(context, 16),
                ),
                _buildSideEffectsField(context),
              ],
            ),

            SizedBox(
              height: ResponsiveUtils.getResponsiveSpacing(context, 100),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(
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
            SizedBox(height: ResponsiveUtils.getResponsiveSpacing(context, 20)),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildAnimalIdField(BuildContext context) {
    return TextFormField(
      controller: controller.animalIdController,
      decoration: InputDecoration(
        labelText: 'animal_id'.tr,
        hintText: 'enter_animal_id'.tr,
        prefixIcon: Icon(
          Icons.pets,
          size: ResponsiveUtils.getIconSize(context, 20),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      validator: (value) {
        if (value?.isEmpty == true) {
          return 'animal_id_required'.tr;
        }
        return null;
      },
    );
  }

  Widget _buildSpeciesDropdown(BuildContext context) {
    return Obx(
      () => DropdownButtonFormField<AnimalSpecies>(
        value: controller.selectedSpecies.value,
        decoration: InputDecoration(
          labelText: 'species'.tr,
          prefixIcon: Icon(
            Icons.category,
            size: ResponsiveUtils.getIconSize(context, 20),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        items: AnimalSpecies.values.map((species) {
          return DropdownMenuItem(
            value: species,
            child: Text(species.name.capitalizeFirst!),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            controller.updateSpecies(value);
          }
        },
        validator: (value) {
          if (value == null) {
            return 'species_required'.tr;
          }
          return null;
        },
      ),
    );
  }

  Widget _buildBreedField(BuildContext context) {
    return TextFormField(
      controller: controller.breedController,
      decoration: InputDecoration(
        labelText: 'breed'.tr,
        hintText: 'enter_breed'.tr,
        prefixIcon: Icon(
          Icons.pets,
          size: ResponsiveUtils.getIconSize(context, 20),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildSexDropdown(BuildContext context) {
    return Obx(
      () => DropdownButtonFormField<AnimalSex>(
        value: controller.selectedSex.value,
        decoration: InputDecoration(
          labelText: 'sex'.tr,
          prefixIcon: Icon(
            Icons.info,
            size: ResponsiveUtils.getIconSize(context, 20),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        items: AnimalSex.values.map((sex) {
          return DropdownMenuItem(
            value: sex,
            child: Text(sex.name.capitalizeFirst!),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            controller.updateSex(value);
          }
        },
        validator: (value) {
          if (value == null) {
            return 'sex_required'.tr;
          }
          return null;
        },
      ),
    );
  }

  Widget _buildAgeDropdown(BuildContext context) {
    return Obx(
      () => DropdownButtonFormField<AnimalAge>(
        value: controller.selectedAge.value,
        decoration: InputDecoration(
          labelText: 'age_category'.tr,
          prefixIcon: Icon(
            Icons.cake,
            size: ResponsiveUtils.getIconSize(context, 20),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        items: AnimalAge.values.map((age) {
          return DropdownMenuItem(
            value: age,
            child: Text(age.name.capitalizeFirst!),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            controller.updateAge(value);
          }
        },
        validator: (value) {
          if (value == null) {
            return 'age_required'.tr;
          }
          return null;
        },
      ),
    );
  }

  Widget _buildColorField(BuildContext context) {
    return TextFormField(
      controller: controller.colorController,
      decoration: InputDecoration(
        labelText: 'color'.tr,
        hintText: 'enter_color'.tr,
        prefixIcon: Icon(
          Icons.color_lens,
          size: ResponsiveUtils.getIconSize(context, 20),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      validator: (value) {
        if (value?.isEmpty == true) {
          return 'color_required'.tr;
        }
        return null;
      },
    );
  }

  Widget _buildWeightField(BuildContext context) {
    return TextFormField(
      controller: controller.weightController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'weight_kg'.tr,
        hintText: 'enter_weight'.tr,
        prefixIcon: Icon(
          Icons.monitor_weight,
          size: ResponsiveUtils.getIconSize(context, 20),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildVaccineTypeDropdown(BuildContext context) {
    final vaccineTypes = [
      'Rabies',
      'DHPP',
      'FVRCP',
      'Bordetella',
      'Lyme',
      'Other',
    ];

    return Obx(
      () => DropdownButtonFormField<String>(
        value: controller.selectedVaccineType.isNotEmpty
            ? controller.selectedVaccineType
            : null,
        decoration: InputDecoration(
          labelText: 'vaccine_type'.tr,
          prefixIcon: Icon(
            Icons.vaccines,
            size: ResponsiveUtils.getIconSize(context, 20),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        items: vaccineTypes.map((type) {
          return DropdownMenuItem(value: type, child: Text(type));
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            controller.updateVaccineType(value);
          }
        },
        validator: (value) {
          if (value?.isEmpty == true) {
            return 'vaccine_type_required'.tr;
          }
          return null;
        },
      ),
    );
  }

  Widget _buildBatchNumberField(BuildContext context) {
    return TextFormField(
      controller: controller.batchNumberController,
      decoration: InputDecoration(
        labelText: 'batch_number'.tr,
        hintText: 'enter_batch_number'.tr,
        prefixIcon: Icon(
          Icons.qr_code,
          size: ResponsiveUtils.getIconSize(context, 20),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      validator: (value) {
        if (value?.isEmpty == true) {
          return 'batch_number_required'.tr;
        }
        return null;
      },
    );
  }

  Widget _buildVaccinationDateField(BuildContext context) {
    return Obx(
      () => TextFormField(
        controller: controller.vaccinationDateController,
        readOnly: true,
        decoration: InputDecoration(
          labelText: 'vaccination_date'.tr,
          hintText: 'select_vaccination_date'.tr,
          prefixIcon: Icon(
            Icons.calendar_today,
            size: ResponsiveUtils.getIconSize(context, 20),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onTap: () => _selectVaccinationDate(context),
        validator: (value) {
          if (value?.isEmpty == true) {
            return 'vaccination_date_required'.tr;
          }
          return null;
        },
      ),
    );
  }

  Widget _buildNextDueDateField(BuildContext context) {
    return Obx(
      () => TextFormField(
        controller: controller.nextDueDateController,
        readOnly: true,
        decoration: InputDecoration(
          labelText: 'next_due_date'.tr,
          hintText: 'select_next_due_date'.tr,
          prefixIcon: Icon(
            Icons.schedule,
            size: ResponsiveUtils.getIconSize(context, 20),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onTap: () => _selectNextDueDate(context),
      ),
    );
  }

  Widget _buildStatusDropdown(BuildContext context) {
    return Obx(
      () => DropdownButtonFormField<VaccinationStatus>(
        value: controller.selectedVaccinationStatus.value,
        decoration: InputDecoration(
          labelText: 'status'.tr,
          prefixIcon: Icon(
            Icons.flag,
            size: ResponsiveUtils.getIconSize(context, 20),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        items: VaccinationStatus.values.map((status) {
          return DropdownMenuItem(
            value: status,
            child: Text(status.name.capitalizeFirst!),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            controller.updateVaccinationStatus(value);
          }
        },
        validator: (value) {
          if (value == null) {
            return 'status_required'.tr;
          }
          return null;
        },
      ),
    );
  }

  Widget _buildWardDropdown(BuildContext context) {
    return Obx(
      () => DropdownButtonFormField<String>(
        value: controller.selectedWard.isNotEmpty
            ? controller.selectedWard
            : null,
        decoration: InputDecoration(
          labelText: 'ward'.tr,
          prefixIcon: Icon(
            Icons.map,
            size: ResponsiveUtils.getIconSize(context, 20),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        items: controller.getUniqueWards().map((ward) {
          return DropdownMenuItem(value: ward, child: Text(ward));
        }).toList(),
        onChanged: (value) {
          if (value != null) {
            controller.filterByWard(value);
          }
        },
        validator: (value) {
          if (value?.isEmpty == true) {
            return 'ward_required'.tr;
          }
          return null;
        },
      ),
    );
  }

  Widget _buildAddressField(BuildContext context) {
    return TextFormField(
      controller: controller.addressController,
      decoration: InputDecoration(
        labelText: 'address'.tr,
        hintText: 'enter_address'.tr,
        prefixIcon: Icon(
          Icons.home,
          size: ResponsiveUtils.getIconSize(context, 20),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildLocationButton(BuildContext context) {
    return Obx(
      () => Card(
        child: ListTile(
          leading: Icon(
            Icons.gps_fixed,
            color: const Color(0xFF7B1FA2),
            size: ResponsiveUtils.getIconSize(context, 24),
          ),
          title: Text(
            controller.currentLocation.value != null
                ? 'location_captured'.tr
                : 'capture_location'.tr,
          ),
          subtitle: controller.currentLocation.value != null
              ? Text(
                  '${controller.currentLocation.value!.lat.toStringAsFixed(6)}, ${controller.currentLocation.value!.lng.toStringAsFixed(6)}',
                )
              : Text('tap_to_capture_location'.tr),
          trailing: Icon(
            controller.currentLocation.value != null
                ? Icons.check_circle
                : Icons.location_searching,
            color: controller.currentLocation.value != null
                ? Colors.green
                : Colors.grey,
            size: ResponsiveUtils.getIconSize(context, 20),
          ),
          onTap: () => controller.captureCurrentLocation(),
        ),
      ),
    );
  }

  Widget _buildVeterinarianNameField(BuildContext context) {
    return TextFormField(
      controller: controller.veterinarianNameController,
      decoration: InputDecoration(
        labelText: 'veterinarian_name'.tr,
        hintText: 'enter_veterinarian_name'.tr,
        prefixIcon: Icon(
          Icons.person,
          size: ResponsiveUtils.getIconSize(context, 20),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      validator: (value) {
        if (value?.isEmpty == true) {
          return 'veterinarian_name_required'.tr;
        }
        return null;
      },
    );
  }

  Widget _buildVeterinarianLicenseField(BuildContext context) {
    return TextFormField(
      controller: controller.veterinarianLicenseController,
      decoration: InputDecoration(
        labelText: 'veterinarian_license'.tr,
        hintText: 'enter_veterinarian_license'.tr,
        prefixIcon: Icon(
          Icons.badge,
          size: ResponsiveUtils.getIconSize(context, 20),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      validator: (value) {
        if (value?.isEmpty == true) {
          return 'veterinarian_license_required'.tr;
        }
        return null;
      },
    );
  }

  Widget _buildNotesField(BuildContext context) {
    return TextFormField(
      controller: controller.notesController,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: 'notes'.tr,
        hintText: 'enter_notes'.tr,
        prefixIcon: Icon(
          Icons.note,
          size: ResponsiveUtils.getIconSize(context, 20),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        alignLabelWithHint: true,
      ),
    );
  }

  Widget _buildCostField(BuildContext context) {
    return TextFormField(
      controller: controller.costController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'cost'.tr,
        hintText: 'enter_cost'.tr,
        prefixIcon: Icon(
          Icons.currency_rupee,
          size: ResponsiveUtils.getIconSize(context, 20),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildSideEffectsField(BuildContext context) {
    return TextFormField(
      controller: controller.sideEffectsController,
      maxLines: 2,
      decoration: InputDecoration(
        labelText: 'side_effects'.tr,
        hintText: 'enter_side_effects'.tr,
        prefixIcon: Icon(
          Icons.warning,
          size: ResponsiveUtils.getIconSize(context, 20),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        alignLabelWithHint: true,
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: ResponsiveUtils.getResponsivePadding(context),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Get.back(),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF7B1FA2),
                  side: const BorderSide(color: Color(0xFF7B1FA2)),
                  padding: EdgeInsets.symmetric(
                    vertical: ResponsiveUtils.getResponsiveSpacing(context, 16),
                  ),
                ),
                child: Text('cancel'.tr),
              ),
            ),
            SizedBox(width: ResponsiveUtils.getResponsiveSpacing(context, 16)),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () => _saveVaccination(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B1FA2),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    vertical: ResponsiveUtils.getResponsiveSpacing(context, 16),
                  ),
                ),
                child: Text('save_vaccination'.tr),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods
  Future<void> _selectVaccinationDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: controller.selectedVaccinationDate.value ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      controller.updateVaccinationDate(date);
    }
  }

  Future<void> _selectNextDueDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate:
          controller.selectedNextDueDate.value ??
          DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (date != null) {
      controller.updateNextDueDate(date);
    }
  }

  void _saveVaccination(BuildContext context) {
    if (controller.formKey.currentState?.validate() == true) {
      controller.saveVaccination();
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/features/listings/domain/entities/listing.dart';
import 'package:myapp/features/listings/presentation/bloc/listings_bloc.dart';
import 'package:myapp/features/listings/presentation/bloc/listings_event.dart';

class ListingFormPage extends StatefulWidget {
  final Listing? existing;
  final String currentUserId;

  const ListingFormPage({
    super.key,
    this.existing,
    required this.currentUserId,
  });

  @override
  State<ListingFormPage> createState() => _ListingFormPageState();
}

class _ListingFormPageState extends State<ListingFormPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _categoryController;
  late final TextEditingController _addressController;
  late final TextEditingController _contactController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _latController;
  late final TextEditingController _lngController;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _nameController = TextEditingController(text: existing?.name ?? '');
    _categoryController =
        TextEditingController(text: existing?.category ?? 'Café');
    _addressController = TextEditingController(text: existing?.address ?? '');
    _contactController =
        TextEditingController(text: existing?.contactNumber ?? '');
    _descriptionController =
        TextEditingController(text: existing?.description ?? '');
    _latController =
        TextEditingController(text: existing?.latitude.toString() ?? '');
    _lngController =
        TextEditingController(text: existing?.longitude.toString() ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    _descriptionController.dispose();
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existing != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Listing' : 'New Listing'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(_nameController, 'Name'),
                const SizedBox(height: 8),
                _buildTextField(_categoryController, 'Category'),
                const SizedBox(height: 8),
                _buildTextField(_addressController, 'Address'),
                const SizedBox(height: 8),
                _buildTextField(_contactController, 'Contact Number'),
                const SizedBox(height: 8),
                _buildTextField(_descriptionController, 'Description',
                    maxLines: 3),
                const SizedBox(height: 8),
                _buildTextField(_latController, 'Latitude',
                    keyboardType: TextInputType.number),
                const SizedBox(height: 8),
                _buildTextField(_lngController, 'Longitude',
                    keyboardType: TextInputType.number),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: Text(isEditing ? 'Update' : 'Create'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required';
        }
        return null;
      },
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final latitude = double.tryParse(_latController.text) ?? 0;
    final longitude = double.tryParse(_lngController.text) ?? 0;

    final listing = Listing(
      id: widget.existing?.id ?? '',
      name: _nameController.text.trim(),
      category: _categoryController.text.trim(),
      address: _addressController.text.trim(),
      contactNumber: _contactController.text.trim(),
      description: _descriptionController.text.trim(),
      latitude: latitude,
      longitude: longitude,
      createdBy: widget.existing?.createdBy ?? widget.currentUserId,
      timestamp: widget.existing?.timestamp ?? DateTime.now(),
    );

    final bloc = context.read<ListingsBloc>();
    if (widget.existing == null) {
      bloc.add(ListingCreated(listing));
    } else {
      bloc.add(ListingUpdated(listing));
    }

    Navigator.of(context).pop();
  }
}


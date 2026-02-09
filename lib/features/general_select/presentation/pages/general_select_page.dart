import 'package:fast_golden_taxi/features/general_select/presentation/providers/general_select_providers.dart';
import 'package:fast_golden_taxi/features/general_select/presentation/widgets/select_option_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Page for displaying and selecting options.
class GeneralSelectPage extends ConsumerStatefulWidget {
  final String type;
  final String? title;
  final String? searchHint;
  final int? limit;

  const GeneralSelectPage({super.key, required this.type, this.title, this.searchHint, this.limit});

  @override
  ConsumerState<GeneralSelectPage> createState() => _GeneralSelectPageState();
}

class _GeneralSelectPageState extends ConsumerState<GeneralSelectPage> {
  final TextEditingController _searchController = TextEditingController();
  String? _selectedOptionId;

  @override
  void initState() {
    super.initState();
    _loadOptions();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadOptions() {
    ref
        .read(generalSelectControllerProvider.notifier)
        .getSelectOptions(
          type: widget.type,
          search: _searchController.text.isEmpty ? null : _searchController.text,
          limit: widget.limit,
        );
  }

  void _onSearchChanged(String value) {
    _loadOptions();
  }

  void _onOptionSelected(String optionId) {
    setState(() {
      _selectedOptionId = optionId;
    });
    Navigator.pop(context, optionId);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(generalSelectControllerProvider);

    return Scaffold(
      appBar: AppBar(title: Text(widget.title ?? 'Select Option')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: widget.searchHint ?? 'Search...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.error != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48),
                        const SizedBox(height: 16),
                        Text(state.error!, textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        ElevatedButton(onPressed: _loadOptions, child: const Text('Retry')),
                      ],
                    ),
                  )
                : state.options.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.list_alt, size: 48, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text('No options found', style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: state.options.length,
                    itemBuilder: (context, index) {
                      final option = state.options[index];
                      return SelectOptionItem(
                        option: option,
                        isSelected: _selectedOptionId == option.id,
                        onTap: () => _onOptionSelected(option.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class UploadPyqsScreen extends StatefulWidget {
  const UploadPyqsScreen({Key? key}) : super(key: key);

  @override
  State<UploadPyqsScreen> createState() => _UploadPyqsScreenState();
}

class _UploadPyqsScreenState extends State<UploadPyqsScreen> {
  List<PlatformFile> _selectedFiles = [];

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      setState(() {
        _selectedFiles = result.files;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Upload PYQs')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 📘 Header
              Text(
                'Upload Previous Year Question Papers',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Upload PDFs or images of question papers to analyze and predict future exams.',
                style: theme.textTheme.bodyMedium,
              ),

              const SizedBox(height: 24),

              /// 📂 Upload Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        Icons.upload_file,
                        size: 48,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 12),

                      ElevatedButton.icon(
                        onPressed: _pickFiles,
                        icon: const Icon(Icons.folder_open),
                        label: const Text('Choose Files'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),

                      if (_selectedFiles.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Text(
                          '${_selectedFiles.length} file(s) selected',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              /// 📄 Selected Files
              if (_selectedFiles.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text('Selected Files', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),

                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _selectedFiles.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final file = _selectedFiles[index];
                    return ListTile(
                      leading: const Icon(Icons.insert_drive_file),
                      title: Text(file.name, overflow: TextOverflow.ellipsis),
                      subtitle: Text(
                        '${(file.size / 1024).toStringAsFixed(1)} KB',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            _selectedFiles.removeAt(index);
                          });
                        },
                      ),
                    );
                  },
                ),
              ],

              const SizedBox(height: 24),

              /// ℹ️ Info Section (RESTORED)
              Card(
                color: theme.colorScheme.surfaceContainerHighest,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Once uploaded, PrepNexa will extract questions, analyze topic-wise trends, and use AI to predict future question papers.',
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

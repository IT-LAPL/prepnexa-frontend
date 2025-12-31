import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import '../auth/auth_service.dart';

class UploadPyqsScreen extends StatefulWidget {
  const UploadPyqsScreen({Key? key}) : super(key: key);

  @override
  State<UploadPyqsScreen> createState() => _UploadPyqsScreenState();
}

class _UploadPyqsScreenState extends State<UploadPyqsScreen> {
  List<PlatformFile> _selectedFiles = [];
  bool _uploading = false;

  // fixed values requested
  static const String _examId = 'd57b0541-dcb1-4784-893b-f676dd766f2c';
  static const String _year = '2023';

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

  Future<void> _uploadFiles() async {
    if (_selectedFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No files selected')));
      return;
    }

    setState(() => _uploading = true);

    try {
      final auth = AuthService.instance;
      final uri = Uri.parse('https://prepnexa-api.stpindia.org/uploads');

      final request = http.MultipartRequest('POST', uri);

      // Add Authorization header
      if (auth.accessToken != null) {
        request.headers['Authorization'] = 'Bearer ${auth.accessToken}';
      }

      // Add fields
      request.fields['exam_id'] = _examId;
      request.fields['year'] = _year;

      // Attach files
      for (var pf in _selectedFiles) {
        if (pf.bytes != null) {
          request.files.add(http.MultipartFile.fromBytes('files', pf.bytes!, filename: pf.name));
        } else if (pf.path != null) {
          request.files.add(await http.MultipartFile.fromPath('files', pf.path!, filename: pf.name));
        }
      }

      final streamed = await request.send();
      final res = await http.Response.fromStream(streamed);

      if (res.statusCode == 200 || res.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Upload successful')));
        setState(() => _selectedFiles = []);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload failed: ${res.statusCode}')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload error: $e')));
    } finally {
      setState(() => _uploading = false);
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

                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton(
                              onPressed: _uploading ? null : _uploadFiles,
                              child: _uploading
                                  ? SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: theme.colorScheme.onPrimary))
                                  : const Text('Upload to /uploads'),
                            ),
                          ),
                        ],
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
                          'Once uploaded, Cognix will extract questions, analyze topic-wise trends, and use AI to predict future question papers.',
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

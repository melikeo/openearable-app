import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:open_earable_flutter/open_earable_flutter.dart';
import '../../../view_models/wearables_provider.dart';

class NoiseCancellingUIView extends StatefulWidget {
  const NoiseCancellingUIView({super.key});

  @override
  State<NoiseCancellingUIView> createState() => _NoiseCancellingUIViewState();

}

  class _NoiseCancellingUIViewState extends State<NoiseCancellingUIView> {

  String? _selectedMode;
  bool _isLoading = false;

  Future<void> _applyMode(String modeName, AudioMode mode) async {
    setState(() => _isLoading = true);

    final provider = Provider.of<WearablesProvider>(context, listen: false);

    final success = await provider.applyAudioModeToAll(mode);

    setState(() {
      _isLoading = false;
      if (success) {
        _selectedMode = modeName;
      }
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success
              ? 'Mode "$modeName" applied'
              : 'Error applying mode'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<WearablesProvider>(
      builder: (context, provider, child) {

        final hasAudioDevices = provider.wearables.any(
          (w) => w is AudioModeManager,
        );


    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: PlatformText('Noise Cancelling'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),

        child: hasAudioDevices
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PlatformText(
              'Choose a filter',
            ),
            const SizedBox(height: 20),

            PlatformElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () => _applyMode('No high pitch sudden sounds (Normal)', const NormalMode()),
              child: PlatformText("Filter 1 / Bahn Filter"),
            ),
            const SizedBox(height: 10),

            PlatformElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () => _applyMode('Dialogue Boost (Transparency)', const TransparencyMode()),
              child: PlatformText("Filter 2 / Dialogue Boost"),
            ),
            const SizedBox(height: 10),

            PlatformElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () => _applyMode('Noise Cancellation', const NoiseCancellationMode()),
              child: PlatformText("Filter 3 / Noise Cancelling"),
            ),
            PlatformElevatedButton(
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Add new mode'),
                  content: const Text('AlertDialog description'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                    TextButton(onPressed: () => Navigator.pop(context, 'OK'), child: const Text('OK')),
                  ],
                ),
              ),
              child: const Text('Add new mode'),
            ),
          ],
        )
            : Center(
                child: PlatformText(
                  'No audio devices connected.',
                ),
      ),
        ),
    );
      },
    );
  }
  }
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

  class _NoiseCancellingUIViewState extends State<NoiseCancellingUIView> with AutomaticKeepAliveClientMixin{

  String? _selectedMode;
  bool _isLoading = false;
  String? _selectedNewFilter;
  List<Map<String, String>> _customFilters = [];


  final List<Map<String, String>> _suggestedFilters = [
    {'title': 'Grocery Shopping', 'subtitle': 'Reduce shopping noise'},
    {'title': 'Mouth Sounds', 'subtitle': 'Block eating sounds'},
    {'title': 'Office Sounds', 'subtitle': 'Keyboard clicking, etc.'},
    {'title': 'Paper Rustling', 'subtitle': 'No paper sounds'},
    {'title': 'Background Chatter', 'subtitle': 'Reduce people talking'},
    {'title': 'Traffic Quieting', 'subtitle': 'Reduce road noise'},
  ];


  @override
  bool get wantKeepAlive => true;


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
              ? '"$modeName" applied'
              : 'Error applying mode'),
        ),
      );
    }
  }

  Widget _buildFilterButton({
    required String title,
    required String subtitle,
    required String modeName,
    required AudioMode mode,
  }) {
    final isSelected = _selectedMode == modeName;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return PlatformElevatedButton(
      onPressed: _isLoading ? null : () => _applyMode(modeName, mode),

      material: (_, __) => MaterialElevatedButtonData(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(15),
          minimumSize: Size.fromHeight(72),
          side: BorderSide(
            color: isSelected ? primaryColor : Colors.grey.shade300,
            width: 1,
          )
        ),
      ),

      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isSelected ? primaryColor : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? primaryColor : Colors.grey,
                width: 2,
              ),
            ),
            child: isSelected ? Icon(Icons.check, color: Colors.white, size: 20) : null,
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewFilterButton({
    required String title,
    required String subtitle,
    required StateSetter setDialogState,
  }) {

    final isSelected = _selectedNewFilter == title;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return PlatformElevatedButton(
      onPressed: () {
        setDialogState(() {
          _selectedNewFilter = title;
        });
      },

      material: (_, __) => MaterialElevatedButtonData(
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(10),
            minimumSize: Size.fromHeight(72),
            side: BorderSide(
              color: isSelected ? primaryColor : Colors.grey.shade300,
              width: 1,
            )
        ),
      ),

      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isSelected ? primaryColor : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? primaryColor : Colors.grey,
                width: 2,
              ),
            ),
            child: isSelected ? Icon(Icons.check, color: Colors.white, size: 20) : null,
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionFilterButton({
    required String title,
    required String subtitle,
  }) {

    final isSelected = _selectedNewFilter == title;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return PlatformElevatedButton(
      onPressed: () {},

      material: (_, __) => MaterialElevatedButtonData(
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(10),
            minimumSize: Size.fromHeight(72),
            side: BorderSide(
              color: Colors.grey.shade300,
              width: 1,
            )
        ),
      ),

      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey,
                width: 2,
              ),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
  super.build(context);
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

          /*
          *
          * child: hasAudioDevices
            ? Column(
          *
          *
          *  */


          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: PlatformText('Choose a filter', style: TextStyle(fontSize: 20)),
            ),

            const SizedBox(height: 20),

            _buildFilterButton(
              title: 'Train Screech Filter',
              subtitle: 'No sudden, high pitch sounds',
              modeName: 'Train Screech Filter',
              mode: const NormalMode(),
            ),

            const SizedBox(height: 10),

            _buildFilterButton(
              title: 'Dialogue Boost',
              subtitle: 'Hear your dialogue partner better',
              modeName: 'Dialogue Boost',
              mode: const TransparencyMode(),
            ),

            const SizedBox(height: 10),

            _buildFilterButton(
              title: 'Active Noise Cancelling',
              subtitle: 'Block all sounds',
              modeName: 'Active Noise Cancelling',
              mode: const NoiseCancellationMode(),
            ),

            ..._customFilters.map((filter) => Column(
              children: [
                const SizedBox(height: 10),
                _buildSuggestionFilterButton(
                  title: filter['title']!,
                  subtitle: filter['subtitle']!,
                ),
              ],
            )),

            const SizedBox(height: 10),

            PlatformElevatedButton(
              child: const Text(
                '+ Add a new filter',
                style: TextStyle(fontSize: 18)),

              onPressed: () {
                setState(() {
                  _selectedNewFilter = null;
                });

                showDialog<String>(
                  context: context,
                  builder: (BuildContext dialogContext) => StatefulBuilder(
                    builder: (context, setDialogState) {
                      return
                        AlertDialog(
                          title: const Text('Add a new filter'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [

                              Text('Choose from our suggestions or create your own filter.', style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                              SizedBox(height: 10),

                              ..._suggestedFilters.map((filter) => Column(
                                children: [
                                  _buildNewFilterButton(
                                    title: filter['title']!,
                                    subtitle: filter['subtitle']!,
                                    setDialogState: setDialogState,
                                  ),
                                  SizedBox(height: 10),
                                ],
                              )),

                              SizedBox(height: 20),


                              PlatformElevatedButton(
                                  child: const Text(
                                      '+ Create your own filter',
                                      style: TextStyle(fontSize: 18)),
                                  onPressed: () {}
                              ),

                            ],
                          ),

                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel', style: TextStyle(color: Colors.red)),
                            ),
                            TextButton(
                                onPressed: () {
                                  if (_selectedNewFilter != null) {
                                    setState(() {



                                      _customFilters.add({
                                        'title': _selectedNewFilter!,
                                        'subtitle': 'Custom filter',
                                      });
                                      _suggestedFilters.removeWhere((filter) => filter['title'] == _selectedNewFilter);
                                    });
                                  }
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'))
                          ],
                        );
                    }
                )
                );
              }
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

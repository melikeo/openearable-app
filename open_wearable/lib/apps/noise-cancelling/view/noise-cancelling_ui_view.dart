import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class NoiseCancellingUIView extends StatefulWidget {
  const NoiseCancellingUIView({super.key});

  @override
  State<NoiseCancellingUIView> createState() => _NoiseCancellingUIViewState();

}

  class _NoiseCancellingUIViewState extends State<NoiseCancellingUIView> {
  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: PlatformText('Noise Cancelling'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PlatformText(
              'Choose a filter',
            ),
            const SizedBox(height: 20),

            PlatformElevatedButton(
              onPressed: () {
                print("Filter 1 clicked");
              },
              child: PlatformText("Filter 1"),
            ),
            const SizedBox(height: 10),

            PlatformElevatedButton(
              onPressed: () {
                print("Filter 2 clicked");
              },
              child: PlatformText("Filter 2"),
            ),
            const SizedBox(height: 10),

            PlatformElevatedButton(
              onPressed: () {
                print("Filter 3 clicked");
              },
              child: PlatformText("Filter 3"),
            ),
          ],
        ),
      ),
    );
  }
  }

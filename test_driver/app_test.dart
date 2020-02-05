import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Treevia App', () {
    
    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the conection to the driver when all the tests are complete
    tearDownAll(() async {
      if(driver != null) {
        driver.close();
      }
    });

    test('check that material button responds to tap', () async {
      final buttonFinder = find.byValueKey('buttonId');
      final textFinder = find.byValueKey('buttonText');

      final Timeline _timeline = await driver.traceAction(() async {
        await driver.startTracing();

        await driver.tap(buttonFinder);

        expect(await driver.getText(textFinder), 'Continue');

        await driver.stopTracingAndDownloadTimeline();
      });

      final TimelineSummary summary = TimelineSummary.summarize(_timeline);

      summary.writeSummaryToFile('button_summary', pretty: true,);
    });
  });
}
import 'package:angular2/angular2.dart';
import 'package:angular2/platform/common.dart';
import 'package:rep_ftl/components/app.dart';
import 'package:angular2/platform/browser.dart';


main() {
  bootstrap(AppComponent, [provide(LocationStrategy, useClass: HashLocationStrategy)]);
}

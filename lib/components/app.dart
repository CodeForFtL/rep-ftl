import 'package:angular2/core.dart';
import 'package:ng_bootstrap/ng_bootstrap.dart';

@Component(selector: 'app',
    templateUrl: 'app.html',
    directives: const [BS_DIRECTIVES])
class AppComponent {
  bool isCollapsed = true;
}

import 'package:angular2/core.dart';
import 'package:ng_bootstrap/ng_bootstrap.dart';
import 'package:angular2/router.dart';
import 'package:rep_ftl/components/main/main.dart';

@Component(selector: 'app',
    templateUrl: 'app.html',
    directives: const [BS_DIRECTIVES, ROUTER_DIRECTIVES],
    providers: const [ROUTER_PROVIDERS] )
@RouteConfig(const [
  const Route(path: '/', name: 'Main', component: MainComponent)
])
class AppComponent {
  bool isCollapsed = true;
}

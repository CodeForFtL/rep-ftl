import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';
import 'package:ng_bootstrap/ng_bootstrap.dart';
import 'package:googleapis_auth/auth_browser.dart';
import 'package:googleapis/civicinfo/v2.dart';
import 'package:rep_ftl/components/reps/rep_detail.dart';
import 'representative.dart';

@Component(selector: 'rep-ftl-reps',
    templateUrl: 'reps.html',
    directives: const [BS_DIRECTIVES, ROUTER_DIRECTIVES, RepDetailComponent])
class RepsComponent implements OnInit {
  String issueType;

  bool isBadAddress = false;

  final RouteParams _routeParams;

  String normalizedAddress;

  List<GeographicDivision> divisions;

  List<Representative> countryRepresentatives;

  List<Representative> stateRepresentatives;

  List<Representative> otherRepresentatives;

  RepsComponent(this._routeParams);

  @override
  ngOnInit() async {
    var client = clientViaApiKey('AIzaSyCN9rkEJ848kuw9-YO7vZ41Mt7v2bhckcs');
    var api = new CivicinfoApi(client);
    try {
      var response = await api.representatives
          .representativeInfoByAddress(
          new RepresentativeInfoRequest(), address: Uri.decodeFull(_routeParams.get('address')));

      var inputObj = response.normalizedInput;
      normalizedAddress = '${inputObj.line1}, ${inputObj.city} ${inputObj.state}  ${inputObj.zip}';

      divisions = response.divisions.values.where((d) => d.name == 'congressional');

      var offices = response.offices.where((o) => o.name != 'President' && o.name != 'Vice President');

      toRepresentative(pv, Office o) {
        return pv
          ..addAll(o.officialIndices.map((oi) {
            var official = response.officials[oi];
            return new Representative()
              ..photoUrl = official.photoUrl
              ..name = official.name
              ..party = official.party
              ..officeName = o.name
              ..phone = official.phones?.elementAt(0)
              ..site = official.urls?.elementAt(0);
          }));
      }

      countryRepresentatives =
          offices.where((o) => o.levels != null && o.levels[0] == 'country').fold([], toRepresentative);
      stateRepresentatives = offices.where((o) => o.levels != null && o.levels[0] == 'administrativeArea1')
          .fold([], toRepresentative);
      otherRepresentatives = offices.where((o) => o.levels == null).fold([], toRepresentative);
    } catch (e) {
      print(e);
      isBadAddress = true;
    }
  }
}


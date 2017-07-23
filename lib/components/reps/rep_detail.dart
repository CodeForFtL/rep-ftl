import 'package:angular2/angular2.dart';
import 'package:rep_ftl/components/reps/representative.dart';

@Component(selector: 'reps-ftl-rep-detail',
  templateUrl: 'rep_detail.html')
class RepDetailComponent implements OnInit {
  String photoUrl;
  String name;
  String party;
  String officeName;
  String phone;
  String site;

  @Input() Representative representative;

  @override
  ngOnInit() {
    photoUrl = representative.photoUrl;
    name = representative.name;
    party = representative.party;
    officeName = representative.officeName;
    phone = representative.phone;
    site = representative.site;
  }
}
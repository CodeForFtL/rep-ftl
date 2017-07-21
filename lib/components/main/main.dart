import 'dart:html';

import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';
import 'package:google_maps/google_maps.dart';


@Component(selector: 'rep-ftl-main',
    templateUrl: 'main.html')
class MainComponent {
  String address;
  String city = 'Coconut Creek';
  Router _router;

  MainComponent(this._router);

  _navigateToAddress(address) {
    _router.navigate(['Reps', {'address': address}]);
  }

  handleSearch() {
    var userLocation = '${address != null ? address + ',' : ''}$city FL';
    _navigateToAddress(userLocation);
  }

  _writeAddressName(LatLng latLng) {
    var geocoder = new Geocoder();
    geocoder.geocode(new GeocoderRequest()..location = latLng, (results, status) {
      if (status == GeocoderStatus.OK) {
        var field = results[0];
        var component = field.addressComponents;
        var len = component.length;
        var addr = 'error';
        for (var i = 0; i < len; ++i) {
          if (component[i].longName == 'Broward County') {
            addr = field.formattedAddress;
            break;
          }
        }
        _navigateToAddress(addr);
      } else {
        window.alert('Location search was unsuccesful. Error : ' + status);
      }
    });
  }

  /// Make request to Google Maps Geocoder API
  geoLocateUser() async {
    if (window.navigator.geolocation != null) {
      var position = await window.navigator.geolocation.getCurrentPosition();
      var pos = new LatLng(position.coords.latitude, position.coords.longitude);
      _writeAddressName(pos); //comment this line to stop the page from reload when debugging
    } else {
      window.alert('Error: The Geolocation service failed.');
    }
  }
}

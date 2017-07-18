import 'dart:html';

import 'package:angular2/angular2.dart';


@Component(selector: 'rep-ftl-main',
    templateUrl: 'main.html')
class MainComponent {
  String address;
  String city;

  createSubmitForm(address) {
    var str_form = '''<form id = "dynamicForm" method = "get" action= "repsView.html" role= "form">
    <input type= "hidden" id = "inputAddress" name = "inputAddress" value = "$address">
    </form>''';
    querySelector('#locationInput').innerHtml = str_form;
    (querySelector('#dynamicForm') as FormElement).submit();
  }

  handleSearch() {
    var userLocation = '$address, $city FL';
    print('userLocation: $userLocation');
//    createSubmitForm(userLocation);
  }

  writeAddressName(latLng) {
    var geocoder = new google.maps.Geocoder();
    geocoder.geocode({
      "location": latLng
    }, (results, status) {
      if (status == google.maps.GeocoderStatus.OK) {
        var field = results[0];
        var component = field.address_components;
        var len = component.length;
        var addr = 'error';
        for (var i = 0; i < len; ++i) {
          if (component[i].long_name == 'Broward County') {
            addr = field.formatted_address;
            break;
          }
        }
        createSubmitForm(addr);
      }
      else
        window.alert('Location search was unsuccesful. Error : ' + status);
    });
  }

  /// Make request to Google Maps Geocoder API
  geolocateUser() {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition((position) {
        var pos = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
        writeAddressName(pos); //comment this line to stop the page from reload when debugging
      });
    }
    else {
      window.alert('Error: The Geolocation service failed.');
    }
  }
}

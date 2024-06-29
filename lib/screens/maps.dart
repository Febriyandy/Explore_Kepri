import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapsPage extends StatefulWidget {
  final double latitude;
  final double longitude;

  const MapsPage({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Maps Page')),
      body: Center(
        child: Container(
          width: 400,
          height: 200,
          child: FlutterMap(
            options: MapOptions(
              center: LatLng(widget.latitude, widget.longitude),
              zoom: 11,
              interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.doubleTapZoom,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'dev.fleaflet.flutter_map.example',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(widget.latitude, widget.longitude),
                    width: 60,
                    height: 60,
                    alignment: Alignment.centerLeft,
                    child: const Icon(
                      Icons.location_pin,
                      size: 60,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

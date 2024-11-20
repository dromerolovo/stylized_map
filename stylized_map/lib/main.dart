import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MapboxOptions.setAccessToken(
      const String.fromEnvironment("mapboxAccessToken"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  MapboxMap? mapboxMap;

  void _onStyleLoaded(StyleLoadedEventData data) async {
    mapboxMap!.style.addSource(
      RasterSource(
          id: "mask",
          tiles: [const String.fromEnvironment("rasterSourceTileUrl")],
          tileSize: 256),
    );
    mapboxMap!.style.addLayerAt(RasterLayer(id: "mask", sourceId: "mask"),
        LayerPosition(below: "road-label-simple"));
  }

  void _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
          child: MapWidget(
        onStyleLoadedListener: _onStyleLoaded,
        key: const ValueKey("mapWidget"),
        onMapCreated: _onMapCreated,
        styleUri: const String.fromEnvironment("mapboxStyleUri"),
      )),
    );
  }
}

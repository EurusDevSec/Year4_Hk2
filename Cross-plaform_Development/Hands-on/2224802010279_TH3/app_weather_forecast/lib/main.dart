import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '2224802010279 - Dự báo thời tiết',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

// API Service
class WeatherService {
  // ⚠️ IMPORTANT: Replace with your own API key from https://openweathermap.org/users/sign_up
  static const String apiKey = '151aa34a64815d0ac9cafcd276fb3d39';
  static const String baseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String geoUrl = 'https://api.openweathermap.org/geo/1.0';

  // Set to true to use Geocoding API (recommended)
  static const bool useGeocodingApi = false;

  /// Get coordinates from city name using Geocoding API (Recommended)
  static Future<Map<String, double>> getCoordinates(String city) async {
    try {
      final url = '$geoUrl/direct?q=$city&limit=1&appid=$apiKey';
      debugPrint('📍 Geocoding URL: $url');

      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 8));

      debugPrint('📊 Geocoding Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          return {'lat': data[0]['lat'], 'lon': data[0]['lon']};
        }
        throw Exception('City not found in database');
      } else if (response.statusCode == 401) {
        throw Exception(
          'Invalid API Key - Check https://openweathermap.org/users/api_keys',
        );
      }
      throw Exception('Geocoding error: HTTP ${response.statusCode}');
    } on TimeoutException catch (_) {
      throw Exception('Network timeout - Emulator has no internet access');
    } catch (e) {
      debugPrint('❌ Geocoding Error: $e');
      rethrow;
    }
  }

  /// Get weather by city name with detailed error reporting
  static Future<Map<String, dynamic>> getWeatherByCity(String city) async {
    try {
      if (useGeocodingApi) {
        // Method A: Using Geocoding API (Recommended)
        final coords = await getCoordinates(city);
        final url =
            '$baseUrl/weather?lat=${coords['lat']}&lon=${coords['lon']}&appid=$apiKey&units=metric&lang=vi';
        debugPrint('🌐 Weather URL (Geocoding): $url');

        final response = await http
            .get(Uri.parse(url))
            .timeout(const Duration(seconds: 8));

        debugPrint('📊 Weather Status: ${response.statusCode}');
        if (response.statusCode == 200) {
          return jsonDecode(response.body);
        }
        throw Exception('Failed to fetch weather: HTTP ${response.statusCode}');
      } else {
        // Method B: Using deprecated built-in geocoding (may not work)
        final url =
            '$baseUrl/weather?q=$city&appid=$apiKey&units=metric&lang=vi';
        debugPrint('🌐 Weather URL (Built-in): $url');

        final response = await http
            .get(Uri.parse(url))
            .timeout(const Duration(seconds: 8));

        debugPrint('📊 Weather Status Code: ${response.statusCode}');
        debugPrint('📄 Response Headers: ${response.headers}');

        if (response.statusCode == 200) {
          return jsonDecode(response.body);
        } else if (response.statusCode == 401) {
          throw Exception(
            '❌ Unauthorized - Invalid API Key\n\nSolutions:\n1. Get new key: https://openweathermap.org/users/sign_up\n2. Replace apiKey in WeatherService\n3. Wait 10 minutes for key to activate',
          );
        } else if (response.statusCode == 404) {
          throw Exception(
            'City "$city" not found. Try:\n- English name\n- Full city name (e.g., "Hanoi" not "HN")',
          );
        } else if (response.statusCode == 429) {
          throw Exception('Rate limit exceeded - too many requests');
        }
        throw Exception('HTTP Error ${response.statusCode}:\n${response.body}');
      }
    } on TimeoutException catch (_) {
      throw Exception(
        '🔴 Network Timeout\n\nPossible causes:\n1. Emulator has no internet\n2. WiFi connection issue\n3. Server is slow\n\nSolutions:\n- Restart emulator\n- Check internet connection\n- Run: adb shell ping 8.8.8.8',
      );
    } catch (e) {
      debugPrint('❌ Full Error: $e');
      rethrow;
    }
  }

  static Future<List<String>> getCitySuggestions(String query) async {
    final suggestions = <String>[
      'Hà Nội',
      'Hồ Chí Minh',
      'Đà Nẵng',
      'Hải Phòng',
      'Cần Thơ',
      'Nha Trang',
      'Huế',
      'Hạ Long',
      'Tokyo',
      'Paris',
      'New York',
      'London',
      'Sydney',
      'Bangkok',
      'Singapore',
    ];

    if (query.isEmpty) {
      return suggestions;
    }

    return suggestions
        .where((city) => city.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }
}

// Weather Model
class WeatherData {
  final String city;
  final String country;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final int pressure;
  final double windSpeed;
  final String description;
  final String icon;
  final int clouds;

  WeatherData({
    required this.city,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.description,
    required this.icon,
    required this.clouds,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final main = json['main'];
    final wind = json['wind'];
    final weather = json['weather'][0];

    return WeatherData(
      city: json['name'],
      country: json['sys']['country'],
      temperature: (main['temp'] as num).toDouble(),
      feelsLike: (main['feels_like'] as num).toDouble(),
      humidity: main['humidity'],
      pressure: main['pressure'],
      windSpeed: (wind['speed'] as num).toDouble(),
      description: weather['main'],
      icon: weather['icon'],
      clouds: json['clouds']['all'],
    );
  }
}

// Main Home Page
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController searchController = TextEditingController();
  List<String> suggestions = [];
  final List<String> featuredCities = [
    'Hà Nội',
    'Hồ Chí Minh',
    'Đà Nẵng',
    'Tokyo',
    'Paris',
    'New York',
  ];

  late Future<List<WeatherData>> weatherDataFuture;

  @override
  void initState() {
    super.initState();
    weatherDataFuture = _loadFeaturedWeather();
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (searchController.text.isEmpty) {
      setState(() {
        suggestions = [];
      });
    } else {
      _loadSuggestions();
    }
  }

  Future<void> _loadSuggestions() async {
    final result = await WeatherService.getCitySuggestions(
      searchController.text,
    );
    setState(() {
      suggestions = result;
    });
  }

  Future<List<WeatherData>> _loadFeaturedWeather() async {
    List<WeatherData> weatherList = [];
    for (String city in featuredCities) {
      try {
        final data = await WeatherService.getWeatherByCity(city);
        weatherList.add(WeatherData.fromJson(data));
      } catch (e) {
        debugPrint('Error loading weather for $city: $e');
      }
    }
    return weatherList;
  }

  void _searchWeather() {
    if (searchController.text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailPage(city: searchController.text.trim()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                const Center(
                  child: Text(
                    '2224802010279 - Dự báo thời tiết',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),

                // Search Bar
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Nhập tên thành phố (vd: Hà Nội)...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          suffixIcon: searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    searchController.clear();
                                    setState(() {
                                      suggestions = [];
                                    });
                                  },
                                )
                              : null,
                        ),
                        onChanged: (_) {
                          setState(() {});
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.search, color: Colors.white),
                        onPressed: _searchWeather,
                      ),
                    ),
                  ],
                ),

                // Search Suggestions
                if (suggestions.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: suggestions.map((city) {
                        return ListTile(
                          title: Text(city),
                          onTap: () {
                            searchController.text = city;
                            setState(() {
                              suggestions = [];
                            });
                            _searchWeather();
                          },
                        );
                      }).toList(),
                    ),
                  ),

                const SizedBox(height: 24),

                // Featured Cities Title
                const Text(
                  'Thành phố nổi bật',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                // Featured Cities List
                FutureBuilder<List<WeatherData>>(
                  future: weatherDataFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 48,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Lỗi tải dữ liệu thời tiết',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.red[50],
                                  border: Border.all(color: Colors.red[200]!),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${snapshot.error}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.red[800],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    weatherDataFuture = _loadFeaturedWeather();
                                  });
                                },
                                child: const Text('🔄 Thử lại'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    final weatherList = snapshot.data ?? [];

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: weatherList.length,
                      itemBuilder: (context, index) {
                        final weather = weatherList[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailPage(city: weather.city),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[300]!),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        weather.city,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        weather.description,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    _getWeatherIcon(weather.icon, 40),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${weather.temperature.toStringAsFixed(1)}°C',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getWeatherIcon(String icon, double size) {
    final iconMap = {
      '01d': '☀️',
      '01n': '🌙',
      '02d': '⛅',
      '02n': '☁️',
      '03d': '☁️',
      '03n': '☁️',
      '04d': '☁️',
      '04n': '☁️',
      '09d': '🌧️',
      '09n': '🌧️',
      '10d': '🌧️',
      '10n': '🌧️',
      '11d': '⛈️',
      '11n': '⛈️',
      '13d': '❄️',
      '13n': '❄️',
      '50d': '🌫️',
      '50n': '🌫️',
    };

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.orange[100],
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center(
        child: Text(
          iconMap[icon] ?? '🌤️',
          style: TextStyle(fontSize: size * 0.6),
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}

// Detail Page
class DetailPage extends StatefulWidget {
  final String city;

  const DetailPage({super.key, required this.city});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<WeatherData> weatherFuture;

  @override
  void initState() {
    super.initState();
    weatherFuture = WeatherService.getWeatherByCity(
      widget.city,
    ).then((data) => WeatherData.fromJson(data));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<WeatherData>(
        future: weatherFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cloud_off, size: 64, color: Colors.red),
                    const SizedBox(height: 24),
                    const Text(
                      'Không thể tải dữ liệu',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        border: Border.all(color: Colors.red[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${snapshot.error}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.red[800],
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back),
                          label: const Text('Quay lại'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              weatherFuture = WeatherService.getWeatherByCity(
                                widget.city,
                              ).then((data) => WeatherData.fromJson(data));
                            });
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Thử lại'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }

          final weather = snapshot.data!;

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue[400]!, Colors.blue[600]!],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Header with back button
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Main weather display
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // City name
                          Text(
                            weather.city,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Weather icon
                          _getDetailWeatherIcon(weather.icon, 80),
                          const SizedBox(height: 24),

                          // Temperature
                          Text(
                            '${weather.temperature.toStringAsFixed(1)}°',
                            style: const TextStyle(
                              fontSize: 72,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Description
                          Text(
                            weather.description.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Weather details grid
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.blue[300]?.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: [
                                  // Row 1
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      _buildWeatherDetailItem(
                                        icon: '💧',
                                        label: 'Cảm giác',
                                        value:
                                            '${weather.feelsLike.toStringAsFixed(1)}°C',
                                      ),
                                      _buildWeatherDetailItem(
                                        icon: '💨',
                                        label: 'Độ ẩm',
                                        value: '${weather.humidity}%',
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  // Row 2
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      _buildWeatherDetailItem(
                                        icon: '💨',
                                        label: 'Sức gió',
                                        value:
                                            '${weather.windSpeed.toStringAsFixed(2)} m/s',
                                      ),
                                      _buildWeatherDetailItem(
                                        icon: '🔘',
                                        label: 'Áp suất',
                                        value: '${weather.pressure} hPa',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWeatherDetailItem({
    required String icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.white)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _getDetailWeatherIcon(String icon, double size) {
    final iconMap = {
      '01d': '☀️',
      '01n': '🌙',
      '02d': '⛅',
      '02n': '☁️',
      '03d': '☁️',
      '03n': '☁️',
      '04d': '☁️',
      '04n': '☁️',
      '09d': '🌧️',
      '09n': '🌧️',
      '10d': '🌧️',
      '10n': '🌧️',
      '11d': '⛈️',
      '11n': '⛈️',
      '13d': '❄️',
      '13n': '❄️',
      '50d': '🌫️',
      '50n': '🌫️',
    };

    return Text(iconMap[icon] ?? '🌤️', style: TextStyle(fontSize: size));
  }
}

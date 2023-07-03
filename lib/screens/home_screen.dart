import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<Weather> fetchWeather() async {
    final resp = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?lat=51.507351&lon=-0.127758&appid=4fb7e9a1a7846f068bd26cfbd5017654"));

    if (resp.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(resp.body);

      return Weather.fromJson(json);
    } else {
      throw Exception('Error');
    }
  }

  late Future<Weather> myWeather;

  @override
  void initState() {
    super.initState();
    myWeather = fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF676BD0),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 15.0,
          right: 15.0,
          top: 30.0,
        ),
        child: Stack(
          children: [
            SafeArea(
              top: true,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Icon(
                        Icons.menu,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  FutureBuilder<Weather>(
                    future: myWeather,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              snapshot.data!.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              snapshot.data!.weather[0]['main'].toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                letterSpacing: 1.3,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const SizedBox(height: 20),
                            Container(
                              height: 250,
                              width: 250,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                image: AssetImage(
                                  'assets/cloudy.png',
                                ),
                              )),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    const Text(
                                      'Sıcaklık',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      '${((snapshot.data!.main['temp'] - 32 * 5) / 9).toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 21,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 50,
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      'Rüzgar',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      '${snapshot.data!.wind['speed']} km/h',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 21,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  width: 50,
                                ),
                                Column(
                                  children: [
                                    const Text(
                                      'Nem',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      '${snapshot.data!.main['humidity']}%',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 21,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return const Text('Error');
                      } else {
                        return const CircularProgressIndicator(
                          color: Colors.white,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

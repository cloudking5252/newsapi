import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'Models.dart/post_model.dart';

class Homeclass extends StatefulWidget {
  Homeclass({super.key});

  final TextEditingController _cityController = TextEditingController();

  @override
  State<Homeclass> createState() => _HomeclassState();
}

class _HomeclassState extends State<Homeclass> {
  List<Postmodel>? _newsData;

  @override
  void initState() {
    super.initState();
     
    _fetchNews('tesla');  
  }

  Future<List<Postmodel>> getpostApi(String city) async {
    var url = Uri.parse(
        'https://newsapi.org/v2/everything?q=$city&from=2024-08-28&sortBy=publishedAt&apiKey=a7d54dda6cc745a688fd342e7c8f4845');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      List<dynamic> articles = responseBody['articles'];
      return articles.map((article) => Postmodel.fromJson(article)).toList();
    } else {
      var errorResponse = jsonDecode(response.body);
      throw Exception('Failed to load news: ${errorResponse['message']}');
    }
  }

  Future<void> _fetchNews([String? city]) async {
    city ??= widget._cityController.text;
    if (city.isNotEmpty) {
      try {
        List<Postmodel> news = await getpostApi(city);
        setState(() {
          _newsData = news;
        });
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: widget._cityController,
              decoration: InputDecoration(
                labelText: 'Enter City Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: Colors.blue,
                    width: 2.0,
                  ),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    _fetchNews();
                  },
                ),
              ),
            ),
          ),
          _newsData == null
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                    itemCount: _newsData!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CachedNetworkImage(
                              imageUrl: _newsData![index].urlToImage,
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => SpinKitThreeBounce(
                                color: Colors.blue,
                                size: 20.0,
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                            const SizedBox(height: 8),
                            ListTile(
                              title: Text(
                                _newsData![index].title,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(_newsData![index].source),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}

// ./json/article.jsonからデータを取得して表示する
// ./json/article.jsonのデータをArticleクラスに変換する
// Articleクラスはtitleとimage_urlを持つ
// ./json/article.jsonのデータをmapして一覧表示する
// image_urlがある場合はImage.networkを使って表示する
// stateless widgetを使って表示する

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  Future<List<Article>> _getArticles() async {
    final jsonString = await rootBundle.loadString('json/article.json');
    final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
    final articles = jsonMap['result']['data'] as List<dynamic>;
    return articles.map((e) => Article.fromJson(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('まとめ'),
      ),
      body: FutureBuilder<List<Article>>(
        future: _getArticles(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: snapshot.data!
                  .map((e) => ListTile(
                        title: Text(e.title),
                        leading: e.imageUrl != null
                            ? Image.network(e.imageUrl!)
                            : null,
                      ))
                  .toList(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class Article {
  Article({
    required this.title,
    this.imageUrl,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] as String,
      imageUrl: json['image_url'] as String?,
    );
  }

  final String title;
  final String? imageUrl;
}

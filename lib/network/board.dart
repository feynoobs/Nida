import 'package:http/http.dart' as http;
import 'package:charset_converter/charset_converter.dart';

class BoardObject
{
    String group;
    List<Map<String, String>> boards;

    BoardObject(this.group, this.boards);
}

class Board
{
    final String url;
    Board(this.url);

    Future<List<BoardObject>> start() async
    {
        List<BoardObject> r = [];
        await http
            .get(Uri.parse(url))
            .then((final http.Response response) {
                if (response.statusCode == 200) {
                    return CharsetConverter.decode('cp932', response.bodyBytes);
                }
                else {
                    throw Exception('Failed to load data');
                }
            })
            .then((final String data) {
                final RegExp exp1 = RegExp(r'<br><br><B>(.+?)</B><br>\n((?:<A HREF=".+?">.+?</A>(?:<br>)?\n)+)');
                final Iterable<RegExpMatch> matches1 = exp1.allMatches(data);
                for (final m1 in matches1) {
                    List<Map<String, String>> group = [];
                    final RegExp exp2 = RegExp(r'(?:<A HREF="(.+?)">(.+?)</A>(?:<br>)?)+');
                    final Iterable<RegExpMatch> matches2 = exp2.allMatches(m1[2]!);
                    for (final m2 in matches2) {
                        group.add({m2[2]!: m2[1]!});
                    }
                    BoardObject obj = BoardObject(m1[1]!, group);
                    r.add(obj);
                }
            })
            .catchError((err) {
                print(err);
            });

        return r;

    }
}

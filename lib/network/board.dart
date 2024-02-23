import 'package:http/http.dart' as http;
import 'package:charset_converter/charset_converter.dart';

class BoardObject
{
    String group;
    List<String> boards;

    BoardObject(this.group, this.boards);

}


class Board
{
    Future<List<BoardObject>?> start(String end, [final Map<String, String> params = const {}]) async
    {
        const List<BoardObject>? r = null;
        await http
            .get(Uri.parse(end))
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
                    final RegExp exp2 = RegExp(r'(?:<A HREF="(.+?)">(.+?)</A>(?:<br>)?)+');
                    final Iterable<RegExpMatch> matches2 = exp2.allMatches(m1[2]!);
                    print('***'+m1[1]!+'***');
                    for (final m2 in matches2) {
                        print(m2[1]);
                        print(m2[2]);
                    }
                }
            })
            .catchError((err) {
                print(err);
                // nop
            });

        return r;

    }
}

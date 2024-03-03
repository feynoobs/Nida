import 'package:http/http.dart' as http;
import 'package:charset_converter/charset_converter.dart';

class ThreadObject
{
    int sequence;
    String title;
    int post;
    ThreadObject(this.sequence, this.title, this.post);
}


class Thread
{
    final String url;
    Thread(this.url);

    Future<List<ThreadObject>> start() async
    {
        const List<ThreadObject> r = [];
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
                final RegExp exp = RegExp(r'(\d{10})\.dat<>(.+\s)\(\d+\)');
                final Iterable<RegExpMatch> matches = exp.allMatches(data);
                for (final m in matches) {
                    ThreadObject obj = ThreadObject(int.parse(m[1]!), m[2]!, int.parse(m[3]!));
                    r.add(obj);
                }
            })
            .catchError((err) {
                print(err);
            });
print(r);
        return r;

    }
}

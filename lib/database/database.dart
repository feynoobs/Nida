import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB
{
    static Future<Database>? _instance;

    static Future<Database> getInstance() async
    {
        _instance ??= openDatabase(
            join(await getDatabasesPath(), 'nida.db'),
            version: 1,
            onCreate: ((final Database db, final int version) {
                db.execute(
                    '''
                        CREATE TABLE t_sites(
                            id INTEGER PRIMARY KEY AUTOINCREMENT,
                            name TEXT NOT NULL,                     -- サイト名
                            url TEXT NOT NULL                       -- bbsのURL
                        )
                    '''
                );
                db.execute(
                    '''
                        CREATE TABLE t_groups(
                            id INTEGER PRIMARY KEY AUTOINCREMENT,
                            site_id INTEGER NOT NULL,               -- 掲示板があるサイト
                            name TEXT NOT NULL                      -- グループ名
                        )
                    '''
                );
                db.execute(
                    '''
                        CREATE TABLE t_boards(
                            id INTEGER PRIMARY KEY AUTOINCREMENT,
                            group_id INTEGER NOT NULL,              -- 所属するグループ
                            name TEXT NOT NULL,                     -- 板名
                            url TEXT NOT NULL                       -- 板のURL
                        )
                    '''
                );
                db.execute(
                    '''
                        CREATE TABLE t_threads(
                            id INTEGER PRIMARY KEY AUTOINCREMENT,
                            board_id INTEGER NOT NULL,              -- 所属する板
                            name TEXT NOT NULL,                     -- スレッド名
                            url TEXT NOT NULL,                      -- スレッドのURL
                            unix INTEGER NOT NULL                   -- スレが建てられたUNIX時間
                        )
                    '''
                );
                db.execute(
                    '''
                        CREATE TABLE t_responses(
                            id INTEGER PRIMARY KEY AUTOINCREMENT,
                            thread_id INTEGER NOT NULL,             -- 所属するスレッド
                            name TEXT DEFAULT NULL,                 -- 投稿者名
                            email TEXT DEFAULT NULL,                -- 投稿者メアド
                            uid TEXT DEFAULT NULL,                  -- ID
                            wacchoi TEXT DEFAULT NULL,              -- ワッチョイ
                            ip TEXT DEFAULT NULL,                   -- IPアドレス
                            unix INTEGER NOT NULL                   -- 投稿された日時

                        )
                    '''
                );
            })
        );

        return _instance!;
    }
}

-- 問１
mysql> SELECT uniform_num, name, club
    -> FROM players;
-- 問2
mysql> SELECT *
    -> FROM countries
    -> WHERE group_name = 'C';
-- 問3
mysql> SELECT *
    -> FROM countries
    ->  WHERE group_name != 'C';
-- 問４
mysql> SELECT *
    -> FROM players
    -> WHERE birth > '1984-08-08';
-- 問５
mysql> SELECT *
    -> FROM players
    -> where height < 170;
-- 問6
mysql> SELECT * from countries
    -> where ranking between 36 and 56;
-- 問7
mysql> SELECT * from players
    -> where position in ('GK','DF','MF');
-- 問８
mysql> SELECT * from goals
    -> WHERE player_id IS NULL;
-- 問９
mysql>  SELECT * from goals
    -> WHERE player_id IS NOT NULL;
-- 問１０
-- 語尾に
mysql> SELECT * from players
    ->  WHERE name LIKE '%ニョ';
-- 問11
mysql> SELECT * from players
    ->  WHERE name LIKE '%ニョ%';
-- 問12
mysql> SELECT *
    -> FROM countries
    -> WHERE not group_name = 'A';
-- 問13
-- BMI式
mysql> SELECT * from players
    -> WHERE weight / POW(height / 100, 2) BETWEEN 20 AND 29;
-- 問14
mysql> SELECT * from players
    -> WHERE height < 165 OR weight < 60;
-- 問15
mysql> SELECT * from players
    -> where (position = 'FW' OR position = 'MF') AND height < 170;
-- 問16
-- 重複なしで一覧表示
mysql> SELECT DISTINCT position
    -> FROM players;
-- 問17
mysql> SELECT name, club, (weight + height) AS 'weight+height'
    -> FROM players;
-- 問18
mysql> SELECT CONCAT(name, '選手のポジションは', position, 'です。') AS position
    -> FROM players;
-- 問１９
mysql> SELECT name, club, (weight + height) AS '体力指数'
    -> FROM players;
-- 問2０
-- 降順はDESC
mysql> SELECT id, name, ranking, group_name
    -> FROM countries
    -> ORDER BY ranking ASC;
-- 問21
mysql> SELECT * from players
    -> ORDER BY birth DESC;
-- 問22
mysql> SELECT * from players
    -> ORDER BY height DESC, weight DESC;
-- 問2３
-- カラム名と同じ名前で出来ない。クエリでpositionという名前をエイリアス使えない。
mysql> SELECT id, country_id, uniform_num, LEFT(position, 1) AS position_ini, name
    -> FROM players;
-- 問24
mysql> SELECT name, CHAR_LENGTH(name) AS name_length
    -> FROM countries
    -> ORDER BY name_length DESC;
-- 問2５
SELECT name, DATE_FORMAT(birth, '%Y年%c月%e日') AS birthday
FROM players;
-- 問26
mysql> SELECT IFNULL(player_id, 9999) AS player_id, goal_time
    -> FROM goals;
-- 問27
mysql> SELECT CASE
    -> WHEN player_id IS NULL THEN 9999
    -> ELSE player_id
    -> END AS player_id,
    -> goal_time
    -> FROM goals;
-- 問28
mysql> SELECT AVG(weight) AS 平均体重, AVG(height) AS 平均身長
    -> FROM players;
-- 問2９
mysql> SELECT COUNT(*) AS 日本のゴール数
    -> FROM goals
    -> WHERE player_id BETWEEN 714 AND 736;
-- 問30
mysql> SELECT COUNT(CASE WHEN player_id IS NOT NULL THEN 1 ELSE NULL END) AS オウンゴール以外のゴール数
    -> FROM goals;
-- 問31
mysql> SELECT MAX(height) AS 最大身長, MAX(weight) AS 最大体重
    -> FROM players;
-- 問32
mysql> SELECT MIN(ranking) AS AグループのFIFAランク最上位
    -> FROM countries
    -> WHERE group_name = 'A';
-- 問33
mysql> SELECT SUM(ranking) AS CグループのFIFAランク合計値
    -> FROM countries
    -> WHERE group_name = 'C';
-- 問34
-- JOIN ON は関連するデータを異なるテーブルから結合して取得する際に使う
mysql> SELECT c.name AS country_name, p.name AS player_name, p.uniform_num
    -> FROM players p
    -> JOIN countries c ON p.country_id = c.id;
-- 問３５
mysql> SELECT c.name AS country_name, p.name AS player_name, g.goal_time
    -> FROM goals g
    -> JOIN players p ON g.player_id = p.id
    -> JOIN countries c ON p.country_id = c.id
    -> WHERE g.player_id IS NOT NULL;
-- 問36
-- 二つの異なる種類の結合方法で、joinの前のものと一致するものをjoin後に記載
mysql> SELECT g.goal_time, p.uniform_num, p.position, p.name
    -> FROM goals g
    -> LEFT JOIN players p ON g.player_id = p.id;
-- 問37
mysql> SELECT g.goal_time, p.uniform_num, p.position, p.name
    -> FROM players p
    -> RIGHT JOIN goals g ON p.id = g.player_id;
-- 問38
mysql> SELECT c.name AS country_name, g.goal_time, p.position, p.name
    -> FROM goals g
    -> LEFT JOIN players p ON g.player_id = p.id
    -> LEFT JOIN countries c ON p.country_id = c.id;
-- 問39
mysql> SELECT p.kickoff,c1.name AS my_country,c2.name AS enemy_country
    -> FROM  pairings p
    -> JOIN countries c1 ON p.my_country_id = c1.id
    -> JOIN countries c2 ON p.enemy_country_id = c2.id;
-- 問40
-- 副問合せ
mysql> SELECT  g.id,g.goal_time,(SELECT p.name FROM players p WHERE p.id = g.player_id) AS player_name
    -> FROM  goals g;
-- 問41
-- 結合
mysql> SELECT  g.id, g.goal_time,p.name as name
    -> FROM  goals g
    -> JOIN  players p ON g.player_id = p.id
    -> WHERE g.player_id IS NOT NULL;
-- 問42
mysql> SELECT  p.position AS position,p.height AS 最大身長,p.name AS name,  p.club AS club
    -> FROM  players p
    -> JOIN (SELECT position, MAX(height) AS max_height FROM players GROUP BY position) AS max_heights
    -> ON p.position = max_heights.position AND p.height = max_heights.max_height;
-- 問43
mysql> SELECT osition, MAX(height) AS max_height, (SELECT name FROM players p2 WHERE p2.position = p1.position AND p2.height = MAX(p1.height)) AS player_name
    -> FROM players p1
    -> GROUP BY position;
-- 問44
mysql> SELECT uniform_num, name, position, height
    -> FROM players
    -> WHERE height < (SELECT AVG(height) FROM players);
-- 問45
mysql> SELECT group_name,MIN(ranking) AS min_ranking,MAX(ranking) AS max_ranking
    -> FROM countries
    -> GROUP BY group_name
    -> HAVING (MAX(ranking) - MIN(ranking)) > 50;
-- 問46
mysql> SELECT '1980' AS 誕生年,COUNT(*) AS count
    -> FROM players
    -> WHERE YEAR(birth) = 1980
    -> UNION
    -> SELECT '1981' AS 誕生年,COUNT(*) AS count
    -> FROM players
    -> WHERE YEAR(birth) = 1981;

-- 問47
mysql> SELECT id, position, name, height, weight
    -> FROM players
    -> WHERE height > 195
    -> UNION ALL
    -> SELECT id, position, name, height, weight
    -> FROM players
    -> WHERE weight > 95;
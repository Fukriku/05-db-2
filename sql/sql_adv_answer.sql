-- 問1
SELECT group_name,MIN(ranking) AS 最上位,MAX(ranking) AS 最下位
FROM countries
GROUP BY group_name
-- 問2
SELECT AVG(height) AS 最高身長, AVG(weight) AS 最高体重
FROM players
WHERE (position = 'GK');
-- 問3
SELECT c.name,(SELECT AVG(p.height) FROM players p WHERE p.country_id = c.id) AS Ave_height
FROM countries c
ORDER BY Ave_height DESC;
-- 問4
SELECT (SELECT c.name FROM countries c WHERE c.id = p.country_id) AS country_name ,AVG(p.height) AS Ave_height
FROM players p
GROUP BY p.country_id
ORDER BY Ave_height DESC;
-- 問5
SELECT p.kickoff,c1.name AS my_country,c2.name AS enemy_country
FROM  pairings p
JOIN countries c1 ON p.my_country_id = c1.id
JOIN countries c2 ON p.enemy_country_id = c2.id
ORDER BY p.kickoff ASC;
-- 問6
SELECT p.name,p.position,p.club,(SELECT COUNT(g.id) FROM goals g WHERE p.id = g.player_id) AS ゴール数
FROM players p
GROUP BY p.id, p.name
ORDER BY goal_count DESC;
-- 問7
SELECT p.name,p.position,p.club,COUNT(g.id) AS ゴール数
FROM players p
LEFT JOIN goals g ON p.id = g.player_id
GROUP BY p.id, p.name
ORDER BY goal_count DESC;
-- 問8
-- ポジションごとのゴール数
SELECT p.position,COUNT(g.id) AS ゴール数
FROM players p
LEFT JOIN goals g ON p.id = g.player_id
GROUP BY p.position
ORDER BY total_goals DESC;
-- 問９
SELECT birth, TIMESTAMPDIFF(YEAR, birth, '2014-06-13') AS age_20140613,name,position
from players
ORDER BY age_20140613 DESC;
-- 問１０
-- NULLの時の1をカウント
mysql> SELECT COUNT(CASE WHEN player_id IS NULL THEN 1 ELSE NULL END) AS own
    -> FROM goals;
-- 問11
SELECT  c.group_name,COUNT(g.id)
FROM goals g
JOIN pairings p ON g.pairing_id = p.id
JOIN countries c ON p.my_country_id = c.id
WHERE p.kickoff BETWEEN '2014-06-13' AND '2014-06-27'
GROUP BY c.group_name;
-- 問12
SELECT goal_time 
FROM goals
WHERE pairing_id = '103';
-- 問13
SELECT c.name, COUNT(g.id) AS total_goals
FROM goals g
JOIN players p ON g.player_id = p.id
JOIN countries c ON p.country_id = c.id
WHERE g.pairing_id IN (39, 103)
GROUP BY c.name;
-- 問14

SELECT m.kickoff AS kickoff_time,c1.name AS my_country_name,c2.name AS enemy_country_name,c1.ranking AS my_ranking,c2.ranking AS enemy_ranking,COUNT(g.id) AS goals
FROM pairings m
JOIN countries c1 ON m.my_country_id = c1.id
JOIN countries c2 ON m.enemy_country_id = c2.id
LEFT JOIN goals g ON g.pairing_id = m.id
WHERE c1.group_name = 'C'
GROUP BY m.kickoff, c1.name, c2.name, c1.ranking, c2.ranking
ORDER BY m.kickoff,c1.ranking;

-- 問1５
SELECT m.kickoff AS kickoff_time,c1.name AS my_country_name,c2.name AS enemy_country_name,c1.ranking AS my_ranking,c2.ranking AS enemy_ranking,(SELECT COUNT(*) FROM goals g JOIN players p ON g.player_id = p.id WHERE g.pairing_id = m.id AND p.country_id = c1.id) AS my_goals
FROM pairings m JOIN countries c1 ON m.my_country_id = c1.id JOIN countries c2 ON m.enemy_country_id = c2.id
WHERE c1.group_name = 'C'
ORDER BY m.kickoff, c1.ranking;

-- 問16

SELECT m.kickoff,c1.name AS my_country_name,c2.name AS enemy_country_name,c1.ranking AS my_ranking,c2.ranking AS enemy_ranking,(SELECT COUNT(*) FROM goals g JOIN players p ON g.player_id = p.id WHERE g.pairing_id = m.id AND p.country_id = c1.id) AS my_goals,(SELECT COUNT(*) FROM goals g JOIN players p ON g.player_id = p.id WHERE g.pairing_id = m.id AND p.country_id = c2.id) AS enemy_goals
FROM pairings m JOIN countries c1 ON m.my_country_id = c1.id JOIN countries c2 ON m.enemy_country_id = c2.id
WHERE c1.group_name = 'C' AND c2.group_name = 'C'
ORDER BY m.kickoff, c1.ranking;

-- 問17
SELECT 
    m.kickoff,
    c1.name AS my_country_name,
    c2.name AS enemy_country_name,
    c1.ranking AS my_ranking,
    c2.ranking AS enemy_ranking,
    (SELECT COUNT(*) FROM goals g JOIN players p ON g.player_id = p.id WHERE g.pairing_id = m.id AND p.country_id = c1.id) AS my_goals,
    (SELECT COUNT(*) FROM goals g JOIN players p ON g.player_id = p.id WHERE g.pairing_id = m.id AND p.country_id = c2.id) AS enemy_goals,
    (SELECT COUNT(*) FROM goals g JOIN players p ON g.player_id = p.id WHERE g.pairing_id = m.id AND p.country_id = c1.id) - (SELECT COUNT(*) FROM goals g JOIN players p ON g.player_id = p.id WHERE g.pairing_id = m.id AND p.country_id = c2.id) AS goal_diff
FROM pairings m JOIN countries c1 ON m.my_country_id = c1.id JOIN countries c2 ON m.enemy_country_id = c2.id
WHERE c1.group_name = 'C' AND c2.group_name = 'C'
ORDER BY m.kickoff, c1.ranking;

-- 問18
SELECT p.kickoff AS kickoff,DATE_SUB(p.kickoff, INTERVAL 12 HOUR) AS kick_jp
FROM pairings p
WHERE p.my_country_id = 1 AND p.enemy_country_id = 4;

-- 問1９
-- TIMESTAMPDIFF　指定した単位で日付の差を計算
SELECT TIMESTAMPDIFF(YEAR, p.birth, '2014-06-13') AS age,COUNT(*) AS player_count
FROM players p
GROUP BY age
ORDER BY age ASC;

-- 問２０
-- FLOOR　10で割って切り捨て、１０をかける
SELECT FLOOR(TIMESTAMPDIFF(YEAR, p.birth, '2014-06-13') / 10) * 10 AS age, COUNT(*) AS player_count
FROM players p
GROUP BY age
ORDER BY age ASC;
-- 問２１
SELECT FLOOR(TIMESTAMPDIFF(YEAR, p.birth, '2014-06-13') / 5) * 5 AS age, COUNT(*) AS player_count
FROM players p
GROUP BY age
ORDER BY age ASC;

-- 問22

SELECT 
    FLOOR(TIMESTAMPDIFF(YEAR, p.birth, '2014-06-13') / 5) * 5 AS age,
    p.position,
    COUNT(*) AS player_count,
    AVG(p.height) AS avg_height,
    AVG(p.weight) AS avg_weight
FROM players p
GROUP BY age, p.position
ORDER BY age ASC, p.position ASC;

-- 問23
SELECT name, height ,weight 
FROM players
ORDER BY height DESC
LIMIT 5;

-- 問24
SELECT name, height ,weight 
FROM players
ORDER BY height DESC
LIMIT 20;
OFFSET 5;

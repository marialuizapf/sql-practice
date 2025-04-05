-- 🏟️ EURO 2012 - ESTUDO DE BANCO DE DADOS RELACIONAL EM SQL
-- Estrutura baseada em times, jogos e gols do campeonato europeu fictício

---------------------------------------------------
-- 📁 Criação das tabelas principais
---------------------------------------------------

-- Tabela de times (eteam): contém ID, nome e técnico
CREATE TABLE eteam (
    id CHAR(3) PRIMARY KEY,
    teamname VARCHAR(100) UNIQUE NOT NULL,
    coach VARCHAR(100) NOT NULL
);

-- Tabela de jogos (game): informações de cada partida
CREATE TABLE game (
    id INT PRIMARY KEY,
    mdate DATE NOT NULL,
    stadium VARCHAR(100) NOT NULL,
    team1 CHAR(3) NOT NULL,
    team2 CHAR(3) NOT NULL,
    FOREIGN KEY (team1) REFERENCES eteam(id),
    FOREIGN KEY (team2) REFERENCES eteam(id)
);

-- Tabela de gols (goal): registra cada gol feito em cada jogo
CREATE TABLE goal (
    matchid INT NOT NULL,
    teamid CHAR(3) NOT NULL,
    player VARCHAR(100) NOT NULL,
    gtime INT NOT NULL,  -- tempo do gol
    PRIMARY KEY (matchid, gtime),
    FOREIGN KEY (matchid) REFERENCES game(id),
    FOREIGN KEY (teamid) REFERENCES eteam(id)
);

---------------------------------------------------
-- 📥 Inserção de dados fictícios nas tabelas
---------------------------------------------------

-- Inserção dos times
INSERT INTO eteam (id, teamname, coach) VALUES
('POL', 'Poland', 'Franciszek Smuda'),
('RUS', 'Russia', 'Dick Advocaat'),
('CZE', 'Czech Republic', 'Michal Bilek'),
('GRE', 'Greece', 'Fernando Santos'),
('ESP', 'Spain', 'Vicente del Bosque'),
('GER', 'Germany', 'Joachim Löw'),
('FRA', 'France', 'Laurent Blanc'),
('ENG', 'England', 'Roy Hodgson'),
('ITA', 'Italy', 'Cesare Prandelli'),
('NED', 'Netherlands', 'Bert van Marwijk'),
('POR', 'Portugal', 'Paulo Bento');

-- Inserção dos jogos
INSERT INTO game (id, mdate, stadium, team1, team2) VALUES
(1001, '2012-06-08', 'National Stadium, Warsaw', 'POL', 'GRE'),
(1002, '2012-06-08', 'Stadion Miejski (Wroclaw)', 'RUS', 'CZE'),
(1003, '2012-06-09', 'Arena Gdansk', 'ESP', 'ITA'),
(1004, '2012-06-09', 'Lviv Arena', 'GER', 'POR'),
(1005, '2012-06-10', 'Donbass Arena', 'FRA', 'ENG'),
(1006, '2012-06-10', 'Stade de France', 'POL', 'CZE'),
(1007, '2012-06-11', 'San Siro', 'NED', 'GER'),
(1008, '2012-06-11', 'Stadio Olimpico', 'GRE', 'RUS'),
(1009, '2012-06-12', 'Camp Nou', 'ESP', 'FRA'),
(1010, '2012-06-12', 'Old Trafford', 'ENG', 'ITA');

-- Inserção dos gols feitos nos jogos
INSERT INTO goal (matchid, teamid, player, gtime) VALUES
(1001, 'POL', 'Robert Lewandowski', 17),
(1001, 'GRE', 'Dimitris Salpingidis', 51),
(1002, 'RUS', 'Alan Dzagoev', 15),
(1002, 'RUS', 'Roman Pavlyuchenko', 82),
(1003, 'ESP', 'Fernando Torres', 24),
(1003, 'ITA', 'Andrea Pirlo', 61),
(1004, 'GER', 'Mario Gomez', 72),
(1005, 'ENG', 'Wayne Rooney', 39),
(1006, 'CZE', 'Tomas Rosicky', 55),
(1009, 'ESP', 'David Silva', 18);

---------------------------------------------------
-- 🔍 Consultas para análise
---------------------------------------------------

-- Lista de gols da Alemanha
SELECT matchid, player
FROM goal
WHERE teamid = 'GER';

-- Detalhes do jogo 1004
SELECT id, stadium, team1, team2
FROM game
WHERE id = 1004;

-- Todos os gols da Alemanha com local e data
SELECT player, teamid, stadium, mdate
FROM game JOIN goal ON game.id = goal.matchid
WHERE teamid = 'GER';

-- Jogadores cujo nome começa com 'Mario' (busca por padrão)
SELECT team1, team2, player
FROM game JOIN goal ON game.id = goal.matchid
WHERE player LIKE 'Mario%';

-- Gols marcados até os 20 minutos, com nome do técnico
SELECT player, teamid, coach, gtime
FROM eteam JOIN goal ON eteam.id = goal.teamid
WHERE gtime <= 20;

-- Jogo onde o técnico Fernando Santos participou (Greece)
SELECT mdate, teamname
FROM game JOIN eteam ON game.team1 = eteam.id
WHERE coach = 'Fernando Santos';

-- Jogadores que marcaram no estádio "National Stadium, Warsaw"
SELECT player
FROM goal JOIN game ON goal.matchid = game.id
WHERE stadium = 'National Stadium, Warsaw';

-- Jogadores que fizeram gol contra a Alemanha
SELECT DISTINCT player
FROM goal JOIN game ON goal.matchid = game.id
WHERE (team1 = 'GER' OR team2 = 'GER') AND teamid <> 'GER';

-- Gols por time (quantidade total de gols por seleção)
SELECT teamname, COUNT(teamname)
FROM goal JOIN eteam ON goal.teamid = eteam.id
GROUP BY teamname;

-- Gols por estádio (quantidade de gols por local)
SELECT stadium, COUNT(stadium)
FROM goal JOIN game ON goal.matchid = game.id
GROUP BY stadium;

-- Gols marcados em partidas da Polônia
SELECT matchid, mdate, COUNT(matchid)
FROM goal JOIN game ON goal.matchid = game.id
WHERE team1 = 'POL' OR team2 = 'POL'
GROUP BY matchid;

-- Gols da Alemanha em partidas onde ela jogou
SELECT matchid, mdate, COUNT(matchid)
FROM goal JOIN game ON goal.matchid = game.id
WHERE (team1 = 'GER' OR team2 = 'GER') AND teamid = 'GER'
GROUP BY matchid;

--  Resultado das partidas: total de gols por time por jogo
SELECT 
  g.mdate,
  g.team1,
  SUM(CASE WHEN go.teamid = g.team1 THEN 1 ELSE 0 END) AS score1,
  g.team2,
  SUM(CASE WHEN go.teamid = g.team2 THEN 1 ELSE 0 END) AS score2
FROM game g
LEFT JOIN goal go ON g.id = go.matchid
GROUP BY g.mdate, g.id, g.team1, g.team2
ORDER BY g.mdate, g.id, g.team1, g.team2;

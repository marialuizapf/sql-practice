-- ======================================================
-- SCRIPT DE SQL: Banco de Dados de Países
-- ======================================================

-- ======================================================
-- 🧱 ESTRUTURA DA TABELA
-- ======================================================

CREATE TABLE world( 
    name VARCHAR(100) NOT NULL UNIQUE,        -- Nome do país
    continent VARCHAR(100) NOT NULL,          -- Continente
    population INT NOT NULL,                  -- População
    gdp BIGINT NOT NULL,                      -- PIB (ajustado para BIGINT)
    area INT NOT NULL                         -- Área territorial
);

-- ======================================================
-- 📥 INSERÇÃO DE DADOS
-- ======================================================

-- Europa
INSERT INTO world (name, continent, population, gdp, area) VALUES
('Germany', 'Europe', 83783942, 3845630000000, 357022),
('France', 'Europe', 65273511, 2715518000000, 551695),
('Italy', 'Europe', 60244639, 2001000000000, 301340),
('Spain', 'Europe', 46754778, 1397200000000, 505990),
('Poland', 'Europe', 38386000, 585000000000, 312696),
('Netherlands', 'Europe', 17134872, 902500000000, 41543);

-- América do Sul
INSERT INTO world (name, continent, population, gdp, area) VALUES
('Brazil', 'South America', 212559417, 2100000000000, 8515767),
('Argentina', 'South America', 45195777, 450000000000, 2780400),
('Colombia', 'South America', 50882891, 350000000000, 1141748),
('Chile', 'South America', 19116201, 300000000000, 756102),
('Peru', 'South America', 32971854, 200000000000, 1285216),
('Venezuela', 'South America', 28435943, 100000000000, 916445);

-- América do Norte
INSERT INTO world (name, continent, population, gdp, area) VALUES
('USA', 'North America', 331002651, 21000000000000, 9833517),
('Canada', 'North America', 37742154, 2000000000000, 9984670),
('Mexico', 'North America', 128932753, 1200000000000, 1964375),
('Cuba', 'North America', 11326616, 100000000000, 109884),
('Haiti', 'North America', 11402528, 20000000000, 27750),
('Dominican Republic', 'North America', 10847904, 80000000000, 48671);

-- Ásia
INSERT INTO world (name, continent, population, gdp, area) VALUES
('China', 'Asia', 1439323776, 14000000000000, 9596961),
('India', 'Asia', 1380004385, 2900000000000, 3287263),
('Japan', 'Asia', 126476461, 5000000000000, 377975),
('South Korea', 'Asia', 51269185, 2000000000000, 100032),
('Indonesia', 'Asia', 273523615, 1000000000000, 1904569),
('Vietnam', 'Asia', 98168829, 300000000000, 331212);

-- Oceania
INSERT INTO world (name, continent, population, gdp, area) VALUES
('Australia', 'Oceania', 25499884, 1500000000000, 7692024),
('New Zealand', 'Oceania', 4822233, 200000000000, 268021),
('Papua New Guinea', 'Oceania', 8947027, 50000000000, 462840),
('Fiji', 'Oceania', 896445, 5000000000, 18274),
('Samoa', 'Oceania', 198410, 1000000000, 2842),
('Tonga', 'Oceania', 105697, 500000000, 748);

-- África
INSERT INTO world (name, continent, population, gdp, area) VALUES
('Egypt', 'Africa', 102334155, 300000000000, 1002450),
('Nigeria', 'Africa', 206139589, 450000000000, 923768),
('South Africa', 'Africa', 59308690, 350000000000, 1219090),
('Kenya', 'Africa', 53771296, 95000000000, 580367),
('Ethiopia', 'Africa', 114114144, 80000000000, 1104300),
('Ghana', 'Africa', 31072940, 60000000000, 238533);

-- ======================================================
-- 🔎 CONSULTAS BÁSICAS
-- ======================================================

-- Busca simples por país
SELECT population FROM world WHERE name = 'Germany';

-- Filtro com OR
SELECT name, population FROM world WHERE name = 'Poland' OR name = 'Spain' OR name = 'Netherlands';

-- Filtro com IN (forma simplificada do OR)
SELECT name, population FROM world WHERE name IN ('Poland', 'Spain', 'Netherlands');

-- BETWEEN: intervalo de valores
SELECT name, area FROM world WHERE area BETWEEN 300000 AND 400000;
SELECT name, population FROM world WHERE population BETWEEN 10000000 AND 50000000;

-- LIKE: busca por padrão
SELECT name FROM world WHERE name LIKE '%y';

-- LENGTH: comprimento do nome
SELECT name FROM world WHERE LENGTH(name) > 6 AND continent = 'Europe';

-- LEFT: comparação pela primeira letra
SELECT name, continent FROM world WHERE LEFT(name, 1) = LEFT(continent, 1) AND name <> continent;

-- ======================================================
-- 🧮 OPERAÇÕES ARITMÉTICAS E TRANSFORMAÇÕES
-- ======================================================

-- Cálculo direto
SELECT name, area * 2 AS double_area FROM world WHERE population > 50000000;

-- Densidade populacional
SELECT name, population / area AS density FROM world WHERE name IN ('Germany', 'France', 'Italy');

-- PIB per capita
SELECT name, gdp / population AS per_capita_gdp FROM world WHERE population >= 50000000;

-- Transformação para milhões
SELECT name, population / 1000000 AS population_millions FROM world WHERE continent = 'South America';

-- ROUND com casas decimais e negativo
SELECT name, ROUND(population / 1000000.0, 2) AS population_millions, ROUND(gdp / 1000000000.0, 2) AS gdp_billions FROM world WHERE continent = 'South America';
SELECT name, ROUND(gdp / population, -3) AS per_capita_gdp FROM world WHERE gdp >= 1000000000000;

-- XOR: área ou população, mas não ambos
SELECT name, population, area FROM world WHERE area > 3000000 XOR population > 250000000;

-- ======================================================
-- 🔠 EXPRESSÕES COM TEXTO
-- ======================================================

-- Países que contêm todas as vogais
SELECT name FROM world WHERE name NOT LIKE '% %' AND name LIKE '%a%' AND name LIKE '%e%' AND name LIKE '%i%' AND name LIKE '%o%' AND name LIKE '%u%';

-- Com REGEXP
SELECT name FROM world WHERE name NOT LIKE '% %' AND name REGEXP 'a' AND name REGEXP 'e' AND name REGEXP 'i' AND name REGEXP 'o' AND name REGEXP 'u';

-- Começam com vogal
SELECT name FROM world WHERE name NOT LIKE '% %' AND name REGEXP '^[aeiou]';

-- Começam com consoante
SELECT name FROM world WHERE name NOT LIKE '% %' AND name REGEXP '^[^aeiou]';

-- Nome e continente com mesmo comprimento
SELECT name, continent FROM world WHERE LENGTH(name) = LENGTH(continent);

-- ======================================================
-- 🔁 SUBQUERIES
-- ======================================================

-- População maior que Cuba
SELECT name FROM world WHERE population > (SELECT population FROM world WHERE name = 'Cuba');

-- PIB per capita maior que da Alemanha
SELECT name FROM world WHERE continent = 'Europe' AND gdp / population > (SELECT gdp / population FROM world WHERE name = 'Germany');

-- População entre dois países
SELECT name, population FROM world WHERE population > (SELECT population FROM world WHERE name = 'Cuba') AND population < (SELECT population FROM world WHERE name = 'Germany');

-- Mesma região de Argentina e Austrália
SELECT name, continent FROM world WHERE continent IN (SELECT continent FROM world WHERE name IN ('Argentina', 'Australia')) ORDER BY name;

-- Comparação populacional percentual
SELECT name, CONCAT(ROUND(population / (SELECT population FROM world WHERE name = 'Germany') * 100), '%') AS perc_vs_germany FROM world WHERE continent = 'Europe';

-- ======================================================
-- 📊 AGREGAÇÕES E AGRUPAMENTOS
-- ======================================================

-- Maior população por continente
SELECT continent, MAX(population) FROM world GROUP BY continent;

-- País mais populoso
SELECT name FROM world WHERE population = (SELECT MAX(population) FROM world);

-- Maior área por continente
SELECT continent, name, area FROM world x WHERE area >= ALL (SELECT area FROM world y WHERE y.continent = x.continent AND area > 0);

-- País mais populoso de cada continente com pop <= 250M
SELECT name, continent, population FROM world x WHERE population >= ALL (SELECT population FROM world y WHERE y.continent = x.continent AND population <= 250000000);

-- Continentes cujo país mais populoso tem no máximo 25M de habitantes
SELECT continent FROM world GROUP BY continent HAVING MAX(population) <= 25000000;

-- Países desses continentes
SELECT name, continent, population FROM world WHERE continent IN (SELECT continent FROM world GROUP BY continent HAVING MAX(population) <= 25000000);

-- País com população 3x maior que todos os outros do mesmo continente
SELECT name, continent FROM world x WHERE population >= ALL (SELECT population * 3 FROM world y WHERE y.continent = x.continent AND y.name <> x.name);


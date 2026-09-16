-- Question 1: SnowSQL Login and Verification
SELECT
    CURRENT_USER(),
    CURRENT_ROLE(),
    CURRENT_WAREHOUSE(),
    CURRENT_DATABASE(),
    CURRENT_SCHEMA();

-- Question 2: Object Creation and DML
CREATE OR REPLACE WAREHOUSE gaming_wh
    WITH WAREHOUSE_SIZE = 'XSMALL'
    AUTO_SUSPEND = 60
    AUTO_RESUME = TRUE;

CREATE OR REPLACE DATABASE gaming_vault_db;
CREATE OR REPLACE SCHEMA studio_schema;

USE WAREHOUSE gaming_wh;
USE DATABASE gaming_vault_db;
USE SCHEMA studio_schema;

CREATE OR REPLACE TABLE game_titles (
    game_id INT,
    title STRING,
    studio STRING,
    genre STRING,
    metacritic_score INT,
    price_usd NUMBER(6, 2)
);

CREATE OR REPLACE STAGE game_data_stage;

INSERT INTO game_titles VALUES
    (101, 'The Witcher 3: Wild Hunt', 'CD Projekt Red', 'RPG', 92, 39.99),
    (102, 'Elden Ring', 'FromSoftware', 'Action RPG', 96, 59.99),
    (103, 'Cyberpunk 2077', 'CD Projekt Red', 'Action RPG', 86, 49.99),
    (104, 'Hollow Knight', 'Team Cherry', 'Metroidvania', 90, 14.99);

SELECT * FROM game_titles ORDER BY game_id;

UPDATE game_titles
SET metacritic_score = 90, price_usd = 29.99
WHERE game_id = 103;

DELETE FROM game_titles
WHERE game_id = 104;

SELECT * FROM game_titles ORDER BY game_id;

-- Question 3: Data Loading via SnowSQL
PUT file://C:/temp/games_batch.csv @game_data_stage AUTO_COMPRESS=TRUE;
LIST @game_data_stage;

COPY INTO game_titles
FROM @game_data_stage/games_batch.csv.gz
FILE_FORMAT = (
    TYPE = 'CSV'
    SKIP_HEADER = 0
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
);

SELECT * FROM game_titles ORDER BY game_id;

-- Question 4: Time Travel Query
SELECT CURRENT_TIMESTAMP();

UPDATE game_titles
SET price_usd = 19.99
WHERE game_id = 106;

DELETE FROM game_titles
WHERE game_id = 101;

SELECT * FROM game_titles ORDER BY game_id;
SELECT * FROM game_titles AT(OFFSET => -300) ORDER BY game_id;

-- Question 5: Data Recovery Using Time Travel
DELETE FROM game_titles WHERE genre = 'RPG';

SELECT * FROM game_titles ORDER BY game_id;

SELECT * FROM game_titles AT(OFFSET => -120) WHERE genre = 'RPG';

INSERT INTO game_titles
SELECT * FROM game_titles AT(OFFSET => -120) WHERE genre = 'RPG';

SELECT * FROM game_titles ORDER BY game_id;
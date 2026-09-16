# Snowflake Tutorial Assignment

This repository contains SQL solutions and datasets for the Snowflake assignment, executed via the SnowSQL CLI client.

---

### 1. SnowSQL Login and Connection
* Installed the SnowSQL CLI locally and verified installation using `snowsql -v`.
* Authenticated into the Snowflake account using account identifier and user credentials.
* Checked session context (`CURRENT_USER`, `CURRENT_ROLE`, `CURRENT_WAREHOUSE`, `CURRENT_DATABASE`, `CURRENT_SCHEMA`).

### 2. Creation of Snowflake Objects
* Built an `XSMALL` warehouse (`gaming_wh`), database (`gaming_vault_db`), and schema (`studio_schema`).
* Created a table (`game_titles`) along with an internal stage (`game_data_stage`).
* Populated sample rows and tested basic DML statements: `INSERT`, `SELECT`, `UPDATE`, and `DELETE`.

### 3. Data Loading Using SnowSQL
* Prepared a local batch file (`data.csv`).
* Staged the file into `@game_data_stage` using the `PUT` command with gzip compression enabled.
* Loaded the staged CSV records directly into `game_titles` via the `COPY INTO` command and verified with `SELECT`.

### 4. Snowflake Time Travel
* Updated and deleted existing table rows to simulate modifications.
* Used the `AT(OFFSET => -300)` clause to query and inspect historical records prior to the changes.

### 5. Data Recovery Using Time Travel
* Executed a `DELETE` query to simulate accidental data loss.
* Located the missing rows in the historical table state using `AT(OFFSET => -120)`.
* Restored the lost data back into the active table using `INSERT INTO ... SELECT * FROM game_titles AT(...)`.
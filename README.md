<div align="center">

# 🎧 SPOTIFY DATA ANALYSIS
### Turning Music Data Into Meaningful Insights With SQL

**A PostgreSQL-powered analytics project exploring tracks, artists, streaming performance, video engagement, and audio features.**

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-18-4169E1?style=for-the-badge&logo=postgresql&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-Analytics-00C853?style=for-the-badge&logo=databricks&logoColor=white)
![pgAdmin](https://img.shields.io/badge/pgAdmin-4-333333?style=for-the-badge&logo=postgresql&logoColor=white)
![Project](https://img.shields.io/badge/Project-Data_Analysis-1DB954?style=for-the-badge)

*Every stream tells a story. Every query uncovers a little more of it.*

</div>

---

## 🟢 The Mission

Music platforms generate enormous amounts of data—but raw data alone doesn't explain what makes a track perform, how artists compare, or how audio characteristics vary across a catalog.

This project uses **SQL in PostgreSQL** to explore a Spotify-related music dataset and answer analytical questions about streaming counts, artists, albums, video engagement, and track-level audio features.

> **The goal:** turn a dataset into a collection of clear, reproducible analyses—not just a pile of queries.

## 🧭 Project Snapshot

| Item | Details |
|---|---|
| Project type | Exploratory data analysis & SQL case study |
| Database | PostgreSQL |
| SQL environment | pgAdmin 4 |
| Dataset table | `public.spotify` |
| Dataset size | 20,594 rows reported after import; cleaning may change this |
| Columns | 24 |
| Main techniques | Aggregations, CTEs, subqueries, conditional aggregation, window functions |
| Deliverable | SQL script with commented analysis queries |

## 🎯 Questions This Project Explores

### 🎵 Track & Artist Performance
- Which tracks have more than **1 billion streams**?
- Which artists have the largest number of tracks in the dataset?
- Which tracks have the highest energy values?
- Which tracks have the highest recorded video views?

### 💿 Albums & Audio Features
- What is the average danceability for each artist–album combination?
- How much does energy vary within an album?
- Which tracks have a liveness score above the dataset average?
- How do track durations vary across the catalog?

### 📺 Platform & Engagement Analysis
- What is the total number of comments associated with licensed tracks?
- How do recorded Spotify and YouTube stream metrics compare for tracks represented on both platforms?
- How do views and likes vary among tracks with official videos?
- Which platforms appear most often in the `most_played_on` field?

*These are analytical questions about the supplied dataset. Results describe the dataset's recorded fields and should not automatically be interpreted as causal relationships or official platform-wide statistics.*

## 🧰 Tech Stack

- **PostgreSQL** — querying and analyzing structured data
- **pgAdmin 4** — database management and SQL execution
- **SQL** — data exploration, cleaning, aggregation, and analysis

## 🧠 SQL Skills Demonstrated

| Concept | How it is used |
|---|---|
| `SELECT`, `WHERE`, `ORDER BY` | Filtering and inspecting tracks |
| `COUNT`, `SUM`, `AVG`, `MIN`, `MAX` | Summarizing music and engagement metrics |
| `GROUP BY`, `HAVING` | Comparing artists, albums, and groups |
| `DISTINCT` | Exploring unique artists, albums, and categories |
| `CASE WHEN` and aggregate `FILTER` | Comparing platform-specific metrics |
| `COALESCE` | Handling missing aggregate results |
| Common Table Expressions (CTEs) | Structuring multi-step analysis |
| Subqueries | Comparing tracks with dataset-level averages |
| Window functions | Ranking tracks within each artist |
| Data cleaning | Identifying and removing invalid zero-duration records |

## 🔬 Selected SQL Techniques

### 1. Find tracks with more than one billion recorded streams

```sql
SELECT artist, track, stream
FROM public.spotify
WHERE stream > 1000000000
ORDER BY stream DESC NULLS LAST;
```

### 2. Rank the three most-viewed tracks for each artist

```sql
WITH ranked_tracks AS (
    SELECT
        artist,
        track,
        views,
        ROW_NUMBER() OVER (
            PARTITION BY artist
            ORDER BY views DESC NULLS LAST
        ) AS rn
    FROM public.spotify
)
SELECT artist, track, views
FROM ranked_tracks
WHERE rn <= 3
ORDER BY artist, rn;
```

### 3. Find tracks above average liveness

```sql
SELECT artist, track, liveness
FROM public.spotify
WHERE liveness > (
    SELECT AVG(liveness)
    FROM public.spotify
)
ORDER BY liveness DESC NULLS LAST;
```

### 4. Measure energy variation within each album

```sql
SELECT
    artist,
    album,
    MAX(energy) - MIN(energy) AS energy_range
FROM public.spotify
GROUP BY artist, album
ORDER BY energy_range DESC NULLS LAST;
```

*The examples above illustrate the analytical techniques. Run them against your final cleaned table to generate current results.*

## 🧹 Data Preparation Notes

The SQL script includes table creation, exploratory checks, and a cleaning step for tracks with a duration of zero minutes.

Before rerunning the script, review any `DROP TABLE IF EXISTS` statement: it deletes the existing table and its data.

Additional considerations:
- Check for missing values in important columns before interpreting results.
- Decide how duplicate track records should be handled based on the analytical question.
- Confirm numeric data types are suitable for the source values, especially large stream, view, like, and comment counts.
- Treat missing platform metrics carefully; a missing value is not always the same as a confirmed zero.
- Use `artist` alongside `track` or `album` where appropriate, since names may repeat.

## 🚀 Run the Project Locally

### 1. Set up PostgreSQL
Install PostgreSQL and open pgAdmin 4.

### 2. Create a database
Create a database for the project (for example, `spotify_db`) and connect to it.

### 3. Load the dataset
Obtain the source dataset and import it into a table named `spotify`. Make sure the table schema and CSV column order/types match.

### 4. Execute the SQL script
Open `spotify_analysis.sql` in Query Tool and run the relevant sections. If the script contains destructive table-reset statements, review them before execution.

### 5. Explore the results
Run the queries individually, inspect the result grids, and record verified findings for the project summary.

## 📁 Repository Structure

```text
spotify-data-analysis-sql/
├── README.md
└── spotify_analysis.sql
```

Optional additions:

```text
├── screenshots/
│   ├── dataset-preview.png
│   └── query-results.png
└── results/
    └── key-findings.md
```

## 📌 Key Findings

Add **3–5 verified findings** here after running your final queries. For each finding, include:
- The question answered
- The metric and result
- The SQL query or section that produced it
- A brief interpretation and any relevant limitation

> Findings intentionally aren't fabricated in this README. Populate this section with actual outputs from your database so readers can reproduce and verify them.

## ⚠️ Interpretation & Limitations

- The analysis reflects the supplied dataset, its collection method, and its coverage—not necessarily all Spotify tracks or current platform-wide performance.
- Fields such as `Stream`, `Views`, `Likes`, and `Comments` may have different measurement definitions and collection dates.
- A track's `most_played_on` value should not be treated as a complete breakdown of its plays across every platform.
- Correlation or differences between audio features and engagement do not establish causation.
- Dataset source, attribution, and redistribution terms should be documented before sharing the raw CSV.

## 🗺️ Next Improvements

- Add verified findings and query output examples.
- Explore relationships between audio features and recorded engagement.
- Investigate data quality, missing values, and duplicate records systematically.
- Optionally connect the cleaned dataset to Power BI or Tableau for a visual companion project.

## 👤 Author

**Nitin Sahu**  
Electrical Engineering student | Aspiring Data Analyst

- GitHub: [@nitinsahu2003](https://github.com/nitinsahu2003)
- LinkedIn: [Nitin Sahu](https://www.linkedin.com/in/nitin-sahu-6528aa166/)

---

<div align="center">

**Built with SQL, curiosity, and a love for data.** 🎧

*If you find this project useful, consider giving the repository a ⭐*

</div>

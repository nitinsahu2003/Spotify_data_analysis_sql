-- Advanced SQL Project -- Spotify Datasets
-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

-- EDA
SELECT COUNT(*) FROM spotify;

SELECT COUNT(DISTINCT artist) AS total_artists FROM spotify;
SELECT COUNT(DISTINCT album) AS total_albums FROM spotify;
SELECT COUNT(DISTINCT channel) AS total_channels FROM spotify;


SELECT DISTINCT album_type FROM spotify;
SELECT DISTINCT channel FROM spotify;

SELECT MAX(duration_min) FROM spotify;
SELECT MIN(duration_min) FROM spotify;

SELECT * FROM spotify WHERE duration_min = 0;
DELETE FROM spotify WHERE duration_min = 0;

SELECT DISTINCT most_played_on FROM spotify;

-- ------------------------------
-- DATA ANALYSIS - EASY CATEGORY
-- ------------------------------

-- 1. Retrieve the names of all tracks that have more than 1 billion streams.
SELECT track FROM spotify WHERE stream > 1000000000  
-- RETURNED 385 ROWS

-- 2. List all albums along with their respective artists.
SELECT album, artist FROM spotify -- Returned 20,592 rows coz 1 album may have more than 1 artist
SELECT DISTINCT album, artist FROM spotify  
-- Returned 14,178 rows coz returned only distinct albums

-- 3. Get the total number of comments for tracks where licensed = TRUE.
SELECT SUM(comments) AS total_number_of_comments FROM spotify WHERE licensed = TRUE  
-- Returned 497,015,695

-- 4. Find all tracks that belong to the album type single.
SELECT track FROM spotify WHERE album_type ILIKE 'single' 
--Returned 4973 rows; ILIKE is used when we don't know first letter is capital or not, 
--instead of '=', we use ILIKE															

-- 5. Count the total number of tracks by each artist.
SELECT artist, COUNT(DISTINCT track) AS total_no_of_songs
FROM spotify
GROUP BY artist
ORDER BY total_no_of_songs;
--Returned 2074 rows


-- ------------------------------
-- DATA ANALYSIS - MEDIUM CATEGORY
-- ------------------------------


--1. Calculate the average danceability of tracks in each album.
SELECT artist, album, ROUND(AVG(danceability)::numeric, 3) AS avg_danceability
FROM spotify
GROUP BY artist, album
ORDER BY avg_danceability DESC;
-- Returned 11,853 rows along with album and avg_danceability


--2. Find the top 5 tracks with the highest energy values.
SELECT artist, track, energy
FROM spotify
ORDER BY energy DESC NULLS LAST
LIMIT 5;


--3. List all tracks along with their views and likes where official_video = TRUE.
SELECT track, views, likes
FROM spotify
WHERE official_video = TRUE
ORDER BY views DESC;
-- Returned 15,634 rows


--4. For each album, calculate the total views of all associated tracks.
SELECT album, SUM(views) AS total_views
FROM spotify
GROUP BY album
ORDER BY total_views DESC;
-- Returned 11,853 rows


--5. Retrieve the track names that have been streamed on Spotify more than YouTube.
WITH spotify_then_youtube AS(
SELECT 
	artist, track,
	COALESCE(SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END), 0) AS streamed_on_youtube,
	COALESCE(SUM(CASE WHEN most_played_on = 'Spotify' THEN stream END), 0) AS streamed_on_spotify
FROM spotify
GROUP BY artist, track
)	
SELECT artist, track, streamed_on_spotify
FROM spotify_then_youtube
WHERE streamed_on_youtube < streamed_on_spotify 
ORDER BY streamed_on_spotify DESC
-- Returned 155 rows





-- ------------------------------
-- DATA ANALYSIS - ADVANCED CATEGORY
-- ------------------------------

--1. Find the top 3 most-viewed tracks for each artist using window functions.
WITH most_viewed_tracks AS(
SELECT artist, track, views, ROW_NUMBER() OVER(PARTITION BY artist ORDER BY views DESC) AS rn
FROM spotify
)
SELECT artist, track, views
FROM most_viewed_tracks
WHERE rn <=3;

--2. Write a query to find tracks where the liveness score is above the average.
SELECT track, liveness
FROM spotify
WHERE liveness > (SELECT AVG(liveness) FROM spotify)
ORDER BY liveness DESC
-- Returned 6364 rows


--3. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.

WITH high_low AS(
SELECT album, MAX(energy) AS highest_energy, MIN(energy) AS lowest_energy
FROM spotify
GROUP BY album
)
SELECT album, (highest_energy - lowest_energy) AS difference
FROM high_low
ORDER BY difference DESC;



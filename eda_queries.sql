-- eda_queries.sql
-- Initial Exploratory Data Analysis (EDA) on the mock datasets in Google BigQuery.

-- 1. Get an overview of the data
-- Count the total number of livestreams and unique DJs.
SELECT 
    COUNT(DISTINCT livestream_id) AS total_livestreams,
    COUNT(DISTINCT dj_id) AS total_djs
FROM `your-gcp-project.tiktok_music_data.dj_livestream_metrics`;

-- 2. Check the distribution of treatment vs. control groups
-- Confirm the split of DJs into the treatment and control groups.
SELECT 
    is_treatment_group,
    COUNT(DISTINCT dj_id) AS number_of_djs
FROM `your-gcp-project.tiktok_music_data.dj_livestream_metrics`
GROUP BY 1;

-- 3. Analyze pre-policy change metrics
-- Calculate the average view duration and total viewers for each group BEFORE the policy change.
SELECT 
    is_treatment_group,
    AVG(avg_view_duration_minutes) AS avg_duration_pre_policy,
    AVG(total_viewers) AS avg_viewers_pre_policy
FROM `your-gcp-project.tiktok_music_data.dj_livestream_metrics`
WHERE date < '2025-07-01'
GROUP BY 1;

-- 4. Analyze post-policy change metrics
-- Calculate the average view duration and total viewers for each group AFTER the policy change.
SELECT 
    is_treatment_group,
    AVG(avg_view_duration_minutes) AS avg_duration_post_policy,
    AVG(total_viewers) AS avg_viewers_post_policy
FROM `your-gcp-project.tiktok_music_data.dj_livestream_metrics`
WHERE date >= '2025-07-01'
GROUP BY 1;

-- 5. Calculate monthly livestream counts per DJ group
-- This helps check for potential changes in DJ activity levels.
SELECT 
    EXTRACT(MONTH FROM date) AS month,
    is_treatment_group,
    COUNT(DISTINCT livestream_id) AS total_livestreams
FROM `your-gcp-project.tiktok_music_data.dj_livestream_metrics`
GROUP BY 1, 2
ORDER BY 1, 2;

-- 6. Examine music source usage before and after the policy
-- This is a critical check to confirm that the 'treatment' group actually shifted their behavior.
SELECT
    CASE WHEN date < '2025-07-01' THEN 'Pre-Policy' ELSE 'Post-Policy' END AS period,
    music_source,
    is_treatment_group,
    COUNT(*) AS count_of_streams
FROM `your-gcp-project.tiktok_music_data.dj_livestream_metrics`
GROUP BY 1, 2, 3
ORDER BY 1, 2, 3;

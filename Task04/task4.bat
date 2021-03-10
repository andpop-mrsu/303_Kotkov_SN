#!/bin/bash
chcp 65001

sqlite3 movies_rating.db < db_init.sql

echo "1. Найти все драмы, выпущенные после 2005 года, которые понравились женщинам (оценка не ниже 4.5). Для каждого фильма в этом списке вывести название, год выпуска и количество таких оценок."
echo "--------------------------------------------------"
sqlite3 movies_rating.db -box -echo "select movies.title, movies.year, (select count(rating) from ratings inner join users on (users.id = user_id) where (movie_id = movies.id) and (instr(movies.genres, 'Drama') > 0) and (users.gender = 'female') and(rating >= 4.5)) as rating_number from ratings inner join movies on (movie_id = movies.id) inner join users on (user_id = users.id) where (users.gender = 'female') and (rating >= 4.5) and (instr(movies.genres, 'Drama') > 0) and (movies.year > 2005) group by movies.id;"
echo " "

echo "2. Провести анализ востребованности ресурса - вывести количество пользователей, регистрировавшихся на сайте в каждом году. Найти, в каких годах регистрировалось больше всего и меньше всего пользователей."
echo "--------------------------------------------------"
sqlite3 movies_rating.db -box -echo "select distinct substr(a.email, instr(a.email, '@') + 1, length(a.email)) as resource_name, substr(a.register_date, 0, instr(a.register_date, '-')) as year, (select count(b.name) from users b where substr(b.email, instr(b.email, '@') + 1, length(b.email)) = substr(a.email, instr(a.email, '@') + 1, length(a.email)) and substr(b.register_date, 0, instr(b.register_date, '-')) = substr(a.register_date, 0, instr(a.register_date, '-'))) as number_of_users from users a order by resource_name, year;"
sqlite3 movies_rating.db -box -echo "select a.year as year_with_max_number_of_registered_users from (select substr(register_date, 0, instr(register_date, '-')) as year, count(id) as number_of_registrations from users group by year) a inner join (select min(number_of_registrations) as min_num_of_registrations, max(number_of_registrations) as max_num_of_registrations from (select substr(register_date, 0, instr(register_date, '-')) as year, count(id) as number_of_registrations from users group by year)) b on a.number_of_registrations = b.max_num_of_registrations;"
sqlite3 movies_rating.db -box -echo "select a.year as year_with_min_number_of_registered_users from (select substr(register_date, 0, instr(register_date, '-')) as year, count(id) as number_of_registrations from users group by year) a inner join (select min(number_of_registrations) as min_num_of_registrations, max(number_of_registrations) as max_num_of_registrations from (select substr(register_date, 0, instr(register_date, '-')) as year, count(id) as number_of_registrations from users group by year)) b on a.number_of_registrations = b.min_num_of_registrations;"
echo " "

echo "3. Найти все пары пользователей, оценивших один и тот же фильм. Устранить дубликаты, проверить отсутствие пар с самим собой. Для каждой пары должны быть указаны имена пользователей и название фильма, который они ценили."
echo "--------------------------------------------------"
sqlite3 movies_rating.db -box -echo "select (a.name || ' - ' || b.name) as users_names, movies.title from ratings r inner join ratings r1 on r.movie_id = r1.movie_id and r.id > r1.id inner join users a on a.id = r.user_id inner join users b on b.id = r1.user_id inner join movies on r.movie_id = movies.id;"
echo " "

echo "4. Найти 10 самых старых оценок от разных пользователей, вывести названия фильмов, имена пользователей, оценку, дату отзыва в формате ГГГГ-ММ-ДД."
echo "--------------------------------------------------"
sqlite3 movies_rating.db -box -echo "select movies.title, users.name, ratings.rating, date(ratings.timestamp, 'unixepoch') as rating_date from ratings inner join movies on movies.id = ratings.movie_id inner join users on users.id = ratings.user_id group by users.name having min(rating_date) order by rating_date limit 10;"
echo " "

echo "5. Вывести в одном списке все фильмы с максимальным средним рейтингом и все фильмы с минимальным средним рейтингом. Общий список отсортировать по году выпуска и названию фильма. В зависимости от рейтинга в колонке 'Рекомендуем' для фильмов должно быть написано 'Да' или 'Нет'."
echo "--------------------------------------------------"
sqlite3 movies_rating.db -box -echo "select title, year, average_rating as rating, case a.average_rating when b.max_avg_rating then 'Yes' else 'No' end 'Recomended' from (select movies.title as title, movies.year as year, avg(rating) as average_rating from ratings inner join movies on movies.id = movie_id group by movie_id) as a inner join (select max(average_rating) as max_avg_rating, min(average_rating) as min_avg_rating from (select movies.title as title, movies.year as year, avg(rating) as average_rating from ratings inner join movies on movies.id = movie_id group by movie_id)) as b on a.average_rating = b.max_avg_rating or a.average_rating = b.min_avg_rating order by a.year, a.title;"
echo " "

echo "6. Вычислить количество оценок и среднюю оценку, которую дали фильмам пользователи-мужчины в период с 2011 по 2014 год."
echo "--------------------------------------------------"
sqlite3 movies_rating.db -box -echo "select count(*) as number_of_ratings, avg(rating) as average_rating from ratings inner join users on (users.id = user_id) where (users.gender = 'male') and date(timestamp, 'unixepoch') >= '2011-01-01' and date(timestamp, 'unixepoch') <= '2013-12-31';"
echo " "

echo "7. Составить список фильмов с указанием средней оценки и количества пользователей, которые их оценили. Полученный список отсортировать по году выпуска и названиям фильмов. В списке оставить первые 20 записей."
echo "--------------------------------------------------"
sqlite3 movies_rating.db -box -echo "select title, year, avg(ratings.rating) as average_rating, count(distinct ratings.user_id) as number_of_ratings from movies inner join ratings on ratings.movie_id = movies.id group by movies.id order by movies.year, movies.title limit 20;"
echo " "

echo "8. Определить самый распространенный жанр фильма и количество фильмов в этом жанре"
echo "--------------------------------------------------"
sqlite3 movies_rating.db -box -echo "select genre, max(number_of_movies) from (with divided_genres(genre, combined_genres) as (select null, genres from movies union all select case when instr(combined_genres, '|') = 0 then combined_genres else substr(combined_genres, 1, instr(combined_genres, '|') - 1) end, case when instr(combined_genres, '|') = 0 then null else substr(combined_genres, instr(combined_genres, '|') + 1) end from divided_genres where combined_genres is not null) select genre, count(*) as number_of_movies from divided_genres where genre is not null group by genre);"
echo " "

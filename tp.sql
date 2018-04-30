/* Schema:
    movie(movie_id, movie_name, production_year, votes, ranking, rating)
    movie_info(movie_id, movie_genre_id, note)
    movie_genre(movie_genre_id, genre_name)
    person(person_id, person_name, gender)
    role(person_id, movie_id, role_name, role_type_id)
    role_type(role_type_id, type_name)
*/

use IMDB;

-- 1:
select movie.movie_name as Filme, person.person_name Diretora
  from role inner join person on role.person_id = person.person_id
            inner join movie  on role.movie_id = movie.movie_id
  where person.gender = 'f'
    and role.role_type_id = 8;

-- 2:
select person_name as Nome, Papeis
  from person inner join (
        select person_id, count(*) as Papeis
          from role inner join movie_info on role.movie_id = movie_info.movie_id
          where role_type_id < 3
            and movie_genre_id = 6
          group by person_id
          order by Papeis desc
          limit 10
       ) as top_crime
  where top_crime.person_id = person.person_id;

-- 3:
select person_name as Diretor, movie_name as Filme, votes as Votos
  from (
    select movie.movie_id, movie_name, votes
      from movie inner join movie_info on movie.movie_id = movie_info.movie_id
      where movie_info.movie_genre_id = 19
      order by votes desc
      limit 10
  ) as top_votes inner join role on top_votes.movie_id = role.movie_id
                 inner join person on role.person_id = person.person_id
  where role.role_type_id = 8;

-- 5:
select movie_name as Filme, role_name as Papel
  from role inner join movie on role.movie_id = movie.movie_id
  where person_id = 1590417 and role_type_id = 1;

-- 6:
select movie_name as Filme, production_year as Ano, ranking as Rank
  from movie
  where production_year > 2000
  order by ranking
  limit 20;

-- 9:
select case role_type_id
        when 1 then 'Ator'
        when 2 then 'Atriz'
       end as Genero,
       count(*) * 100 / (
        select count(*)
          from role
          where role_type_id < 3
       ) as Porcentagem
  from role
  where role_type_id < 3
  group by role_type_id
  order by Porcentagem desc;

-- 12:
select person_name, role_name
  from role inner join person on role.person_id = person.person_id
            inner join movie  on role.movie_id = movie.movie_id
  where movie.movie_name = 'Back to the Future';

-- 13:
select movie_name, person_name, genre_name
  from role inner join movie on role.movie_id = movie.movie_id
            inner join person on role.person_id = person.person_id
            inner join movie_info on role.movie_id = movie_info.movie_id
            inner join movie_genre on movie_info.movie_genre_id = movie_genre.movie_genre_id
  where role.role_name = 'director'
    and movie_genre.genre_name = 'Horror';

-- 14:
select movie_name, role_name, rating
  from role inner join person on role.person_id = person.person_id
            inner join movie  on role.movie_id = movie.movie_id
  where person.person_name = 'Foster, Jodie';

-- 15:
select person_name, movie_name, rating
  from role inner join person on role.person_id = person.person_id
            inner join movie  on role.movie_id = movie.movie_id
            inner join movie_info on movie.movie_id = movie_info.movie_id
  where role.role_name = 'director'
    and movie_info.movie_genre_id = 7
  order by rating desc;

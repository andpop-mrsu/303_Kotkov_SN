def parse_movies_data(line):
    splitted_line = line.split(',')

    if len(splitted_line) == 3:
        id = splitted_line[0]

        if splitted_line[1][0] == '"' and splitted_line[1][-1] == '"':
            middle = splitted_line[1][1:-1]
            title = middle[:-7].rstrip()
            year = middle[-5:-1]
        else:
            title = splitted_line[1][:-7].rstrip()
            year = splitted_line[1][-5:-1]
        genres = splitted_line[2][:-1]

        try:
            year = int(year)
        except:
            year = 'NULL'
            title = splitted_line[1].rstrip()

    else:
        id = splitted_line[0]

        middle = splitted_line[1]
        for segment in splitted_line[2:-1]:
            middle = middle + ', ' + segment
        middle = middle[1:-1]

        title = middle[:-7].rstrip()
        year = middle[-5:-1]
        genres = splitted_line[-1][:-1]

        try:
            year = int(year)
        except:
            year = 'NULL'
            title = middle.rstrip()
    return [id, title, year, genres]


if __name__ == '__main__':
    with open('db_init.sql', 'w+') as f:
        # Drop created tables
        f.write(f'drop table if exists movies;\n'
         'drop table if exists ratings;\n'
         'drop table if exists tags;\n'
         'drop table if exists users;\n\n')

        # Create tables
        f.write(f'create table movies(\n'
        '\tid int primary key,\n'
        '\ttitle varchar(255),\n'
        '\tyear int,\n'
        '\tgenres varchar(255)\n'
        ');\n\n')

        f.write(f'create table ratings(\n'
        '\tid int primary key,\n'
        '\tuser_id int,\n'
        '\tmovie_id int,\n'
        '\trating float,\n'
        '\ttimestamp int\n'
        ');\n\n')

        f.write(f'create table tags(\n'
        '\tid int primary key,\n'
        '\tuser_id int,\n'
        '\tmovie_id int,\n'
        '\ttag varchar(255),\n'
        '\ttimestamp int\n'
        ');\n\n')

        f.write(f'create table users(\n'
        '\tid int primary key,\n'
        '\tname varchar(255),\n'
        '\temail varchar(255),\n'
        '\tgender varchar(16),\n'
        '\tregister_date varchar(32),\n'
        '\toccupation varchar(255)\n'
        ');\n\n')

        # Filling tables
        # Movies table

        with open('movies.csv', 'r') as mf:
            movies_data = mf.readlines()

        f.write(f'insert into movies(id, title, year, genres)\n'
            'values\n')

        for line in movies_data[1:-1]:
            movie_data = parse_movies_data(line)
            f.write(f'({movie_data[0]}, "{movie_data[1]}", {movie_data[2]}, "{movie_data[3]}"),\n')

        movie_data = parse_movies_data(movies_data[-1])
        f.write(f'({movie_data[0]}, "{movie_data[1]}", {movie_data[2]}, "{movie_data[3]}");\n\n')

        # Ratings table
        with open('ratings.csv', 'r') as rf:
            ratings_data = rf.readlines()

        f.write(f'insert into ratings(id, user_id, movie_id, rating, timestamp)\n'
                'values\n');
        id = 1
        for line in ratings_data[1:-1]:
            rating_data = line.split(',')
            f.write(f'({id}, {rating_data[0]}, {rating_data[1]}, {rating_data[2]}, {rating_data[3][:-1]}),\n')
            id += 1

        rating_data = ratings_data[-1].split(',')
        f.write(f'({id}, {rating_data[0]}, {rating_data[1]}, {rating_data[2]}, {rating_data[3][:-1]});\n\n')

        # Tags table
        with open('tags.csv', 'r') as tf:
            tags_data = tf.readlines()

        f.write(f'insert into tags(id, user_id, movie_id, tag, timestamp)\n'
                'values\n');
        id = 1
        for line in tags_data[1:-1]:
            tag_data = line.split(',')

            tag_data[2] = tag_data[2].replace('"', '')

            f.write(f'({id}, {tag_data[0]}, {tag_data[1]}, "{tag_data[2]}", {tag_data[3][:-1]}),\n')
            id += 1

        tag_data = tags_data[-1].split(',')
        f.write(f'({id}, {tag_data[0]}, {tag_data[1]}, "{tag_data[2]}", {tag_data[3][:-1]});\n\n')

        # Users table
        with open('users.txt', 'r') as uf:
            users_data = uf.readlines()

        f.write(f'insert into users(id, name, email, gender, register_date, occupation)\n'
                'values\n');
    
        for line in users_data[:-1]:
            user_data = line.split('|')
            f.write(f'({user_data[0]}, "{user_data[1]}", "{user_data[2]}", "{user_data[3]}", "{user_data[4]}", "{user_data[5][:-1]}"),\n')


        user_data = users_data[-1].split('|')
        f.write(f'({user_data[0]}, "{user_data[1]}", "{user_data[2]}", "{user_data[3]}", "{user_data[4]}", "{user_data[5][:-1]}");')
        
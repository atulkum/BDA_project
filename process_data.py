#download data from https://www.preflib.org/data/election/netflix/
i = 0
movie2id = {}
ranking_data = []

#per file vars
for fid in range(1, 100 + 1):
    curr_n_movies = -1
    movie_is_map = {}
    for i, line in enumerate(open(f'netflix/ED-00004-00000{fid:03d}.soc')):
        line = line.strip()
        if i == 0:
            curr_n_movies = int(line)
            assert curr_n_movies == 3
        elif i <= curr_n_movies:
            parts = line.split(',')
            movie_name = ' '.join(parts[1:])
            if movie_name not in movie2id:
                movie2id[movie_name] = len(movie2id) + 1
            movie_is_map[parts[0]] = movie2id[movie_name]
        elif i == curr_n_movies + 1:
            pass
        else:
            parts = line.split(',')
            datum = {'count': int(parts[0])}
            for rank_id in range(1, curr_n_movies+1):
                datum[f'rank{rank_id}'] = movie_is_map[parts[rank_id]]
            ranking_data.append(datum)
movie_data = []
for k, v in movie2id.items():
    movie_data.append({
        'id': v,
        'movie_name': k
    })

import pandas as pd
movie_df = pd.DataFrame(movie_data)
movie_df.to_csv('movie_name2id.tsv', sep='\t', index=False)
ranking_df = pd.DataFrame(ranking_data)
ranking_df.to_csv('ranking_data.csv', index=False)



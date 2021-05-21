functions {
 real exploded_lpmf(int[] x, vector Theta){
    real out = 0;
    vector[num_elements(Theta)] thetar = Theta;
    for(pos in x){
      out += log(thetar[pos]) - log(sum(thetar));
      thetar[pos] = 0;
    }
    return(out);
 }
}
data{
  int N_ranking; //total times the choices were ranked
  int N_ranked; //total choices ranked
  int N_options; //total options
  int res[N_ranking, N_ranked];
  int weights[N_ranking];
}
parameters {
  simplex[N_options] Theta;
}
model {
  target += dirichlet_lpdf(Theta| rep_vector(1, N_options));
  for(r in 1:N_ranking){
    for (w in 1:weights[r]){
      target += exploded_lpmf(res[r]|Theta);
    }
  }
}

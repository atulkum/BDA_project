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
 int[] exploded_rng(int ranked, vector Theta){
    int res[ranked] = rep_array(0,ranked);
    vector[num_elements(Theta)] thetar = Theta;
    
    for(i in 1:ranked){
      thetar = thetar/sum(thetar);
      res[i] = categorical_rng(thetar);
      thetar[res[i]] = 0;
    }
    return (res);
 }
}
data{
  int N_ranking; //total times the choices were ranked
  int N_ranked; //total choices ranked
  int N_options; //total options
}
transformed data {
  int res_sim[N_ranking, N_ranked];
  vector[N_options] Theta_ = dirichlet_rng(rep_vector(1, N_options));
  
  for (j in 1:N_ranking){
    res_sim[j] = exploded_rng(N_ranked, Theta_);
  }
}
parameters {
  simplex[N_options] Theta;
}
model {
  target += dirichlet_lpdf(Theta| rep_vector(1, N_options));
  for(r in 1:N_ranking){
    target += exploded_lpmf(res_sim[r]|Theta);
  }
}

generated quantities {
  int ranks_[N_options];
  for (j in 1:N_options){ 
    ranks_[j] = Theta[j] < Theta_[j];
  }
}

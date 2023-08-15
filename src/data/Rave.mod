/*********************************************
 * OPL 12.4 Model
 * Author: andrrari
 * Creation Date: 11/03/2018 at 15:26:49
 * Sport Schedulling model
 * Basic modell.
 * Tournoment type : Double robin Round
 * Symetric        : French scheme
 * constrain     : time compacted
    : top team
    : H-W balanced
 * Opt Function    : away - away breaks in pair of consecutive matchs 
 *********************************************/

int n = ...; /*numero de equipos*/
int h = 2*n-2 ; /*numero de  fechas Times contrain*/


range I = 1..n; /*equipo i,j*/
range K = 1..h; /*fecha k*/
range It = 1..2; /*top teams*/
range Ic = 3..10; /*normal teams*/
{int} Kodd = {1,3,5,7,9,11,13,15,17}; /*fechas impares*/

dvar boolean X[I,I,K]; // 1 si el equipo i juega de local contra j en la ronda k. 
dvar boolean Y[I,K]; // 1 si el equipo i juega una secuencia H-A en la ronda k. 
dvar boolean W[I,K]; // 1 si el equipo i tiene un A-A break iniciando en la ronda k
  
 
/*minimizar el numero de A-A breaks*/
 minimize
  sum(i in I)
    sum(k in Kodd)
      W[i][k];

subject to {
  
/*ronda 1: el equipo i debe enfrentarse al equipo j una sola vez de local o visitante*/
 forall(i in I, j in I : i!=j) 
   ctr2:
     sum(k in K : k <= (n-1)) 
       (X[i][j][k] + X[j][i][k]) == 1;

/*ronda 2: el equipo i debe enfrentarse al equipo j una sola vez de local o visitante*/
 forall(i in I, j in I : i!=j) 
   ctr3:
     sum(k in K : k > (n-1)) 
       (X[i][j][k] + X[j][i][k]) == 1;

/*el equipo i debe enfrentarse al equipo j de local una sola vez*/
 forall(i in I, j in I : i!=j) 
   ctr4:
     sum(k in K ) 
       (X[i][j][k]) == 1;       
       
      
/*compactness: cada equipo debera jugar en cada ronda */
 forall(j in I, k in K ) 
  ctr5:
    sum( i in I : i!=j) 
       (X[i][j][k] + X[j][i][k]) == 1;


/* top team const =1,2 */ 
 forall(i in Ic, k in K : k < h)
  ctr6:
    sum(j in It)
       (X[i][j][k] + X[j][i][k] + X[i][j][k+1] + X[j][i][k+1]) <= 1;
      
/* Restricciones de balance */ 

/* cada equipo tiene entre n/2 -1 y n/2 secuencias H-A*/
 forall(i in I)
   ctr7:
     sum(k in Kodd)
       Y[i][k] <= n/2;

 forall(i in I)
   ctr8:
     sum(k in Kodd)
       Y[i][k] >= n/2-1;

/* si el equipo i juega de local en una fecha, la proxima tiene que jugar de visitante*/

 forall(i in I, k in Kodd)
   ctr9:
     sum(j in I: i!=j)
       (X[i][j][k]+X[j][i][k+1])<=1+Y[i][k];
 
 forall(i in I, k in Kodd)
   ctr10:
     sum(j in I: i!=j)
       (X[i][j][k])>=Y[i][k];
       
 forall(i in I, k in Kodd)
   ctr11:
     sum(j in I: i != j)
       X[j][i][k+1] >= Y[i][k];

/* */

 forall(i in I, k in Kodd)
   ctr12:
     sum(j in I: i!=j)
       (X[j][i][k]+X[j][i][k+1])<=1+ W[i][k];
 
 forall(i in I, k in Kodd)
   ctr13:
     sum(j in I: i!=j)
       (X[j][i][k])>= W[i][k];
       
 forall(i in I, k in Kodd)
   ctr14:
     sum(j in I: i != j)
       X[j][i][k+1] >= W[i][k];
        

/* Symetric french scheme */
 forall (i in I, j in I: i!=j)
   ctr15:
    X[i][j][1] == X[j][i][2*n-2];
    
 forall (i in I, j in I: i!=j , k in 2..n-1)
   ctr16:
    X[i][j][k] == X[j][i][k+n-2];
 

}
tuple productData {
   string name;
   float demand;
   float insideCost;
   float outsideCost;
   float consumptionFlour;
   float consumptionEggs;
}
{productData} Products = ...;
float CapacityFlour = 20;
float CapacityEggs = 40;

dvar int+ Inside[Products];
dvar int+ Outside[Products];

execute CPX_PARAM {
  cplex.preind = 0;   
  cplex.simdisplay = 2;   
}


minimize
  sum( p in Products ) 
    (p.insideCost * Inside[p] + 
    p.outsideCost * Outside[p] );
subject to {
	ctInsideFlour: 
	  sum( p in Products ) 
	    p.consumptionFlour * Inside[p] <= CapacityFlour;
	ctInsideEggs: 
	  sum( p in Products ) 
	    p.consumptionEggs * Inside[p] <= CapacityEggs;
  forall( p in Products )
    ctDemand: 
      Inside[p] + Outside[p] >= p.demand;
}

tuple R {
   string productName; 
   float inside;
   float outside;
};
{R} Results = { <p.name, Inside[p], Outside[p]> | p in Products };


/* 
Let's take as example a production model 
with four products, each one with a known demand, 
also with a processing time and a profit

we would like to maximize the profit taking into account
the maximum production time avialable
*/

//Define parameters
tuple produdct_tuple
{
 key int id;
 float demand;
 float profit;
 float prod_time;
}

{produdct_tuple} products={<1,50,40,15>,<2,70,20,15>,<3,100,10,5>,<4,20,70,25>};
	
float capacity = 2000;

//Define decision variables
dvar int production[products];

//Define linear expressions
dexpr float profit_prod = sum(p in products)(production[p]*p.profit);

maximize profit_prod;

//Define constraints
subject to{
  //For each product the produced quantity must be less than or equal to the demand
  forall(p in products)
    	production[p] <= p.demand;
  //The total production time must be less than or equal to the available production time
  ctCapacity: sum(p in products)(production[p]*p.prod_time) <= capacity;
}

execute{
  writeln("The maximum profit would be: "+profit_prod);
  for(var p in products){
    writeln("The company needs to produce "+production[p]+" unit of product "+p.id);
  }
  
}

/*
Now we would like to see what happens if the available time is doubled
to do so, use flow control and a buffer variable
*/

main{
  thisOplModel.generate();
  
  cplex.solve();  
  thisOplModel.postProcess();
  
  writeln("now 4000 of capacity instead of 2000");
  
  var buffer=2*thisOplModel.capacity;
  
  thisOplModel.ctCapacity.UB=buffer;
  
  cplex.solve();
  thisOplModel.postProcess();
}
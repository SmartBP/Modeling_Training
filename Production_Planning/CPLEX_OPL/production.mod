
//Define sets
{string} products = {"A","B","C","D"};

//Define parameters
//demand
int demand[products] = [50,70,100,20];
//profit
int profit[products] = [40,20,10,70];
//processing time
int pro_time[products] = [15,15,5,25];
//total capacity
int capacity = 2000;

//Define decision variables
dvar int production[products];

//Define linear expressions
dexpr int profit_prod = sum(p in products)(production[p]*profit[p]);
//Define objective function
maximize profit_prod;

//Define constraints
subject to{
  //The company has limited time capacity to produce all the products
  forall(p in products)
  	production[p] <= demand[p];
  //The company cannot sale products over the known demand
  sum(p in products)(production[p]*pro_time[p]) <= capacity;
}

execute{
  writeln("The maximum profit would be: "+profit_prod);
  for(var p in products){
    writeln("The company needs to produce "+production[p]+" unit of product "+p);
  }
  
}
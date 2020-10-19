// Vehicles
int     v          = 2;
range   Vehicles   = 1..v;
 
// Customers
int     CustomersNumber      = 4;
range   Customers            = 1..CustomersNumber;
range   CustomersAndRefinery   = 0..(CustomersNumber+1); // includes the starting depot and the returning depot

// Capacity
int Capacity = 100;

// Demand
int Demand[Customers] = [35, 25, 35, 45];

// Time windows
int LBTW[CustomersAndRefinery] = [0, 15, 23, 12, 24, 0]; // Lower Bound of the Time Window
int UBTW[CustomersAndRefinery] = [120, 24, 42, 38, 48, 120]; // Upper Bound of the Time Window
 
int   ServiceTime[CustomersAndRefinery] = [0, 5, 6, 5, 6, 0];
float Cost[CustomersAndRefinery][CustomersAndRefinery] = [[0, 7, 7, 15, 5, 0],
														  [7, 0, 12, 8, 5, 7],
														  [7, 12, 0, 9, 3, 7],
														  [15, 8, 9, 0, 2, 15],
														  [5, 5, 3, 2, 0, 5],
														  [0, 7, 7, 15, 5, 0]]; // Cost between i and j
float Time[CustomersAndRefinery][CustomersAndRefinery] = [[0, 7, 7, 15, 5, 0],
														  [7, 0, 12, 8, 5, 7],
														  [7, 12, 0, 9, 3, 7],
														  [15, 8, 9, 0, 2, 15],
														  [5, 5, 3, 2, 0, 5],
														  [0, 7, 7, 15, 5, 0]]; // Distance between i and j

// Decision variables
dvar boolean x[Vehicles][CustomersAndRefinery][CustomersAndRefinery]; // 1 if a vehicle drives directly from vertex i to vertex j
dvar int s[Vehicles][CustomersAndRefinery]; // the time a vehicle starts to service a customer
dexpr float maxTimeSpentBetweenTwoCustomers = max(a,b in CustomersAndRefinery)(UBTW[a] + Time[a][b] - LBTW[b]);

minimize sum(k in Vehicles, i,j in CustomersAndRefinery) (Cost[i][j]*x[k][i][j]);

subject to {
	forall(i in CustomersAndRefinery, k in Vehicles)
	  x[k][i][i] == 0;

   	// Each customer is visited exactly once
	forall (i in Customers)
		sum(k in Vehicles, j in CustomersAndRefinery) x[k][i][j] == 1;

   	// A vehicle can only be loaded up to it's capacity
	forall(k in Vehicles)
     	sum(i in Customers, j in CustomersAndRefinery)(Demand[i] * x[k][i][j]) <= Capacity;
   	// Each vehicle must leave the depot 0
	forall(k in Vehicles)
     	sum (j in CustomersAndRefinery)x[k][0][j] == 1;
   	// After a vehicle arrives at a customer it has to leave for another destination
   	forall(h in Customers, k in Vehicles)
     	sum(i in CustomersAndRefinery)x[k][i][h] - sum(j in CustomersAndRefinery)x[k][h][j] == 0;
   	// All vehicles must arrive at the depot n + 1
   	forall(k in Vehicles)
     	sum (i in CustomersAndRefinery) x[k][i][CustomersNumber+1] == 1;
   	// The time windows are observed
   	forall(i in CustomersAndRefinery, k in Vehicles)
     	LBTW[i] <= s[k][i] <= UBTW[i];
   	// From depot departs a number of vehicles equal to or smaller than v
   	forall(k in Vehicles, j in CustomersAndRefinery)
     	sum (k in Vehicles, j in CustomersAndRefinery) x[k][0][j] <= v;
   	// Vehicle departure time from a customer and its immediate successor
   	forall(i,j in CustomersAndRefinery, k in Vehicles)
     	s[k][i] + Time[i][j] + ServiceTime[i] - maxTimeSpentBetweenTwoCustomers*(1 - x[k][i][j]) <= s[k][j];
};

execute DISPLAY {
    writeln("Solutions: ");
	for(var k in Vehicles){
		for(var i in CustomersAndRefinery){
			for (var j in CustomersAndRefinery){
				if(x[k][i][j] == 1){
					writeln("vehicle ", k, " from ", i, " to ", j,", starts trip at: ", (s[k][j]-Time[i][j]),", starting service at: ", s[k][j], " and ending at: ",(s[k][j] + ServiceTime[j]));
  				} 			
 			}			
		}		
	}	
}
# Vehicle Routing Problem with Time Windows (VRPTW)

The VRPTW can be described as follows. Given a set of customers, a set of vehicles, and a depot, the VRPTW is to find a set of routes of minimal total length, starting and ending at the depot, such that each customer is visited by exactly one vehicle to satisfy a specific demand. Customer visit has to respect a requested time window. A vehicle can wait in case of early arrival, but late arrival is not allowed. In connection with customer demands, a capacity constraint restricts the load that can be carried by a vehicle.

More formally, the VRPTW is defined on a complete directed graph G = (V, A), where V = {v0, . . . , vn} is the set of nodes and A is the set of arcs. Vertex v0 is a special node called the depot, vertices v1 to vn represent customers. A cost ci j and a travel time ti j are defined for every arc (vi, vj ) ∈ A. Every customer vi ∈ V\{v0} has a positive demand di , a time window [ai , bi ] and a positive service time servi . A fleet of U vehicles of capacity Q is available for serving the customers. Vehicles must begin and end their routes at the depot within a time horizon [a0, b0]. The cumulative demand of the customers visited by a route is limited by Q. The service of a customer has to start within its time window, but a vehicle is allowed to arrive earlier and to wait. The VRPTW consists in finding a minimum cost set of at most U routes visiting exactly once each customer with respect to the previous constraints.

## VRPTW applications

- Product deliveries
- Solid waste collection
- Street cleaning
- School bus routing
- Dial-a-ride systems
- Transportation of handicapped persons
- Routing of salespeople
- Maintenance of units

This modeling example is at the advanced level, where we assume that you know Python and the CPLEX Python API and you have advanced knowledge of building mathematical optimization models.

## Actual example

In order to present the VRPTW problem, the problem is defined on a complete directed graph G = (V, A), a set of customers and depots is created where V = {v0, v1, v2, v3, v4 , v5} is the set of nodes and A is the set of arcs. 
- Vertex v0 and v5 are special nodes called origin and destination depots, vertices v1 to v4 represent customers
- A cost c(i,j) and a travel time t(i,j) are defined for every arc (vi, vj ) ∈ A 
- Every customer vi ∈ V\{v0, v5} has a positive demand di , a time window [ai , bi ] and a positive service time servi 
- A fleet of 2 vehicles of capacity 100 is available for serving the customers 
- Vehicles must begin and end their routes at the depot within a time horizon [a0, b0] 
- The cumulative demand of the customers visited by a route is limited by 100
- The service of a customer has to start within its time window, but a vehicle is allowed to arrive earlier and to wait. 

## Video Tutorials
You can find a complete playlist with the tutorials and the walkthrough of the VRPTW by clicking [here](https://www.youtube.com/watch?v=gNeTPxgZ5RE&list=PL_xEQLGJPHhL_Pi7bchXaXI5YBJhhGp17).
## Get your IBM® ILOG CPLEX Optimization Studio edition

- You can get a free [Community Edition](http://www-01.ibm.com/software/websphere/products/optimization/cplex-studio-community-edition)
 of CPLEX Optimization Studio, with limited solving capabilities in term of problem size.

- Faculty members, research professionals at accredited institutions can get access to an unlimited version of CPLEX through the
 [IBM® Academic Initiative](https://www.ibm.com/academic/technology/data-science).

#### For more information about SmartBP
- [Website](http://www.smart-bp.com)
- [Like Us](https://www.facebook.com/Smartbp-122794631689852/?ref=bookmarks)
- [Follow Us](https://twitter.com/Smart_BP) 
- [Connect with Us](https://www.linkedin.com/company/smartbp/?viewAsMember=true)
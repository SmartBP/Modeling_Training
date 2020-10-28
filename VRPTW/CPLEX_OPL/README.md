# Vehicle Routing Problem with Time Windows


## Problem Description 
The VRPTW can be described as follows. Given a set of customers, a set of vehicles, and a depot, the VRPTW is to find a set of routes of minimal total length, starting and ending at the depot, such that each customer is visited by exactly one vehicle to satisfy a specific demand. Customer visit has to respect a requested time window. A vehicle can wait in case of early arrival, but late arrival is not allowed. In connection with customer demands, a capacity constraint restricts the load that can be carried by a vehicle.

### CPLEX license

In order to run this `.mod` properly, you must have a IBM® ILOG CPLEX license.

- You can get a free [Community Edition](http://www-01.ibm.com/software/websphere/products/optimization/cplex-studio-community-edition)
 of CPLEX Optimization Studio, with limited solving capabilities in term of problem size.

- Faculty members, research professionals at accredited institutions can get access to an unlimited version of CPLEX through the
 [IBM® Academic Initiative](https://www.ibm.com/academic/technology/data-science).
 

## VRPTW Model Formulation
### Sets and Indices
<!-- $\text{Vertex}= {(v_{0},...,v_{n})}$ --> <img src="https://render.githubusercontent.com/render/math?math=%5Ctext%7BVertex%7D%3D%20%7B(v_%7B0%7D%2C...%2Cv_%7Bn%7D)%7D">: is the set of nodes with a special node <!-- $v_{0}$ --> <img src="https://render.githubusercontent.com/render/math?math=v_%7B0%7D"> called the depot
 
<!-- $\text{Arcs}= \{(v_{i},v_{j}) \in Vertex \times Vertex \}$ --> <img src="https://render.githubusercontent.com/render/math?math=%5Ctext%7BArcs%7D%3D%20%5C%7B(v_%7Bi%7D%2Cv_%7Bj%7D)%20%5Cin%20Vertex%20%5Ctimes%20Vertex%20%5C%7D">: Set of arcs between nodes.

<!-- $G = (V, A)$ --> <img src="https://render.githubusercontent.com/render/math?math=G%20%3D%20(V%2C%20A)">: A complete directed graph.

### Parameters 

<!-- $c_{i,j}$ --> <img src="https://render.githubusercontent.com/render/math?math=c_%7Bi%2Cj%7D">: Cost of going from vertex <!-- $i$ --> <img src="https://render.githubusercontent.com/render/math?math=i"> to vertex <!-- $j$ --> <img src="https://render.githubusercontent.com/render/math?math=j">, for all <!-- $(v_{i},v_{j}) \in A$ --> <img src="https://render.githubusercontent.com/render/math?math=(v_%7Bi%7D%2Cv_%7Bj%7D)%20%5Cin%20A">.

<!-- $t_{i,j}$ --> <img src="https://render.githubusercontent.com/render/math?math=t_%7Bi%2Cj%7D">: Travel time going from vertex <!-- $i$ --> <img src="https://render.githubusercontent.com/render/math?math=i"> to vertex <!-- $j$ --> <img src="https://render.githubusercontent.com/render/math?math=j">, for all <!-- $(v_{i},v_{j}) \in A$ --> <img src="https://render.githubusercontent.com/render/math?math=(v_%7Bi%7D%2Cv_%7Bj%7D)%20%5Cin%20A">.

<!-- $d_{i} \in \mathbb{R}^+$ --> <img src="https://render.githubusercontent.com/render/math?math=d_%7Bi%7D%20%5Cin%20%5Cmathbb%7BR%7D%5E%2B">: Demand of the customer <!-- $v_{i} \in \text{V}-v_{0}$ --> <img src="https://render.githubusercontent.com/render/math?math=v_%7Bi%7D%20%5Cin%20%5Ctext%7BV%7D-v_%7B0%7D">. 

<!-- $serv_{i} \in \mathbb{R}^+$ --> <img src="https://render.githubusercontent.com/render/math?math=serv_%7Bi%7D%20%5Cin%20%5Cmathbb%7BR%7D%5E%2B">: Service time for the customer <!-- $v_{i} \in \text{V}-v_{0}$ --> <img src="https://render.githubusercontent.com/render/math?math=v_%7Bi%7D%20%5Cin%20%5Ctext%7BV%7D-v_%7B0%7D">. 

<!-- $[a_{i},b_{i}]$ --> <img src="https://render.githubusercontent.com/render/math?math=%5Ba_%7Bi%7D%2Cb_%7Bi%7D%5D">: Time window for the vertex <!-- $v_{i} \in \text{V}$ --> <img src="https://render.githubusercontent.com/render/math?math=v_%7Bi%7D%20%5Cin%20%5Ctext%7BV%7D">.

<!-- $U$ --> <img src="https://render.githubusercontent.com/render/math?math=U">: Size of the fleet of vehicles.

<!-- $Q$ --> <img src="https://render.githubusercontent.com/render/math?math=Q">: Capacity for a vehicle.

#### Assumptions
In the following, we make these additional common assumptions: the cost and the travel time matrices are supposed to be equal, nonnegative and to satisfy the triangle inequality. For the sake of simplicity, we also define <!-- $d_{0}=0$ --> <img src="https://render.githubusercontent.com/render/math?math=d_%7B0%7D%3D0"> and <!-- $serv_{0}=0$ --> <img src="https://render.githubusercontent.com/render/math?math=serv_%7B0%7D%3D0">.

### Decision Variables
<!-- $x_{i, j}^u \in \{0, 1\}$ --> <img src="https://render.githubusercontent.com/render/math?math=x_%7Bi%2C%20j%7D%5Eu%20%5Cin%20%5C%7B0%2C%201%5C%7D">: This variable is equal to 1, if the arc <!-- $(v_{i},v_{j}) \in A$ --> <img src="https://render.githubusercontent.com/render/math?math=(v_%7Bi%7D%2Cv_%7Bj%7D)%20%5Cin%20A"> is used by vehicle <!-- $u$ --> <img src="https://render.githubusercontent.com/render/math?math=u">. Otherwise, the decision variable is equal to zero.

<!-- $s_{i}^u \in \mathbb{R}^+$ --> <img src="https://render.githubusercontent.com/render/math?math=s_%7Bi%7D%5Eu%20%5Cin%20%5Cmathbb%7BR%7D%5E%2B">: The time when the vehicle <!-- $u$ --> <img src="https://render.githubusercontent.com/render/math?math=u"> starts serving vertex <!-- $v_{i} \in V$ --> <img src="https://render.githubusercontent.com/render/math?math=v_%7Bi%7D%20%5Cin%20V">. For the depot, <!-- $s_{0}^u$ --> <img src="https://render.githubusercontent.com/render/math?math=s_%7B0%7D%5Eu"> is the departure time of vehicle <!-- $u$ --> <img src="https://render.githubusercontent.com/render/math?math=u">.  

### Objective Function
- **Minimum cost routes**. Minimize the total cost of the routes. 

    <img src=
    "https://render.githubusercontent.com/render/math?math=%5Cdisplaystyle+%5Cbegin%7Bequation%7D%0A%5Ctext%7BMin%7D+%5Cquad+Z+%3D+%5Csum_%7B1+%5Cleq+u+%5Cleq+U%7D%5Csum_%7B%28v_%7Bi%7D%2Cv_%7Bj%7D%29+%5Cin+%5Ctext%7BA%7D%7Dc_%7Bi%2Cj%7D+%5Ccdot+x_%7Bi%2Cj%7D%5Eu%0A%5Cend%7Bequation%7D%0A" 
    alt="\begin{equation}
    \text{Min} \quad Z = \sum_{1 \leq u \leq U}\sum_{(v_{i},v_{j}) \in \text{A}}c_{i,j} \cdot x_{i,j}^u
    \end{equation}
    ">

### Constraints 
- **Customer satisfaction**. Enforces the visit of every customer. Notice that is is allowed to visit a customer more than once, this relaxation is valid since is not optimal to visit a customer more than once. 

    <img src=
    "https://render.githubusercontent.com/render/math?math=%5Cdisplaystyle+%5Cbegin%7Bequation%7D%0A%5Csum_%7B1+%5Cleq+u+%5Cleq+U%7D+%5Csum_%7Bv_%7Bj%7D+%5Cin+V+%7C%28v_%7Bi%7D%2Cv_%7Bj%7D%29+%5Cin+%5Ctext%7BA%7D%7D+x_%7Bi%2C+j%7D%5Eu+%5Cgeq+1+%5Cquad+%5Cforall+%5Cquad+v_%7Bi%7D+%5Cin+%5Ctext%7BV%7D-v_%7B0%7D%0A%5Cend%7Bequation%7D" 
    alt="\begin{equation}
    \sum_{1 \leq u \leq U} \sum_{v_{j} \in V |(v_{i},v_{j}) \in \text{A}} x_{i, j}^u \geq 1 \quad \forall \quad v_{i} \in \text{V}-v_{0}
    \end{equation}">

- **Route structure**. The following constraints define the route structure for the vehicles.

    <img src=
    "https://render.githubusercontent.com/render/math?math=%5Cdisplaystyle+%5Cbegin%7Bequation%7D%0A%5Csum_%7Bv_%7Bj%7D+%5Cin+V+%7C%28v_%7Bi%7D%2Cv_%7Bj%7D%29+%5Cin+%5Ctext%7BA%7D%7D+x_%7Bi%2Cj%7D%5Eu+-+%5Csum_%7Bv_%7Bj%7D+%5Cin+V+%7C%28v_%7Bi%7D%2Cv_%7Bj%7D%29+%5Cin+%5Ctext%7BA%7D%7D+x_%7Bj%2Ci%7D%5Eu++%3D+0+%5Cquad+%5Cforall+%5Cquad++v_%7Bi%7D+%5Cin+V%2C+1+%5Cleq+u+%5Cleq+U%0A%5Cend%7Bequation%7D" 
    alt="\begin{equation}
    \sum_{v_{j} \in V |(v_{i},v_{j}) \in \text{A}} x_{i,j}^u - \sum_{v_{j} \in V |(v_{i},v_{j}) \in \text{A}} x_{j,i}^u  = 0 \quad \forall \quad  v_{i} \in V, 1 \leq u \leq U
    \end{equation}">
    
    <img src=
    "https://render.githubusercontent.com/render/math?math=%5Cdisplaystyle+%5Cbegin%7Bequation%7D%0A%5Csum_%7Bv_%7Bj%7D+%5Cin+V+%7C%28v_%7Bi%7D%2Cv_%7Bj%7D%29+%5Cin+%5Ctext%7BA%7D%7D+x_%7B0%2Ci%7D%5Eu+%5Cleq+1+%5Cquad+%5Cforall+%5Cquad+1+%5Cleq+u+%5Cleq+U%0A%5Cend%7Bequation%7D" 
    alt="\begin{equation}
    \sum_{v_{j} \in V |(v_{i},v_{j}) \in \text{A}} x_{0,i}^u \leq 1 \quad \forall \quad 1 \leq u \leq U
    \end{equation}">

- **Capacity**. The total demand satisfied by a vehicle with a route cant be greater than teh vehicle capacity.

    <img src=
    "https://render.githubusercontent.com/render/math?math=%5Cdisplaystyle+%5Cbegin%7Bequation%7D%0A%5Csum_%7B%28v_%7Bi%7D%2Cv_%7Bj%7D%29+%5Cin+%5Ctext%7BA%7D%7D+d_%7Bi%7D+%5Ccdot+x_%7Bi%2Cj%7D%5Eu+%5Cleq+Q+%5Cquad+%5Cforall+%5Cquad+1+%5Cleq+u+%5Cleq+U%0A%5Cend%7Bequation%7D" 
    alt="\begin{equation}
    \sum_{(v_{i},v_{j}) \in \text{A}} d_{i} \cdot x_{i,j}^u \leq Q \quad \forall \quad 1 \leq u \leq U
    \end{equation}">

- **Time windows**. The following constraints concern time windows satisfaction.

    <img src=
    "https://render.githubusercontent.com/render/math?math=%5Cdisplaystyle+%5Cbegin%7Bequation%7D%0As_%7Bi%7D%5Eu+%2B+serv_%7Bi%7D+%2B+t_%7Bi%2Cj%7D+-+s_%7Bj%7D%5Eu+%2B+M+%5Ccdot+x_%7Bi%2Cj%7D%5Eu+%5Cleq+M+%5Cquad+%5Cforall+%5Cquad+%28v_%7Bi%7D%2Cv_%7Bj%7D%29%5Cin+A%2C+v_%7Bi%7D%5Cneq+v_%7B0%7D%2C1+%5Cleq+u+%5Cleq+U%0A%5Cend%7Bequation%7D" 
    alt="\begin{equation}
    s_{i}^u + serv_{i} + t_{i,j} - s_{j}^u + M \cdot x_{i,j}^u \leq M \quad \forall \quad (v_{i},v_{j})\in A, v_{i}\neq v_{0},1 \leq u \leq U
    \end{equation}">

    <img src=
    "https://render.githubusercontent.com/render/math?math=%5Cdisplaystyle+%5Cbegin%7Bequation%7D%0As_%7Bi%7D%5Eu+%2B+serv_%7Bi%7D+%2B+t_%7Bi%2C0%7D+-+b_%7B0%7D+%2B+M+%5Ccdot+x_%7Bi%2C0%7D%5Eu+%5Cleq+M+%5Cquad+%5Cforall+%5Cquad+%28v_%7Bi%7D%2Cv_%7Bj%7D%29%5Cin+A%2C1+%5Cleq+u+%5Cleq+U%0A%5Cend%7Bequation%7D" 
    alt="\begin{equation}
    s_{i}^u + serv_{i} + t_{i,0} - b_{0} + M \cdot x_{i,0}^u \leq M \quad \forall \quad (v_{i},v_{j})\in A,1 \leq u \leq U
    \end{equation}">

    <img src=
    "https://render.githubusercontent.com/render/math?math=%5Cdisplaystyle+%5Cbegin%7Bequation%7D%0Aa_%7Bi%7D+%5Cleq+s_%7Bi%7D%5Eu+%5Cleq+b_%7Bi%7D+%5Cquad+%5Cforall+%5Cquad+v_%7Bi%7D+%5Cin+V%2C1+%5Cleq+u+%5Cleq+U%0A%5Cend%7Bequation%7D" 
    alt="\begin{equation}
    a_{i} \leq s_{i}^u \leq b_{i} \quad \forall \quad v_{i} \in V,1 \leq u \leq U
    \end{equation}">

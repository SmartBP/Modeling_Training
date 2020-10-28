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
<img src=
"https://render.githubusercontent.com/render/math?math=%5Cdisplaystyle+%5Cbegin%7Balign%2A%7D%0A%5Ctext%7BVertex%7D%3D+%7B%28v_%7B0%7D%2C...%2Cv_%7Bn%7D%29%7D+%5Ctext%7B%3A+is+the+set+of+nodes+with+a+special+node%7D+v_%7B0%7D+%5Ctext%7Bcalled+the+depot%7D%0A%5Cend%7Balign%2A%7D" 
alt="\begin{align*}
\text{Vertex}= {(v_{0},...,v_{n})} \text{: is the set of nodes with a special node} v_{0} \text{called the depot}
\end{align*}">
 
<img src=
"https://render.githubusercontent.com/render/math?math=%5Cdisplaystyle+%5Cbegin%7Balign%2A%7D%0A%5Ctext%7BArcs%7D%3D+%5C%7B%28v_%7Bi%7D%2Cv_%7Bj%7D%29+%5Cin+%5Ctext%7BVertex%7D+%5Ctimes+%5Ctext%7BVertex+%5C%7D%3A+Set+of+arcs+between+nodes.%7D%0A%5Cend%7Balign%2A%7D" 
alt="\begin{align*}
\text{Arcs}= \{(v_{i},v_{j}) \in \text{Vertex} \times \text{Vertex \}: Set of arcs between nodes.}
\end{align*}">

<img src=
"https://render.githubusercontent.com/render/math?math=%5Cdisplaystyle+%5Cbegin%7Balign%2A%7D%0AG+%3D+%28V%2C+A%29+%5Ctext%7B%3A+A+complete+directed+graph.%7D%0A%5Cend%7Balign%2A%7D" 
alt="\begin{align*}
G = (V, A) \text{: A complete directed graph.}
\end{align*}">

### Parameters 

<img src=
"https://render.githubusercontent.com/render/math?math=%5Cdisplaystyle+%5Cbegin%7Balign%2A%7D%0Ac_%7Bi%2Cj%7D+%5Ctext%7B%3A+Cost+of+going+from+vertex+%7D+%5C%3A+i+%5C%3A+%5Ctext%7Bto+vertex+%7D+j+%5Ctext%7B%2C+for+all%7D+%28v_%7Bi%7D%2Cv_%7Bj%7D%29+%5Cin+%5Ctext%7BA.%7D%0A%5Cend%7Balign%2A%7D" 
alt="\begin{align*}
c_{i,j} \text{: Cost of going from vertex } \: i \: \text{to vertex } j \text{, for all} (v_{i},v_{j}) \in \text{A.}
\end{align*}">

<img src=
"https://render.githubusercontent.com/render/math?math=%5Cdisplaystyle+%5Cbegin%7Balign%2A%7D%0At_%7Bi%2Cj%7D+%5Ctext%7B%3A+Travel+time+going+from+vertex+%7D+%5C%3A+i+%5C%3A+%5Ctext%7Bto+vertex%7D++%5C%3A+j+%5C%3A+%5Ctext%7B%2C+for+all+%7D%28v_%7Bi%7D%2Cv_%7Bj%7D%29+%5Cin+%5Ctext%7BA.%7D%0A%5Cend%7Balign%2A%7D" 
alt="\begin{align*}
t_{i,j} \text{: Travel time going from vertex } \: i \: \text{to vertex}  \: j \: \text{, for all }(v_{i},v_{j}) \in \text{A.}
\end{align*}">

<img src=
"https://render.githubusercontent.com/render/math?math=%5Cdisplaystyle+%5Cbegin%7Balign%2A%7D%0Ad_%7Bi%7D+%5Cin+%5Cmathbb%7BR%7D%5E%2B+%5Ctext%7B%3A+Demand+of+the+customer+%7Dv_%7Bi%7D+%5Cin+%5Ctext%7BV%7D-v_%7B0%7D+%5Ctext%7B.%7D+%0A%5Cend%7Balign%2A%7D" 
alt="\begin{align*}
d_{i} \in \mathbb{R}^+ \text{: Demand of the customer }v_{i} \in \text{V}-v_{0} \text{.} 
\end{align*}">

<img src=
"https://render.githubusercontent.com/render/math?math=%5Cdisplaystyle+%5Cbegin%7Balign%2A%7D%0Aserv_%7Bi%7D+%5Cin+%5Cmathbb%7BR%7D%5E%2B+%5Ctext%7B%3A+Service+time+for+the+customer%7D+v_%7Bi%7D+%5Cin+%5Ctext%7BV%7D-v_%7B0%7D+%5Ctext%7B.%7D++%0A%5Cend%7Balign%2A%7D" 
alt="\begin{align*}
serv_{i} \in \mathbb{R}^+ \text{: Service time for the customer} v_{i} \in \text{V}-v_{0} \text{.}  
\end{align*}">

<img src=
"https://render.githubusercontent.com/render/math?math=%5Cdisplaystyle+%5Cbegin%7Balign%2A%7D%0A%5Ba_%7Bi%7D%2Cb_%7Bi%7D%5D+%5Ctext%7B%3A+Time+window+for+the+vertex%7D+v_%7Bi%7D+%5Cin+%5Ctext%7BV.%7D+%0A%5Cend%7Balign%2A%7D" 
alt="\begin{align*}
[a_{i},b_{i}] \text{: Time window for the vertex} v_{i} \in \text{V.} 
\end{align*}">

<img src=
"https://render.githubusercontent.com/render/math?math=%5Cdisplaystyle+%5Cbegin%7Balign%2A%7D%0AU+%5Ctext%7B%3A+Size+of+the+fleet+of+vehicles+%7D%0A%5Cend%7Balign%2A%7D" 
alt="\begin{align*}
U \text{: Size of the fleet of vehicles }
\end{align*}">

<img src=
"https://render.githubusercontent.com/render/math?math=%5Cdisplaystyle+%5Cbegin%7Balign%2A%7D%0AQ+%5Ctext%7B%3A+Capacity+for+a+vehicle%7D%0A%5Cend%7Balign%2A%7D" 
alt="\begin{align*}
Q \text{: Capacity for a vehicle}
\end{align*}">

#### Assumptions
In the following, we make these additional common assumptions: the cost and the travel time matrices are supposed to be equal, nonnegative and to satisfy the triangle inequality. For the sake of simplicity, we also define <!-- $d_{0}=0$ --> <img src="https://render.githubusercontent.com/render/math?math=d_%7B0%7D%3D0"> and <!-- $serv_{0}=0$ --> <img src="https://render.githubusercontent.com/render/math?math=serv_%7B0%7D%3D0">.

### Decision Variables
<img src=
"https://render.githubusercontent.com/render/math?math=%5Cdisplaystyle+%5Cbegin%7Balign%2A%7D%0Ax_%7Bi%2C+j%7D%5Eu+%5Cin+%5C%7B0%2C+1%5C+%5Ctext%7B%3A+This+variable+is+equal+to+1%2C+if+the+arc%7D+%28v_%7Bi%7D%2Cv_%7Bj%7D%29+%5Cin+A+%5Ctext%7Bis+used+by+vehicle%7D+%5C%3A+u+%5C%3A+%5Ctext%7B.+Otherwise%2C+the+decision+variable+is+equal+to+zero.%7D%0A%5Cend%7Balign%2A%7D" 
alt="\begin{align*}
x_{i, j}^u \in \{0, 1\ \text{: This variable is equal to 1, if the arc} (v_{i},v_{j}) \in A \text{is used by vehicle} \: u \: \text{. Otherwise, the decision variable is equal to zero.}
\end{align*}">

<img src=
"https://render.githubusercontent.com/render/math?math=%5Cdisplaystyle+%5Cbegin%7Balign%2A%7D%0As_%7Bi%7D%5Eu+%5Cin+%5Cmathbb%7BR%7D%5E%2B+%5Ctext%7B%3A+The+time+when+the+vehicle%7D+%5C%3A+u+%5C%3A+%5Ctext%7Bstarts+serving+vertex+%7Dv_%7Bi%7D+%5Cin+V%5Ctext%7B+.+For+the+depot%2C+%7D+%5C%3A+s_%7B0%7D%5Eu++%5C%3A+%5Ctext%7Bis+the+departure+time+of+vehicle%7D+%5C%3A+u+%5Ctext%7B.%7D++%0A%5Cend%7Balign%2A%7D" 
alt="\begin{align*}
s_{i}^u \in \mathbb{R}^+ \text{: The time when the vehicle} \: u \: \text{starts serving vertex }v_{i} \in V\text{ . For the depot, } \: s_{0}^u  \: \text{is the departure time of vehicle} \: u \text{.}  
\end{align*}">

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

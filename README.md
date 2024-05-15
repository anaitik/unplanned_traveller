Unplanned_traveller is currently work in progress

visiting different cities without any plans , i faced a common problem of not able to navigate through the routes, unable to find trains,planes or any mode of transportation on those routes,find different cities to explore in between the start and end destination.

tha project basically aiming to solve the issue
it uses djistra to find shortest distance to find the routes
 -user can select intermediate cities in which he want to explore and add it to his destinations list and the travel will be planned including those cities.
 -user can include the duration he want to spend in each city.
 In turn user will get alternate paths to travel and train destination, ship and airplane reservation on those particular windows , in order to explore fast and waste smallest time possible on 
 travelling during your journey.

what has been implemented:
route path between cities with intermediate destinations added with time estimations and how much time u want to spend at each desination
the route  path finds has been made for land based and sea based mode of transportation 

Example

suppose , ram wants to travel to trivandrum from bhopal
hence he books tickets and then decides he will explore on his own
since the distance between trivandrum and bhopal is 2650 km , its hard to find direct routes and travel at given points 
like ram want to leave trivandrum to bhopal but cant find a train , but finds a alternate route with coneecting trains 

So what if Ram can got from trivandrum to bhopal, instead of direct 
he can add preference cities he want to visit and the time he want to spend in each 

so the algorithm will show him timely bookings for each city in either one go or he can keep optimizing his path

so now ram has a preference to visit munnar and wayanad for 2 days each 

so the route will go

trivandrum  - kochi (train route) - munnar(bus route) - yanoor -wayanad(bus route) - mangluru - mumbai (train route) - bhopal (train route)

now here we see certain cities added to the mix , because that is the shorted distance available at that point of time when ram wants to stay 2 days in each at munnar and wayanad

as there was no direct route at that given day and time

so this is the logic behind the project

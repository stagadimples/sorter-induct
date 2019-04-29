**Project Description**

This project is aimed at addressing 2 main requirements:
* preparing a form that maps out the layout of how parcels flow from the various packing areas to the sorter inducts.
* setting up a model for computing the theoretical number of parcels that can be inducted to all the sorters in an hour.

**Model Design and Considerations**

The primary objective of the model is to calculate a theoretical maximum number of parcels that can be inducted onto all six sorter inducts in an hour.
Additionally, an estimate of actual usage must be made. This must focus on usage during our peak period.

**Planned Approach**

Use linear programming to estimate the maximum number of parcels that can be inducted per hour, given capacity and other constraints to be defined.

**Optimisation Problem**

*Objective Function*: Maximise number of parcels packed in 1 hour

*Constraints*: 
* 6 Available inducts, each with maximum capacity of 1700 parcels/hr
* 
* Cartons from Ipack Machines => Induct 2

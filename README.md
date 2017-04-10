# Track Driving Simulator in MATLAB
 * This simulator is intended for developing algorithms for autonomous cars. 
 * Can be easily tuned to implement reinforcement learning or inverse reinforcement learning algorithms. 

#### Collecting Demonstrations (Run 'run_track01_manualcollect')
![collect](http://i.makeagif.com/media/4-10-2017/UzEzi3.gif)
#### Check Collected Demonstrations (Run 'run_track02_checkcollected')
![check](http://i.makeagif.com/media/4-10-2017/t2CBSf.gif)
#### Train Controller with DMRL (Run 'run_track03_trainDMRL')
![train](http://i.makeagif.com/media/4-10-2017/4z14t8.gif)
#### Test on More Complex Tracks (Run 'run_track04_testDMRL')
![test](http://i.makeagif.com/media/4-10-2017/plC0E9.gif)

* For example, it was used for implementing an imitation learning algorithm named [density matching reward learning](http://arxiv.org/abs/1608.03694). 
![](http://i.giphy.com/o3QLfGAQNU9Bm.gif)
 * [YouTube Link](https://www.youtube.com/watch?v=7_buzNvUfmA&feature=youtu.be)

## Track Driving Simulation
 * The blue car is controlled by the keyboard and the red cars autonomously maintain each lanes. 
![Track driving simulator (updated)](http://i.makeagif.com/media/4-10-2017/TtNcQv.gif)
 * [YouTube Link](https://www.youtube.com/watch?v=RaQ_e6G_LGM)

## Main Features
1. Control the car with keyboard inputs. 
2. Compose tracks with a block-building like manner. 
3. Lane width, length, number of lane, and the number of segments can also be modified. 
4. Obtainable features are
  * Lane deviate distance / degree
  * Distances from the closest right, center, and left cars
  * Geodesic distance from the start lane
  * Which lane and segment the current car is located at. 
 5. Traffic Lights are added. 
 6. Range finder sensors are added. 

## Contact
sungjoon.choi@cpslab.snu.ac.kr

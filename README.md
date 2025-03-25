# Question 1 Submission

## Project Structure  
- *src Folder*: Contains all Verilog source files used to design the system, along with a .vcd file that captures the simulation results.  
- *Results Folder*: Includes screenshots of different signal values at various clock cycles. It also contains register and memory data values that were stored or loaded during instruction execution.  

## Viewing the Simulation  
To analyze the simulation results, open the .vcd file using *GTKWave*. This will allow you to observe signal transitions and debug execution behavior effectively.  

---

## Simulation Results  

### *1. Memory Operations*  
The following screenshots illustrate the loading and storing of the value *163* in stack memory:  

#### *Data Memory Signals*  
![Memory Signals](Results/DataMem_signals/image.png)  

![Memory Signals (Copy)](Results/DataMem_signals/image%20copy%202.png)  

---

### *2. Register Values After Execution*  
The screenshot below shows the final values stored in registers upon completion of instruction execution:  

#### *Register Values*  
![Register Signals](Results/Register_signals/image%20copy%205.png)

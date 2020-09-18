#include "../../includes/am_types.h"

generic configuration FloodingC(int channel){
    provides interface Flooding;
    uses interface List<pack> as neighborListC;
}

implementation{
    components new FloodingP();
    Flooding = FloodingP.Flooding;

    components new SimpleSendC(AM_NEIGHBOR);
    components new AMReceiverC(AM_NEIGHBOR);


    components new TimerMilliC() as sendTimer;
    FloodingP.sendTimer -> neigborDiscoveryTimer;
    
    components RandomC as Random;
    FloodingP.Random -> Random;

    FloodingP.neighborList = neighborListC;
}

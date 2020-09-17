#include "../../includes/am_types.h"

generic configuration NeighborDiscoveryC(int channel){
    provides interface NeighborDiscovery;
    uses interface List<pack> as neighborListC;
}

implementation{
    components new NeighborDiscoveryP();
    NeighborDiscovery = NeighborDiscoveryP.NeighborDiscovery;

    components new SimpleSendC(AM_NEIGHBOR);
    components new AMReceiverC(AM_NEIGHBOR);


    components new TimerMilliC() as sendTimer;
    NeighborDiscoveryP.sendTimer -> neigborDiscoveryTimer;
    
    components RandomC as Random;
    NeighborDiscoveryP.Random -> Random;

    NeighborDiscoveryP.neighborList = neighborListC;
}

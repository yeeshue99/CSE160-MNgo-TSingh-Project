#include "../../includes/am_types.h"

generic configuration NeighborDiscoveryC(int channel){
   provides interface NeighborDiscovery;
}

implementation{
   components new NeighborDiscoveryP();
   NeighborDiscovery = NeighborDiscoveryP.NeighborDiscovery;

   components new TimerMilliC() as sendTimer;
   components RandomC as Random;
   components new AMSenderC(channel);

   //Timers
   NeighborDiscoveryP.sendTimer -> sendTimer;
   NeighborDiscoveryP.Random -> Random;

   NeighborDiscoveryP.Packet -> AMSenderC;
   NeighborDiscoveryP.AMPacket -> AMSenderC;
   NeighborDiscoveryP.AMSend -> AMSenderC;

   //Lists
   components new PoolC(sendInfo, 20);
   components new QueueC(sendInfo*, 20);

   NeighborDiscoveryP.Pool -> PoolC;
   NeighborDiscoveryP.Queue -> QueueC;
}

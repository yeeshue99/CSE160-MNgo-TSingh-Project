/**
 * @author UCM ANDES Lab
 * $Author: abeltran2 $
 * $LastChangedDate: 2014-08-31 16:06:26 -0700 (Sun, 31 Aug 2014) $
 *
 */


#include "../../includes/CommandMsg.h"
#include "../../includes/command.h"
#include "../../includes/channels.h"

configuration FloodingC{
   provides interface Flooding;
}

implementation{
    components FloodingP;
    Flooding = FloodingP;
    components new AMReceiverC(AM_COMMANDMSG) as CommandReceive;
    FloodingP.Receive -> CommandReceive;

   //Lists
   components new PoolC(message_t, 20);
   components new QueueC(message_t*, 20);

   FloodingP.Pool -> PoolC;
   FloodingP.Queue -> QueueC;

   components ActiveMessageC;
   FloodingP.Packet -> ActiveMessageC;
}

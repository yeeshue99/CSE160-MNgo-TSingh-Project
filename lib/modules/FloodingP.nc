/**
 * ANDES Lab - University of California, Merced
 *
 * @author UCM ANDES Lab
 * @date   2013/09/03
 *
 */
#include "../../includes/packet.h"
#include "../../includes/sendInfo.h"
#include "../../includes/channels.h"

/*  Neighbor entry
 *      Neighbor reference(Unknown. Packet?)
 *      Quality of link(float?)
 *      Active(bool)
 */



generic module FloodingP(){
    // provides shows the interface we are implementing. See lib/interface/Flooding.nc
    // to see what funcitons we need to implement.
    provides interface Flooding;

    uses interface Timer<TMilli> as neigborDiscoveryTimer;
    uses interface SimpleSend as sender;
    uses interface List<pack> as neighborList;
    uses interface Random as Random;

}

implementation{
    uint16_t sequenceNum = 0;
    bool busy = FALSE;
    pack pkt;

    command void Flooding.start(){
        // one shot timer and include random element to it.
        uint32_t startTimer;
        dbg(GENERAL_CHANNEL, "Booted\n");
        startTimer = (20000 + (uint16_t) ((call Random.rand16())%5000));;
        //call neigbordiscoveryTimer.startPeriodic(startTimer);
        call neigbordiscoveryTimer.startOneShot(10000);
    }

    command void Flooding.neighborReceived(pack *myMsg){
        if(!findMyNeighbor(myMsg)){
            call neighborList.pushback(*myMsg);
        }

    }

    event void neigbordiscoveryTimer.fired(){
        char* neighborPayload = "Neighbor Discovery";
        uint16_t size = call neighborList.size();
        uint16_t i = 0;
        if(neighborAge==MAX_NEIGHBOR_AGE){
            //dbg(NEIGHBOR_CHANNEL,"removing neighbor of %d with Age %d \n",TOS_NODE_ID,neighborAge);
            neighborAge = 0;
            for(i = 0; i < size; i++){
                call neighborList.popfront();
            }
        }
        makePack(&pkt, TOS_NODE_ID, AM_BROADCAST_ADDR, 2, PROTOCOL_PING, seqNumber,  (uint8_t*) neighborPayload, PACKET_MAX_PAYLOAD_SIZE);
        neighborAge++;
        //Check TOS_NODE_ID and destination
        call FloodSender.send(sendPackage, AM_BROADCAST_ADDR);
    }

    void makePack(pack *Package, uint16_t src, uint16_t dest, uint16_t TTL, uint16_t protocol, uint16_t seq, uint8_t* payload, uint8_t length){
        Package->src = src;
        Package->dest = dest;
        Package->TTL = TTL;
        Package->seq = seq;
        Package->protocol = protocol;
        memcpy(Package->payload, payload, length);
    }

    //event void AMReceiver.

    event void AMSend.sendDone(message_t* msg, error_t error){
      //Clear Flag, we can send again.
      if(&pkt == msg){
         busy = FALSE;
         postSendTask();
      }
   }
}

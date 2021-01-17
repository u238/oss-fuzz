#include "ntop_includes.h"

AfterShutdownAction afterShutdownAction = after_shutdown_nop;

extern "C" int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size)
{

    Prefs *prefs = NULL;
    if((ntop = new(std::nothrow)  Ntop("argv[0]")) == NULL) _exit(0);
    ntop->getTrace()->set_trace_level(TRACE_LEVEL_ERROR);
    if((prefs = new(std::nothrow) Prefs(ntop)) == NULL)   _exit(0);
//
//    Flow *flow = NULL;
//    system_interface = new (std::nothrow) NetworkInterface(SYSTEM_INTERFACE_NAME, SYSTEM_INTERFACE_NAME);
//    u_int8_t _mac[6];
//    cli_mac = new (std::nothrow) Mac(system_interface, _mac);
//    srv_mac = new (std::nothrow) Mac(system_interface, _mac);
//    const IpAddress *cli_ip = get_cli_ip_addr(), *srv_ip = get_srv_ip_addr();
//    time_t first_seen, last_seen;
//    if((flow = new(std::nothrow) Flow(
//            system_interface, // NetworkInterface *_iface,
//            0, // u_int16_t _vlanId,
//            0, // u_int8_t _protocol,
//            cli_mac, // Mac *_cli_mac,
//            cli_ip, // IpAddress *_cli_ip,
//            1, // u_int16_t _cli_port,
//            srv_mac, // Mac *_srv_mac,
//            srv_ip, // IpAddress *_srv_ip,
//            1, // u_int16_t _srv_port,
//            // const ICMPinfo * const _icmp_info,
//            first_seen, // time_t _first_seen,
//            last_seen, // time_t _last_seen
//            )) == NULL)   _exit(0);

    prefs->loadInstanceNameDefaults();

//    ntop->registerPrefs(prefs, false);

    int len = Size;
    const u_char * packet = Data;

    u_int16_t c;
    struct pcap_pkthdr h;
    Host *srcHost = NULL, *dstHost = NULL;
    Flow *flow = NULL;

    h.len = h.caplen = len, gettimeofday(&h.ts, NULL);

    ZMQParserInterface * sub_iface = new (std::nothrow) ZMQParserInterface("dummy", CONST_INTERFACE_TYPE_FLOW);
//    sub_iface->getAlertsManager();
    ntop->resetNetworkInterfaces();
    sub_iface->allocateStructures();
    sub_iface->dissectPacket(DUMMY_BRIDGE_INTERFACE_ID,
                         true /* ingress packet */,
                         NULL, &h, packet, &c, &srcHost, &dstHost, &flow);


//    delete(flow);
    delete(ntop);
    delete(prefs);
    return(0);
}

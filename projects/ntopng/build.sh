#!/bin/bash

# apply patches
patch -p0 < Makefile.in.patch

# build nDPI project
cd nDPI
sh autogen.sh
./configure
make -j$(nproc)
cd ..

# build ntopng project
cd ntopng
sh autogen.sh
./configure
make -j$(nproc)
#cd ..

# debug info
find . | grep json_config.h

# build fuzzers
for f in $(find $SRC -name '*_fuzzer.cpp'); do
    b=$(basename -s .cpp $f)
    INCLUDE_DIRS="-I/src/ntopng -I/src/ntopng/include -I/usr/local/include -I/usr/include/hiredis -I/usr/include/hiredis -I/src/ntopng/third-party/mongoose -I/usr/include/json-c   -I../nDPI/src/include -I../nDPI/src/lib/third_party/include -I/src/ntopng/third-party/lua-5.3.5/src   -I/usr/include/mysql  -Wno-address-of-packed-member -Wno-unused-function -I/src/ntopng -I/src/ntopng/include -I/usr/local/include -I/src/ntopng/third-party/http-client-c/src/  -I/usr/include/openssl  -DDATA_DIR='"/usr/local/share"' -I/src/ntopng/third-party/libgeohash -I/src/ntopng/third-party/patricia"
    $CXX $CXXFLAGS -std=c++11 $INCLUDE_DIRS $f -o $OUT/$b $LIB_FUZZING_ENGINE src/RecipientQueues.o  src/ICMPstats.o  src/HostScore.o  src/FrequentStringItems.o  src/SyslogStats.o  src/Logstash.o  src/ZMQCollectorInterface.o  src/VirtualHost.o  src/FlowStats.o  src/DnsStats.o  src/TimeseriesExporter.o  src/Paginator.o  src/GenericHashEntry.o  src/PacketStats.o  src/SyslogCollectorInterface.o  src/AlertsQueue.o  src/ParserInterface.o  src/FlowAlertCheckLuaEngine.o  src/PcapInterface.o  src/Utils.o  src/ElasticSearch.o  src/Host.o  src/ParsedeBPF.o  src/Ping.o  src/Mac.o  src/AutonomousSystemHash.o  src/BroadcastDomains.o  src/Trace.o  src/ContinuousPingStats.o  src/LuaEngineNtop.o  src/ParsedFlowCore.o  src/EthStats.o  src/StoreManager.o  src/AddressResolution.o  src/SyslogLuaEngine.o  src/Country.o  src/ZCCollectorInterface.o  src/Fingerprint.o  src/Vlan.o  src/MacStats.o  src/Flow.o  src/HostPools.o  src/HTTPserver.o  src/InterarrivalStats.o  src/Grouper.o  src/ContainerStats.o  src/AddressTree.o  src/Bitmask.o  src/Recipients.o  src/NetworkDiscovery.o  src/VirtualHostHash.o  src/TimelineExtract.o  src/GenericTrafficElement.o  src/VlanHash.o  src/SerializableElement.o  src/HTTPstats.o  src/ThreadedActivity.o  src/MySQLDB.o  src/AddressList.o  src/AlertCounter.o  src/Condvar.o  src/Ntop.o  src/LocalHostStats.o  src/SNMP.o  src/LuaEngineHost.o  src/LuaEngine.o  src/ContinuousPing.o  src/ViewInterface.o  src/AlertCheckLuaEngine.o  src/HostPoolStats.o  src/DSCPStats.o  src/MDNS.o  src/AlertsManager.o  src/ZMQParserInterface.o  src/MacHash.o  src/InterfaceStatsHash.o  src/ProtoStats.o  src/nDPIStats.o  src/TcpPacketStats.o  src/StatsManager.o  src/InfluxDBTimeseriesExporter.o  src/AlertableEntity.o  src/NtopGlobals.o  src/Geolocation.o  src/L4Stats.o  src/PF_RINGInterface.o  src/ThroughputStats.o  src/PeriodicActivities.o  src/ThreadPool.o  src/CountriesHash.o  src/TrafficStats.o  src/HostHash.o  src/LocalTrafficStats.o  src/PacketDumper.o  src/FlowHash.o  src/LuaEngineNetwork.o  src/ICMPinfo.o  src/GenericHash.o  src/HostStats.o  src/RRDTimeseriesExporter.o  src/FlowTrafficStats.o  src/LuaEngineFlow.o  src/IpAddress.o  src/AutonomousSystem.o  src/FlowGrouper.o  src/TcpFlowStats.o  src/LuaReusableEngine.o  src/NetworkInterface.o  src/Bloom.o  src/SyslogParserInterface.o  src/Redis.o  src/ExportInterface.o  src/Mutex.o  src/MacManufacturers.o  src/DummyInterface.o  src/VlanAddressTree.o  src/LuaEngineInterface.o  src/Prefs.o  src/NetworkStats.o  src/RwLock.o  src/ThreadedActivityStats.o  src/RemoteHost.o  src/PartializableFlowTrafficStats.o  src/LocalHost.o  src/DB.o  src/ParsedFlow.o  src/PacketDumperTuntap.o  -Wall  ../nDPI/src/lib/libndpi.a -lpcap /src/ntopng/third-party/lua-5.3.5/src/liblua.a -lrrd_th -lzmq -ljson-c -lsnmp -lmaxminddb  -lhiredis -lhiredis -lsqlite3 -L/usr/lib/x86_64-linux-gnu -lmysqlclient -lpthread -lz -lm -lrt -lssl -lcrypto -ldl  -lexpat -lssl -lssl -lcrypto   -L/usr/local/lib -lcap -lldap -llber -lrt -lz -ldl -lcurl   -lm -lpthread
done


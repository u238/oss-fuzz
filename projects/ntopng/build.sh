#!/bin/bash

cd ..
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

ldd ntopng

# debug info
find . | grep json_config.h
mkdir -p $OUT/lib
rm -rf $OUT/lib/*

# build fuzzers
for f in $(find $SRC -name '*_fuzzer.cpp'); do
    b=$(basename -s .cpp $f)
    INCLUDE_DIRS="-I/src/ntopng -I/src/ntopng/include -I/usr/local/include -Wall -D_FILE_OFFSET_BITS=64 -I/usr/include/hiredis -I/usr/include/hiredis -I/src/ntopng/third-party/mongoose -I/usr/include/json-c   -I../nDPI/src/include -I../nDPI/src/lib/third_party/include -I/src/ntopng/third-party/lua-5.3.5/src   -I/usr/include/mysql  -Wno-address-of-packed-member -Wno-unused-function -I/src/ntopng -I/src/ntopng/include -I/usr/local/include -I/src/ntopng/third-party/http-client-c/src/  -I/usr/include/openssl  -DDATA_DIR='"/usr/local/share"' -I/src/ntopng/third-party/libgeohash -I/src/ntopng/third-party/patricia"
    O_FILES="src/PacketDumperTuntap.o  src/LuaReusableEngine.o  src/ICMPstats.o  src/HostScore.o  src/FrequentStringItems.o  src/Redis.o  src/ZMQCollectorInterface.o  src/VirtualHost.o  src/DnsStats.o  src/TimeseriesExporter.o  src/Paginator.o  src/GenericHashEntry.o  src/nDPIStats.o  src/PacketStats.o  src/SyslogCollectorInterface.o  src/ParsedeBPF.o  src/ParserInterface.o  src/FlowAlertCheckLuaEngine.o  src/PcapInterface.o  src/Utils.o  src/ElasticSearch.o  src/Host.o  src/AddressTree.o  src/SyslogDump.o  src/Mac.o  src/AutonomousSystemHash.o  src/FlowGrouper.o  src/Trace.o  src/ParsedFlow.o  src/LuaEngineNtop.o  src/ParsedFlowCore.o  src/StoreManager.o  src/HostStats.o  src/SyslogLuaEngine.o  src/BroadcastDomains.o  src/Country.o  src/DummyInterface.o  src/Fingerprint.o  src/Vlan.o  src/MacStats.o  src/Flow.o  src/HostPools.o  src/InterarrivalStats.o  src/TrafficStats.o  src/ContainerStats.o  src/Bloom.o  src/Bitmask.o  src/Recipients.o  src/NetworkDiscovery.o  src/VirtualHostHash.o  src/TimelineExtract.o  src/IEC104Stats.o  src/GenericTrafficElement.o  src/AlertsManager.o  src/SerializableElement.o  src/ViewInterface.o  src/HTTPserver.o  src/ThreadedActivity.o  src/EthStats.o  src/ProtoStats.o  src/Condvar.o  src/Ntop.o  src/LocalHostStats.o  src/SNMP.o  src/Ping.o  src/LuaEngineHost.o  src/LuaEngine.o  src/ContinuousPing.o  src/SyslogStats.o  src/AlertCheckLuaEngine.o  src/HostPoolStats.o  src/DSCPStats.o  src/MDNS.o  src/MySQLDB.o  src/ZMQParserInterface.o  src/MacHash.o  src/InterfaceStatsHash.o  src/AlertsQueue.o  src/TcpPacketStats.o  src/StatsManager.o  src/InfluxDBTimeseriesExporter.o  src/AlertableEntity.o  src/NtopGlobals.o  src/Geolocation.o  src/HTTPstats.o  src/L4Stats.o  src/PF_RINGInterface.o  src/ThroughputStats.o  src/PeriodicActivities.o  src/ThreadPool.o  src/CountriesHash.o  src/RecipientQueues.o  src/HostHash.o  src/LocalTrafficStats.o  src/PacketDumper.o  src/FlowHash.o  src/LuaEngineNetwork.o  src/ICMPinfo.o  src/GenericHash.o  src/DB.o  src/RRDTimeseriesExporter.o  src/FlowTrafficStats.o  src/LuaEngineFlow.o  src/IpAddress.o  src/AutonomousSystem.o src/Grouper.o  src/VlanHash.o  src/TcpFlowStats.o  src/NetworkInterface.o  src/FlowStats.o  src/SyslogParserInterface.o  src/AlertCounter.o  src/ExportInterface.o  src/ZCCollectorInterface.o  src/Mutex.o  src/MacManufacturers.o  src/ContinuousPingStats.o  src/VlanAddressTree.o  src/LuaEngineInterface.o  src/Prefs.o  src/NetworkStats.o  src/RwLock.o  src/ThreadedActivityStats.o  src/RemoteHost.o  src/PartializableFlowTrafficStats.o  src/LocalHost.o  src/AddressResolution.o"
    LIBS="../nDPI/src/lib/libndpi.a -lpcap /src/ntopng/third-party/lua-5.3.5/src/liblua.a -lrrd_th -lzmq -ljson-c -lsnmp -lmaxminddb  -lhiredis -lhiredis -lsqlite3 -L/usr/lib/x86_64-linux-gnu -lmysqlclient -lpthread -lz -lm -lrt -lssl -lcrypto -ldl  -lexpat -lssl -lssl -lcrypto   -latomic -L/usr/local/lib -lcap -lldap -llber -lrt -lz -ldl -lcurl   -lm -lpthread"
    $CXX -std=c++0x -O1 -fno-omit-frame-pointer -gline-tables-only $CXXFLAGS $INCLUDE_DIRS -stdlib=libc++ -c $f -o src/$b.o || true
    $CXX -std=c++0x -O1 -fno-omit-frame-pointer -gline-tables-only $CXXFLAGS $INCLUDE_DIRS $O_FILES src/$b.o -o $OUT/$b $LIB_FUZZING_ENGINE -Wall $LIBS -Wl,-rpath,'$ORIGIN/lib' || true

#    sleep 99999

    # copy libraries
    SO_LIBS=`ldd $OUT/$b | sed -n 's/.* => \(.*\) .*/\1/p'`
    for lib in "$SO_LIBS"; do
        cp -f $lib $OUT/lib/ || true
    done
done

#sleep 99999

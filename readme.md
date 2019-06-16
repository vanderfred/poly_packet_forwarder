The Things Network packet forwarder
====================================

Forked from Semtech''s Lora network packet forwarder project. See original description below.


	 / _____)             _              | |    
	( (____  _____ ____ _| |_ _____  ____| |__  
	 \____ \| ___ |    (_   _) ___ |/ ___)  _ \ 
	 _____) ) ____| | | || |_| ____( (___| | | |
	(______/|_____)_|_|_| \__)_____)\____)_| |_|
	  (C)2013 Semtech-Cycleo

Lora network packet forwarder project
======================================

1. Core program: basic_pkt_fwd
-------------------------------

The basic packet forwarder is a program running on the host of a Lora Gateway 
that forward RF packets receive by the concentrator to a server through a 
IP/UDP link, and emits RF packets that are sent by the server.

	((( Y )))
	    |
	    |
	+- -|- - - - - - - - - - - - -+        xxxxxxxxxxxx          +--------+
	|+--+-----------+     +------+|       xx x  x     xxx        |        |
	||              |     |      ||      xx  Internet  xx        |        |
	|| Concentrator |<----+ Host |<------xx     or    xx-------->|        |
	||              | SPI |      ||      xx  Intranet  xx        | Server |
	|+--------------+     +------+|       xxxx   x   xxxx        |        |
	|                             |           xxxxxxxx           |        |
	|            Gateway          |                              |        |
	+- - - - - - - - - - - - - - -+                              +--------+

Uplink: radio packets received by the gateway, with metadata added by the
gateway, forwarded to the server. Might also include gateway status.

Downlink: packets generated by the server, with additional metadata, to be
transmitted by the gateway on the radio channel. Might also include
configuration data for the gateway.

2. Packet forwarder derivatives
--------------------------------

### 2.1 gps_pkt_fwd ###

This derivative of the basic_packet_forwarder add support for a GPS receiver
for absolute time synchronization and gateway localisation.

### 2.2 beacon_pkt_fwd ###

This derivative of the gps_packet_forwarder uses GPS reference to send beacon
packets at very accurate time intervals for node synchronization.

3. Helper programs
-------------------

Those programs are included in the project to provide examples on how to 
communicate with the packet forwarder, and to help the system builder use it 
without having to implement a full Lora network server.

### 3.1. util_sink ###

The packet sink is a simple helper program listening on a single port for UDP 
datagrams, and displaying a message each time one is received. The content of 
the datagram itself is ignored.

### 3.2. util_ack ###

The packet acknowledger is a simple helper program listening on a single UDP 
port and responding to PUSH_DATA datagrams with PUSH_ACK, and to PULL_DATA 
datagrams with PULL_ACK.

### 3.3. util_tx_test ###

The network packet sender is a simple helper program used to send packets 
through the gateway-to-server downlink route.

4. Helper scripts
-----------------

### 4.1. reset_pkt_fwd.sh

This script is to be used on IoT Start Kit platform to reset concentrator chip through GPIO.
It also allows automatic update of Gateway_ID with unique MAC address, in Packet Forwarder JSON
configuration file.
Please refer to the script header for more details.

### 4.2. autoconnect.sh
This script is to be used when we want to connect our Gateway to Server via WI-FI, it allows to 
autoconnect to AP (or Hot Spot) once it possible. Need to run it before running main programm and also 
add profile of AP (or Hot Spot) to /etc/wpa_supplicant/wpa_supplicant.conf in your linux machine.


5. Changelog
-------------


### v2.1.1 - 2019-06-16 ###

Poly packet forwarder from now may to save packets which weren't sent to server if server was unreachable (timeout).
In this case packet forwarder saves packets in static variable array and will send it to server once server will be online - 
if poly packet forwarder sucseeded to send packet, it will send all not sent packets one after another and then will contuinue 
his job as usual.

### v2.1.0 - 2015-06-29 ###

* Added helper script for concentrator reset through GPIO, needed on IoT Starter Kit (reset_pkt_fwd.sh).
* The same reset_pkt_fwd.sh script also allows to automatically update the Gateway_ID field in JSON configuration file, with board MAC address.
* Updated JSON configuration file with proper default value for IoT Starter Kit: server address set to local server, GPS device path set to proper value (/dev/ttyAMA0).

### v2.0.0 - 2015-04-30 ###

* Changed: Several configuration parameters are now set dynamically from the JSON configuration file: RSSI offset, concentrator clock source, radio type, TX gain table, network type. The HAL does not need to be recompiled any more to update those parameters. An example for IoT Starter Kit platform is provided in global_conf.json for basic, gps and beacon packet_forwarder.
* Removed: Band frequency JSON configuration file has been removed. An example for EU 868MHz is provided in global_conf.json for basic, gps and beacon packet_forwarder.
* Changed: Updated makefiles to allow cross compilation from environment variable (ARCH, CROSS_COMPILE).

** WARNING: **
** Update your JSON configuration file with new dynamic parameters. **

### v1.4.1 - 2015-01-23 ###

* Bugfix: fixed LP-116, fdev parameter parsed incorrectly, making FSK TX fail.
* Bugfix: fixed a platform-dependant minor rounding issue.
* Beta: updated beacon format, partially aligned with latest class B proposal.

### v1.4.0 - 2014-10-16 ###

* Feature: Adding TX FSK support.
* Feature: optional auto-quit if a certain number of PULL_ACK is missed.
* Feature: upstream and downstream ping time is displayed on console.
* Bugfix: some beacons were missed at high beaconing frequency.
* Bugfix: critical snprintf error caused a crash for long payloads.
* FSK bitrate now appears in the upstream JSON.

### v1.3.0 - 2014-03-28 ###

* Feature: adding preliminary beacon support for class B development.
* Solved warnings with 64b integer printf when compiling on x86_64.
* Updated build system for easier deployment on various hardware.
* Changed threads organization in the forwarder programs.
* Removed duplicate protocol documentation.

### v1.2.0 - 2014-02-03 ###

* Feature: added a GPS-enabled packet forwarder, used to timestamp received
packet with a globally-synchronous microsecond-accurate timestamp.
* Feature: GPS packet forwarder sends status report on the uplink, protocol
specification updated accordingly (report include gateway geolocation).
* Feature: packets can be sent without CRC at radio layer.
* Bugfix: no more crash with base64 padded input.
* Bugfix: no more rounding errors on the 'freq' value sent to server.
* A minimum preamble of 6 Lora symbol is enforced for optimum sensitivity.
* Padded Base64 is sent on uplink, downlink accepts padded and unpadded Base64.
* Updated the Parson JSON library to a version that supports comments.
* Added .md (Markdown) extension to readme files for better Github viewing.

### v1.1.0 - 2013-12-09 ###

* Feature: added packet filtering parameters to the JSON configuration files.
* Bugfix: won't send a datagram if all the packets returned by the receive()
function have been filtered out.
* Bugfix: removed leading zeros for the timestamp in the upstream JSON because
it's not compliant with JSON standard (might be interpreted as octal number).
* Removed TXT extension for README files for better Github integration.
* Cleaned-up documentation, moving change log to top README.
* Modified Makefiles to ease cross-compilation.

### v1.0.0 - 2013-11-22 ###

* Initial release of the packet forwarder, protocol specifications and helper
programs.

6. Legal notice
----------------

The information presented in this project documentation does not form part of 
any quotation or contract, is believed to be accurate and reliable and may be 
changed without notice. No liability will be accepted by the publisher for any 
consequence of its use. Publication thereof does not convey nor imply any 
license under patent or other industrial or intellectual property rights. 
Semtech assumes no responsibility or liability whatsoever for any failure or 
unexpected operation resulting from misuse, neglect improper installation, 
repair or improper handling or unusual physical or electrical stress 
including, but not limited to, exposure to parameters beyond the specified 
maximum ratings or operation outside the specified range. 

SEMTECH PRODUCTS ARE NOT DESIGNED, INTENDED, AUTHORIZED OR WARRANTED TO BE 
SUITABLE FOR USE IN LIFE-SUPPORT APPLICATIONS, DEVICES OR SYSTEMS OR OTHER 
CRITICAL APPLICATIONS. INCLUSION OF SEMTECH PRODUCTS IN SUCH APPLICATIONS IS 
UNDERSTOOD TO BE UNDERTAKEN SOLELY AT THE CUSTOMERíS OWN RISK. Should a 
customer purchase or use Semtech products for any such unauthorized 
application, the customer shall indemnify and hold Semtech and its officers, 
employees, subsidiaries, affiliates, and distributors harmless against all 
claims, costs damages and attorney fees which could arise.

*EOF*

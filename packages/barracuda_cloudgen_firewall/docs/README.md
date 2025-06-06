# Barracuda CloudGen Firewall integration

This integration ingests and parses logs from
[Barracuda CloudGen Firewalls](https://www.barracuda.com/products/cloudgenfirewall).

Barracuda CloudGen Firewall allows you to stream event logs from Firewall
Insights to Elastic Agent. This provides information on firewall activity,
threat logs, and information related to network, version, and location of
managed firewall units. Data is sent to Elastic Agent over a TCP connection
using CloudGen Firewall's built-in generic Logstash output.

### Setup

For a detailed walk-through of the setup steps the see
[How to Enable Filebeat Stream to a Logstash Pipeline](https://campus.barracuda.com/product/cloudgenfirewall/doc/96025953/how-to-enable-filebeat-stream-to-a-logstash-pipeline/).
These steps were written with a Logstash server as the intended destination, and
where it references the "Hostname" use the address and port of the Elastic Agent
that is running this integration. Logstash is not used as part of this
integration.

## Logs

This is the Barracuda CloudGen Firewall `log` dataset. Below is a sample
event and a list of fields that can be produced.

An example event for `log` looks as following:

```json
{
    "@timestamp": "2020-11-24T15:02:21.000Z",
    "agent": {
        "ephemeral_id": "84e1084a-b6b7-4442-8fab-ab5f1d9b6f49",
        "id": "70e5c8ad-b33e-4666-8e7c-74260a15f28e",
        "name": "elastic-agent-76642",
        "type": "filebeat",
        "version": "8.17.3"
    },
    "barracuda_cloudgen_firewall": {
        "log": {
            "app_rule": "<App>:ALL-APPS",
            "apps": [
                "Web browsing",
                "Microsoft Services"
            ],
            "fw_info": 2007,
            "protos": [
                "HTTPS direct",
                "HTTPS",
                "All HTTP protocols"
            ]
        }
    },
    "data_stream": {
        "dataset": "barracuda_cloudgen_firewall.log",
        "namespace": "50874",
        "type": "logs"
    },
    "destination": {
        "address": "67.43.156.78",
        "as": {
            "number": 35908
        },
        "bytes": 561503,
        "geo": {
            "continent_name": "Asia",
            "country_iso_code": "BT",
            "country_name": "Bhutan",
            "location": {
                "lat": 27.5,
                "lon": 90.5
            }
        },
        "ip": "67.43.156.78",
        "mac": "00-0C-29-00-D6-00",
        "nat": {
            "ip": "67.43.156.100"
        },
        "packets": 439,
        "port": 443
    },
    "ecs": {
        "version": "8.11.0"
    },
    "elastic_agent": {
        "id": "70e5c8ad-b33e-4666-8e7c-74260a15f28e",
        "snapshot": false,
        "version": "8.17.3"
    },
    "event": {
        "action": "End",
        "agent_id_status": "verified",
        "category": [
            "network"
        ],
        "dataset": "barracuda_cloudgen_firewall.log",
        "duration": 8436000000,
        "ingested": "2025-04-01T14:47:56Z",
        "kind": "event",
        "type": [
            "end"
        ]
    },
    "input": {
        "type": "lumberjack"
    },
    "labels": {
        "origin_address": "172.19.0.3:43116"
    },
    "network": {
        "community_id": "1:HGU1tX9W2VUF5ND2ey3X6Niv/AQ=",
        "iana_number": "6",
        "transport": "tcp",
        "type": "ipv4"
    },
    "observer": {
        "egress": {
            "interface": {
                "name": "eth0"
            }
        },
        "hostname": "cgf-scout-int",
        "ingress": {
            "interface": {
                "name": "eth0"
            }
        },
        "product": "ngfw",
        "serial_number": "4f94abdf7a8c465fa2cd76f680ecafd1",
        "type": "firewall",
        "vendor": "Barracuda"
    },
    "related": {
        "ip": [
            "10.17.35.171",
            "67.43.156.78"
        ]
    },
    "rule": {
        "name": "BOX-LAN-2-INTERNET"
    },
    "source": {
        "address": "10.17.35.171",
        "bytes": 7450,
        "ip": "10.17.35.171",
        "mac": "00-0C-29-9A-0A-78",
        "nat": {
            "ip": "10.17.35.175"
        },
        "packets": 129,
        "port": 40532
    },
    "tags": [
        "barracuda_cloudgen_firewall-log",
        "forwarded"
    ]
}
```

**Exported fields**

| Field | Description | Type |
|---|---|---|
| @timestamp | Date/time when the event originated. This is the date/time extracted from the event, typically representing when the event was generated by the source. If the event source has no original timestamp, this value is typically populated by the first time the event was received by the pipeline. Required field for all events. | date |
| barracuda_cloudgen_firewall.log.app_rule | Application rule name (e.g. "\<App\>:ALL-APPS") | keyword |
| barracuda_cloudgen_firewall.log.apps | Applications related to the logged activity (e.g., ["Microsoft Services Base","Microsoft Services"]) | keyword |
| barracuda_cloudgen_firewall.log.fw_info | Detailed information about the action performed by the firewall. More information can be found [here](https://campus.barracuda.com/product/cloudgenfirewall/doc/96025108/how-to-enable-filebeat-stream-to-a-logstash-pipeline/) | long |
| barracuda_cloudgen_firewall.log.protos | Detected application protocols, from most specific to least specific (e.g., ["HTTPS direct", "HTTPS", "All HTTP protocols"]) | keyword |
| barracuda_cloudgen_firewall.log.traffic_type | Always "0" | long |
| barracuda_cloudgen_firewall.log.user_type | User type of web log. 1 if "user" is a username or 0 if "user" is an IP address. | keyword |
| data_stream.dataset | Data stream dataset. | constant_keyword |
| data_stream.namespace | Data stream namespace. | constant_keyword |
| data_stream.type | Data stream type. | constant_keyword |
| event.dataset | Event dataset | constant_keyword |
| event.module | Event module | constant_keyword |
| input.type | Type of Filebeat input. | keyword |
| labels.origin_address | Remote address where the log originated. | keyword |
| labels.origin_client_subject | Distinguished name of subject of the x.509 certificate presented by the origin client when mutual TLS is enabled. | keyword |

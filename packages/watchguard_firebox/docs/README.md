# WatchGuard Firebox

WatchGuard Firebox is a firewall appliance that provides network security. Firebox is a powerful network security device that controls all traffic between the external network and the trusted network. Fireware OS is the software that runs on a Firebox. Fireware includes a Web UI that gives you an easy way to manage, and monitor each Firebox in your network.

## Data streams

This integration supports ingestion of logs from WatchGuard Firebox, via [UDP](https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-input-udp.html) input.

**Log** is used to retrieve log messages generated by Firebox. See more details in the documentation [here](https://www.watchguard.com/help/docs/fireware/12/en-US/log_catalog/12_10_Log-Catalog.pdf).

## Requirements

Elastic Agent must be installed. For more information, refer to the link [here](https://www.elastic.co/guide/en/fleet/current/elastic-agent-installation.html).

### Installing and managing an Elastic Agent:

You have a few options for installing and managing an Elastic Agent:

### Install a Fleet-managed Elastic Agent (recommended):

With this approach, you install Elastic Agent and use Fleet in Kibana to define, configure, and manage your agents in a central location. We recommend using Fleet management because it makes the management and upgrade of your agents considerably easier.

### Install Elastic Agent in standalone mode (advanced users):

With this approach, you install Elastic Agent and manually configure the agent locally on the system where it’s installed. You are responsible for managing and upgrading the agents. This approach is reserved for advanced users only.

### Install Elastic Agent in a containerized environment:

You can run Elastic Agent inside a container, either with Fleet Server or standalone. Docker images for all versions of Elastic Agent are available from the Elastic Docker registry, and we provide deployment manifests for running on Kubernetes.

There are some minimum requirements for running Elastic Agent and for more information, refer to the link [here](https://www.elastic.co/guide/en/fleet/current/elastic-agent-installation.html#_minimum_requirements).

The minimum **Kibana version** required is **8.13.0**.

This module has been tested against **Fireware v12.10.3**.

## Setup

Follow the [setup guide](https://www.watchguard.com/help/docs/help-center/en-US/Content/en-US/Fireware/logging/send_logs_to_syslog_c.html) to forward Firebox log messages to a syslog server.

### Enabling the integration in Elastic:

1. In Kibana go to Management > Integrations.
2. In "Search for integrations" search bar, type WatchGuard Firebox.
3. Click on the "WatchGuard Firebox" integration from the search results.
4. Click on the "Add WatchGuard Firebox" button to add the integration.
5. Add all the required integration configuration parameters according to the enabled input type.
6. Click on "Save and continue" to save the integration.

## Logs Reference

### Log

This is the `Log` dataset.

#### Example

An example event for `log` looks as following:

```json
{
    "@timestamp": "2024-01-16T15:19:05.000Z",
    "agent": {
        "ephemeral_id": "5a9738b6-025a-4df4-861e-1cc1eea5c622",
        "id": "7aaba523-565c-4597-bc42-59135436336b",
        "name": "docker-fleet-agent",
        "type": "filebeat",
        "version": "8.13.0"
    },
    "data_stream": {
        "dataset": "watchguard_firebox.log",
        "namespace": "76887",
        "type": "logs"
    },
    "destination": {
        "bytes": 282,
        "geo": {
            "city_name": "Changchun",
            "continent_name": "Asia",
            "country_iso_code": "CN",
            "country_name": "China",
            "location": {
                "lat": 43.88,
                "lon": 125.3228
            },
            "region_iso_code": "CN-22",
            "region_name": "Jilin Sheng"
        },
        "ip": [
            "175.16.199.1"
        ],
        "port": [
            25
        ]
    },
    "ecs": {
        "version": "8.11.0"
    },
    "elastic_agent": {
        "id": "7aaba523-565c-4597-bc42-59135436336b",
        "snapshot": false,
        "version": "8.13.0"
    },
    "email": {
        "sender": {
            "address": "tester@testnet.com"
        },
        "to": {
            "address": [
                "wg@localhost"
            ]
        }
    },
    "event": {
        "agent_id_status": "verified",
        "category": [
            "email"
        ],
        "dataset": "watchguard_firebox.log",
        "ingested": "2024-08-07T05:26:04Z",
        "kind": "event",
        "original": "<139>Jan 16 15:19:05 WatchGuard-Firebox FVE6035FD3AE3 (2024-01-19T08:48:15) firewall: msg_id=\"1BFF-000F\" Allow 1-Trusted 0-External tcp 10.0.1.2 175.16.199.1 39398 25 msg=\"SMTP request\" proxy_act=\"SMTP-Outgoing.1\" rcvd_bytes=\"272\" sent_bytes=\"282\" sender=\"tester@testnet.com\" recipients=\"wg@localhost\" server_ssl=\"ECDHE-RSA-AES256-GCMSHA384\" client_ssl=\"AES128-SHA256\" tls_profile=\"TLS-Client.Standard\" (SMTP-proxy-00)",
        "outcome": "success",
        "timezone": "UTC",
        "type": [
            "info"
        ]
    },
    "input": {
        "type": "udp"
    },
    "log": {
        "source": {
            "address": "192.168.240.4:51247"
        },
        "syslog": {
            "appname": "firewall",
            "hostname": "WatchGuard-Firebox",
            "priority": 139
        }
    },
    "network": {
        "bytes": 554,
        "community_id": "1:jKtS0CPHMiYL+rYXXHskx9Y4Gig=",
        "transport": "tcp"
    },
    "observer": {
        "egress": {
            "interface": {
                "alias": "0-External"
            }
        },
        "hostname": "WatchGuard-Firebox",
        "ingress": {
            "interface": {
                "alias": "1-Trusted"
            }
        },
        "product": "Firebox",
        "serial_number": "FVE6035FD3AE3",
        "type": "firewall",
        "vendor": "WatchGuard"
    },
    "related": {
        "hosts": [
            "WatchGuard-Firebox"
        ],
        "ip": [
            "10.0.1.2",
            "175.16.199.1"
        ],
        "user": [
            "wg@localhost",
            "tester@testnet.com"
        ]
    },
    "rule": {
        "name": [
            "SMTP-proxy-00"
        ]
    },
    "source": {
        "bytes": 272,
        "ip": [
            "10.0.1.2"
        ],
        "port": [
            39398
        ]
    },
    "tags": [
        "preserve_original_event",
        "preserve_duplicate_custom_fields",
        "forwarded",
        "watchguard_firebox-log"
    ],
    "tls": {
        "client": {
            "supported_ciphers": [
                "AES128-SHA256"
            ]
        }
    },
    "watchguard_firebox": {
        "log": {
            "bytes_in": 272,
            "bytes_out": 282,
            "client_ssl": "AES128-SHA256",
            "destination_ip": "175.16.199.1",
            "destination_ip_geo": {
                "city_name": "Changchun",
                "continent_name": "Asia",
                "country_iso_code": "CN",
                "country_name": "China",
                "location": {
                    "lat": 43.88,
                    "lon": 125.3228
                },
                "region_iso_code": "CN-22",
                "region_name": "Jilin Sheng"
            },
            "destination_port": 25,
            "disposition": "Allow",
            "in_interface_name": "1-Trusted",
            "log_type": "traffic",
            "msg": "SMTP request",
            "msg_id": "1BFF-000F",
            "out_interface_name": "0-External",
            "policy_name": "SMTP-proxy-00",
            "proxy_act": "SMTP-Outgoing.1",
            "recipients": "wg@localhost",
            "sender": "tester@testnet.com",
            "serial_number": "FVE6035FD3AE3",
            "server_ssl": "ECDHE-RSA-AES256-GCMSHA384",
            "source_ip": "10.0.1.2",
            "source_port": 39398,
            "syslog_timestamp": "2024-01-16T15:19:05.000Z",
            "timestamp": "2024-01-19T08:48:15.000Z",
            "tls_profile": "TLS-Client.Standard",
            "transport": "tcp"
        }
    }
}
```

**Exported fields**

| Field | Description | Type |
|---|---|---|
| @timestamp | Event timestamp. | date |
| data_stream.dataset | Data stream dataset. | constant_keyword |
| data_stream.namespace | Data stream namespace. | constant_keyword |
| data_stream.type | Data stream type. | constant_keyword |
| event.dataset | Event dataset. | constant_keyword |
| event.module | Event module. | constant_keyword |
| input.type | Type of filebeat input. | keyword |
| log.offset | Log offset. | long |
| log.source.address | Source address from which the log event was read / sent from. | keyword |
| watchguard_firebox.log.action |  | keyword |
| watchguard_firebox.log.action_name |  | keyword |
| watchguard_firebox.log.address |  | keyword |
| watchguard_firebox.log.app_beh_id |  | keyword |
| watchguard_firebox.log.app_beh_name |  | keyword |
| watchguard_firebox.log.app_cat_id |  | keyword |
| watchguard_firebox.log.app_cat_name |  | keyword |
| watchguard_firebox.log.app_control_disposition |  | keyword |
| watchguard_firebox.log.app_id |  | keyword |
| watchguard_firebox.log.app_name |  | keyword |
| watchguard_firebox.log.arg |  | keyword |
| watchguard_firebox.log.attachment |  | keyword |
| watchguard_firebox.log.authenticated_user |  | keyword |
| watchguard_firebox.log.authenticated_user_domain |  | keyword |
| watchguard_firebox.log.authentication_method |  | keyword |
| watchguard_firebox.log.authentication_server |  | keyword |
| watchguard_firebox.log.authentication_type |  | keyword |
| watchguard_firebox.log.beh_name |  | keyword |
| watchguard_firebox.log.blocked_site_limit |  | long |
| watchguard_firebox.log.bootup_time |  | date |
| watchguard_firebox.log.bounce_ip |  | ip |
| watchguard_firebox.log.bytes |  | long |
| watchguard_firebox.log.bytes_in |  | long |
| watchguard_firebox.log.bytes_out |  | long |
| watchguard_firebox.log.call_from |  | ip |
| watchguard_firebox.log.call_to |  | ip |
| watchguard_firebox.log.category_name |  | keyword |
| watchguard_firebox.log.cats |  | keyword |
| watchguard_firebox.log.certificate_id |  | keyword |
| watchguard_firebox.log.certificate_issuer |  | keyword |
| watchguard_firebox.log.certificate_subject |  | keyword |
| watchguard_firebox.log.certificate_type |  | keyword |
| watchguard_firebox.log.client_name |  | keyword |
| watchguard_firebox.log.client_ssl |  | keyword |
| watchguard_firebox.log.cluster_id |  | keyword |
| watchguard_firebox.log.cluster_role |  | keyword |
| watchguard_firebox.log.cn |  | keyword |
| watchguard_firebox.log.codec |  | keyword |
| watchguard_firebox.log.command |  | keyword |
| watchguard_firebox.log.content |  | keyword |
| watchguard_firebox.log.content_inspection |  | keyword |
| watchguard_firebox.log.content_source |  | keyword |
| watchguard_firebox.log.content_type |  | keyword |
| watchguard_firebox.log.ctl_dst_ip |  | ip |
| watchguard_firebox.log.ctl_dst_port |  | long |
| watchguard_firebox.log.ctl_src_ip |  | ip |
| watchguard_firebox.log.ctl_src_port |  | long |
| watchguard_firebox.log.current_ca_certificate_version |  | keyword |
| watchguard_firebox.log.current_connection |  | long |
| watchguard_firebox.log.current_session |  | long |
| watchguard_firebox.log.data |  | keyword |
| watchguard_firebox.log.destination_device |  | keyword |
| watchguard_firebox.log.destination_ip |  | ip |
| watchguard_firebox.log.destination_ip_geo.city_name |  | keyword |
| watchguard_firebox.log.destination_ip_geo.continent_name |  | keyword |
| watchguard_firebox.log.destination_ip_geo.country_iso_code |  | keyword |
| watchguard_firebox.log.destination_ip_geo.country_name |  | keyword |
| watchguard_firebox.log.destination_ip_geo.location |  | geo_point |
| watchguard_firebox.log.destination_ip_geo.region_iso_code |  | keyword |
| watchguard_firebox.log.destination_ip_geo.region_name |  | keyword |
| watchguard_firebox.log.destination_name |  | keyword |
| watchguard_firebox.log.destination_port |  | long |
| watchguard_firebox.log.destination_user |  | keyword |
| watchguard_firebox.log.destination_user_domain |  | keyword |
| watchguard_firebox.log.details |  | keyword |
| watchguard_firebox.log.dev_name |  | keyword |
| watchguard_firebox.log.device |  | keyword |
| watchguard_firebox.log.device_id |  | keyword |
| watchguard_firebox.log.disposition |  | keyword |
| watchguard_firebox.log.dlp_rule |  | keyword |
| watchguard_firebox.log.dlp_sensor |  | keyword |
| watchguard_firebox.log.dns_ip_address |  | ip |
| watchguard_firebox.log.dns_question |  | keyword |
| watchguard_firebox.log.domain |  | keyword |
| watchguard_firebox.log.duration |  | long |
| watchguard_firebox.log.elapsed_time |  | keyword |
| watchguard_firebox.log.email_length |  | long |
| watchguard_firebox.log.encoding |  | keyword |
| watchguard_firebox.log.encoding_type |  | keyword |
| watchguard_firebox.log.error |  | keyword |
| watchguard_firebox.log.exception_rule |  | keyword |
| watchguard_firebox.log.exchange_role |  | keyword |
| watchguard_firebox.log.exchange_type |  | keyword |
| watchguard_firebox.log.expected |  | keyword |
| watchguard_firebox.log.expected_interface |  | keyword |
| watchguard_firebox.log.expected_ip |  | ip |
| watchguard_firebox.log.expected_protocol |  | keyword |
| watchguard_firebox.log.expected_value |  | long |
| watchguard_firebox.log.failure_count |  | long |
| watchguard_firebox.log.feature_expiration_date |  | date |
| watchguard_firebox.log.feature_key |  | keyword |
| watchguard_firebox.log.feature_name |  | keyword |
| watchguard_firebox.log.file_name |  | keyword |
| watchguard_firebox.log.flags |  | keyword |
| watchguard_firebox.log.from |  | keyword |
| watchguard_firebox.log.from_header |  | keyword |
| watchguard_firebox.log.gateway |  | keyword |
| watchguard_firebox.log.gateway_endpoint |  | keyword |
| watchguard_firebox.log.geo_destination |  | keyword |
| watchguard_firebox.log.group_name |  | keyword |
| watchguard_firebox.log.header |  | keyword |
| watchguard_firebox.log.headers_size |  | long |
| watchguard_firebox.log.host_dest_domain |  | keyword |
| watchguard_firebox.log.host_dest_ip |  | ip |
| watchguard_firebox.log.hostname |  | keyword |
| watchguard_firebox.log.http_status |  | long |
| watchguard_firebox.log.http_version |  | keyword |
| watchguard_firebox.log.ikev2_ikesa_state |  | keyword |
| watchguard_firebox.log.image_source |  | keyword |
| watchguard_firebox.log.in_interface_name |  | keyword |
| watchguard_firebox.log.in_spi |  | keyword |
| watchguard_firebox.log.info_msg |  | keyword |
| watchguard_firebox.log.inspect_action |  | keyword |
| watchguard_firebox.log.interface_id |  | keyword |
| watchguard_firebox.log.interface_name |  | keyword |
| watchguard_firebox.log.ip_address |  | ip |
| watchguard_firebox.log.ip_packet_length |  | long |
| watchguard_firebox.log.iph_length |  | long |
| watchguard_firebox.log.keyword |  | keyword |
| watchguard_firebox.log.length |  | long |
| watchguard_firebox.log.limit |  | long |
| watchguard_firebox.log.line |  | keyword |
| watchguard_firebox.log.line_length |  | long |
| watchguard_firebox.log.link |  | keyword |
| watchguard_firebox.log.link_state |  | keyword |
| watchguard_firebox.log.local |  | keyword |
| watchguard_firebox.log.local_address |  | ip |
| watchguard_firebox.log.local_address_port |  | long |
| watchguard_firebox.log.local_mask_ip |  | keyword |
| watchguard_firebox.log.lockout_type |  | keyword |
| watchguard_firebox.log.log_type |  | keyword |
| watchguard_firebox.log.logical |  | keyword |
| watchguard_firebox.log.mac |  | keyword |
| watchguard_firebox.log.mac_address |  | keyword |
| watchguard_firebox.log.mask |  | ip |
| watchguard_firebox.log.master_id |  | keyword |
| watchguard_firebox.log.max_user_connection |  | long |
| watchguard_firebox.log.mbx |  | keyword |
| watchguard_firebox.log.md5 |  | keyword |
| watchguard_firebox.log.member_id |  | keyword |
| watchguard_firebox.log.member_info |  | keyword |
| watchguard_firebox.log.message |  | keyword |
| watchguard_firebox.log.method |  | keyword |
| watchguard_firebox.log.msg |  | keyword |
| watchguard_firebox.log.msg_id |  | keyword |
| watchguard_firebox.log.msg_info |  | keyword |
| watchguard_firebox.log.negotiation_ip |  | ip |
| watchguard_firebox.log.negotiation_mode |  | keyword |
| watchguard_firebox.log.negotiation_role |  | keyword |
| watchguard_firebox.log.new_action |  | keyword |
| watchguard_firebox.log.new_ca_certificate_version |  | keyword |
| watchguard_firebox.log.new_interface |  | keyword |
| watchguard_firebox.log.new_ip |  | ip |
| watchguard_firebox.log.new_ipv6 |  | keyword |
| watchguard_firebox.log.new_mask |  | long |
| watchguard_firebox.log.new_policy_position |  | long |
| watchguard_firebox.log.new_system_time |  | keyword |
| watchguard_firebox.log.next_update_time |  | date |
| watchguard_firebox.log.notification_gap_duration |  | long |
| watchguard_firebox.log.notify_msg |  | keyword |
| watchguard_firebox.log.num |  | long |
| watchguard_firebox.log.number_of_recipients |  | long |
| watchguard_firebox.log.object |  | keyword |
| watchguard_firebox.log.offset |  | long |
| watchguard_firebox.log.old_policy_position |  | long |
| watchguard_firebox.log.op |  | keyword |
| watchguard_firebox.log.operation |  | keyword |
| watchguard_firebox.log.out_interface_name |  | keyword |
| watchguard_firebox.log.out_spi |  | keyword |
| watchguard_firebox.log.p1_sa_id |  | keyword |
| watchguard_firebox.log.package_release_time |  | date |
| watchguard_firebox.log.packets_count |  | long |
| watchguard_firebox.log.packets_in |  | long |
| watchguard_firebox.log.packets_out |  | long |
| watchguard_firebox.log.pad_error |  | keyword |
| watchguard_firebox.log.path |  | keyword |
| watchguard_firebox.log.pcy_name |  | keyword |
| watchguard_firebox.log.peer_address |  | ip |
| watchguard_firebox.log.peer_address_port |  | long |
| watchguard_firebox.log.physical_name |  | keyword |
| watchguard_firebox.log.policy_name |  | keyword |
| watchguard_firebox.log.pool_name |  | keyword |
| watchguard_firebox.log.port |  | long |
| watchguard_firebox.log.previous_interface |  | keyword |
| watchguard_firebox.log.previous_ip |  | ip |
| watchguard_firebox.log.previous_ipv6 |  | keyword |
| watchguard_firebox.log.previous_mask |  | long |
| watchguard_firebox.log.previous_system_time |  | keyword |
| watchguard_firebox.log.probe_method |  | keyword |
| watchguard_firebox.log.property_name |  | keyword |
| watchguard_firebox.log.protocol |  | keyword |
| watchguard_firebox.log.protocol_flags |  | keyword |
| watchguard_firebox.log.proxy_act |  | keyword |
| watchguard_firebox.log.proxy_host |  | keyword |
| watchguard_firebox.log.proxy_type |  | keyword |
| watchguard_firebox.log.query_class |  | keyword |
| watchguard_firebox.log.query_opcode |  | keyword |
| watchguard_firebox.log.query_type |  | keyword |
| watchguard_firebox.log.quota_info |  | keyword |
| watchguard_firebox.log.real_ip_address |  | ip |
| watchguard_firebox.log.reason |  | keyword |
| watchguard_firebox.log.reboot_hour |  | long |
| watchguard_firebox.log.reboot_option |  | keyword |
| watchguard_firebox.log.reboot_second |  | long |
| watchguard_firebox.log.reboot_status |  | keyword |
| watchguard_firebox.log.received |  | keyword |
| watchguard_firebox.log.received_dh_group |  | long |
| watchguard_firebox.log.received_interface |  | keyword |
| watchguard_firebox.log.received_interface_index |  | keyword |
| watchguard_firebox.log.received_ip |  | ip |
| watchguard_firebox.log.received_message_id |  | keyword |
| watchguard_firebox.log.received_proto |  | keyword |
| watchguard_firebox.log.received_value |  | long |
| watchguard_firebox.log.recipients |  | keyword |
| watchguard_firebox.log.record_type |  | keyword |
| watchguard_firebox.log.redirect_action |  | keyword |
| watchguard_firebox.log.remote |  | keyword |
| watchguard_firebox.log.remote_mask_ip |  | keyword |
| watchguard_firebox.log.reply |  | keyword |
| watchguard_firebox.log.reply_ip |  | ip |
| watchguard_firebox.log.reply_protocol |  | keyword |
| watchguard_firebox.log.reply_time |  | date |
| watchguard_firebox.log.reputation |  | long |
| watchguard_firebox.log.req_or_resp |  | keyword |
| watchguard_firebox.log.response |  | keyword |
| watchguard_firebox.log.response_code |  | long |
| watchguard_firebox.log.response_size |  | long |
| watchguard_firebox.log.restore_type |  | keyword |
| watchguard_firebox.log.result |  | keyword |
| watchguard_firebox.log.retry_count |  | long |
| watchguard_firebox.log.return_code |  | long |
| watchguard_firebox.log.role |  | keyword |
| watchguard_firebox.log.route_type |  | keyword |
| watchguard_firebox.log.rule_name |  | keyword |
| watchguard_firebox.log.ruleset_name |  | keyword |
| watchguard_firebox.log.sa_id |  | keyword |
| watchguard_firebox.log.scan_stage |  | keyword |
| watchguard_firebox.log.scan_type |  | keyword |
| watchguard_firebox.log.scheme |  | keyword |
| watchguard_firebox.log.selected_dh_group |  | long |
| watchguard_firebox.log.sender |  | keyword |
| watchguard_firebox.log.sequence_number |  | long |
| watchguard_firebox.log.serial_number |  | keyword |
| watchguard_firebox.log.server_ip |  | ip |
| watchguard_firebox.log.server_name |  | keyword |
| watchguard_firebox.log.server_ssl |  | keyword |
| watchguard_firebox.log.service |  | keyword |
| watchguard_firebox.log.session_id |  | keyword |
| watchguard_firebox.log.severity |  | long |
| watchguard_firebox.log.signature_category |  | keyword |
| watchguard_firebox.log.signature_id |  | keyword |
| watchguard_firebox.log.signature_name |  | keyword |
| watchguard_firebox.log.signature_version |  | keyword |
| watchguard_firebox.log.size |  | long |
| watchguard_firebox.log.sni |  | keyword |
| watchguard_firebox.log.software_version |  | keyword |
| watchguard_firebox.log.source_ip |  | ip |
| watchguard_firebox.log.source_ip_geo.city_name |  | keyword |
| watchguard_firebox.log.source_ip_geo.continent_name |  | keyword |
| watchguard_firebox.log.source_ip_geo.country_iso_code |  | keyword |
| watchguard_firebox.log.source_ip_geo.country_name |  | keyword |
| watchguard_firebox.log.source_ip_geo.location |  | geo_point |
| watchguard_firebox.log.source_ip_geo.region_iso_code |  | keyword |
| watchguard_firebox.log.source_ip_geo.region_name |  | keyword |
| watchguard_firebox.log.source_port |  | long |
| watchguard_firebox.log.source_user |  | keyword |
| watchguard_firebox.log.source_user_domain |  | keyword |
| watchguard_firebox.log.spi |  | keyword |
| watchguard_firebox.log.srv_ip |  | ip |
| watchguard_firebox.log.srv_port |  | long |
| watchguard_firebox.log.ssl_offload |  | keyword |
| watchguard_firebox.log.state |  | keyword |
| watchguard_firebox.log.static_ip |  | ip |
| watchguard_firebox.log.status |  | keyword |
| watchguard_firebox.log.subsystem |  | keyword |
| watchguard_firebox.log.syslog_timestamp |  | date |
| watchguard_firebox.log.tag |  | keyword |
| watchguard_firebox.log.target |  | keyword |
| watchguard_firebox.log.task_uuid |  | keyword |
| watchguard_firebox.log.threat_level |  | keyword |
| watchguard_firebox.log.timeout |  | long |
| watchguard_firebox.log.timestamp |  | date |
| watchguard_firebox.log.tls_profile |  | keyword |
| watchguard_firebox.log.tls_version |  | keyword |
| watchguard_firebox.log.to |  | keyword |
| watchguard_firebox.log.to_header |  | keyword |
| watchguard_firebox.log.tr_local |  | keyword |
| watchguard_firebox.log.tr_remote |  | keyword |
| watchguard_firebox.log.transport |  | keyword |
| watchguard_firebox.log.ttl |  | long |
| watchguard_firebox.log.tunnel_name |  | keyword |
| watchguard_firebox.log.tunnel_type |  | keyword |
| watchguard_firebox.log.ui_type |  | keyword |
| watchguard_firebox.log.unit |  | keyword |
| watchguard_firebox.log.unlocked_by |  | keyword |
| watchguard_firebox.log.update |  | keyword |
| watchguard_firebox.log.updated_role |  | keyword |
| watchguard_firebox.log.user_auth_protocol |  | keyword |
| watchguard_firebox.log.user_domain |  | keyword |
| watchguard_firebox.log.user_name |  | keyword |
| watchguard_firebox.log.user_response_time |  | date |
| watchguard_firebox.log.user_type |  | keyword |
| watchguard_firebox.log.version |  | keyword |
| watchguard_firebox.log.version_number |  | keyword |
| watchguard_firebox.log.virtual_ip_address |  | ip |
| watchguard_firebox.log.virus |  | keyword |
| watchguard_firebox.log.vlan_id |  | keyword |
| watchguard_firebox.log.vpn_connection_type |  | keyword |
| watchguard_firebox.log.vpn_user_type |  | keyword |
| watchguard_firebox.log.wgrd_spam_id |  | keyword |
| watchguard_firebox.log.window_size |  | long |
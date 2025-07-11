# Teleport Audit Events Integration

## Overview

[Teleport](https://goteleport.com/docs/) provides connectivity, authentication, access controls, and audit for infrastructure.

This integration ingests audit events from Teleport. You can use it to perform historical analysis, 
detect unusual behavior, and form a better understanding of how users interact with your Teleport cluster.

Use this integration to collect and parse audit event logs from various events supported by Teleport. 
Then visualize that data in Kibana using the included dashboard, create alerts to notify you if 
something goes wrong, and reference logs when troubleshooting an issue.

For example, you can filter for failed authorization events and examine the graph of the number of these attempts 
by time, as well as such data points as the geographical location of clients and related user names.

## Data streams

The `teleport` integration collects the following logs:

- **audit** provides events from Teleport audit logs.

## Requirements

Elastic Agent must be installed. For more details, check the Elastic Agent [installation instructions](docs-content://reference/fleet/install-elastic-agents.md).

## Setup

Check out [the guide on configuring Teleport's Event Handler plugin](https://goteleport.com/docs/management/export-audit-events/)
to make it send audit logs to the Elasticsearch instance.

See the {{ url "getting-started-observability" "Getting started guide" }} for instructions on setting up the Elastic Stack.

### Enable the integration in Elastic

1. In Kibana navigate to **Management** > **Integrations**.
2. In the search top bar, type **Symantec Endpoint Security**.
3. Select the **Symantec Endpoint Security** integration and add it.
4. Add all the required integration configuration parameters, including Paths.
5. Save the integration.

## Reference

**Logs** help you keep a record of events happening in Teleport.

### Audit Events Log

The `audit` data stream collects JSON documents from Teleport audit logs.

Event fields are mapped either into the Elastic Common Schema, its extensions, or into custom fields. The latter are grouped
into logical categories, such as `teleport.audit.session.*`. 

Each event is categorized into the four Elastic Common Schema
categorizations fields: `event.kind`, `event.category`, `event.type`, and `event.outcome`.

{{ event "audit" }}

{{ fields "audit" }}

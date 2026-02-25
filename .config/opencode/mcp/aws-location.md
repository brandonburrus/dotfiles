---
name: aws-location
type: local
command: ["uvx", "awslabs.aws-location-mcp-server@latest"]
requires_env:
  - AWS_REGION
optional_env:
  - AWS_PROFILE
  - AWS_ACCESS_KEY_ID
  - AWS_SECRET_ACCESS_KEY
  - AWS_SESSION_TOKEN
  - FASTMCP_LOG_LEVEL
env:
  AWS_REGION: "us-east-1"
  FASTMCP_LOG_LEVEL: "ERROR"
---

## Description

MCP server for Amazon Location Service. Provides geocoding, reverse geocoding, place search,
nearby search, open-now filtering, route calculation, and waypoint optimization using the
Amazon Location Service geo-places and geo-routes APIs.

## Tools provided

- **search_places** — Search for places by text query using geocoding; returns summaries or full details
- **get_place** — Retrieve details for a specific place by its unique `PlaceId`
- **reverse_geocode** — Convert longitude/latitude coordinates to a street address
- **search_nearby** — Find places near a given coordinate with auto-expanding radius until results are found
- **search_places_open_now** — Search for places matching a query that are currently open, with radius expansion
- **calculate_route** — Calculate a route between two positions with turn-by-turn directions; supports Car, Truck, Walking, and Bicycle travel modes
- **geocode** — Convert a location name or address string to coordinates
- **optimize_waypoints** — Reorder a list of waypoints for the most efficient route between an origin and destination

## When to use

- Looking up coordinates for an address or place name (geocoding / reverse geocoding)
- Finding nearby points of interest (restaurants, hospitals, ATMs, etc.) around a location
- Filtering results to only businesses that are currently open
- Calculating driving, walking, cycling, or truck routes with directions and distance/duration
- Optimizing a multi-stop delivery or travel itinerary via waypoint reordering
- Any task that requires geographic context: mapping, logistics, field-service routing

## Caveats

- Requires an AWS account with Amazon Location Service enabled and appropriate IAM permissions for the geo-places and geo-routes APIs
- `AWS_REGION` must be set to a region where Amazon Location Service is available (e.g. `us-east-1`)
- Route and waypoint optimization features may incur AWS costs per request — check the Amazon Location Service pricing page
- `search_nearby` and `search_places_open_now` expand the search radius automatically up to a configurable maximum, which may increase latency and cost
- Results depend on Amazon Location Service data coverage, which varies by region and place type

## Setup

Prerequisites (install once):

```sh
# Install uv (Python package runner)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Install Python 3.10 via uv
uv python install 3.10
```

Ensure your AWS credentials are configured:

```sh
# Option 1: AWS CLI profile (recommended)
aws configure --profile your-profile

# Option 2: Environment variables
export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
export AWS_SESSION_TOKEN=...   # only for temporary credentials
```

Required IAM permissions (minimum):

```json
{
  "Effect": "Allow",
  "Action": [
    "geo-places:SearchText",
    "geo-places:GetPlace",
    "geo-places:ReverseGeocode",
    "geo-places:SearchNearby",
    "geo-routes:CalculateRoutes",
    "geo-routes:OptimizeWaypoints"
  ],
  "Resource": "*"
}
```

## opencode.jsonc config

```jsonc
"aws-location": {
  "type": "local",
  "command": ["uvx", "awslabs.aws-location-mcp-server@latest"],
  "environment": {
    "AWS_PROFILE": "your-aws-profile",
    "AWS_REGION": "us-east-1",
    "FASTMCP_LOG_LEVEL": "ERROR"
  }
}
```

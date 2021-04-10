#!/bin/bash
echo "=== IP Address ===================="
ip address show
echo "=== Start LOCUST as master mode ==="
locust -f /locust/locustfile.py --master -H ${LOCUST_TARGET_URL}

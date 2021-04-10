#!/bin/bash
echo "=== Confirm to connect master ===="
ping -c 3 ${LOCUST_MASTER}
echo "=== Start LOCUST as slave mode ==="
locust -f /locust/locustfile.py --worker --master-host ${LOCUST_MASTER}

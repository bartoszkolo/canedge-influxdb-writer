#!/bin/bash

# Update and upgrade the system
sudo apt update && sudo apt upgrade -y

## Install InfluxDB 2.x
echo "Installing InfluxDB 2.x..."
# Add InfluxDB repository
wget -qO- https://repos.influxdata.com/influxdata-archive_compat.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/influxdb.gpg > /dev/null
echo "deb [signed-by=/etc/apt/trusted.gpg.d/influxdb.gpg] https://repos.influxdata.com/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/influxdb.list

# Update package list and install InfluxDB 2.x
sudo apt update
sudo apt install influxdb2 -y

# Start InfluxDB service and enable it to start on boot
sudo systemctl start influxdb
sudo systemctl enable influxdb

## Install Grafana
echo "Installing Grafana..."
# Add Grafana repository
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee /etc/apt/sources.list.d/grafana.list
sudo curl -sL https://packages.grafana.com/gpg.key | sudo apt-key add -

# Update package list and install Grafana
sudo apt update
sudo apt install grafana -y

# Start Grafana service and enable it to start on boot
sudo systemctl start grafana-server
sudo systemctl enable grafana-server

## Install CANedge InfluxDB Writer
echo "Installing CANedge InfluxDB Writer..."

# Clone the CANedge InfluxDB Writer repository
git clone https://github.com/bartoszkolo/canedge-influxdb-writer.git

# Change to the project directory
cd canedge-influxdb-writer

python -m venv venv
source venv/bin/activate


# Install the required Python packages
pip install -r requirements.txt

# Print status
echo "InfluxDB 2.x, Grafana, and CANedge InfluxDB Writer have been installed."
echo "InfluxDB status:"
sudo systemctl status influxdb
echo "Grafana status:"
sudo systemctl status grafana-server
echo "CANedge InfluxDB Writer is installed in $(pwd)"

echo "You can access Grafana at http://localhost:3000 (default credentials: admin/admin)"
echo "To set up InfluxDB 2.x, visit http://localhost:8086 and follow the setup wizard"
echo "Please configure the CANedge InfluxDB Writer by editing the inputs.py file in the canedge-influxdb-writer directory"
echo "Make sure to update the InfluxDB connection details in the CANedge InfluxDB Writer configuration to use InfluxDB 2.x API"

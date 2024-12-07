#!/bin/bash

set -e

sudo apt update

apt install -y postgresql

sudo systemctl start postgresql

systemctl enable postgresql

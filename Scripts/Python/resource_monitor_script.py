#!/usr/bin/env python3

# This script monitors system resources, such as CPU usage, memory usage, and disk space, and sends notifications or triggers actions when thresholds are exceeded.
# It can help detect and resolve resource-related issues in real-time, ensuring optimal performance and availability of servers.

import psutil
import smtplib
from email.mime.text import MIMEText

# Thresholds for CPU usage, memory usage, and disk usage
cpu_threshold = 90
memory_threshold = 80
disk_threshold = 70

# Check CPU usage
cpu_percent = psutil.cpu_percent(interval=1)
if cpu_percent > cpu_threshold:
    send_alert('High CPU Usage', f'CPU usage is {cpu_percent}%')

# Check memory usage
memory_percent = psutil.virtual_memory().percent
if memory_percent > memory_threshold:
    send_alert('High Memory Usage', f'Memory usage is {memory_percent}%')

# Check disk usage
disk_percent = psutil.disk_usage('/').percent
if disk_percent > disk_threshold:
    send_alert('High Disk Usage', f'Disk usage is {disk_percent}%')

# Function to send alert via email
def send_alert(subject, body):
    from_email = '<email_address>'
    to_email = '<recipient_email>'
    msg = MIMEText(body)
    msg['From'] = from_email
    msg['To'] = to_email
    msg['Subject'] = subject


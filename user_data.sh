#!/bin/bash
# Update the system
yum update -y

# Install Apache (httpd)
yum install -y httpd

# Start the Apache service
systemctl start httpd

# Enable Apache to start on boot
systemctl enable httpd

# Get the host's IP address or FQDN
HOST_IP=$(hostname -f)

# Get the current date
CURRENT_DATE=$(date '+%Y-%m-%d %H:%M:%S')

# Generate the HTML content with styling
cat > /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to Hill-Top Consultancy DevOps CLASS 2024A</title>
    <style>
        body {
            background-color: #f0f0f0;
            text-align: center;
            font-family: Arial, sans-serif;
            font-size: 24px; /* Increase base font size */
        }
        h1, h2, p {
            margin: 24px 0; /* Adjust spacing */
        }
        h1 {
            color: #007bff;
            font-weight: bold;
            font-size: 32px; /* Increase font size for h1 */
        }
        h2 {
            color: #007bff;
            font-weight: bold;
            font-size: 24px; /* Increase font size for h2 */
        }
        .content {
            background-color: #ffffff;
            margin: auto;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            width: 80%;
            max-width: 600px;
        }
    </style>
</head>
<body>
    <div class="content">
        <h1>Welcome to Hill-Top Consultancy DevOps CLASS 2024A</h1>
        <h2>This is the Current Host IP Address: $HOST_IP</h2>
        <p>Current Date and Time: $CURRENT_DATE</p>
        <p>Hill-Top Consultancy is a premier IT training and consulting firm that was founded with the vision of empowering professionals and organizations by providing them with cutting-edge skills in DevOps, Cloud Computing, and Software Development. Our ethos is built on the foundation of continuous learning and innovation, which we believe are essential in navigating the ever-evolving technology landscape.</p>
        <p><strong>Email:</strong> info@htconsultancy.net</p>
        <p><strong>Phone:</strong> +45 715 740 47</p>
        <p><strong>Address:</strong> 2630 Taastrup, Denmark</p>
    </div>
</body>
</html>
EOF

# Restart Apache to apply changes
systemctl restart httpd

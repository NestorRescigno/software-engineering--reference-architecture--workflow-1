AWS recommend segurity group
---

The configuration for this scenario includes a virtual private cloud (VPC) with a public subnet and a private subnet. We recommend this scenario if you want to run a public-facing web application, while maintaining back-end servers that aren't publicly accessible. A common example is a multi-tier website, with the web servers in a public subnet and the database servers in a private subnet. You can set up security and routing so that the web servers can communicate with the database servers.

An instance that's launched into the VPC is automatically associated with the default security group if you don't specify a different security group during launch. For this scenario, we recommend that you create the following security groups instead of using the default security group:

* **WebServerSG:** Specify this security group when you launch the web servers in the public subnet.
* **DBServerSG:** Specify this security group when you launch the database servers in the private subnet.

## Security group WebServerSG in public subnet
The following table describes the recommended rules for the WebServerSG security group
### Inbound
Source          | Protocol      | Port range    | comments      |
--------------- | ------------- | ------------- | ------------- |
0.0.0.0/0       | TCP           |  80           | Allow inbound HTTP access to the web servers from any IPv4 address.
0.0.0.0/0       | TCP           |  443          | Allow inbound HTTPS access to the web servers from any IPv4 address
Public IPv4 address range of your network      | TCP           |  22           | AAllow inbound SSH access from your network over IPv4.
Public IPv4 address range of your network      | TCP           |  3389           | Allow inbound RDP access to Windows instances from your home network

### outbound
Source          | Protocol      | Port range    | comments      |
--------------- | ------------- | ------------- | ------------- |
bd server sg    | TCP           |  1433         | Allow outbound Microsoft SQL Server access to the database servers assigned to the DBServerSG security group.
bd server sg    | TCP           |  3306         | Allow outbound MySQL access to the database servers assigned to the DBServerSG security group.
0.0.0.0/0       | TCP           |  80           | Allow outbound HTTP access to any IPv4 addres
0.0.0.0/0       | TCP           |  443          | Allow outbound HTTPS access to any IPv4 address.


## Security group DBServerSG in private subnet
The following table describes the recommended rules for the DBServerSG security group, which

### Inbound
Source          | Protocol      | Port range    | comments      |
--------------- | ------------- | ------------- | ------------- |
web server sg    | TCP           |  1433         | Allow inbound Microsoft SQL Server access from the web servers associated with the WebServerSG security group.
web server sg    | TCP           |  3306         | Allow inbound MySQL Server access from the web servers associated with the WebServerSG security group.


### outbound
Source          | Protocol      | Port range    | comments      |
--------------- | ------------- | ------------- | ------------- |
0.0.0.0/0       | TCP           |  80           | Allow outbound HTTP access to any IPv4 addres
0.0.0.0/0       | TCP           |  443          | Allow outbound HTTPS access to any IPv4 address.

# The default security group 

The default security group for a VPC has rules that automatically allow assigned instances to communicate with each other. To allow that type of communication for a custom security group, you must add the following rules:

### Inbound
Source          | Protocol      | Port range    | comments      |
--------------- | ------------- | ------------- | ------------- |
The ID of the security group   | ALL           |  ALL       | Allow inbound traffic from other instances assigned to this security group.security group.
### outbound
Source          | Protocol      | Port range    | comments      |
--------------- | ------------- | ------------- | ------------- |
The ID of the security group   | ALL           |  ALLL         | Allow outbound traffic to other instances assigned to this security group.

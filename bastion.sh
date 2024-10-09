#!/bin/bash
yum update -y
yum install -y telnet net-tools

touch /etc/yum.repos.d/MariaDB.repo
echo "[mariadb]" >> /etc/yum.repos.d/MariaDB.repo
echo "name=MariaDB" >>  /etc/yum.repos.d/MariaDB.repo
echo "baseurl=https://mirror.mariadb.org/yum/11.6/rhel/9Server/x86_64/" >> /etc/yum.repos.d/MariaDB.repo
echo "gpgkey=https://rpm.mariadb.org/RPM-GPG-KEY-MariaDB" >>  /etc/yum.repos.d/MariaDB.repo
echo "gpgcheck=1" >>  /etc/yum.repos.d/MariaDB.repo
yum install -y mariadb-server 
touch /home/ec2-user/.ssh/key.pem
echo "-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAqmj9x0piLLj5naYfJLtWngO/6IUzUL4tlwwMrqLv4JNq+bEZ
Lh5as9wdKbzTy0e+m6GrJ8D5+1DhEI+YP1digNzJ6D50pL14IOQQlQgrd3tn/w+w
J4kXwHP5iltwIFF/tE61ORwrFHhvS/ehxngB7kzTaGzZdQWN9b/szy1jF2U/XH+d
dYmXFVONnu7XJEGKYC667Xw1OMIr5MV8FHZuuZS5sGBcOjgBvnJEri17gGXTYHN4
1//HI0WQh4Ph2ymQrCAIFyEnoQF9h3imnSltEb7gwTVps0FhkentzsoEN3MeUy+R
IGhgVeLlPSmV1xJsu626mo/fmlH4P5nx9S851wIDAQABAoIBAFZjCRupSqGPWAMi
PrF5Qsyx6+xs8fmhnyzuT9OMB/yZ3uYbcD9f5e09zY7mCZwIj8kHqONrQY60jpO9
p5mcq/PVeYmBd9I3tpk95GYYkSht5+d2RX+VUPQgFsWb2viXOBzotZfw/qnO7+Tb
8SfSmG/8hENwwsA/A5ssI1lXkd8+f9NTOUl9WCy11iI4wUy2jBSNQRgORBXXhV0d
NtuTS/2LW3MhdsW0+dx7rdWsfGDMoRuU0XvT1SizvjW7FzEB3X9f0/mGxPXS3PfR
EQwZw24nbP/2X6KHJQFo8kHJiGwcBXxZjJR1u9va8N4typ2+GI+l1wr55NpJieo2
PwujL7ECgYEA7ebMMWzSOsEuHZ33oROvNHC8q+x9zhqupYLVrLduY7obsglMbvKH
+6Ck2r9kLDDsXijgAhY3l7978X7XlfpeQeXDDL+iou0ksulaiexesqMG3wcexlMj
QBnPh5qTm5QWrf4IuS+cxNNHNSPj71BGam1LASg9F8wBAW7JS1q6PC8CgYEAt1/H
QFKrOCicLD+ycXh3VFjkjrRv0a0T/FVjQwZP/hucUD4RYImkFWx4sHdbNJfgFJyO
p7hwwjDiwdvuu96BVLq3uhLLPQOCB6nCqA8MDyPGsTeAF1QjKIfkXuyfT1QLft67
tuRBjZzU32D3es8hdfHW5R12jvf+CTH678aVqtkCgYEAgX2Wt3BcHc74ovZQy0RD
oW+bwpi/AWhUl5JXa+OMGow6dvXIvLsWeUg/czGp/MPEZJwrEfe12stHU3OPNPtK
QuQk/tNwWu5pg1ixB1G5WdKS8uKVRa4LCeECrPTeU1iP37TeWq4nzpqRr8MRVjmD
mnpS0RZt6n4ILhd3SaTgqdECgYB9LNt2FDifCFG7fuvPu50xrdCvfYqLRivLZ3pv
6WI3ox9sQ0JXdP3WRgqI46EV4MrtJwXWhfgrB3XzQa/Q/Q2qCh+a3HNyPe/ITWD8
mfDwcMqUdL9yrVOmukTxa3NAkq2aOG9JZL0+7xz9M1McuUItIh5AnoEtDSqTmlOi
1Buc2QKBgEpReCYOXf73A+ATPJEE7ghORPpGFhkjjVbyO0EThB8ZIGh7ftopeM+B
rEIBxYHgwFazgLFmar2rhIghOp962p6MJdOgoKU6WuDzSMubnwSvPBPP0q2odSnS
wl+X++z659HDiCg/BZKL9qduYVb6RHTaRFkx9dScNmtCSqMN5lBN
-----END RSA PRIVATE KEY----" >> /home/ec2-user/.ssh/key.pem
chmod 400 /home/ec2-user/.ssh/key.pem
sudo chown ec2-user:ec2-user key.pem
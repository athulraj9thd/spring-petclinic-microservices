piVersion: v1
kind: ConfigMap
metadata:
  name: mysql-initdb
  namespace: petclinic-dev
data:
  init.sql: |
    CREATE DATABASE IF NOT EXISTS petclinic_customers;
    CREATE DATABASE IF NOT EXISTS petclinic_vets;
    CREATE DATABASE IF NOT EXISTS petclinic_visits;

    CREATE USER IF NOT EXISTS 'petclinic'@'%' IDENTIFIED BY 'petclinicpass';

    GRANT ALL PRIVILEGES ON petclinic_customers.* TO 'petclinic'@'%';
    GRANT ALL PRIVILEGES ON petclinic_vets.* TO 'petclinic'@'%';
    GRANT ALL PRIVILEGES ON petclinic_visits.* TO 'petclinic'@'%';

    FLUSH PRIVILEGES;

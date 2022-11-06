sudo mysql -u root -p

CREATE DATABASE wpress CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

CREATE USER 'wpressuser'@'localhost' IDENTIFIED BY 'tintin';

GRANT ALL ON wpress.* TO 'wpressuser'@'localhost'

FLUSH PRIVILEGES;
EXIT;
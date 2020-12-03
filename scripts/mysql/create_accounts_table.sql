CREATE DATABASE IF NOT EXISTS dbzlogin DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE dbzlogin;

CREATE TABLE IF NOT EXISTS accounts
(
    id       int(11)      NOT NULL AUTO_INCREMENT,
    username varchar(50)  NOT NULL,
    password varchar(255) NOT NULL,
    PRIMARY KEY (id)
);

INSERT INTO accounts (`id`, `username`, `password`)
VALUES (1, 'test', 'test');

INSERT INTO accounts (`id`, `username`, `password`)
VALUES (1, 'admin', 'admin');

INSERT INTO accounts (`id`, `username`, `password`)
VALUES (1, 'user', 'user');

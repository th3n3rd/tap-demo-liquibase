--liquibase formatted sql

--changeset mgarofalo:create-greetings-table
create table greetings
(
    id      bigint primary key,
    message varchar(255) not null
);

--changeset mgarofalo:add-sample-greetings
insert into greetings(id, message) values (1, 'Hello World!');
insert into greetings(id, message) values (2, 'Ciao Mondo!');
insert into greetings(id, message) values (3, 'Bonjour Le Monde!');

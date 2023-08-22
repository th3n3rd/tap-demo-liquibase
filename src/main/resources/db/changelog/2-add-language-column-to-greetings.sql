--liquibase formatted sql

--changeset mgarofalo:add-language-column-to-greetings
alter table greetings add column language char(3) default 'eng';

--changeset mgarofalo:update-languages
update greetings set language='eng' where id = 1;
update greetings set language='ita' where id = 2;
update greetings set language='fra' where id = 3;

drop table if exists test;
create table if not exists test (
  id int,
  name string
)
;

insert into test(id, name)
values
  (1, 'jonas'),
  (2, 'iris')
;

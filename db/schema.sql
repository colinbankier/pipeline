DROP TABLE IF EXISTS pipelines;
CREATE TABLE pipelines (
  id   serial,
  name varchar(255)
);
DROP TABLE IF EXISTS tasks;
CREATE TABLE tasks ( id   serial, name varchar(255), pipeline_id int);

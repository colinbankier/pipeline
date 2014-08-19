var frisby = require('frisby');
var host = "http://localhost:4000";

frisby.create('List first level tasks of source repo Pipeline')
  .post(host + '/source_repos', {
        name: "simple_pipeline"
    }, {json: true})
  .get(host + '/pipelines', {headers: {"content-type": ""}})
  .inspectJSON()
  .expectJSONTypes({
      pipelines: Array
  })
  .expectJSONTypes('pipelines.?', {
    name: "Simple Pipeline",
    tasks: [
      { name: "task 1" },
      { name: "task 2" },
      { name: "task 3" }
    ]
  })
  .toss();

  frisby.create("Show pipeline")
  .get(host + '/pipelines/Simple Pipeline')
  .expectJSON({
    name: "Simple Pipeline",
    tasks: [
      { name: "task 1" },
      { name: "task 2" },
      { name: "task 3" }
    ]
  })
  .toss();

var frisby = require('frisby');
var host = "http://localhost:4000";

frisby.create('List first level tasks of source repo Pipeline')
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
.after(function() {
  frisby.create("Show pipeline")
  .get(host + '/pipelines/simple_pipeline')
  .inspectJSON()
  .expectJSON({
    name: "Simple Pipeline",
    source_repo: "simple_pipeline",
    tasks: [
      { name: "task 1",
        command: "echo 1"
    },
    { name: "task 2",
      tasks: [
        { name: "task 2a",
          command: "echo 2a"
      },
      { name: "task 2b",
        command: "echo 2b"
      },
      { name: "task 2c",
        command: "echo 2c"
      }
      ]
    },
    { name: "task 3",
      command: "echo 3"
    }
    ]
  })
})
.toss();

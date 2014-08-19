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
    path: ["simple_pipeline"],
    tasks: [
      { name: "task 1",
        path: ["simple_pipeline", "Simple Pipeline"],
        command: "echo 1"
    },
    { name: "task 2",
      path: ["simple_pipeline", "Simple Pipeline"],
      tasks: [
        { name: "task 2a",
          path: ["simple_pipeline", "Simple Pipeline", "task 2"],
          command: "echo 2a"
      },
      { name: "task 2b",
        path: ["simple_pipeline", "Simple Pipeline", "task 2"],
        command: "echo 2b"
      },
      { name: "task 2c",
        path: ["simple_pipeline", "Simple Pipeline", "task 2"],
        command: "echo 2c"
      }
      ]
    },
    { name: "task 3",
      path: ["simple_pipeline", "Simple Pipeline"],
      command: "echo 3"
    }
    ]
  })
  .toss();

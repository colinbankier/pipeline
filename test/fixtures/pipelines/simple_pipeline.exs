[
  name: "Simple Pipeline",
  tasks: [
    [name: "task 1", command: "echo 1"],
    [name: "task 2",
      tasks: [
        [name: "task 2a", command: "echo 2a" ],
        [name: "task 2b", command: "echo 2b" ],
        [name: "task 2c", command: "echo 2c" ],
      ]
    ],
    [name: "task 3", command: "echo 3"]
  ]
]
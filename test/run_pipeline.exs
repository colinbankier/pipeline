    json_path = "test/resources/simple_pipeline.json"
    { :ok, pipeline } = PipelineParser.parse_file(Path.expand(json_path))
    result = PipelineRunner.run(pipeline)

    IO.inspect result
    IO.inspect result.tasks
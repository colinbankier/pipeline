    json_path = "test/resources/play_pipeline.json"
    { :ok, pipeline } = PipelineParser.parse_file(Path.expand(json_path))
    PipelineRunner.run(pipeline)

    IO.inspect Poll.poll_until_complete(pipeline)

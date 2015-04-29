# Pipeline

Continuous Delivery System built in Elixir

## Rationale
For modern web-based applications, we need to ship code to production with increased frequency, confidence and 
reliability than ever before. We need to ship continuously. There are many tools out there that claim to assist
in building software delivery pipelines, but none adequately solve the simple problems I encounter in real world
scenarios.

Pipeline is the tool that does just that. Here are it's features:

## Features
### Flexible Task hierarchy
A pipeline is simple a set of tasks that are to be executed. A task can either run an external command, or it
can be a nested task, which is simply another set of tasks. A pipeline is of arbitrary depth, and can consist of a single
task or a complex tree of tasks. A set of tasks can be executed in series or in parallel.

### First-class support for passing parameters down the line
Each task in the pipeline can produce some result that affects the future steps in the pipeline. Pipeline supports
passing these down the line as a first-class concept.

### First-class support for passing artifacts down the line
Each task in the pipeline can produce an artifact that can be used by future steps in the pipeline. Pipeline supports
passing these down the line as a first-class concept.

### Birds-eye view of your deployment flow
A pipeline is intended to model the full deployment flow of a piece of software, from code commmit, continuous integration,
deployment to testing environments, running acceptance tests, deployment to production, and final smoke tests, for example.
It is intended to give easy feedback as to which step any build is up to in this flow, and the overall health of your
deployments. It is intended to do this for many systems or service at once.

### Integration with existing tools
It offers web-hook integration with Github or other CI tools so can integrate with your existing tool set. You can
use another tool purely for CI if you wish, using pipeline for the deployment steps through multiple environments.

### Technology agnostic
Pipeline simply allows you to orchestrate running commands. It doesn't care what those commands are, so can perform any
action in any technology you wish.

### Versioned Configuration Files
Pipelines are defined in one or more plain text files that can easily be version controlled. They can easily be
expressed in YAML or JSON, but for simplicity can just be expressed as an Elixir data structure.


# Developing
Pipeline uses Phoenix for it's HTTP API.
To start your new Phoenix application:

1. Install dependencies with `mix deps.get`
2. Start Phoenix endpoint with `mix phoenix.server`

Now you can visit `localhost:4000` from your browser.

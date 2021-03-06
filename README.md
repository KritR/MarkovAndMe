## What is this ?

It's a quote generator.
It uses markov chains to determine what words to say next based on input data that the chain is "trained on".

## Usage Prerequisites

1. Have data compiled
2. Or use the example data

There needs to be a ```config/messages.json``` file in order for the binary to run.
That is the source of the data for the markov chain generation. Take a look at
```config/messages.json.example``` for an example. 
You can simply remove the suffix on example and edit the json file to your needs.
It's important that each sentence begins with "SENTENCE_START" and ends with "SENTENCE_END"
as this is a hardcoded start / end value ( although can be adjusted by tweaking a few variables.

## Run the app locally

Once you have installed the Swift compiler and cloned this Git repository, you can now compile and run the application. Go to the root folder of this repository on your system and issue the following command:

```shell
$ swift build
```

This command might take a few minutes to run.

Once the application is successfully compiled, you can run the executable that was generated by the Swift compiler:
```
$ ./.build/debug/markov-and-me
```

You should see an output similar to the following:

```
Markov Chain Trained
```

You can then view your app at: http://localhost:8080.


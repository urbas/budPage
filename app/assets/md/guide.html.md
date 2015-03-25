# Guide


## Installation

### Windows

You can install Bud with [Chocolatey](https://chocolatey.org/packages/bud). Just use this command:

```language-bash
choco install bud
```

Verify that your installation succeeded by running <code>bud</code> in the command prompt.

### Linux

<div class="alert alert-warning">
  <span class="label label-warning">TODO:</span> Add support for Linux.
</div>

### OS X

<div class="alert alert-warning">
  <span class="label label-warning">TODO:</span> Add support for OS X.
</div>


## Usage

### Creating a new project

Say the name of your project is `Foo`. Create the `Foo` directory, and place your C# sources into
`Foo/src/main/cs`.

<div class="panel panel-danger">
  <div class="panel-heading">
    <h3 class="panel-title">Important:</h3>
  </div>

  <div class="panel-body">
    You should give your project a unique name.
    Search for packages on <a href="https://www.nuget.org/packages/">NuGet</a> to ensure
    you're using a unique name.
  </div>
</div>

### Customising the build

To customise your builds, create the build configuration file `.bud/Build.cs`. If this
file does not exist, Bud will use a default build configuration. The following build
configuration is equivalent to the default one.

```language-csharp
using Bud;
using Bud.CSharp;
using Bud.Projects;
using System.IO;

public class Build : IBuild {
  public Settings Setup(Settings settings, string baseDir) {
    return settings.Project(Path.GetFileName(baseDir), baseDir, Cs.Exe(), Cs.Test());
  }
}
```

Call methods on the `settings` object to customise your build configuration.


### Concepts

A build definition is a collection of key-value pairs. There are two types of keys: `ConfigKey` and
`TaskKey`. Every key has a path, such as `/project/Foo.Bar/main/cs/baseDir` or
`/build`. A value can be of any .NET type.

A value of a config key is evaluated when it is accessed for the first time. It is evaluated
once per lifetime of the build definition. A value of a task key is evaluated once per root-level task
invocation (i.e.: if a task calls another task twice, its value is evaluated once only and in the second
invocation the cached value is used).

You define values of config keys and task keys by building them up (i.e., you add small modifiers to a
`Settings` instance). For example, you can introduce your own key and value by calling
`settings.Add(MySettings.HelloWorldMessage.Init("Hello, World!"))`. The parameter to the
`Add` method is a modifier. This modifier initialises the
`HelloWorldMessage`
key with the value `"Hello, World!"` (if it has not been initialised before in `settings`).
You can define your own config and task keys like this:

```language-csharp
public static readonly ConfigKey<string> HelloWorldMessage = Key.Define("helloWorldMessage", "Prints a hello world message in the log.");

public static readonly TaskKey HelloWorld = Key.Define("helloWorld", "Prints a hello world message in the log.");
```

<div class="alert alert-info">
  <span class="label label-primary">Note:</span> The <code>Settings</code> class is immutable. Therefore,
  <code>settings.Add(...)</code> returns
  a new instance instead of mutating the existing one.
</div>


### Building

<div class="panel panel-success">
  <div class="panel-heading">
    <h3 class="panel-title">Task:</h3>
  </div>

  <div class="panel-body">
    <pre><code>build</code></pre>
  </div>
</div>

Run `bud build` in the `Foo` directory. This will produce the
executable for your project in `.bud/output/main/cs/debug/bin/Foo.exe`.

<div class="alert alert-info">
  <span class="label label-primary">Note:</span> Bud invokes the `build` task
  by default (if you run Bud without any command line arguments).
</div>


### Testing

<div class="panel panel-success">
  <div class="panel-heading">
    <h3 class="panel-title">Task:</h3>
  </div>

  <div class="panel-body">
    <pre><code>test</code></pre>
  </div>
</div>

<div class="alert alert-warning">
  <span class="label label-warning">TODO:</span> Testing is not yet implemented.
</div>


### Cleaning

<div class="panel panel-success">
  <div class="panel-heading">
    <h3 class="panel-title">Task:</h3>
  </div>

  <div class="panel-body">
    <pre><code>clean</code></pre>
  </div>
</div>

Run `bud clean` to clean the files in the `.bud/output` folder.


### Generating solution and project files

<div class="panel panel-success">
  <div class="panel-heading">
    <h3 class="panel-title">Task:</h3>
  </div>

  <div class="panel-body">
    <pre><code>generateSolution</code></pre>
  </div>
</div>

Run `bud generateSolution` to generate a Visual Studio solution for
your project. Bud will place the solution file `Foo.sln` into the root
directory of your project. Bud will also generate multiple csproj files in
`src/[scope]/cs` folders.

The following command will generate solution files for the build-level sources (i.e., to be able to edit the
`.bud/Build.cs` file in an IDE):

```language-bash
bud -b 1 generateSolution
```


### Publishing to NuGet

<div class="panel panel-success">
  <div class="panel-heading">
    <h3 class="panel-title">Task:</h3>
  </div>

  <div class="panel-body">
    <pre><code>publish</code></pre>
  </div>
</div>

You have to create an account with [NuGet](https://www.nuget.org/) before you can publish your
project to the NuGet repository.

Once you have an account, get your API key from [here](https://www.nuget.org/account) and
place it into the `$HOME/.bud/nuGetApiKey` file.

Now you can run `bud publish`. This will push the package to
`https://www.nuget.org/packages/Foo/`.


### Setting the version of your project

This is how you specify the version of your project in the `.bud/Build.cs` file:

1. First add the `using Bud.Projects;` directive to the top of the file.

2. Then call `settings.Version("1.2.3")` in your `IBuild` class.

### Specifying dependencies

To add the `Newtonsoft.Json` library to your project
you must place `Cs.Dependency("Newtonsoft.Json")` into
the `.bud/Build.cs` like this:

```language-csharp
settings.Project("Foo.Bar", baseDir, Cs.Exe(Cs.Dependency("Newtonsoft.Json")), Cs.Test());
```


### Using a plugin

Plugins add features to the build or modify it. For example, the [HelloWorldPlugin](https://github.com/urbas/Bud.Examples.HelloWorldPlugin)
adds the task `helloWorld` to the build. It prints a hello message if you invoke `bud helloWorld`.

Say you want to use the plugin `Bud.Example.HelloWorldPlugin` in your build. Create the file `.bud/.bud/Build.cs`
with the following content:

```language-csharp
using Bud;
using Bud.CSharp;
using Bud.Projects;

public class Build : IBuild {
  public Settings Setup(Settings settings, string baseDir) {
    return settings.BuildDefinition(
      Cs.Dependency("Bud.Example.HelloWorldPlugin")
    );
  }
}
```


### Writing a plugin

Put the following into your build configuration (i.e., into the `.bud/Build.cs`
file):

```language-csharp
settings.BudPlugin("Your.Plugin", baseDir)
```

You'll have to publish your plugin before you'll be able to use it.

Please use the following plugins as a reference source:

1. [Hello world plugin](https://github.com/urbas/Bud.Examples.HelloWorldPlugin)

